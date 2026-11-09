-- 0007_policies.sql
-- Policy RLS mengikuti matriks bagian 4 dan ringkasan bagian 11,
-- ditambah aturan active-only, rekan satu tim, akses anon, dan session_code.
-- Policy bersifat permissive; beberapa policy SELECT akan digabung dengan OR.

-- ---------------------------------------------------------------------------
-- profiles
-- ---------------------------------------------------------------------------

create policy profiles_select_management
on public.profiles for select to authenticated
using (public.is_management());

create policy profiles_select_dosen
on public.profiles for select to authenticated
using (public.is_dosen());

create policy profiles_select_self
on public.profiles for select to authenticated
using (id = auth.uid());

create policy profiles_select_teammates
on public.profiles for select to authenticated
using (
  public.is_atlet()
  and id <> auth.uid()
  and status = 'active'
  and team_id is not null
  and team_id = public.current_profile_team_id()
);

create policy profiles_insert_management
on public.profiles for insert to authenticated
with check (public.is_management());

create policy profiles_update_management
on public.profiles for update to authenticated
using (public.is_management())
with check (public.is_management());

create policy profiles_update_self
on public.profiles for update to authenticated
using (
  id = auth.uid()
  and (public.is_atlet() or public.is_member())
)
with check (
  id = auth.uid()
  and (public.is_atlet() or public.is_member())
);

create policy profiles_delete_management
on public.profiles for delete to authenticated
using (public.is_management());

-- ---------------------------------------------------------------------------
-- divisions
-- ---------------------------------------------------------------------------

create policy divisions_select_active
on public.divisions for select to authenticated
using (public.is_active_user());

create policy divisions_select_anon
on public.divisions for select to anon
using (is_active and show_on_landing);

create policy divisions_insert_management
on public.divisions for insert to authenticated
with check (public.is_management());

create policy divisions_update_management
on public.divisions for update to authenticated
using (public.is_management())
with check (public.is_management());

create policy divisions_delete_management
on public.divisions for delete to authenticated
using (public.is_management());

-- ---------------------------------------------------------------------------
-- teams
-- ---------------------------------------------------------------------------

create policy teams_select_active
on public.teams for select to authenticated
using (public.is_active_user());

create policy teams_insert_management
on public.teams for insert to authenticated
with check (public.is_management());

create policy teams_update_management
on public.teams for update to authenticated
using (public.is_management())
with check (public.is_management());

create policy teams_delete_management
on public.teams for delete to authenticated
using (public.is_management());

-- ---------------------------------------------------------------------------
-- metric_definitions
-- ---------------------------------------------------------------------------

create policy metric_definitions_select_management
on public.metric_definitions for select to authenticated
using (public.is_management());

create policy metric_definitions_select_dosen
on public.metric_definitions for select to authenticated
using (public.is_dosen());

create policy metric_definitions_select_atlet_division
on public.metric_definitions for select to authenticated
using (
  public.is_atlet()
  and division_id = public.current_profile_division_id()
);

create policy metric_definitions_insert_management
on public.metric_definitions for insert to authenticated
with check (public.is_management());

create policy metric_definitions_update_management
on public.metric_definitions for update to authenticated
using (public.is_management())
with check (public.is_management());

create policy metric_definitions_delete_management
on public.metric_definitions for delete to authenticated
using (public.is_management());

-- ---------------------------------------------------------------------------
-- performance_entries
-- ---------------------------------------------------------------------------

create policy performance_entries_select_management
on public.performance_entries for select to authenticated
using (public.is_management());

create policy performance_entries_select_dosen
on public.performance_entries for select to authenticated
using (public.is_dosen());

create policy performance_entries_select_own
on public.performance_entries for select to authenticated
using (
  public.is_atlet()
  and athlete_id = auth.uid()
);

create policy performance_entries_select_teammate_verified
on public.performance_entries for select to authenticated
using (
  public.is_atlet()
  and verification_status = 'verified'
  and athlete_id <> auth.uid()
  and public.is_teammate(athlete_id)
);

