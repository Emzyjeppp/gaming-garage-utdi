-- 0003_indexes.sql
-- Index untuk foreign key dan kolom yang sering difilter/diurutkan.
-- Unique/PK sudah membuat index sendiri dan tidak diduplikasi.

create index profiles_division_id_idx on public.profiles (division_id);
create index profiles_team_id_idx on public.profiles (team_id);
create index profiles_role_status_idx on public.profiles (role, status);
create index profiles_team_status_idx on public.profiles (team_id, status);

create index teams_division_id_idx on public.teams (division_id);

create index metric_definitions_division_id_idx
  on public.metric_definitions (division_id);
create index metric_definitions_division_active_idx
  on public.metric_definitions (division_id, is_active);

create index events_status_idx on public.events (status);
create index events_type_idx on public.events (type);
create index events_division_id_idx on public.events (division_id);
create index events_start_date_idx on public.events (start_date);
create index events_status_type_start_idx
  on public.events (status, type, start_date desc);

create index performance_entries_athlete_id_idx
  on public.performance_entries (athlete_id);
create index performance_entries_division_id_idx
  on public.performance_entries (division_id);
create index performance_entries_event_id_idx
  on public.performance_entries (event_id);
create index performance_entries_verification_status_idx
  on public.performance_entries (verification_status);
create index performance_entries_athlete_status_idx
  on public.performance_entries (athlete_id, verification_status);
create index performance_entries_division_status_idx
  on public.performance_entries (division_id, verification_status);

create index performance_values_metric_id_idx
  on public.performance_values (metric_id);

create index coach_notes_athlete_id_idx on public.coach_notes (athlete_id);
create index coach_notes_entry_id_idx on public.coach_notes (entry_id);
create index coach_notes_author_id_idx on public.coach_notes (author_id);

create index schedules_division_id_idx on public.schedules (division_id);
create index schedules_team_id_idx on public.schedules (team_id);
create index schedules_start_at_idx on public.schedules (start_at);
create index schedules_created_by_idx on public.schedules (created_by);

create index schedule_participants_profile_id_idx
  on public.schedule_participants (profile_id);

create index attendance_sessions_division_id_idx
  on public.attendance_sessions (division_id);
create index attendance_sessions_schedule_id_idx
  on public.attendance_sessions (schedule_id);
create index attendance_sessions_event_id_idx
  on public.attendance_sessions (event_id);
create index attendance_sessions_status_idx
  on public.attendance_sessions (status);
create index attendance_sessions_starts_at_idx
  on public.attendance_sessions (starts_at);
create index attendance_sessions_created_by_idx
  on public.attendance_sessions (created_by);

create index attendance_records_profile_id_idx
  on public.attendance_records (profile_id);
create index attendance_records_status_idx
  on public.attendance_records (status);
create index attendance_records_recorded_by_idx
  on public.attendance_records (recorded_by);

create index guest_attendances_session_id_idx
  on public.guest_attendances (session_id);

create index inventory_items_status_idx on public.inventory_items (status);
create index inventory_items_category_idx on public.inventory_items (category);
create index inventory_items_condition_idx on public.inventory_items (condition);

create index loans_borrower_id_idx on public.loans (borrower_id);
create index loans_status_idx on public.loans (status);
create index loans_due_at_idx on public.loans (due_at);
create index loans_handled_by_idx on public.loans (handled_by);

create index loan_items_item_id_idx on public.loan_items (item_id);

create index archives_event_id_idx on public.archives (event_id);
create index archives_category_idx on public.archives (category);
create index archives_uploaded_by_idx on public.archives (uploaded_by);
create index archives_created_at_idx on public.archives (created_at desc);

create index announcements_target_role_idx
  on public.announcements (target_role);
create index announcements_target_division_id_idx
  on public.announcements (target_division_id);
create index announcements_created_at_idx
  on public.announcements (created_at desc);

create index activity_logs_actor_id_idx on public.activity_logs (actor_id);
create index activity_logs_created_at_idx
  on public.activity_logs (created_at desc);
create index activity_logs_action_idx on public.activity_logs (action);
create index activity_logs_entity_idx
  on public.activity_logs (entity_type, entity_id);
