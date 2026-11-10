-- Learning Atelier: безопасное хранилище прогресса пользователя
-- Выполни весь SQL в Supabase → SQL Editor → New query → Run.

create table if not exists public.user_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  state jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.user_data enable row level security;

drop policy if exists "Users can read own learning data" on public.user_data;
create policy "Users can read own learning data"
on public.user_data for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can insert own learning data" on public.user_data;
create policy "Users can insert own learning data"
on public.user_data for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update own learning data" on public.user_data;
create policy "Users can update own learning data"
on public.user_data for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

grant select, insert, update on public.user_data to authenticated;
