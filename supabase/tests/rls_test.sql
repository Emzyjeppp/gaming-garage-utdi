-- rls_test.sql
-- Uji RLS Gaming Garage UTDI Tahap 1.
-- Jalankan dengan psql terhadap database Supabase yang sudah dimigrasi + diseed.
-- Seluruh fixture dibuat di dalam transaksi dan di-ROLLBACK di akhir.
--
-- Catatan:
-- - File ini mengasumsikan dijalankan oleh role postgres/service role.
-- - auth.uid() dibaca dari request.jwt.claims (format Supabase).
-- - Setiap PASS dicetak sebagai NOTICE; kegagalan melempar exception.

\set ON_ERROR_STOP on
\echo '=== RLS TEST: Gaming Garage UTDI Tahap 1 ==='

begin;

-- ---------------------------------------------------------------------------
-- Auth users (di Supabase, auth.users sudah ada)
-- ---------------------------------------------------------------------------

insert into auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at
)
values
  ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000001', 'authenticated', 'authenticated', 'manajemen@test.local', '', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000002', 'authenticated', 'authenticated', 'atlet-ff-a@test.local', '', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000003', 'authenticated', 'authenticated', 'atlet-ff-b@test.local', '', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000004', 'authenticated', 'authenticated', 'atlet-valorant@test.local', '', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000005', 'authenticated', 'authenticated', 'member@test.local', '', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000006', 'authenticated', 'authenticated', 'dosen@test.local', '', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000007', 'authenticated', 'authenticated', 'pending@test.local', '', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000008', 'authenticated', 'authenticated', 'inactive@test.local', '', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now()),
  ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000009', 'authenticated', 'authenticated', 'auth-only@test.local', '', now(), '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, now(), now());

-- ---------------------------------------------------------------------------
-- Profil fixture
-- ---------------------------------------------------------------------------

insert into public.profiles (
  id, role, nim, full_name, jurusan, division_id, team_id, status
)
values
  (
    '00000000-0000-0000-0000-000000000001',
    'manajemen', null, 'Manajemen Test', null, null, null, 'active'
  ),
  (
    '00000000-0000-0000-0000-000000000002',
    'atlet', 'TEST-FF-001', 'Atlet FF A', 'Informatika',
    (select id from public.divisions where name = 'Free Fire'),
    (select t.id from public.teams t
       join public.divisions d on d.id = t.division_id
      where d.name = 'Free Fire' and t.name = 'Tim Utama'),
    'active'
  ),
  (
    '00000000-0000-0000-0000-000000000003',
    'atlet', 'TEST-FF-002', 'Atlet FF B', 'Informatika',
    (select id from public.divisions where name = 'Free Fire'),
    (select t.id from public.teams t
       join public.divisions d on d.id = t.division_id
      where d.name = 'Free Fire' and t.name = 'Tim Utama'),
    'active'
  ),
  (
    '00000000-0000-0000-0000-000000000004',
    'atlet', 'TEST-VAL-001', 'Atlet Valorant C', 'Informatika',
    (select id from public.divisions where name = 'Valorant'),
    (select t.id from public.teams t
       join public.divisions d on d.id = t.division_id
      where d.name = 'Valorant' and t.name = 'Tim Utama'),
    'active'
  ),
  (
    '00000000-0000-0000-0000-000000000005',
    'member', 'TEST-MBR-001', 'Member Test', 'Informatika',
    (select id from public.divisions where name = 'Game Developer'),
    null, 'active'
  ),
  (
    '00000000-0000-0000-0000-000000000006',
    'dosen', null, 'Dosen Test', null, null, null, 'active'
  ),
  (
    '00000000-0000-0000-0000-000000000007',
    'atlet', 'TEST-FF-003', 'Atlet Pending', 'Informatika',
    (select id from public.divisions where name = 'Free Fire'),
    (select t.id from public.teams t
       join public.divisions d on d.id = t.division_id
      where d.name = 'Free Fire' and t.name = 'Tim Utama'),
    'pending'
  ),
  (
    '00000000-0000-0000-0000-000000000008',
    'member', 'TEST-MBR-002', 'Member Inactive', 'Informatika',
    (select id from public.divisions where name = 'Social Media'),
    null, 'inactive'
  );

-- ---------------------------------------------------------------------------
-- Fixture konten, jadwal, presensi, inventaris, arsip, performa, log
-- ---------------------------------------------------------------------------

insert into public.events (
  id, title, slug, type, status, start_date, created_by
)
values
  ('10000000-0000-0000-0000-000000000001', 'Test Published', 'test-published', 'workshop', 'published', current_date, '00000000-0000-0000-0000-000000000001'),
  ('10000000-0000-0000-0000-000000000002', 'Test Draft', 'test-draft', 'lainnya', 'draft', current_date, '00000000-0000-0000-0000-000000000001'),
  ('10000000-0000-0000-0000-000000000003', 'Test Finished', 'test-finished', 'turnamen', 'finished', current_date, '00000000-0000-0000-0000-000000000001');

insert into public.site_settings (key, value, updated_by)
values ('hero', '{}'::jsonb, '00000000-0000-0000-0000-000000000001');

insert into public.schedules (
  id, title, type, division_id, team_id, start_at, end_at, created_by
)
values (
  '20000000-0000-0000-0000-000000000001',
  'Test Schedule',
  'latihan',
  (select id from public.divisions where name = 'Free Fire'),
  (select t.id from public.teams t
     join public.divisions d on d.id = t.division_id
    where d.name = 'Free Fire' and t.name = 'Tim Utama'),
  now(),
  now() + interval '1 hour',
  '00000000-0000-0000-0000-000000000001'
);

insert into public.schedule_participants (schedule_id, profile_id)
values (
  '20000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000002'
);

insert into public.attendance_sessions (
  id, title, session_type, division_id, starts_at, ends_at,
  late_after, allow_guests, status, session_code, created_by
)
values (
  '30000000-0000-0000-0000-000000000001',
  'Test Session',
  'latihan',
  (select id from public.divisions where name = 'Free Fire'),
  now() - interval '1 hour',
  now() + interval '1 hour',
  now(),
  true,
  'open',
  'TEST-CODE-FF',
  '00000000-0000-0000-0000-000000000001'
);

insert into public.attendance_records (
  id, session_id, profile_id, status, checked_in_at, method
)
values
  ('31000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000002', 'hadir', now(), 'qr'),
  ('31000000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003', 'hadir', now(), 'qr');

insert into public.guest_attendances (
  id, session_id, name, purpose, checked_in_at
)
values (
  '32000000-0000-0000-0000-000000000001',
  '30000000-0000-0000-0000-000000000001',
  'Tamu Test',
  'Test',
  now()
);

insert into public.inventory_items (
  id, code, name, category, condition, status
)
values
  ('40000000-0000-0000-0000-000000000001', 'INV-TEST-001', 'Laptop Test', 'Laptop', 'baik', 'tersedia'),
  ('40000000-0000-0000-0000-000000000002', 'INV-TEST-002', 'Mouse Test', 'Aksesoris', 'baik', 'tersedia');

insert into public.loans (
  id, borrower_id, purpose, loaned_at, due_at, status, handled_by
)
values (
  '50000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000002',
  'Test Loan',
  now(),
  now() + interval '1 day',
  'dipinjam',
  '00000000-0000-0000-0000-000000000001'
);

insert into public.loan_items (loan_id, item_id, condition_out)
values (
  '50000000-0000-0000-0000-000000000001',
  '40000000-0000-0000-0000-000000000001',
  'baik'
);