create policy performance_entries_insert_atlet
on public.performance_entries for insert to authenticated
with check (
  public.is_atlet()
  and athlete_id = auth.uid()
  and division_id = public.current_profile_division_id()
  and verification_status = 'pending'
  and verified_by is null
  and verified_at is null
  and reject_reason is null
);

create policy performance_entries_update_atlet_pending
on public.performance_entries for update to authenticated
using (
  public.is_atlet()
  and athlete_id = auth.uid()
  and verification_status = 'pending'
)
with check (
  public.is_atlet()
  and athlete_id = auth.uid()
  and division_id = public.current_profile_division_id()
  and verification_status = 'pending'
  and verified_by is null
  and verified_at is null
  and reject_reason is null
);

create policy performance_entries_update_management
on public.performance_entries for update to authenticated
using (public.is_management())
with check (public.is_management());

-- ---------------------------------------------------------------------------
-- performance_values
-- ---------------------------------------------------------------------------

create policy performance_values_select_management
on public.performance_values for select to authenticated
using (public.is_management());

create policy performance_values_select_dosen
on public.performance_values for select to authenticated
using (public.is_dosen());

create policy performance_values_select_atlet
on public.performance_values for select to authenticated
using (
  public.is_atlet()
  and exists (
    select 1
    from public.performance_entries e
    where e.id = performance_values.entry_id
      and (
        e.athlete_id = auth.uid()
        or (
          e.verification_status = 'verified'
          and public.is_teammate(e.athlete_id)
        )
      )
  )
);

create policy performance_values_insert_atlet_pending
on public.performance_values for insert to authenticated
with check (
  public.is_atlet()
  and exists (
    select 1
    from public.performance_entries e
    where e.id = performance_values.entry_id
      and e.athlete_id = auth.uid()
      and e.verification_status = 'pending'
  )
);

create policy performance_values_update_atlet_pending
on public.performance_values for update to authenticated
using (
  public.is_atlet()
  and exists (
    select 1
    from public.performance_entries e
    where e.id = performance_values.entry_id
      and e.athlete_id = auth.uid()
      and e.verification_status = 'pending'
  )
)
with check (
  public.is_atlet()
  and exists (
    select 1
    from public.performance_entries e
    where e.id = performance_values.entry_id
      and e.athlete_id = auth.uid()
      and e.verification_status = 'pending'
  )
);

-- ---------------------------------------------------------------------------
-- coach_notes
-- ---------------------------------------------------------------------------

create policy coach_notes_select_management
on public.coach_notes for select to authenticated
using (public.is_management());

create policy coach_notes_select_dosen
on public.coach_notes for select to authenticated
using (public.is_dosen());

create policy coach_notes_select_atlet
on public.coach_notes for select to authenticated
using (
  public.is_atlet()
  and athlete_id = auth.uid()
);

create policy coach_notes_insert_management
on public.coach_notes for insert to authenticated
with check (public.is_management());

create policy coach_notes_update_management
on public.coach_notes for update to authenticated
using (public.is_management())
with check (public.is_management());

create policy coach_notes_delete_management
on public.coach_notes for delete to authenticated
using (public.is_management());

-- ---------------------------------------------------------------------------
-- events
-- ---------------------------------------------------------------------------

create policy events_select_management
on public.events for select to authenticated
using (public.is_management());

create policy events_select_active
on public.events for select to authenticated
using (public.is_active_user());

create policy events_select_anon
on public.events for select to anon
using (status = 'published');

create policy events_insert_management
on public.events for insert to authenticated
with check (public.is_management());

create policy events_update_management
on public.events for update to authenticated
using (public.is_management())
with check (public.is_management());

create policy events_delete_management
on public.events for delete to authenticated
using (public.is_management());

-- ---------------------------------------------------------------------------
-- site_settings
-- ---------------------------------------------------------------------------

create policy site_settings_select_active
on public.site_settings for select to authenticated
using (public.is_active_user());

create policy site_settings_select_anon
on public.site_settings for select to anon
using (true);

create policy site_settings_insert_management
on public.site_settings for insert to authenticated
with check (public.is_management());

