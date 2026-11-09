# Supabase Stage 1 — Gaming Garage UTDI

Folder ini berisi fondasi database Tahap 1: 20 tabel, enum, index, helper
security-definer, trigger, RLS, grant, seed, dan uji RLS. Tidak ada UI, auth
flow, storage, Edge Function, atau pekerjaan Tahap 2–12.

## Struktur

- `migrations/0001_enums.sql` — 18 enum.
- `migrations/0002_tables.sql` — 20 tabel, PK, FK, unique, check.
- `migrations/0003_indexes.sql` — index FK dan kolom filter/sort.
- `migrations/0004_helper_functions.sql` — helper security definer.
- `migrations/0005_triggers.sql` — `updated_at`, proteksi profil, integritas
  performa, append-only log.
- `migrations/0006_rls_enable.sql` — RLS aktif di 20 tabel.
- `migrations/0007_policies.sql` — policy SELECT/INSERT/UPDATE/DELETE.
- `migrations/0008_grants.sql` — grant tabel/kolom dan `session_code`.
- `seed.sql` — 8 divisi, 5 tim `Tim Utama` untuk divisi esport, 29
  `metric_definitions`. Tidak mengisi `site_settings`.
- `tests/rls_test.sql` — uji RLS berbasis `psql`; fixture dibuat di dalam
  transaksi dan di-`ROLLBACK`.
- `templates/management_account.sql` — template akun Manajemen pertama.

## Prasyarat

- Project Supabase baru/kosong.
- Koneksi database langsung (`DATABASE_URL`) atau Supabase CLI yang sudah
  ter-link.
- `psql` 15+.
- Jangan commit `DATABASE_URL`, service role key, password, atau kredensial ke
  repo. Publishable/anon key **tidak cukup** untuk menjalankan DDL/migrasi.

## Urutan migrasi

Jalankan berurutan, satu kali, pada database kosong:

1. `0001_enums.sql`
2. `0002_tables.sql`
3. `0003_indexes.sql`
4. `0004_helper_functions.sql`
5. `0005_triggers.sql`
6. `0006_rls_enable.sql`
7. `0007_policies.sql`
8. `0008_grants.sql`

### Opsi A — psql

```bash
export DATABASE_URL='postgresql://...'

for f in supabase/migrations/*.sql; do
  psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f "$f"
done

psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/seed.sql
```

### Opsi B — Supabase CLI

```bash
supabase link --project-ref <project-ref>
supabase db push
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/seed.sql
```

`supabase db push` menjalankan migrasi. Seed tidak otomatis; jalankan manual.

## Akun Manajemen pertama

1. Buat user di Supabase Auth (Authentication → Users).
2. Salin UUID user.
3. Edit `templates/management_account.sql`, ganti:
   - `<AUTH_USER_UUID>`
   - `<NAMA_LENGKAP>`
   - `<JURUSAN>`
4. Jalankan SQL tersebut.
5. Login; profil harus `role = manajemen` dan `status = active`.

## Uji RLS

```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/tests/rls_test.sql
```

- Jalankan sebagai role `postgres`/service role yang bisa insert ke
  `auth.users` dan melakukan `SET ROLE`.
- Script membuat 9 auth user uji, profil, dan fixture lain, lalu `ROLLBACK`.
- Script memakai meta-command `psql` (`\set`, `\echo`). Jalankan lewat `psql`,
  bukan SQL Editor.
- Semua PASS muncul sebagai `NOTICE`. Jika ada yang gagal, script berhenti
  dengan `ERROR`.

## Status eksekusi

- **PostgreSQL lokal 16 (stub `auth`): LULUS** — seluruh migrasi, seed, dan
  skenario `rls_test.sql` berhasil pada 2026-11-09.
- **Supabase project: BELUM DIJALANKAN** — kredensial yang diberikan hanya
  `NEXT_PUBLIC_SUPABASE_URL` dan publishable key. Publishable key tidak dapat
  menjalankan DDL/migrasi. Untuk menjalankan di Supabase, diperlukan
  `DATABASE_URL` koneksi langsung atau akses management/service role.
- Jangan mengklaim tes Supabase lulus sampai dijalankan dengan kredensial yang
  tepat.

## Ringkasan RLS

