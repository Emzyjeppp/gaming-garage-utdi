-- 0001_enums.sql
-- Tipe enum untuk seluruh skema Gaming Garage UTDI.
-- Tidak ada nilai di luar dokumen perancangan.

create type public.user_role as enum (
  'manajemen',
  'atlet',
  'member',
  'dosen'
);

create type public.account_status as enum (
  'pending',
  'active',
  'inactive'
);

create type public.division_kind as enum (
  'esport',
  'non_esport'
);

create type public.metric_data_type as enum (
  'integer',
  'decimal',
  'percent'
);

create type public.match_type as enum (
  'scrim',
  'turnamen',
  'ranked',
  'latihan'
);

create type public.match_result as enum (
  'win',
  'lose',
  'draw'
);

create type public.verification_status as enum (
  'pending',
  'verified',
  'rejected'
);

create type public.event_type as enum (
  'turnamen',
  'workshop',
  'recruitment',
  'scrim',
  'lainnya'
);

create type public.event_status as enum (
  'draft',
  'published',
  'finished'
);

create type public.schedule_type as enum (
  'latihan',
  'scrim',
  'turnamen',
  'lainnya'
);

create type public.session_type as enum (
  'latihan',
  'rapat',
  'kegiatan',
  'event'
);

create type public.session_status as enum (
  'open',
  'closed'
);

create type public.attendance_status as enum (
  'hadir',
  'terlambat',
  'izin',
  'sakit',
  'alpa'
);

create type public.attendance_method as enum (
  'qr',
  'manual'
);

create type public.item_condition as enum (
  'baik',
  'rusak_ringan',
  'rusak_berat'
);

create type public.inventory_status as enum (
  'tersedia',
  'dipinjam',
  'maintenance',
  'hilang'
);

create type public.loan_status as enum (
  'dipinjam',
  'dikembalikan'
);

create type public.archive_category as enum (
  'proposal',
  'lpj',
  'info_turnamen',
  'dokumentasi',
  'laporan_performa',
  'lainnya'
);