create policy site_settings_update_management
on public.site_settings for update to authenticated
using (public.is_management())
with check (public.is_management());

create policy site_settings_delete_management
on public.site_settings for delete to authenticated
using (public.is_management());

-- ---------------------------------------------------------------------------
-- schedules
-- ---------------------------------------------------------------------------

create policy schedules_select_management
on public.schedules for select to authenticated
using (public.is_management());

create policy schedules_select_dosen
on public.schedules for select to authenticated
using (public.is_dosen());

create policy schedules_select_participant
on public.schedules for select to authenticated
using (
  public.is_active_user()
  and (public.is_atlet() or public.is_member())
  and exists (
    select 1
    from public.schedule_participants sp
    where sp.schedule_id = schedules.id
      and sp.profile_id = auth.uid()
  )
);

create policy schedules_insert_management
on public.schedules for insert to authenticated
with check (public.is_management());

create policy schedules_update_management
on public.schedules for update to authenticated
using (public.is_management())
with check (public.is_management());

create policy schedules_delete_management
on public.schedules for delete to authenticated
using (public.is_management());

-- ---------------------------------------------------------------------------
-- schedule_participants
-- ---------------------------------------------------------------------------

create policy schedule_participants_select_management
on public.schedule_participants for select to authenticated
using (public.is_management());

create policy schedule_participants_select_dosen
on public.schedule_participants for select to authenticated
using (public.is_dosen());

create policy schedule_participants_select_self
on public.schedule_participants for select to authenticated
using (
  public.is_active_user()
  and (public.is_atlet() or public.is_member())
  and profile_id = auth.uid()
);

create policy schedule_participants_insert_management
on public.schedule_participants for insert to authenticated
with check (public.is_management());

create policy schedule_participants_update_management
on public.schedule_participants for update to authenticated
using (public.is_management())
with check (public.is_management());

create policy schedule_participants_delete_management
on public.schedule_participants for delete to authenticated
using (public.is_management());

-- ---------------------------------------------------------------------------
-- attendance_sessions
-- ---------------------------------------------------------------------------

create policy attendance_sessions_select_management
on public.attendance_sessions for select to authenticated
using (public.is_management());

create policy attendance_sessions_select_dosen
on public.attendance_sessions for select to authenticated
using (public.is_dosen());

create policy attendance_sessions_select_relevant
on public.attendance_sessions for select to authenticated
using (
  public.is_active_user()
  and (public.is_atlet() or public.is_member())
  and (
    division_id is null
    or division_id = public.current_profile_division_id()
    or exists (
      select 1
      from public.attendance_records ar
      where ar.session_id = attendance_sessions.id
        and ar.profile_id = auth.uid()
    )
  )
);

create policy attendance_sessions_insert_management
on public.attendance_sessions for insert to authenticated
with check (public.is_management());

create policy attendance_sessions_update_management
on public.attendance_sessions for update to authenticated
using (public.is_management())
with check (public.is_management());

create policy attendance_sessions_delete_management
on public.attendance_sessions for delete to authenticated
using (public.is_management());

-- ---------------------------------------------------------------------------
-- attendance_records
-- Non-Manajemen tidak boleh menulis pada Tahap 1.
-- ---------------------------------------------------------------------------

create policy attendance_records_select_management
on public.attendance_records for select to authenticated
using (public.is_management());

create policy attendance_records_select_dosen
on public.attendance_records for select to authenticated
using (public.is_dosen());

create policy attendance_records_select_self
on public.attendance_records for select to authenticated
using (
  public.is_active_user()
  and (public.is_atlet() or public.is_member())
  and profile_id = auth.uid()
);

create policy attendance_records_insert_management
on public.attendance_records for insert to authenticated
with check (public.is_management());

create policy attendance_records_update_management
on public.attendance_records for update to authenticated
using (public.is_management())
with check (public.is_management());

-- ---------------------------------------------------------------------------
-- guest_attendances
-- Non-Manajemen tidak boleh menulis pada Tahap 1.
-- ---------------------------------------------------------------------------

create policy guest_attendances_select_management
on public.guest_attendances for select to authenticated
using (public.is_management());