insert into public.archives (
  id, title, category, file_path, file_name, file_type, file_size, uploaded_by
)
values (
  '60000000-0000-0000-0000-000000000001',
  'Test Archive',
  'dokumentasi',
  'test/archive.pdf',
  'archive.pdf',
  'application/pdf',
  1024,
  '00000000-0000-0000-0000-000000000001'
);

insert into public.announcements (
  id, title, body, target_role, target_division_id, created_by
)
values (
  '70000000-0000-0000-0000-000000000001',
  'Test Announcement',
  'Test Body',
  'atlet',
  (select id from public.divisions where name = 'Free Fire'),
  '00000000-0000-0000-0000-000000000001'
);

insert into public.performance_entries (
  id, athlete_id, division_id, played_on, match_type, result,
  verification_status, verified_by, verified_at
)
values
  (
    '80000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000003',
    (select id from public.divisions where name = 'Free Fire'),
    current_date, 'scrim', 'win', 'verified',
    '00000000-0000-0000-0000-000000000001', now()
  ),
  (
    '80000000-0000-0000-0000-000000000002',
    '00000000-0000-0000-0000-000000000003',
    (select id from public.divisions where name = 'Free Fire'),
    current_date, 'scrim', 'lose', 'pending', null, null
  ),
  (
    '80000000-0000-0000-0000-000000000003',
    '00000000-0000-0000-0000-000000000004',
    (select id from public.divisions where name = 'Valorant'),
    current_date, 'scrim', 'win', 'verified',
    '00000000-0000-0000-0000-000000000001', now()
  ),
  (
    '80000000-0000-0000-0000-000000000004',
    '00000000-0000-0000-0000-000000000002',
    (select id from public.divisions where name = 'Free Fire'),
    current_date, 'latihan', 'draw', 'pending', null, null
  );

insert into public.performance_values (id, entry_id, metric_id, value)
values
  (
    '81000000-0000-0000-0000-000000000001',
    '80000000-0000-0000-0000-000000000001',
    (select m.id from public.metric_definitions m
       join public.divisions d on d.id = m.division_id
      where d.name = 'Free Fire' and m.key = 'kills'),
    10
  ),
  (
    '81000000-0000-0000-0000-000000000002',
    '80000000-0000-0000-0000-000000000002',
    (select m.id from public.metric_definitions m
       join public.divisions d on d.id = m.division_id
      where d.name = 'Free Fire' and m.key = 'kills'),
    5
  ),
  (
    '81000000-0000-0000-0000-000000000003',
    '80000000-0000-0000-0000-000000000003',
    (select m.id from public.metric_definitions m
       join public.divisions d on d.id = m.division_id
      where d.name = 'Valorant' and m.key = 'kills'),
    20
  ),
  (
    '81000000-0000-0000-0000-000000000004',
    '80000000-0000-0000-0000-000000000004',
    (select m.id from public.metric_definitions m
       join public.divisions d on d.id = m.division_id
      where d.name = 'Free Fire' and m.key = 'kills'),
    7
  );

