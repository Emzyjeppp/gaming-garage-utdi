-- 0004_helper_functions.sql
-- Helper security definer untuk membaca profil pemanggil tanpa memicu
-- rekursi RLS pada tabel profiles.

create or replace function public.current_profile_role()
returns public.user_role
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select role
  from public.profiles
  where id = auth.uid();
$$;

create or replace function public.current_profile_status()
returns public.account_status
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select status
  from public.profiles
  where id = auth.uid();
$$;

create or replace function public.current_profile_division_id()
returns uuid
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select division_id
  from public.profiles
  where id = auth.uid();
$$;

create or replace function public.current_profile_team_id()
returns uuid
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select team_id
  from public.profiles
  where id = auth.uid();
$$;

create or replace function public.is_active_user()
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and status = 'active'
  );
$$;

create or replace function public.is_management()
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role = 'manajemen'
      and status = 'active'
  );
$$;

create or replace function public.is_dosen()
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role = 'dosen'
      and status = 'active'
  );
$$;

create or replace function public.is_atlet()
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role = 'atlet'
      and status = 'active'
  );
$$;

create or replace function public.is_member()
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role = 'member'
      and status = 'active'
  );
$$;

create or replace function public.is_teammate(p_profile_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.profiles p
    where p.id = p_profile_id
      and p.status = 'active'
      and p.team_id is not null
      and p.team_id = public.current_profile_team_id()
  );
$$;

create or replace function public.get_session_code(p_session_id uuid)
returns text
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_code text;
begin
  if not public.is_management() then
    raise exception 'Akses session_code hanya untuk Manajemen'
      using errcode = '42501';
  end if;

  select session_code
    into v_code
  from public.attendance_sessions
  where id = p_session_id;

  return v_code;
end;
$$;