create policy guest_attendances_insert_management
on public.guest_attendances for insert to authenticated
with check (public.is_management());

create policy guest_attendances_update_management
on public.guest_attendances for update to authenticated
using (public.is_management())
with check (public.is_management());

-- ---------------------------------------------------------------------------
-- inventory_items
-- ---------------------------------------------------------------------------

create policy inventory_items_select_management
on public.inventory_items for select to authenticated
using (public.is_management());

create policy inventory_items_insert_management
on public.inventory_items for insert to authenticated
with check (public.is_management());

create policy inventory_items_update_management
on public.inventory_items for update to authenticated
using (public.is_management())
with check (public.is_management());

create policy inventory_items_delete_management
on public.inventory_items for delete to authenticated
using (public.is_management());

-- ---------------------------------------------------------------------------
-- loans
-- ---------------------------------------------------------------------------

create policy loans_select_management
on public.loans for select to authenticated
using (public.is_management());

create policy loans_select_own
on public.loans for select to authenticated
using (
  public.is_active_user()
  and (public.is_atlet() or public.is_member())
  and borrower_id = auth.uid()
);

create policy loans_insert_management
on public.loans for insert to authenticated
with check (public.is_management());

create policy loans_update_management
on public.loans for update to authenticated
using (public.is_management())
with check (public.is_management());

create policy loans_delete_management
on public.loans for delete to authenticated
using (public.is_management());

-- ---------------------------------------------------------------------------
-- loan_items
-- ---------------------------------------------------------------------------

create policy loan_items_select_management
on public.loan_items for select to authenticated
using (public.is_management());

create policy loan_items_select_own
on public.loan_items for select to authenticated
using (
  public.is_active_user()
  and (public.is_atlet() or public.is_member())
  and exists (
    select 1
    from public.loans l
    where l.id = loan_items.loan_id
      and l.borrower_id = auth.uid()
  )
);

create policy loan_items_insert_management
on public.loan_items for insert to authenticated
with check (public.is_management());

create policy loan_items_update_management
on public.loan_items for update to authenticated
using (public.is_management())
with check (public.is_management());

create policy loan_items_delete_management
on public.loan_items for delete to authenticated
using (public.is_management());

-- ---------------------------------------------------------------------------
-- archives
-- ---------------------------------------------------------------------------

create policy archives_select_management
on public.archives for select to authenticated
using (public.is_management());

create policy archives_select_dosen
on public.archives for select to authenticated
using (public.is_dosen());

create policy archives_insert_management
on public.archives for insert to authenticated
with check (public.is_management());

create policy archives_update_management
on public.archives for update to authenticated
using (public.is_management())
with check (public.is_management());

create policy archives_delete_management
on public.archives for delete to authenticated
using (public.is_management());

-- ---------------------------------------------------------------------------
-- announcements
-- ---------------------------------------------------------------------------

create policy announcements_select_management
on public.announcements for select to authenticated
using (public.is_management());

create policy announcements_select_dosen
on public.announcements for select to authenticated
using (public.is_dosen());

create policy announcements_select_targeted
on public.announcements for select to authenticated
using (
  public.is_active_user()
  and (public.is_atlet() or public.is_member())
  and (target_role is null or target_role = public.current_profile_role())
  and (
    target_division_id is null
    or target_division_id = public.current_profile_division_id()
  )
);

create policy announcements_insert_management
on public.announcements for insert to authenticated
with check (public.is_management());

create policy announcements_update_management
on public.announcements for update to authenticated
using (public.is_management())
with check (public.is_management());

create policy announcements_delete_management
on public.announcements for delete to authenticated
using (public.is_management());

-- ---------------------------------------------------------------------------
-- activity_logs
-- Append-only: hanya SELECT. Tidak ada policy INSERT/UPDATE/DELETE.
-- ---------------------------------------------------------------------------

create policy activity_logs_select_management
on public.activity_logs for select to authenticated
using (public.is_management());

create policy activity_logs_select_self
on public.activity_logs for select to authenticated
using (
  public.is_active_user()
  and actor_id = auth.uid()
);