insert into public.coach_notes (id, athlete_id, entry_id, author_id, note)
values
  ('90000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000002', '80000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000001', 'Catatan untuk A'),
  ('90000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000003', '80000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'Catatan untuk B');

insert into public.activity_logs (id, actor_id, action, entity_type)
values
  ('a0000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'login', 'auth'),
  ('a0000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', 'login', 'auth'),
  ('a0000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000003', 'login', 'auth'),
  ('a0000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000006', 'login', 'auth'),
  ('a0000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000005', 'login', 'auth');

-- Filter anon: satu divisi disembunyikan dari landing, satu dinonaktifkan.
update public.divisions set show_on_landing = false where name = 'Game Developer';
update public.divisions set is_active = false where name = 'Event & Talent';

-- ===========================================================================
-- SKENARIO: Atlet Free Fire
-- ===========================================================================

\echo '--- Atlet Free Fire: visibilitas performa dan data ---'
reset role;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000002","role":"authenticated"}', true);
set local role authenticated;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count from public.profiles where id = '00000000-0000-0000-0000-000000000002';
  if v_count <> 1 then raise exception 'FAIL: atlet tidak bisa membaca profil sendiri'; end if;

  select count(*) into v_count from public.profiles where id = '00000000-0000-0000-0000-000000000003';
  if v_count <> 1 then raise exception 'FAIL: atlet tidak bisa membaca profil rekan satu tim'; end if;

  select count(*) into v_count from public.profiles where id = '00000000-0000-0000-0000-000000000004';
  if v_count <> 0 then raise exception 'FAIL: atlet bisa membaca profil divisi lain'; end if;

  select count(*) into v_count from public.performance_entries where id = '80000000-0000-0000-0000-000000000001';
  if v_count <> 1 then raise exception 'FAIL: atlet tidak melihat entri verified rekan Free Fire'; end if;

  select count(*) into v_count from public.performance_entries where id = '80000000-0000-0000-0000-000000000002';
  if v_count <> 0 then raise exception 'FAIL: atlet melihat entri pending rekan Free Fire'; end if;

  select count(*) into v_count from public.performance_entries where id = '80000000-0000-0000-0000-000000000003';
  if v_count <> 0 then raise exception 'FAIL: atlet melihat entri divisi lain'; end if;

  select count(*) into v_count from public.performance_entries where id = '80000000-0000-0000-0000-000000000004';
  if v_count <> 1 then raise exception 'FAIL: atlet tidak melihat entri miliknya sendiri'; end if;

  select count(*) into v_count from public.performance_values where entry_id = '80000000-0000-0000-0000-000000000001';
  if v_count <> 1 then raise exception 'FAIL: atlet tidak melihat value verified rekan'; end if;

  select count(*) into v_count from public.performance_values where entry_id = '80000000-0000-0000-0000-000000000002';
  if v_count <> 0 then raise exception 'FAIL: atlet melihat value pending rekan'; end if;

  select count(*) into v_count from public.performance_values where entry_id = '80000000-0000-0000-0000-000000000003';
  if v_count <> 0 then raise exception 'FAIL: atlet melihat value divisi lain'; end if;

  select count(*) into v_count
    from public.metric_definitions m
    join public.divisions d on d.id = m.division_id
   where d.name = 'Free Fire';
  if v_count <> 5 then raise exception 'FAIL: atlet tidak melihat 5 metrik Free Fire (got %)', v_count; end if;

  select count(*) into v_count
    from public.metric_definitions m
    join public.divisions d on d.id = m.division_id
   where d.name = 'Valorant';
  if v_count <> 0 then raise exception 'FAIL: atlet melihat metrik divisi lain'; end if;

  select count(*) into v_count from public.schedules where id = '20000000-0000-0000-0000-000000000001';
  if v_count <> 1 then raise exception 'FAIL: atlet tidak melihat jadwal miliknya'; end if;

  select count(*) into v_count from public.schedule_participants where schedule_id = '20000000-0000-0000-0000-000000000001';
  if v_count <> 1 then raise exception 'FAIL: atlet tidak melihat partisipasi jadwal sendiri'; end if;

  select count(*) into v_count from public.attendance_sessions where id = '30000000-0000-0000-0000-000000000001';
  if v_count <> 1 then raise exception 'FAIL: atlet tidak melihat sesi presensi divisinya'; end if;

  select count(*) into v_count from public.attendance_records where id = '31000000-0000-0000-0000-000000000001';
  if v_count <> 1 then raise exception 'FAIL: atlet tidak melihat presensi sendiri'; end if;

  select count(*) into v_count from public.attendance_records where id = '31000000-0000-0000-0000-000000000002';
  if v_count <> 0 then raise exception 'FAIL: atlet melihat presensi rekan'; end if;

  select count(*) into v_count from public.loans where id = '50000000-0000-0000-0000-000000000001';
  if v_count <> 1 then raise exception 'FAIL: atlet tidak melihat pinjaman sendiri'; end if;

  select count(*) into v_count from public.loan_items where loan_id = '50000000-0000-0000-0000-000000000001';
  if v_count <> 1 then raise exception 'FAIL: atlet tidak melihat item pinjaman sendiri'; end if;

  select count(*) into v_count from public.inventory_items;
  if v_count <> 0 then raise exception 'FAIL: atlet bisa membaca inventaris'; end if;

  select count(*) into v_count from public.archives;
  if v_count <> 0 then raise exception 'FAIL: atlet bisa membaca arsip'; end if;

  select count(*) into v_count from public.guest_attendances;
  if v_count <> 0 then raise exception 'FAIL: atlet bisa membaca presensi tamu'; end if;

  select count(*) into v_count from public.announcements where id = '70000000-0000-0000-0000-000000000001';
  if v_count <> 1 then raise exception 'FAIL: atlet tidak melihat pengumuman yang ditargetkan'; end if;

  select count(*) into v_count from public.coach_notes where id = '90000000-0000-0000-0000-000000000001';
  if v_count <> 1 then raise exception 'FAIL: atlet tidak melihat catatan pelatih untuk dirinya'; end if;

  select count(*) into v_count from public.coach_notes where id = '90000000-0000-0000-0000-000000000002';
  if v_count <> 0 then raise exception 'FAIL: atlet melihat catatan pelatih untuk rekan'; end if;

  select count(*) into v_count from public.activity_logs;
  if v_count <> 1 then raise exception 'FAIL: atlet tidak melihat tepat satu log miliknya (got %)', v_count; end if;

  select count(*) into v_count from public.activity_logs where id = 'a0000000-0000-0000-0000-000000000003';
  if v_count <> 0 then raise exception 'FAIL: atlet melihat log milik rekan'; end if;

  select count(*) into v_count from public.events;
  if v_count <> 3 then raise exception 'FAIL: atlet active tidak melihat semua event (got %)', v_count; end if;

  raise notice 'PASS: atlet Free Fire hanya melihat entri verified rekan Free Fire, entri sendiri, dan data yang relevan';
end;
$$;

\echo '--- Atlet: proteksi kolom profil ---'
do $$
declare
  v_sqls text[] := array[
    $sql$update public.profiles set role = 'manajemen' where id = '00000000-0000-0000-0000-000000000002'$sql$,
    $sql$update public.profiles set status = 'inactive' where id = '00000000-0000-0000-0000-000000000002'$sql$,
    $sql$update public.profiles set nim = 'HACKED' where id = '00000000-0000-0000-0000-000000000002'$sql$,
    $sql$update public.profiles set division_id = (select id from public.divisions where name = 'Valorant') where id = '00000000-0000-0000-0000-000000000002'$sql$,
    $sql$update public.profiles set team_id = (select t.id from public.teams t join public.divisions d on d.id = t.division_id where d.name = 'Valorant' and t.name = 'Tim Utama') where id = '00000000-0000-0000-0000-000000000002'$sql$
  ];
  i integer;
begin
  for i in 1..array_length(v_sqls, 1) loop
    begin
      execute v_sqls[i];
      raise exception 'FAIL: atlet bisa mengubah protected field (statement %)', i;
    exception
      when insufficient_privilege then
        null;
    end;
  end loop;
  raise notice 'PASS: atlet ditolak mengubah role/status/nim/division_id/team_id';
end;
$$;

do $$
begin
  update public.profiles
     set full_name = 'Atlet FF A Updated', jurusan = 'Sistem Informasi'
   where id = '00000000-0000-0000-0000-000000000002';
  if not found then
    raise exception 'FAIL: atlet tidak bisa update nama/jurusan sendiri';
  end if;
  raise notice 'PASS: atlet bisa update nama/jurusan sendiri';
end;
$$;

do $$
begin
  update public.profiles
     set full_name = 'Hacked Teammate'
   where id = '00000000-0000-0000-0000-000000000003';
  if found then
    raise exception 'FAIL: atlet bisa update profil rekan';
  end if;
  raise notice 'PASS: atlet tidak bisa update profil rekan';
end;
$$;

-- ===========================================================================
-- SKENARIO: Member
-- ===========================================================================

\echo '--- Member: performa dan data lain ---'
reset role;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000005","role":"authenticated"}', true);
set local role authenticated;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count from public.performance_entries;
  if v_count <> 0 then raise exception 'FAIL: member bisa membaca performance_entries'; end if;

  select count(*) into v_count from public.performance_values;
  if v_count <> 0 then raise exception 'FAIL: member bisa membaca performance_values'; end if;

  select count(*) into v_count from public.coach_notes;
  if v_count <> 0 then raise exception 'FAIL: member bisa membaca coach_notes'; end if;

  select count(*) into v_count from public.profiles where id = '00000000-0000-0000-0000-000000000005';
  if v_count <> 1 then raise exception 'FAIL: member tidak bisa membaca profil sendiri'; end if;

  select count(*) into v_count from public.profiles where id <> '00000000-0000-0000-0000-000000000005';
  if v_count <> 0 then raise exception 'FAIL: member bisa membaca profil lain'; end if;

  select count(*) into v_count from public.schedules where id = '20000000-0000-0000-0000-000000000001';
  if v_count <> 0 then raise exception 'FAIL: member bisa membaca jadwal yang bukan miliknya'; end if;

  select count(*) into v_count from public.attendance_sessions where id = '30000000-0000-0000-0000-000000000001';
  if v_count <> 0 then raise exception 'FAIL: member bisa membaca sesi divisi lain'; end if;

  select count(*) into v_count from public.loans;
  if v_count <> 0 then raise exception 'FAIL: member bisa membaca pinjaman orang lain'; end if;

  select count(*) into v_count from public.announcements where id = '70000000-0000-0000-0000-000000000001';
  if v_count <> 0 then raise exception 'FAIL: member melihat pengumuman target atlet'; end if;

  select count(*) into v_count from public.activity_logs;
  if v_count <> 1 then raise exception 'FAIL: member tidak melihat tepat satu log miliknya (got %)', v_count; end if;

  select count(*) into v_count from public.events;
  if v_count <> 3 then raise exception 'FAIL: member active tidak melihat semua event (got %)', v_count; end if;

  raise notice 'PASS: member tidak bisa membaca performance_entries/values dan hanya melihat data miliknya';
end;
$$;

-- ===========================================================================
-- SKENARIO: Pending
-- ===========================================================================

\echo '--- Pending: hanya profil sendiri ---'
reset role;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000007","role":"authenticated"}', true);
set local role authenticated;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count from public.profiles where id = '00000000-0000-0000-0000-000000000007';
  if v_count <> 1 then raise exception 'FAIL: pending tidak bisa membaca profil sendiri'; end if;

  select count(*) into v_count from public.profiles where id <> '00000000-0000-0000-0000-000000000007';
  if v_count <> 0 then raise exception 'FAIL: pending bisa membaca profil lain'; end if;

  select count(*) into v_count from public.divisions;
  if v_count <> 0 then raise exception 'FAIL: pending bisa membaca divisions'; end if;

  select count(*) into v_count from public.events;
  if v_count <> 0 then raise exception 'FAIL: pending bisa membaca events'; end if;

  select count(*) into v_count from public.performance_entries;
  if v_count <> 0 then raise exception 'FAIL: pending bisa membaca performance_entries'; end if;

  select count(*) into v_count from public.attendance_sessions;
  if v_count <> 0 then raise exception 'FAIL: pending bisa membaca attendance_sessions'; end if;

  select count(*) into v_count from public.activity_logs;
  if v_count <> 0 then raise exception 'FAIL: pending bisa membaca activity_logs'; end if;

  update public.profiles set full_name = 'Pending Update' where id = '00000000-0000-0000-0000-000000000007';
  if found then raise exception 'FAIL: pending bisa update profil sendiri'; end if;

  raise notice 'PASS: pending hanya bisa membaca profil sendiri dan tidak bisa update';
end;
$$;

-- ===========================================================================
-- SKENARIO: Inactive
-- ===========================================================================

\echo '--- Inactive: hanya profil sendiri ---'
reset role;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000008","role":"authenticated"}', true);
set local role authenticated;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count from public.profiles where id = '00000000-0000-0000-0000-000000000008';
  if v_count <> 1 then raise exception 'FAIL: inactive tidak bisa membaca profil sendiri'; end if;

  select count(*) into v_count from public.profiles where id <> '00000000-0000-0000-0000-000000000008';
  if v_count <> 0 then raise exception 'FAIL: inactive bisa membaca profil lain'; end if;

  select count(*) into v_count from public.divisions;
  if v_count <> 0 then raise exception 'FAIL: inactive bisa membaca divisions'; end if;

  select count(*) into v_count from public.events;
  if v_count <> 0 then raise exception 'FAIL: inactive bisa membaca events'; end if;

  raise notice 'PASS: inactive hanya bisa membaca profil sendiri';
end;
$$;

-- ===========================================================================
-- SKENARIO: Anon
-- ===========================================================================

\echo '--- Anon: event published, divisions landing, site_settings ---'
reset role;
select set_config('request.jwt.claims', '{}', true);
set local role anon;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count from public.events where id = '10000000-0000-0000-0000-000000000001';
  if v_count <> 1 then raise exception 'FAIL: anon tidak bisa membaca event published'; end if;

  select count(*) into v_count from public.events where id = '10000000-0000-0000-0000-000000000002';
  if v_count <> 0 then raise exception 'FAIL: anon bisa membaca event draft'; end if;

  select count(*) into v_count from public.events where id = '10000000-0000-0000-0000-000000000003';
  if v_count <> 0 then raise exception 'FAIL: anon bisa membaca event finished (aturan Tahap 1: published saja)'; end if;

  select count(*) into v_count from public.divisions;
  if v_count <> 6 then raise exception 'FAIL: anon tidak melihat tepat 6 divisi landing (got %)', v_count; end if;

  select count(*) into v_count from public.site_settings;
  if v_count <> 1 then raise exception 'FAIL: anon tidak bisa membaca site_settings'; end if;

  begin
    execute 'select count(*) from public.profiles';
    raise exception 'FAIL: anon bisa membaca profiles';
  exception
    when insufficient_privilege then
      raise notice 'PASS: anon ditolak membaca profiles';
  end;

  begin
    execute 'select count(*) from public.attendance_sessions';
    raise exception 'FAIL: anon bisa membaca attendance_sessions';
  exception
    when insufficient_privilege then
      raise notice 'PASS: anon ditolak membaca attendance_sessions';
  end;

  begin
    insert into public.events (title, slug, type, start_date, status, created_by)
    values ('Anon Event', 'anon-event', 'lainnya', current_date, 'draft', '00000000-0000-0000-0000-000000000001');
    raise exception 'FAIL: anon bisa INSERT events';
  exception
    when insufficient_privilege then
      raise notice 'PASS: anon ditolak INSERT events';
  end;

  raise notice 'PASS: anon hanya membaca event published, divisions landing, dan site_settings';
end;
$$;

-- ===========================================================================
-- SKENARIO: Dosen read-only
-- ===========================================================================

\echo '--- Dosen: SELECT sesuai bagian 11 ---'
reset role;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000006","role":"authenticated"}', true);
set local role authenticated;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count from public.profiles;
  if v_count <> 8 then raise exception 'FAIL: dosen tidak melihat semua 8 profil (got %)', v_count; end if;

  select count(*) into v_count from public.performance_entries;
  if v_count <> 4 then raise exception 'FAIL: dosen tidak melihat semua performance_entries (got %)', v_count; end if;

  select count(*) into v_count from public.performance_values;
  if v_count <> 4 then raise exception 'FAIL: dosen tidak melihat semua performance_values (got %)', v_count; end if;

  select count(*) into v_count from public.coach_notes;
  if v_count <> 2 then raise exception 'FAIL: dosen tidak melihat semua coach_notes (got %)', v_count; end if;

  select count(*) into v_count from public.attendance_records;
  if v_count <> 2 then raise exception 'FAIL: dosen tidak melihat semua attendance_records (got %)', v_count; end if;

  select count(*) into v_count from public.attendance_sessions;
  if v_count <> 1 then raise exception 'FAIL: dosen tidak melihat attendance_sessions (got %)', v_count; end if;

  select count(*) into v_count from public.archives;
  if v_count <> 1 then raise exception 'FAIL: dosen tidak melihat archives (got %)', v_count; end if;

  select count(*) into v_count from public.schedules;
  if v_count <> 1 then raise exception 'FAIL: dosen tidak melihat schedules (got %)', v_count; end if;

  select count(*) into v_count from public.schedule_participants;
  if v_count <> 1 then raise exception 'FAIL: dosen tidak melihat schedule_participants (got %)', v_count; end if;

  select count(*) into v_count from public.events;
  if v_count <> 3 then raise exception 'FAIL: dosen tidak melihat semua events (got %)', v_count; end if;

  select count(*) into v_count from public.divisions;
  if v_count <> 8 then raise exception 'FAIL: dosen tidak melihat semua divisions (got %)', v_count; end if;

  select count(*) into v_count from public.site_settings;
  if v_count <> 1 then raise exception 'FAIL: dosen tidak melihat site_settings (got %)', v_count; end if;

  select count(*) into v_count from public.teams;
  if v_count <> 5 then raise exception 'FAIL: dosen tidak melihat semua teams (got %)', v_count; end if;

  select count(*) into v_count from public.metric_definitions;
  if v_count <> 29 then raise exception 'FAIL: dosen tidak melihat semua metric_definitions (got %)', v_count; end if;

  select count(*) into v_count from public.announcements;
  if v_count <> 1 then raise exception 'FAIL: dosen tidak melihat announcements (got %)', v_count; end if;

  select count(*) into v_count from public.loans;
  if v_count <> 0 then raise exception 'FAIL: dosen bisa membaca loans'; end if;

  select count(*) into v_count from public.inventory_items;
  if v_count <> 0 then raise exception 'FAIL: dosen bisa membaca inventory_items'; end if;

  select count(*) into v_count from public.guest_attendances;
  if v_count <> 0 then raise exception 'FAIL: dosen bisa membaca guest_attendances'; end if;

  select count(*) into v_count from public.activity_logs;
  if v_count <> 1 then raise exception 'FAIL: dosen tidak melihat tepat satu log miliknya (got %)', v_count; end if;

  raise notice 'PASS: dosen bisa SELECT sesuai bagian 11';
end;
$$;

\echo '--- Dosen: UPDATE/DELETE ditolak di semua 20 tabel ---'
do $$
declare
  v_tables text[] := array[
    'profiles',
    'divisions',
    'teams',
    'metric_definitions',
    'performance_entries',
    'performance_values',
    'coach_notes',
    'events',
    'site_settings',
    'schedules',
    'schedule_participants',
    'attendance_sessions',
    'attendance_records',
    'guest_attendances',
    'inventory_items',
    'loans',
    'loan_items',
    'archives',
    'announcements',
    'activity_logs'
  ];
  v_where text[] := array[
    $w$id = '00000000-0000-0000-0000-000000000006'$w$,
    $w$id = (select id from public.divisions where name = 'Free Fire')$w$,
    $w$division_id = (select id from public.divisions where name = 'Free Fire') and name = 'Tim Utama'$w$,
    $w$division_id = (select id from public.divisions where name = 'Free Fire') and key = 'kills'$w$,
    $w$id = '80000000-0000-0000-0000-000000000001'$w$,
    $w$id = '81000000-0000-0000-0000-000000000001'$w$,
    $w$id = '90000000-0000-0000-0000-000000000001'$w$,
    $w$id = '10000000-0000-0000-0000-000000000001'$w$,
    $w$key = 'hero'$w$,
    $w$id = '20000000-0000-0000-0000-000000000001'$w$,
    $w$schedule_id = '20000000-0000-0000-0000-000000000001' and profile_id = '00000000-0000-0000-0000-000000000002'$w$,
    $w$id = '30000000-0000-0000-0000-000000000001'$w$,
    $w$id = '31000000-0000-0000-0000-000000000001'$w$,
    $w$id = '32000000-0000-0000-0000-000000000001'$w$,
    $w$id = '40000000-0000-0000-0000-000000000001'$w$,
    $w$id = '50000000-0000-0000-0000-000000000001'$w$,
    $w$loan_id = '50000000-0000-0000-0000-000000000001' and item_id = '40000000-0000-0000-0000-000000000001'$w$,
    $w$id = '60000000-0000-0000-0000-000000000001'$w$,
    $w$id = '70000000-0000-0000-0000-000000000001'$w$,
    $w$id = 'a0000000-0000-0000-0000-000000000004'$w$
  ];
  i integer;
  v_rows integer;
begin
  for i in 1..array_length(v_tables, 1) loop
    begin
      execute format('update public.%I set created_at = created_at where %s', v_tables[i], v_where[i]);
      get diagnostics v_rows = row_count;
      if v_rows <> 0 then
        raise exception 'FAIL: dosen bisa UPDATE %', v_tables[i];
      end if;
    exception
      when insufficient_privilege then
        null;
    end;

    begin
      execute format('delete from public.%I where %s', v_tables[i], v_where[i]);
      get diagnostics v_rows = row_count;
      if v_rows <> 0 then
        raise exception 'FAIL: dosen bisa DELETE %', v_tables[i];
      end if;
    exception
      when insufficient_privilege then
        null;
    end;
  end loop;
  raise notice 'PASS: dosen ditolak UPDATE dan DELETE di semua 20 tabel';
end;
$$;

\echo '--- Dosen: INSERT ditolak di semua 20 tabel ---'
do $$
declare
  v_sqls text[] := array[
    $s$insert into public.profiles (id, role, nim, full_name, status) values ('00000000-0000-0000-0000-000000000009', 'atlet', 'DOSEN-TEST-INSERT', 'Dosen Insert Test', 'pending')$s$,
    $s$insert into public.divisions (name, kind) values ('Dosen Test Division', 'esport')$s$,
    $s$insert into public.teams (division_id, name) values ((select id from public.divisions where name = 'Free Fire'), 'Dosen Test Team')$s$,
    $s$insert into public.metric_definitions (division_id, key, label, data_type) values ((select id from public.divisions where name = 'Free Fire'), 'dosen_test_metric', 'Dosen Test', 'integer')$s$,
    $s$insert into public.performance_entries (athlete_id, division_id, played_on, match_type, result) values ('00000000-0000-0000-0000-000000000002', (select id from public.divisions where name = 'Free Fire'), current_date, 'latihan', 'win')$s$,
    $s$insert into public.performance_values (entry_id, metric_id, value) values ('80000000-0000-0000-0000-000000000001', (select m.id from public.metric_definitions m join public.divisions d on d.id = m.division_id where d.name = 'Free Fire' and m.key = 'damage'), 1)$s$,
    $s$insert into public.coach_notes (athlete_id, author_id, note) values ('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000006', 'Dosen Test Note')$s$,
    $s$insert into public.events (title, slug, type, start_date, status, created_by) values ('Dosen Test Event', 'dosen-test-event', 'lainnya', current_date, 'draft', '00000000-0000-0000-0000-000000000006')$s$,
    $s$insert into public.site_settings (key, value, updated_by) values ('about', '{}'::jsonb, '00000000-0000-0000-0000-000000000006')$s$,
    $s$insert into public.schedules (title, type, division_id, start_at, end_at, created_by) values ('Dosen Test Schedule', 'latihan', (select id from public.divisions where name = 'Free Fire'), now(), now() + interval '1 hour', '00000000-0000-0000-0000-000000000006')$s$,
    $s$insert into public.schedule_participants (schedule_id, profile_id) values ('20000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000006')$s$,
    $s$insert into public.attendance_sessions (title, session_type, division_id, starts_at, ends_at, status, session_code, created_by) values ('Dosen Test Session', 'latihan', (select id from public.divisions where name = 'Free Fire'), now(), now() + interval '1 hour', 'open', 'DOSEN-TEST-CODE', '00000000-0000-0000-0000-000000000006')$s$,
    $s$insert into public.attendance_records (session_id, profile_id, status, method) values ('30000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000006', 'hadir', 'qr')$s$,
    $s$insert into public.guest_attendances (session_id, name, purpose, checked_in_at) values ('30000000-0000-0000-0000-000000000001', 'Dosen Guest', 'Test', now())$s$,
    $s$insert into public.inventory_items (code, name, category, condition, status) values ('DOSEN-TEST-INV', 'Dosen Test Item', 'Test', 'baik', 'tersedia')$s$,
    $s$insert into public.loans (borrower_id, purpose, loaned_at, due_at, status, handled_by) values ('00000000-0000-0000-0000-000000000006', 'Dosen Test Loan', now(), now() + interval '1 day', 'dipinjam', '00000000-0000-0000-0000-000000000006')$s$,
    $s$insert into public.loan_items (loan_id, item_id, condition_out) values ('50000000-0000-0000-0000-000000000001', '40000000-0000-0000-0000-000000000002', 'baik')$s$,
    $s$insert into public.archives (title, category, file_path, file_name, file_type, file_size, uploaded_by) values ('Dosen Test Archive', 'lainnya', 'test/dosen.pdf', 'dosen.pdf', 'application/pdf', 10, '00000000-0000-0000-0000-000000000006')$s$,
    $s$insert into public.announcements (title, body, created_by) values ('Dosen Test Announcement', 'Test', '00000000-0000-0000-0000-000000000006')$s$,
    $s$insert into public.activity_logs (actor_id, action, entity_type) values ('00000000-0000-0000-0000-000000000006', 'login', 'auth')$s$
  ];
  i integer;
begin
  for i in 1..array_length(v_sqls, 1) loop
    begin
      execute v_sqls[i];
      raise exception 'FAIL: dosen bisa INSERT statement %', i;
    exception
      when insufficient_privilege then
        null;
    end;
  end loop;
  raise notice 'PASS: dosen ditolak INSERT di semua 20 tabel';
end;
$$;

-- ===========================================================================
-- SKENARIO: Non-Manajemen tidak boleh menulis presensi
-- ===========================================================================

\echo '--- Atlet: tulis attendance_records/guest_attendances ditolak ---'
reset role;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000002","role":"authenticated"}', true);
set local role authenticated;

do $$
begin
  begin
    insert into public.attendance_records (session_id, profile_id, status, method)
    values ('30000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000007', 'hadir', 'qr');
    raise exception 'FAIL: atlet bisa INSERT attendance_records';
  exception
    when insufficient_privilege then
      raise notice 'PASS: atlet ditolak INSERT attendance_records';
  end;

  begin
    insert into public.guest_attendances (session_id, name, purpose, checked_in_at)
    values ('30000000-0000-0000-0000-000000000001', 'Tamu Atlet', 'Test', now());
    raise exception 'FAIL: atlet bisa INSERT guest_attendances';
  exception
    when insufficient_privilege then
      raise notice 'PASS: atlet ditolak INSERT guest_attendances';
  end;

  update public.attendance_records
     set status = 'alpa'
   where id = '31000000-0000-0000-0000-000000000001';
  if found then
    raise exception 'FAIL: atlet bisa UPDATE attendance_records';
  end if;
  raise notice 'PASS: atlet ditolak UPDATE attendance_records';
end;
$$;

\echo '--- Member: tulis attendance_records ditolak ---'
reset role;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000005","role":"authenticated"}', true);
set local role authenticated;

do $$
begin
  begin
    insert into public.attendance_records (session_id, profile_id, status, method)
    values ('30000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000007', 'hadir', 'qr');
    raise exception 'FAIL: member bisa INSERT attendance_records';
  exception
    when insufficient_privilege then
      raise notice 'PASS: member ditolak INSERT attendance_records';
  end;
end;
$$;

-- ===========================================================================
-- SKENARIO: session_code hanya untuk Manajemen
-- ===========================================================================

\echo '--- Atlet: session_code tidak terbaca ---'
reset role;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000002","role":"authenticated"}', true);
set local role authenticated;

do $$
declare
  v_code text;
begin
  begin
    select session_code into v_code
      from public.attendance_sessions
     where id = '30000000-0000-0000-0000-000000000001';
    raise exception 'FAIL: atlet bisa SELECT session_code langsung';
  exception
    when insufficient_privilege then
      raise notice 'PASS: atlet ditolak SELECT session_code langsung';
  end;

  begin
    perform public.get_session_code('30000000-0000-0000-0000-000000000001');
    raise exception 'FAIL: atlet bisa memanggil get_session_code';
  exception
    when insufficient_privilege then
      raise notice 'PASS: atlet ditolak get_session_code';
  end;
end;
$$;

\echo '--- Dosen: session_code tidak terbaca ---'
reset role;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000006","role":"authenticated"}', true);
set local role authenticated;

do $$
declare
  v_code text;
begin
  begin
    select session_code into v_code
      from public.attendance_sessions
     where id = '30000000-0000-0000-0000-000000000001';
    raise exception 'FAIL: dosen bisa SELECT session_code langsung';
  exception
    when insufficient_privilege then
      raise notice 'PASS: dosen ditolak SELECT session_code langsung';
  end;

  begin
    perform public.get_session_code('30000000-0000-0000-0000-000000000001');
    raise exception 'FAIL: dosen bisa memanggil get_session_code';
  exception
    when insufficient_privilege then
      raise notice 'PASS: dosen ditolak get_session_code';
  end;
end;
$$;

\echo '--- Manajemen: session_code lewat RPC ---'
reset role;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000001","role":"authenticated"}', true);
set local role authenticated;

do $$
declare
  v_code text;
  v_title text;
begin
  begin
    select session_code into v_code
      from public.attendance_sessions
     where id = '30000000-0000-0000-0000-000000000001';
    raise exception 'FAIL: manajemen bisa SELECT session_code langsung';
  exception
    when insufficient_privilege then
      raise notice 'PASS: manajemen ditolak SELECT session_code langsung';
  end;

  v_code := public.get_session_code('30000000-0000-0000-0000-000000000001');
  if v_code <> 'TEST-CODE-FF' then
    raise exception 'FAIL: get_session_code Manajemen mengembalikan nilai salah';
  end if;

  select title into v_title
    from public.attendance_sessions
   where id = '30000000-0000-0000-0000-000000000001';
  if v_title <> 'Test Session' then
    raise exception 'FAIL: manajemen tidak bisa membaca kolom attendance_sessions lain';
  end if;

  raise notice 'PASS: manajemen membaca session_code lewat get_session_code';
end;
$$;

-- ===========================================================================
-- SKENARIO: activity_logs append-only
-- ===========================================================================

\echo '--- Manajemen: activity_logs update/delete ditolak ---'
do $$
begin
  begin
    update public.activity_logs set action = 'logout' where id = 'a0000000-0000-0000-0000-000000000001';
    raise exception 'FAIL: manajemen bisa UPDATE activity_logs';
  exception
    when insufficient_privilege then
      raise notice 'PASS: manajemen ditolak UPDATE activity_logs';
  end;

  begin
    delete from public.activity_logs where id = 'a0000000-0000-0000-0000-000000000001';
    raise exception 'FAIL: manajemen bisa DELETE activity_logs';
  exception
    when insufficient_privilege then
      raise notice 'PASS: manajemen ditolak DELETE activity_logs';
  end;
end;
$$;

\echo '--- Atlet: activity_logs update/delete ditolak ---'
reset role;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000002","role":"authenticated"}', true);
set local role authenticated;

do $$
begin
  begin
    update public.activity_logs set action = 'logout' where id = 'a0000000-0000-0000-0000-000000000002';
    raise exception 'FAIL: atlet bisa UPDATE activity_logs';
  exception
    when insufficient_privilege then
      raise notice 'PASS: atlet ditolak UPDATE activity_logs';
  end;

  begin
    delete from public.activity_logs where id = 'a0000000-0000-0000-0000-000000000002';
    raise exception 'FAIL: atlet bisa DELETE activity_logs';
  exception
    when insufficient_privilege then
      raise notice 'PASS: atlet ditolak DELETE activity_logs';
  end;
end;
$$;

\echo '--- Dosen: activity_logs update/delete ditolak ---'
reset role;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000006","role":"authenticated"}', true);
set local role authenticated;

do $$
begin
  begin
    update public.activity_logs set action = 'logout' where id = 'a0000000-0000-0000-0000-000000000004';
    raise exception 'FAIL: dosen bisa UPDATE activity_logs';
  exception
    when insufficient_privilege then
      raise notice 'PASS: dosen ditolak UPDATE activity_logs';
  end;

  begin
    delete from public.activity_logs where id = 'a0000000-0000-0000-0000-000000000004';
    raise exception 'FAIL: dosen bisa DELETE activity_logs';
  exception
    when insufficient_privilege then
      raise notice 'PASS: dosen ditolak DELETE activity_logs';
  end;
end;
$$;

\echo '--- Member: activity_logs update/delete ditolak ---'
reset role;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000005","role":"authenticated"}', true);
set local role authenticated;

do $$
begin
  begin
    update public.activity_logs set action = 'logout' where id = 'a0000000-0000-0000-0000-000000000005';
    raise exception 'FAIL: member bisa UPDATE activity_logs';
  exception
    when insufficient_privilege then
      raise notice 'PASS: member ditolak UPDATE activity_logs';
  end;

  begin
    delete from public.activity_logs where id = 'a0000000-0000-0000-0000-000000000005';
    raise exception 'FAIL: member bisa DELETE activity_logs';
  exception
    when insufficient_privilege then
      raise notice 'PASS: member ditolak DELETE activity_logs';
  end;
end;
$$;

\echo '--- Postgres: trigger append-only activity_logs ---'
reset role;
select set_config('request.jwt.claims', '{}', true);

do $$
begin
  begin
    update public.activity_logs set action = 'logout' where id = 'a0000000-0000-0000-0000-000000000001';
    raise exception 'FAIL: postgres bisa UPDATE activity_logs';
  exception
    when insufficient_privilege then
      raise notice 'PASS: trigger activity_logs menolak UPDATE untuk postgres';
  end;

  begin
    delete from public.activity_logs where id = 'a0000000-0000-0000-0000-000000000001';
    raise exception 'FAIL: postgres bisa DELETE activity_logs';
  exception
    when insufficient_privilege then
      raise notice 'PASS: trigger activity_logs menolak DELETE untuk postgres';
  end;
end;
$$;

-- ===========================================================================
-- SKENARIO: Manajemen CRUD sesuai matriks
-- ===========================================================================

\echo '--- Manajemen: CRUD profiles ---'
reset role;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-000000000001","role":"authenticated"}', true);
set local role authenticated;

do $$
declare
  v_id uuid := '00000000-0000-0000-0000-000000000009';
begin
  insert into public.profiles (
    id, role, nim, full_name, jurusan, division_id, team_id, status
  )
  values (
    v_id,
    'atlet',
    'TEST-TEMP-001',
    'Temp Athlete',
    'Informatika',
    (select id from public.divisions where name = 'Free Fire'),
    (select t.id from public.teams t
       join public.divisions d on d.id = t.division_id
      where d.name = 'Free Fire' and t.name = 'Tim Utama'),
    'pending'
  );

  update public.profiles
     set role = 'member',
         status = 'active',
         nim = 'TEST-TEMP-002',
         full_name = 'Temp Member',
         division_id = (select id from public.divisions where name = 'Game Developer'),
         team_id = null
   where id = v_id;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa UPDATE profil';
  end if;

  delete from public.profiles where id = v_id;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa DELETE profil';
  end if;

  raise notice 'PASS: Manajemen CRUD profiles';
end;
$$;

\echo '--- Manajemen: CRUD divisions/teams/metric_definitions ---'
do $$
declare
  v_div uuid;
  v_team uuid;
  v_metric uuid;
begin
  insert into public.divisions (name, kind, show_on_landing, sort_order, is_active)
  values ('Manajemen Test Division', 'esport', false, 99, true)
  returning id into v_div;

  insert into public.teams (division_id, name, is_active)
  values (v_div, 'Tim Test', true)
  returning id into v_team;

  update public.teams set name = 'Tim Test Updated' where id = v_team;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa UPDATE teams';
  end if;

  insert into public.metric_definitions (
    division_id, key, label, data_type, higher_is_better, sort_order, is_active
  )
  values (v_div, 'test_metric', 'Test Metric', 'integer', true, 1, true)
  returning id into v_metric;

  update public.metric_definitions
     set label = 'Test Metric Updated'
   where id = v_metric;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa UPDATE metric_definitions';
  end if;

  delete from public.metric_definitions where id = v_metric;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa DELETE metric_definitions';
  end if;

  delete from public.teams where id = v_team;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa DELETE teams';
  end if;

  delete from public.divisions where id = v_div;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa DELETE divisions';
  end if;

  raise notice 'PASS: Manajemen CRUD divisions/teams/metric_definitions';
end;
$$;

\echo '--- Manajemen: CRUD events/site_settings ---'
do $$
declare
  v_event uuid;
begin
  insert into public.events (
    title, slug, type, start_date, status, created_by
  )
  values (
    'Manajemen Test Event',
    'manajemen-test-event',
    'lainnya',
    current_date,
    'draft',
    '00000000-0000-0000-0000-000000000001'
  )
  returning id into v_event;

  update public.events
     set title = 'Manajemen Test Event Updated'
   where id = v_event;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa UPDATE events';
  end if;

  delete from public.events where id = v_event;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa DELETE events';
  end if;

  insert into public.site_settings (key, value, updated_by)
  values ('footer', '{"test":true}'::jsonb, '00000000-0000-0000-0000-000000000001');

  update public.site_settings
     set value = '{"test":false}'::jsonb
   where key = 'footer';
  if not found then
    raise exception 'FAIL: manajemen tidak bisa UPDATE site_settings';
  end if;

  delete from public.site_settings where key = 'footer';
  if not found then
    raise exception 'FAIL: manajemen tidak bisa DELETE site_settings';
  end if;

  raise notice 'PASS: Manajemen CRUD events/site_settings';
end;
$$;

\echo '--- Manajemen: CRUD schedules/schedule_participants ---'
do $$
declare
  v_schedule uuid;
begin
  insert into public.schedules (
    title, type, division_id, team_id, start_at, end_at, created_by
  )
  values (
    'Manajemen Test Schedule',
    'latihan',
    (select id from public.divisions where name = 'Free Fire'),
    (select t.id from public.teams t
       join public.divisions d on d.id = t.division_id
      where d.name = 'Free Fire' and t.name = 'Tim Utama'),
    now(),
    now() + interval '1 hour',
    '00000000-0000-0000-0000-000000000001'
  )
  returning id into v_schedule;

  update public.schedules
     set title = 'Manajemen Test Schedule Updated'
   where id = v_schedule;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa UPDATE schedules';
  end if;

  insert into public.schedule_participants (schedule_id, profile_id)
  values (v_schedule, '00000000-0000-0000-0000-000000000002');

  delete from public.schedule_participants
   where schedule_id = v_schedule
     and profile_id = '00000000-0000-0000-0000-000000000002';
  if not found then
    raise exception 'FAIL: manajemen tidak bisa DELETE schedule_participants';
  end if;

  delete from public.schedules where id = v_schedule;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa DELETE schedules';
  end if;

  raise notice 'PASS: Manajemen CRUD schedules/schedule_participants';
end;
$$;

\echo '--- Manajemen: CRUD attendance_sessions + session_code ---'
do $$
declare
  v_session uuid;
  v_code text;
begin
  insert into public.attendance_sessions (
    title, session_type, division_id, starts_at, ends_at,
    allow_guests, status, session_code, created_by
  )
  values (
    'Manajemen Test Session',
    'latihan',
    (select id from public.divisions where name = 'Free Fire'),
    now(),
    now() + interval '1 hour',
    false,
    'open',
    'MGMT-TEST-CODE',
    '00000000-0000-0000-0000-000000000001'
  )
  returning id into v_session;

  update public.attendance_sessions
     set title = 'Manajemen Test Session Updated'
   where id = v_session;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa UPDATE attendance_sessions';
  end if;

  v_code := public.get_session_code(v_session);
  if v_code <> 'MGMT-TEST-CODE' then
    raise exception 'FAIL: get_session_code setelah INSERT salah';
  end if;

  delete from public.attendance_sessions where id = v_session;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa DELETE attendance_sessions';
  end if;

  raise notice 'PASS: Manajemen CRUD attendance_sessions + get_session_code';
end;
$$;

\echo '--- Manajemen: INSERT/UPDATE attendance_records dan guest_attendances ---'
do $$
declare
  v_record uuid;
  v_guest uuid;
begin
  insert into public.attendance_records (
    session_id, profile_id, status, checked_in_at, method, manual_reason, recorded_by
  )
  values (
    '30000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000007',
    'hadir',
    now(),
    'manual',
    'Alasan awal',
    '00000000-0000-0000-0000-000000000001'
  )
  returning id into v_record;

  update public.attendance_records
     set status = 'izin',
         manual_reason = 'Alasan manual test'
   where id = v_record;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa UPDATE attendance_records';
  end if;

  insert into public.guest_attendances (
    session_id, name, purpose, checked_in_at
  )
  values (
    '30000000-0000-0000-0000-000000000001',
    'Tamu Manajemen',
    'Test',
    now()
  )
  returning id into v_guest;

  update public.guest_attendances
     set purpose = 'Test Updated'
   where id = v_guest;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa UPDATE guest_attendances';
  end if;

  raise notice 'PASS: Manajemen INSERT/UPDATE attendance_records dan guest_attendances';
end;
$$;

\echo '--- Manajemen: verifikasi performa + batas tulis ---'
do $$
begin
  update public.performance_entries
     set verification_status = 'verified',
         verified_by = '00000000-0000-0000-0000-000000000001',
         verified_at = now()
   where id = '80000000-0000-0000-0000-000000000002';
  if not found then
    raise exception 'FAIL: manajemen tidak bisa verifikasi performance_entries';
  end if;
  raise notice 'PASS: Manajemen bisa verifikasi performance_entries';
end;
$$;

do $$
begin
  begin
    insert into public.performance_entries (
      athlete_id, division_id, played_on, match_type, result
    )
    values (
      '00000000-0000-0000-0000-000000000002',
      (select id from public.divisions where name = 'Free Fire'),
      current_date,
      'latihan',
      'win'
    );
    raise exception 'FAIL: manajemen bisa INSERT performance_entries';
  exception
    when insufficient_privilege then
      raise notice 'PASS: Manajemen ditolak INSERT performance_entries';
  end;

  begin
    insert into public.performance_values (entry_id, metric_id, value)
    values (
      '80000000-0000-0000-0000-000000000001',
      (select m.id from public.metric_definitions m
         join public.divisions d on d.id = m.division_id
        where d.name = 'Free Fire' and m.key = 'damage'),
      1
    );
    raise exception 'FAIL: manajemen bisa INSERT performance_values';
  exception
    when insufficient_privilege then
      raise notice 'PASS: Manajemen ditolak INSERT performance_values';
  end;

  begin
    update public.performance_entries
       set notes = 'Hack'
     where id = '80000000-0000-0000-0000-000000000001';
    raise exception 'FAIL: manajemen bisa UPDATE notes performance_entries';
  exception
    when insufficient_privilege then
      raise notice 'PASS: Manajemen hanya boleh mengubah kolom verifikasi';
  end;

  begin
    delete from public.performance_entries
     where id = '80000000-0000-0000-0000-000000000001';
    raise exception 'FAIL: manajemen bisa DELETE performance_entries';
  exception
    when insufficient_privilege then
      raise notice 'PASS: Manajemen ditolak DELETE performance_entries';
  end;
end;
$$;

\echo '--- Manajemen: CRUD coach_notes ---'
do $$
declare
  v_note uuid;
begin
  insert into public.coach_notes (athlete_id, entry_id, author_id, note)
  values (
    '00000000-0000-0000-0000-000000000002',
    '80000000-0000-0000-0000-000000000004',
    '00000000-0000-0000-0000-000000000001',
    'Catatan test manajemen'
  )
  returning id into v_note;

  update public.coach_notes
     set note = 'Catatan test manajemen updated'
   where id = v_note;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa UPDATE coach_notes';
  end if;

  delete from public.coach_notes where id = v_note;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa DELETE coach_notes';
  end if;

  raise notice 'PASS: Manajemen CRUD coach_notes';
end;
$$;

\echo '--- Manajemen: CRUD inventory_items/loans/loan_items ---'
do $$
declare
  v_item uuid;
  v_loan uuid;
begin
  insert into public.inventory_items (code, name, category, condition, status)
  values ('MGMT-TEST-INV', 'Item Test', 'Test', 'baik', 'tersedia')
  returning id into v_item;

  update public.inventory_items
     set status = 'maintenance'
   where id = v_item;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa UPDATE inventory_items';
  end if;

  insert into public.loans (
    borrower_id, purpose, loaned_at, due_at, status, handled_by
  )
  values (
    '00000000-0000-0000-0000-000000000002',
    'Test loan manajemen',
    now(),
    now() + interval '1 day',
    'dipinjam',
    '00000000-0000-0000-0000-000000000001'
  )
  returning id into v_loan;

  insert into public.loan_items (loan_id, item_id, condition_out)
  values (v_loan, v_item, 'baik');

  update public.loans
     set notes = 'Test loan updated'
   where id = v_loan;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa UPDATE loans';
  end if;

  delete from public.loan_items
   where loan_id = v_loan and item_id = v_item;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa DELETE loan_items';
  end if;

  delete from public.loans where id = v_loan;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa DELETE loans';
  end if;

  delete from public.inventory_items where id = v_item;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa DELETE inventory_items';
  end if;

  raise notice 'PASS: Manajemen CRUD inventory_items/loans/loan_items';
end;
$$;

\echo '--- Manajemen: CRUD archives/announcements ---'
do $$
declare
  v_archive uuid;
  v_announcement uuid;
begin
  insert into public.archives (
    title, category, file_path, file_name, file_type, file_size, uploaded_by
  )
  values (
    'Archive Test Manajemen',
    'lainnya',
    'test/archive-manajemen.pdf',
    'archive-manajemen.pdf',
    'application/pdf',
    100,
    '00000000-0000-0000-0000-000000000001'
  )
  returning id into v_archive;

  update public.archives
     set title = 'Archive Test Manajemen Updated'
   where id = v_archive;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa UPDATE archives';
  end if;

  delete from public.archives where id = v_archive;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa DELETE archives';
  end if;

  insert into public.announcements (
    title, body, target_role, target_division_id, created_by
  )
  values (
    'Announcement Test Manajemen',
    'Body',
    'atlet',
    (select id from public.divisions where name = 'Free Fire'),
    '00000000-0000-0000-0000-000000000001'
  )
  returning id into v_announcement;

  update public.announcements
     set title = 'Announcement Test Manajemen Updated'
   where id = v_announcement;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa UPDATE announcements';
  end if;

  delete from public.announcements where id = v_announcement;
  if not found then
    raise exception 'FAIL: manajemen tidak bisa DELETE announcements';
  end if;

  raise notice 'PASS: Manajemen CRUD archives/announcements';
end;
$$;

\echo '--- Manajemen: activity_logs SELECT + INSERT ditolak ---'
do $$
declare
  v_count integer;
begin
  select count(*) into v_count from public.activity_logs;
  if v_count <> 5 then
    raise exception 'FAIL: manajemen tidak melihat semua activity_logs (got %)', v_count;
  end if;

  begin
    insert into public.activity_logs (actor_id, action, entity_type)
    values ('00000000-0000-0000-0000-000000000001', 'login', 'auth');
    raise exception 'FAIL: manajemen bisa INSERT activity_logs';
  exception
    when insufficient_privilege then
      raise notice 'PASS: Manajemen ditolak INSERT activity_logs';
  end;

  raise notice 'PASS: Manajemen bisa SELECT semua activity_logs';
end;
$$;

\echo '=== SEMUA SKENARIO RLS SELESAI ==='
rollback;
