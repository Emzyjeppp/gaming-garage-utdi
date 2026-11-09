-- 0006_rls_enable.sql
-- RLS aktif di seluruh 20 tabel. Tanpa policy, akses ditolak.

alter table public.profiles enable row level security;
alter table public.divisions enable row level security;
alter table public.teams enable row level security;
alter table public.metric_definitions enable row level security;
alter table public.performance_entries enable row level security;
alter table public.performance_values enable row level security;
alter table public.coach_notes enable row level security;
alter table public.events enable row level security;
alter table public.site_settings enable row level security;
alter table public.schedules enable row level security;
alter table public.schedule_participants enable row level security;
alter table public.attendance_sessions enable row level security;
alter table public.attendance_records enable row level security;
alter table public.guest_attendances enable row level security;
alter table public.inventory_items enable row level security;
alter table public.loans enable row level security;
alter table public.loan_items enable row level security;
alter table public.archives enable row level security;
alter table public.announcements enable row level security;
alter table public.activity_logs enable row level security;
