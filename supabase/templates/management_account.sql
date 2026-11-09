-- management_account.sql
-- Template manual pembuatan profil Manajemen pertama.
-- Jalankan HANYA setelah user dibuat di Supabase Auth (Authentication > Users).
-- Ganti placeholder di bawah. Jangan menulis password atau service role key.
--
-- Cara pakai:
--   1. Buat user email/password di Supabase Auth.
--   2. Salin UUID user dari halaman Auth.
--   3. Ganti <AUTH_USER_UUID>, <NAMA_LENGKAP>, dan <JURUSAN>.
--   4. Jalankan SQL ini di SQL Editor Supabase atau psql.
--   5. Login sebagai user tersebut; status harus active dan role manajemen.

insert into public.profiles (
  id,
  role,
  nim,
  full_name,
  jurusan,
  division_id,
  team_id,
  status
)
values (
  '<AUTH_USER_UUID>'::uuid,
  'manajemen',
  null,
  '<NAMA_LENGKAP>',
  '<JURUSAN>',
  null,
  null,
  'active'
)
on conflict (id) do update
set
  role = 'manajemen',
  full_name = excluded.full_name,
  jurusan = excluded.jurusan,
  division_id = null,
  team_id = null,
  status = 'active';
