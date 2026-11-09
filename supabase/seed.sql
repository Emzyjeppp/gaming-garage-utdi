-- seed.sql
-- Seed idempoten untuk divisi, tim, dan metric_definitions.
-- site_settings sengaja tidak diisi (Tahap 8).

-- ---------------------------------------------------------------------------
-- Divisi
-- ---------------------------------------------------------------------------

insert into public.divisions (
  name,
  kind,
  show_on_landing,
  sort_order,
  is_active
)
values
  ('Mobile Legends', 'esport', true, 1, true),
  ('PES/eFootball', 'esport', true, 2, true),
  ('Valorant', 'esport', true, 3, true),
  ('Free Fire', 'esport', true, 4, true),
  ('Tekken', 'esport', true, 5, true),
  ('Game Developer', 'non_esport', true, 6, true),
  ('Social Media', 'non_esport', true, 7, true),
  ('Event & Talent', 'non_esport', true, 8, true)
on conflict (name) do update
set
  kind = excluded.kind,
  show_on_landing = excluded.show_on_landing,
  sort_order = excluded.sort_order,
  is_active = excluded.is_active;

-- ---------------------------------------------------------------------------
-- Tim default satu per divisi esport
-- ---------------------------------------------------------------------------

insert into public.teams (division_id, name, is_active)
select d.id, 'Tim Utama', true
from public.divisions d
where d.kind = 'esport'
on conflict (division_id, name) do update
set is_active = excluded.is_active;

-- ---------------------------------------------------------------------------
-- metric_definitions sesuai bagian 8
-- Aturan data_type:
--   key berakhiran _pct              -> percent
--   gold_per_min, avg_combo_damage,
--   survival_minutes                 -> decimal
--   sisanya                          -> integer
-- higher_is_better = false untuk:
--   deaths, damage_taken, goals_against, rounds_lost, placement
-- ---------------------------------------------------------------------------

insert into public.metric_definitions (
  division_id,
  key,
  label,
  data_type,
  higher_is_better,
  sort_order,
  is_active
)
select
  d.id,
  v.key,
  v.label,
  v.data_type::public.metric_data_type,
  v.higher_is_better,
  v.sort_order,
  true
from (
  values
    -- Mobile Legends
    ('Mobile Legends', 'kills', 'Kills', 'integer', true, 1),
    ('Mobile Legends', 'deaths', 'Deaths', 'integer', false, 2),
    ('Mobile Legends', 'assists', 'Assists', 'integer', true, 3),
    ('Mobile Legends', 'hero_damage', 'Hero Damage', 'integer', true, 4),
    ('Mobile Legends', 'damage_taken', 'Damage Taken', 'integer', false, 5),
    ('Mobile Legends', 'turret_damage', 'Turret Damage', 'integer', true, 6),
    ('Mobile Legends', 'gold_per_min', 'Gold per Menit', 'decimal', true, 7),
    ('Mobile Legends', 'teamfight_pct', 'Teamfight %', 'percent', true, 8),
    ('Mobile Legends', 'objective_taken', 'Objective Taken', 'integer', true, 9),

    -- Valorant
    ('Valorant', 'acs', 'ACS', 'integer', true, 1),
    ('Valorant', 'kills', 'Kills', 'integer', true, 2),
    ('Valorant', 'deaths', 'Deaths', 'integer', false, 3),
    ('Valorant', 'assists', 'Assists', 'integer', true, 4),
    ('Valorant', 'headshot_pct', 'Headshot %', 'percent', true, 5),
    ('Valorant', 'first_blood', 'First Blood', 'integer', true, 6),
    ('Valorant', 'clutch_won', 'Clutch Won', 'integer', true, 7),

    -- PES/eFootball
    ('PES/eFootball', 'goals_for', 'Gol', 'integer', true, 1),
    ('PES/eFootball', 'goals_against', 'Kebobolan', 'integer', false, 2),
    ('PES/eFootball', 'shots_on_target', 'Shots on Target', 'integer', true, 3),
    ('PES/eFootball', 'possession_pct', 'Possession %', 'percent', true, 4),
    ('PES/eFootball', 'pass_accuracy_pct', 'Pass Accuracy %', 'percent', true, 5),

    -- Tekken
    ('Tekken', 'rounds_won', 'Ronde Menang', 'integer', true, 1),
    ('Tekken', 'rounds_lost', 'Ronde Kalah', 'integer', false, 2),
    ('Tekken', 'avg_combo_damage', 'Rata-rata Combo Damage', 'decimal', true, 3),

    -- Free Fire
    ('Free Fire', 'kills', 'Kills', 'integer', true, 1),
    ('Free Fire', 'damage', 'Damage', 'integer', true, 2),
    ('Free Fire', 'survival_minutes', 'Menit Bertahan', 'decimal', true, 3),
    ('Free Fire', 'headshot_pct', 'Headshot %', 'percent', true, 4),
    ('Free Fire', 'placement', 'Peringkat', 'integer', false, 5)
) as v(division_name, key, label, data_type, higher_is_better, sort_order)
join public.divisions d on d.name = v.division_name
on conflict (division_id, key) do update
set
  label = excluded.label,
  data_type = excluded.data_type,
  higher_is_better = excluded.higher_is_better,
  sort_order = excluded.sort_order,
  is_active = true;
