-- 0002_tables.sql
-- 20 tabel sesuai ERD. Urutan mengikuti dependensi foreign key.
-- Semua tabel memiliki created_at; id uuid PK default gen_random_uuid()
-- kecuali site_settings (key text PK), schedule_participants dan loan_items
-- (PK komposit sesuai dokumen).

-- ---------------------------------------------------------------------------
-- Master komunitas
-- ---------------------------------------------------------------------------

create table public.divisions (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  kind public.division_kind not null,
  description text,
  show_on_landing boolean not null default false,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.teams (
  id uuid primary key default gen_random_uuid(),
  division_id uuid not null references public.divisions(id),
  name text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  constraint teams_division_name_unique unique (division_id, name)
);

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role public.user_role not null,
  nim text unique,
  full_name text not null,
  jurusan text,
  division_id uuid references public.divisions(id),
  team_id uuid references public.teams(id),
  status public.account_status not null default 'pending',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint profiles_nim_required_for_student
    check (
      role not in ('atlet', 'member')
      or (nim is not null and length(trim(nim)) > 0)
    )
);

create table public.metric_definitions (
  id uuid primary key default gen_random_uuid(),
  division_id uuid not null references public.divisions(id),
  key text not null,
  label text not null,
  data_type public.metric_data_type not null,
  higher_is_better boolean not null default true,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  constraint metric_definitions_division_key_unique unique (division_id, key)
);

-- ---------------------------------------------------------------------------
-- Konten landing
-- ---------------------------------------------------------------------------

create table public.events (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  slug text not null unique,
  type public.event_type not null,
  division_id uuid references public.divisions(id),
  description text,
  start_date date not null,
  end_date date,
  location text,
  format text,
  quota text,
  prize_pool text,
  fee_text text,
  contact_info text,
  registration_url text,
  poster_path text,
  status public.event_status not null,
  created_by uuid not null references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint events_date_order
    check (end_date is null or end_date >= start_date)
);

create table public.site_settings (
  key text primary key,
  value jsonb not null,
  updated_by uuid not null references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint site_settings_key_allowed
    check (
      key in (
        'hero',
        'about',
        'program_pillars',
        'contact_persons',
        'social_links',
        'footer'
      )
    )
);

-- ---------------------------------------------------------------------------
-- Performa
-- ---------------------------------------------------------------------------

create table public.performance_entries (
  id uuid primary key default gen_random_uuid(),
  athlete_id uuid not null references public.profiles(id),
  division_id uuid not null references public.divisions(id),
  event_id uuid references public.events(id),
  played_on date not null,
  match_type public.match_type not null,
  opponent text,
  result public.match_result not null,
  notes text,
  evidence_url text,
  verification_status public.verification_status not null default 'pending',
  verified_by uuid references public.profiles(id),
  verified_at timestamptz,
  reject_reason text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.performance_values (
  id uuid primary key default gen_random_uuid(),
  entry_id uuid not null references public.performance_entries(id) on delete cascade,
  metric_id uuid not null references public.metric_definitions(id),
  value numeric not null,
  created_at timestamptz not null default now(),
  constraint performance_values_entry_metric_unique unique (entry_id, metric_id)
);

create table public.coach_notes (
  id uuid primary key default gen_random_uuid(),
  athlete_id uuid not null references public.profiles(id),
  entry_id uuid references public.performance_entries(id),
  author_id uuid not null references public.profiles(id),
  note text not null,
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- Jadwal dan presensi
-- ---------------------------------------------------------------------------

create table public.schedules (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  type public.schedule_type not null,
  division_id uuid not null references public.divisions(id),
  team_id uuid references public.teams(id),
  start_at timestamptz not null,
  end_at timestamptz not null,
  location text,
  notes text,
  created_by uuid not null references public.profiles(id),
  created_at timestamptz not null default now(),
  constraint schedules_time_order check (end_at > start_at)
);

create table public.schedule_participants (
  schedule_id uuid not null references public.schedules(id) on delete cascade,
  profile_id uuid not null references public.profiles(id),
  created_at timestamptz not null default now(),
  primary key (schedule_id, profile_id)
);

create table public.attendance_sessions (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  session_type public.session_type not null,
  division_id uuid references public.divisions(id),
  schedule_id uuid references public.schedules(id),
  event_id uuid references public.events(id),
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  late_after timestamptz,
  allow_guests boolean not null default false,
  status public.session_status not null,
  session_code text not null unique,
  created_by uuid not null references public.profiles(id),
  created_at timestamptz not null default now(),
  constraint attendance_sessions_time_order check (ends_at > starts_at)
);

create table public.attendance_records (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.attendance_sessions(id),
  profile_id uuid not null references public.profiles(id),
  status public.attendance_status not null,
  checked_in_at timestamptz,
  method public.attendance_method not null,
  activity_note text,
  manual_reason text,
  recorded_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  constraint attendance_records_session_profile_unique
    unique (session_id, profile_id),
  constraint attendance_records_manual_reason_required
    check (
      method <> 'manual'
      or (manual_reason is not null and length(trim(manual_reason)) > 0)
    )
);

create table public.guest_attendances (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.attendance_sessions(id),
  name text not null,
  institution text,
  purpose text not null,
  phone text,
  checked_in_at timestamptz not null,
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- Inventaris dan peminjaman
-- ---------------------------------------------------------------------------

create table public.inventory_items (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null,
  category text not null,
  condition public.item_condition not null,
  status public.inventory_status not null,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.loans (
  id uuid primary key default gen_random_uuid(),
  borrower_id uuid references public.profiles(id),
  borrower_name text,
  borrower_contact text,
  purpose text not null,
  loaned_at timestamptz not null,
  due_at timestamptz not null,
  returned_at timestamptz,
  status public.loan_status not null,
  handled_by uuid not null references public.profiles(id),
  notes text,
  created_at timestamptz not null default now(),
  constraint loans_borrower_required
    check (
      borrower_id is not null
      or (borrower_name is not null and length(trim(borrower_name)) > 0)
    )
);

create table public.loan_items (
  loan_id uuid not null references public.loans(id) on delete cascade,
  item_id uuid not null references public.inventory_items(id),
  condition_out public.item_condition not null,
  condition_in public.item_condition,
  created_at timestamptz not null default now(),
  primary key (loan_id, item_id)
);

-- ---------------------------------------------------------------------------
-- Arsip, pengumuman, log
-- ---------------------------------------------------------------------------

create table public.archives (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category public.archive_category not null,
  event_id uuid references public.events(id),
  description text,
  file_path text not null,
  file_name text not null,
  file_type text not null,
  file_size bigint not null,
  uploaded_by uuid not null references public.profiles(id),
  created_at timestamptz not null default now()
);

create table public.announcements (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text not null,
  target_role public.user_role,
  target_division_id uuid references public.divisions(id),
  created_by uuid not null references public.profiles(id),
  created_at timestamptz not null default now()
);

create table public.activity_logs (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references public.profiles(id),
  action text not null,
  entity_type text not null,
  entity_id uuid,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  constraint activity_logs_action_allowed
    check (
      action in (
        'login',
        'logout',
        'profile.update',
        'account.approve',
        'account.reject',
        'attendance.checkin',
        'attendance.manual',
        'session.open',
        'session.close',
        'performance.create',
        'performance.update',
        'performance.verify',
        'performance.reject',
        'loan.create',
        'loan.return',
        'content.update',
        'archive.upload',
        'schedule.create'
      )
    )
);