| Tabel | Anon | Authenticated |
| --- | --- | --- |
| `profiles` | tidak ada | active: own + rekan satu tim (atlet), Dosen semua, Manajemen semua; pending/inactive: own saja; Manajemen insert/update/delete; atlet/member aktif update field non-proteksi sendiri |
| `divisions` | `is_active` dan `show_on_landing` | active: semua; Manajemen CRUD |
| `teams` | tidak ada | active: semua; Manajemen CRUD |
| `metric_definitions` | tidak ada | Manajemen/Dosen semua; atlet divisi sendiri; Manajemen CRUD |
| `performance_entries` | tidak ada | Manajemen/Dosen semua; atlet own semua status + rekan satu tim yang `verified`; atlet insert/update `pending`; Manajemen update kolom verifikasi; tanpa delete |
| `performance_values` | tidak ada | Manajemen/Dosen semua; atlet own + rekan `verified`; atlet insert/update `pending`; tanpa delete |
| `coach_notes` | tidak ada | Manajemen/Dosen semua; atlet own; Manajemen CRUD |
| `events` | `published` saja | active: semua; Manajemen CRUD |
| `site_settings` | semua | active: semua; Manajemen CRUD |
| `schedules` | tidak ada | Manajemen/Dosen semua; atlet/member peserta saja; Manajemen CRUD |
| `schedule_participants` | tidak ada | Manajemen/Dosen semua; atlet/member own; Manajemen CRUD |
| `attendance_sessions` | tidak ada | Manajemen/Dosen semua; atlet/member divisi relevan atau own record; `session_code` lewat RPC Manajemen; Manajemen CRUD |
| `attendance_records` | tidak ada | Manajemen/Dosen semua; atlet/member own; Manajemen insert/update; tanpa delete |
| `guest_attendances` | tidak ada | Manajemen semua; insert/update; tanpa delete |
| `inventory_items` | tidak ada | Manajemen CRUD |
| `loans` | tidak ada | Manajemen semua; atlet/member own; Manajemen CRUD |
| `loan_items` | tidak ada | Manajemen semua; atlet/member own loan; Manajemen CRUD |
| `archives` | tidak ada | Manajemen/Dosen semua; Manajemen CRUD |
| `announcements` | tidak ada | Manajemen/Dosen semua; atlet/member sesuai target; Manajemen CRUD |
| `activity_logs` | tidak ada | Manajemen semua; active user own; append-only (tanpa insert/update/delete) |

## Catatan keamanan dan batasan

1. **`session_code`** tidak di-grant SELECT ke `authenticated`/`anon`.
   Manajemen membacanya lewat `get_session_code(session_id)`. `INSERT ...
   RETURNING session_code` akan gagal karena privilege kolom; buat kode di
   client atau panggil RPC setelah insert.
2. **Event untuk anon** hanya `published`, sesuai aturan Tahap 1. Event
   `finished` tidak terbaca anon. Jika section "Aktivitas" di landing harus
   menampilkan event selesai, perlu penyesuaian Tahap 8 (misalnya mengizinkan
   `finished` untuk anon atau menambah RPC publik).
3. **Manajemen** hanya boleh mengubah kolom verifikasi
   `performance_entries` (`verification_status`, `verified_by`, `verified_at`,
   `reject_reason`). Manajemen tidak boleh insert/delete performance.
4. **Atlet** bisa membaca entri sendiri di semua status; rekan satu tim hanya
   entri `verified`.
5. **Hard delete profil** bisa terhalang FK references (`activity_logs`,
   `events`, dan lain-lain). Untuk akun nyata, gunakan `status = 'inactive'`.
   Uji delete Manajemen memakai profil baru tanpa referensi.
6. **Non-Manajemen** tidak boleh menulis `attendance_records`/
   `guest_attendances` pada Tahap 1. Input manual hanya Manajemen.
7. **`site_settings`** sengaja tidak di-seed; diisi pada Tahap 8.
8. **Field profil yang dilindungi trigger** untuk non-Manajemen: `role`,
   `status`, `nim`, `division_id`, `team_id`, `id`, `created_at`.
9. Semua fungsi security definer memakai `search_path = public, pg_temp`.
10. RLS aktif di seluruh 20 tabel. Tidak ada view tambahan.

## Catatan operasional

- Jangan pernah menaruh service role key di frontend.
- Gunakan environment variable dan secret manager.
- Jalankan migrasi lewat CI/psql, bukan SQL Editor, agar urutan dan error
  terlihat.
- Jika kredensial pernah terekspos di chat/log, rotasi key tersebut.
