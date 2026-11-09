-- 0008_grants.sql
-- Privilege tabel/kolom. RLS tetap menjadi penentu baris.
-- session_code sengaja tidak di-grant SELECT ke authenticated/anon.
-- Manajemen membacanya lewat fungsi get_session_code(uuid).

grant usage on schema public to anon, authenticated;

revoke all on all tables in schema public from anon, authenticated;
revoke all on all sequences in schema public from anon, authenticated;

-- Helper functions: cabut dari public, beri ke authenticated/service_role.
revoke all on function public.current_profile_role() from public;
revoke all on function public.current_profile_status() from public;
revoke all on function public.current_profile_division_id() from public;
revoke all on function public.current_profile_team_id() from public;
revoke all on function public.is_active_user() from public;
revoke all on function public.is_management() from public;
revoke all on function public.is_dosen() from public;
revoke all on function public.is_atlet() from public;
revoke all on function public.is_member() from public;
revoke all on function public.is_teammate(uuid) from public;
revoke all on function public.get_session_code(uuid) from public;

grant execute on function public.current_profile_role() to authenticated, service_role;
grant execute on function public.current_profile_status() to authenticated, service_role;
grant execute on function public.current_profile_division_id() to authenticated, service_role;
grant execute on function public.current_profile_team_id() to authenticated, service_role;
grant execute on function public.is_active_user() to authenticated, service_role;
grant execute on function public.is_management() to authenticated, service_role;
grant execute on function public.is_dosen() to authenticated, service_role;
grant execute on function public.is_atlet() to authenticated, service_role;
grant execute on function public.is_member() to authenticated, service_role;
grant execute on function public.is_teammate(uuid) to authenticated, service_role;
grant execute on function public.get_session_code(uuid) to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- Authenticated: SELECT + operasi tulis sesuai policy.
-- ---------------------------------------------------------------------------

grant select, insert, update, delete on public.profiles to authenticated;
grant select, insert, update, delete on public.divisions to authenticated;
grant select, insert, update, delete on public.teams to authenticated;
grant select, insert, update, delete on public.metric_definitions to authenticated;
grant select, insert, update on public.performance_entries to authenticated;
grant select, insert, update on public.performance_values to authenticated;
grant select, insert, update, delete on public.coach_notes to authenticated;
grant select, insert, update, delete on public.events to authenticated;
grant select, insert, update, delete on public.site_settings to authenticated;
grant select, insert, update, delete on public.schedules to authenticated;
grant select, insert, update, delete on public.schedule_participants to authenticated;

-- attendance_sessions: SELECT semua kolom kecuali session_code.
grant select (
  id,
  title,
  session_type,
  division_id,
  schedule_id,
  event_id,
  starts_at,
  ends_at,
  late_after,
  allow_guests,
  status,
  created_by,
  created_at
) on public.attendance_sessions to authenticated;

grant insert, update, delete on public.attendance_sessions to authenticated;

grant select, insert, update on public.attendance_records to authenticated;
grant select, insert, update on public.guest_attendances to authenticated;
grant select, insert, update, delete on public.inventory_items to authenticated;
grant select, insert, update, delete on public.loans to authenticated;
grant select, insert, update, delete on public.loan_items to authenticated;
grant select, insert, update, delete on public.archives to authenticated;
grant select, insert, update, delete on public.announcements to authenticated;
grant select on public.activity_logs to authenticated;

-- ---------------------------------------------------------------------------
-- Anon: hanya event published, divisi yang tampil di landing, site_settings.
-- ---------------------------------------------------------------------------

grant select on public.events to anon;
grant select on public.divisions to anon;
grant select on public.site_settings to anon;
