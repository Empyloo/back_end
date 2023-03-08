CREATE INDEX refresh_token_session_id ON auth.refresh_tokens USING btree (session_id);

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION auth.email()
 RETURNS text
 LANGUAGE sql
 STABLE
AS $function$
  select 
  	coalesce(
		nullif(current_setting('request.jwt.claim.email', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
	)::text
$function$
;

CREATE OR REPLACE FUNCTION auth.role()
 RETURNS text
 LANGUAGE sql
 STABLE
AS $function$
  select 
  	coalesce(
		nullif(current_setting('request.jwt.claim.role', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
	)::text
$function$
;

CREATE OR REPLACE FUNCTION auth.uid()
 RETURNS uuid
 LANGUAGE sql
 STABLE
AS $function$
  select 
  	coalesce(
		nullif(current_setting('request.jwt.claim.sub', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
	)::uuid
$function$
;


create extension if not exists "http" with schema "extensions";

create extension if not exists "pg_net" with schema "extensions";


create table "public"."contact_us" (
    "id" uuid not null default uuid_generate_v4(),
    "email" character varying(255) not null,
    "message" text,
    "company" text,
    "data" jsonb,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
);


CREATE UNIQUE INDEX contact_us_pkey ON public.contact_us USING btree (id);

alter table "public"."contact_us" add constraint "contact_us_pkey" PRIMARY KEY using index "contact_us_pkey";


drop trigger if exists "update_objects_updated_at" on "storage"."objects";

CREATE TRIGGER post_visitor_to_slack AFTER INSERT ON "contact_us" FOR EACH ROW EXECUTE FUNCTION post_to_slack();

COMMENT ON TRIGGER post_visitor_to_slack ON public.contact_us IS 'Trigger for posting new landing page visitor data to Slack';

