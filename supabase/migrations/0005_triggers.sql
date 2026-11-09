-- 0005_triggers.sql
-- Trigger updated_at, proteksi kolom profil, integritas performa,
-- dan append-only activity_logs.

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

create trigger performance_entries_set_updated_at
before update on public.performance_entries
for each row execute function public.set_updated_at();

create trigger events_set_updated_at
before update on public.events
for each row execute function public.set_updated_at();

create trigger site_settings_set_updated_at
before update on public.site_settings
for each row execute function public.set_updated_at();

create trigger inventory_items_set_updated_at
before update on public.inventory_items
for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- User biasa tidak boleh mengubah role, status, nim, division_id, team_id,
-- id, atau created_at miliknya sendiri. Manajemen dan service role boleh.
-- ---------------------------------------------------------------------------

create or replace function public.enforce_profile_protected_fields()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if auth.uid() is null or public.is_management() then
    return new;
  end if;

  if auth.uid() = old.id
     and old.role in ('atlet', 'member')
     and old.status = 'active' then
    if new.id is distinct from old.id
       or new.role is distinct from old.role
       or new.status is distinct from old.status
       or new.nim is distinct from old.nim
       or new.division_id is distinct from old.division_id
       or new.team_id is distinct from old.team_id
       or new.created_at is distinct from old.created_at then
      raise exception 'User tidak boleh mengubah role, status, nim, division_id, team_id, id, atau created_at'
        using errcode = '42501';
    end if;

    return new;
  end if;

  raise exception 'Perubahan profil tidak diizinkan'
    using errcode = '42501';
end;
$$;

create trigger profiles_enforce_protected_fields
before update on public.profiles
for each row execute function public.enforce_profile_protected_fields();

-- ---------------------------------------------------------------------------
-- performance_entries.division_id harus sama dengan division_id atlet
-- saat entri dibuat. Pengecekan hanya dilakukan saat insert atau saat
-- athlete_id/division_id diubah, agar entri lama tetap bisa diverifikasi
-- setelah atlet pindah divisi.
-- ---------------------------------------------------------------------------

create or replace function public.enforce_performance_entry_integrity()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_role public.user_role;
  v_division_id uuid;
begin
  if tg_op = 'UPDATE'
     and new.athlete_id is not distinct from old.athlete_id
     and new.division_id is not distinct from old.division_id then
    return new;
  end if;

  select p.role, p.division_id
    into v_role, v_division_id
  from public.profiles p
  where p.id = new.athlete_id;

  if v_role is null then
    raise exception 'Atlet untuk performance_entries tidak ditemukan';
  end if;

  if v_role <> 'atlet' then
    raise exception 'performance_entries.athlete_id harus profil ber-role atlet';
  end if;

  if v_division_id is null
     or new.division_id is distinct from v_division_id then
    raise exception 'performance_entries.division_id harus sama dengan division_id atlet';
  end if;

  return new;
end;
$$;

create trigger performance_entries_enforce_integrity
before insert or update on public.performance_entries
for each row execute function public.enforce_performance_entry_integrity();

-- ---------------------------------------------------------------------------
-- Manajemen hanya boleh mengubah kolom verifikasi. Atlet hanya boleh
-- mengubah isi entri selama statusnya pending. RLS tetap menjadi lapisan
-- utama; trigger ini mencegah perubahan kolom yang tidak diizinkan.
-- ---------------------------------------------------------------------------

create or replace function public.enforce_performance_entry_update()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if auth.uid() is null then
    return new;
  end if;

  if public.is_management() then
    if new.athlete_id is distinct from old.athlete_id
       or new.division_id is distinct from old.division_id
       or new.event_id is distinct from old.event_id
       or new.played_on is distinct from old.played_on
       or new.match_type is distinct from old.match_type
       or new.opponent is distinct from old.opponent
       or new.result is distinct from old.result
       or new.notes is distinct from old.notes
       or new.evidence_url is distinct from old.evidence_url
       or new.created_at is distinct from old.created_at then
      raise exception 'Manajemen hanya boleh mengubah kolom verifikasi performa'
        using errcode = '42501';
    end if;

    return new;
  end if;

  if public.is_atlet()
     and old.athlete_id = auth.uid()
     and old.verification_status = 'pending' then
    if new.athlete_id is distinct from old.athlete_id
       or new.division_id is distinct from old.division_id
       or new.verification_status is distinct from old.verification_status
       or new.verified_by is distinct from old.verified_by
       or new.verified_at is distinct from old.verified_at
       or new.reject_reason is distinct from old.reject_reason
       or new.created_at is distinct from old.created_at then
      raise exception 'Atlet tidak boleh mengubah kolom verifikasi atau identitas entri'
        using errcode = '42501';
    end if;

    return new;
  end if;

  raise exception 'Perubahan performance_entries tidak diizinkan'
    using errcode = '42501';
end;
$$;

create trigger performance_entries_enforce_update
before update on public.performance_entries
for each row execute function public.enforce_performance_entry_update();

-- ---------------------------------------------------------------------------
-- performance_values.metric_id harus berasal dari divisi entry.
-- ---------------------------------------------------------------------------

create or replace function public.enforce_performance_value_metric_division()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_entry_division_id uuid;
  v_metric_division_id uuid;
begin
  select e.division_id
    into v_entry_division_id
  from public.performance_entries e
  where e.id = new.entry_id;

  select m.division_id
    into v_metric_division_id
  from public.metric_definitions m
  where m.id = new.metric_id;

  if v_entry_division_id is null
     or v_metric_division_id is null
     or v_entry_division_id is distinct from v_metric_division_id then
    raise exception 'metric_id harus berasal dari divisi yang sama dengan entry';
  end if;

  return new;
end;
$$;

create trigger performance_values_enforce_metric_division
before insert or update on public.performance_values
for each row execute function public.enforce_performance_value_metric_division();

-- ---------------------------------------------------------------------------
-- activity_logs append-only: update dan delete ditolak untuk role mana pun,
-- termasuk service role dan pemilik tabel.
-- ---------------------------------------------------------------------------

create or replace function public.prevent_activity_log_mutation()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  raise exception 'activity_logs bersifat append-only: update/delete tidak diizinkan'
    using errcode = '42501';
end;
$$;

create trigger activity_logs_prevent_update
before update on public.activity_logs
for each row execute function public.prevent_activity_log_mutation();

create trigger activity_logs_prevent_delete
before delete on public.activity_logs
for each row execute function public.prevent_activity_log_mutation();
