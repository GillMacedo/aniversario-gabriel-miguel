-- Rode isto uma vez no Supabase: SQL Editor › New query › Run.
create table if not exists public.confirmacoes (
  id          bigint generated always as identity primary key,
  criado_em   timestamptz not null default now(),
  nome        text not null check (char_length(nome) between 2 and 100),
  adultos     smallint not null default 1 check (adultos between 0 and 10),
  criancas    smallint not null default 0 check (criancas between 0 and 10),
  recado      text check (recado is null or char_length(recado) <= 500)
);

alter table public.confirmacoes enable row level security;

-- Visitantes do site só podem INSERIR. Não existe política de leitura,
-- então ninguém consegue ver a lista pelo site — só você, no painel do Supabase.
drop policy if exists "convidados podem confirmar" on public.confirmacoes;
create policy "convidados podem confirmar"
  on public.confirmacoes for insert
  to anon
  with check (true);

grant insert on public.confirmacoes to anon;

-- Resumo para consultar no painel (Table Editor ou SQL):
--   select nome, adultos, criancas, recado, criado_em from confirmacoes order by criado_em;
--   select count(*) as confirmacoes, sum(adultos) as adultos, sum(criancas) as criancas from confirmacoes;
