class CreateContent < ActiveRecord::Migration
  def self.up
    execute <<EOF

create sequence content_id_seq start 1 increment 1 no cycle;
create table content(
  id                     integer not null default nextval('content_id_seq'),
  title                  text not null,
  start_date             date not null default now()::date,
  end_date               date,
  published              boolean not null default false,
  created_at             timestamp with time zone not null default now(),
  updated_at             timestamp with time zone not null default now(),
  primary key(id)
);

create table articles(
  body                   text
) inherits (content);

create table news(
  synopsis               text
) inherits (articles);

EOF
  end
end
