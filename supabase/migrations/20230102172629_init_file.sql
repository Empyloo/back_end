create type "public"."profile_completion" as enum ('invited', 'active', 'suspended');

create table "public"."answers" (
    "id" uuid not null default uuid_generate_v4(),
    "text_answer" text,
    "float_answer" double precision,
    "boolean_answer" boolean,
    "comment" text,
    "duration_to_answer" interval,
    "data" jsonb,
    "campaign_id" uuid,
    "question_id" uuid not null,
    "user_id" uuid not null,
    "created_by" uuid not null,
    "updated_by" uuid not null,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
);


create table "public"."campaign_job" (
    "campaign_id" uuid not null,
    "job_id" uuid not null,
    "company_id" uuid not null,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
);


create table "public"."campaigns" (
    "id" uuid not null default uuid_generate_v4(),
    "name" character varying(255) not null,
    "type" character varying(255),
    "count" integer not null default 0,
    "threshold" integer not null default 0,
    "schedule" character varying(255),
    "duration" integer,
    "status" character varying(255) not null default 'draft'::character varying,
    "company_id" uuid not null,
    "created_by" uuid not null,
    "start_date" timestamp with time zone not null,
    "end_date" timestamp with time zone not null default (timezone('utc'::text, now()) + '1 year'::interval),
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
);


create table "public"."chat_room_members" (
    "user_id" uuid not null,
    "chat_room_id" uuid not null,
    "company_id" uuid not null,
    "campaign_id" uuid,
    "job_id" uuid,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
);


create table "public"."chat_rooms" (
    "id" uuid not null default uuid_generate_v4(),
    "name" character varying(255) not null,
    "description" text,
    "data" jsonb,
    "campaign_id" uuid,
    "job_id" uuid,
    "created_by" uuid not null,
    "company_id" uuid not null,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
);


create table "public"."companies" (
    "id" uuid not null default uuid_generate_v4(),
    "name" character varying(255) not null,
    "email" character varying(255) not null,
    "phone" character varying(255),
    "website" character varying(255),
    "logo" character varying(255),
    "size" integer,
    "description" text,
    "data" jsonb,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "subscribed" boolean default true
);


create table "public"."failed_invites" (
    "id" uuid not null default uuid_generate_v4(),
    "email" text not null,
    "payload" jsonb,
    "reason" text not null,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now())
);


create table "public"."jobs" (
    "id" uuid not null default uuid_generate_v4(),
    "name" character varying(255),
    "tag" character varying(255) not null,
    "type" character varying(255),
    "frequency" character varying(255),
    "count" integer not null default 0,
    "duration" integer not null,
    "status" character varying(255) not null default 'active'::character varying,
    "campaign_id" uuid not null,
    "company_id" uuid not null,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "edited_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "completed_at" timestamp with time zone not null default timezone('utc'::text, now())
);


create table "public"."messages" (
    "id" uuid not null default uuid_generate_v4(),
    "message" text not null,
    "data" jsonb,
    "campaign_id" uuid,
    "job_id" uuid,
    "chat_room_id" uuid not null,
    "user_id" uuid not null,
    "company_id" uuid not null,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
);


create table "public"."notes" (
    "id" uuid not null default uuid_generate_v4(),
    "note" text not null,
    "data" jsonb,
    "table_name" text,
    "company_id" uuid,
    "user_id" uuid,
    "created_by" uuid not null,
    "updated_by" uuid not null,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
);


create table "public"."question_buckets" (
    "id" uuid not null default uuid_generate_v4(),
    "name" character varying(255) not null,
    "description" text,
    "data" jsonb,
    "company_id" uuid not null,
    "created_by" uuid not null,
    "updated_by" uuid not null,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
);


create table "public"."question_question_buckets" (
    "id" uuid not null default uuid_generate_v4(),
    "question_id" uuid not null,
    "question_bucket_id" uuid not null,
    "created_by" uuid not null,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now())
);


create table "public"."questions" (
    "id" uuid not null default uuid_generate_v4(),
    "question" text not null,
    "description" text,
    "data" jsonb,
    "comment" text,
    "created_by" uuid not null,
    "updated_by" uuid not null,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
);


create table "public"."results" (
    "id" uuid not null default uuid_generate_v4(),
    "campaign_id" uuid not null,
    "job_id" uuid not null,
    "name" character varying(255),
    "type" character varying(255),
    "designation" character varying(255) default 'company'::character varying,
    "description" character varying(255),
    "explanation" character varying(255),
    "value" double precision not null,
    "data" jsonb,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
);


create table "public"."teams" (
    "id" uuid not null default uuid_generate_v4(),
    "name" character varying(255) not null,
    "description" text,
    "logo" text,
    "data" jsonb,
    "parent_id" uuid,
    "level" integer not null default 0,
    "level_name" text,
    "company_id" uuid not null,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
);


create table "public"."user_team_mapping" (
    "user_id" uuid not null,
    "team_id" uuid not null,
    "company_id" uuid not null,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
);


create table "public"."users" (
    "id" uuid not null,
    "first_name" character varying(255),
    "last_name" character varying(255),
    "email" character varying(255) not null,
    "phone" character varying(255),
    "data" jsonb,
    "job_title" character varying(255),
    "gender" character varying(255),
    "married" boolean,
    "ethnicity" character varying(255),
    "sexuality" character varying(255),
    "disability" boolean,
    "date_of_birth" timestamp without time zone,
    "profile_status" profile_completion not null default 'invited'::profile_completion,
    "is_parent" boolean,
    "team_selected" boolean not null default false,
    "accepted_terms" boolean not null default false,
    "profile_type" character varying(255) not null default 'full'::character varying,
    "company_id" uuid not null,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "start_date" timestamp with time zone default timezone('utc'::text, now())
);


CREATE UNIQUE INDEX answers_pkey ON public.answers USING btree (id);

CREATE UNIQUE INDEX campaign_job_pkey ON public.campaign_job USING btree (campaign_id, job_id);

CREATE UNIQUE INDEX campaigns_pkey ON public.campaigns USING btree (id);

CREATE UNIQUE INDEX chat_room_members_pkey ON public.chat_room_members USING btree (user_id, chat_room_id);

CREATE UNIQUE INDEX chat_rooms_pkey ON public.chat_rooms USING btree (id);

CREATE UNIQUE INDEX companies_pkey ON public.companies USING btree (id);

CREATE UNIQUE INDEX failed_invites_pkey ON public.failed_invites USING btree (id);

CREATE UNIQUE INDEX jobs_pkey ON public.jobs USING btree (id);

CREATE UNIQUE INDEX messages_pkey ON public.messages USING btree (id);

CREATE UNIQUE INDEX notes_pkey ON public.notes USING btree (id);

CREATE UNIQUE INDEX question_buckets_pkey ON public.question_buckets USING btree (id);

CREATE UNIQUE INDEX question_question_buckets_pkey ON public.question_question_buckets USING btree (id);

CREATE UNIQUE INDEX questions_pkey ON public.questions USING btree (id);

CREATE UNIQUE INDEX results_pkey ON public.results USING btree (id);

CREATE UNIQUE INDEX teams_pkey ON public.teams USING btree (id);

CREATE UNIQUE INDEX user_team_mapping_pkey ON public.user_team_mapping USING btree (user_id, team_id);

CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);

alter table "public"."answers" add constraint "answers_pkey" PRIMARY KEY using index "answers_pkey";

alter table "public"."campaign_job" add constraint "campaign_job_pkey" PRIMARY KEY using index "campaign_job_pkey";

alter table "public"."campaigns" add constraint "campaigns_pkey" PRIMARY KEY using index "campaigns_pkey";

alter table "public"."chat_room_members" add constraint "chat_room_members_pkey" PRIMARY KEY using index "chat_room_members_pkey";

alter table "public"."chat_rooms" add constraint "chat_rooms_pkey" PRIMARY KEY using index "chat_rooms_pkey";

alter table "public"."companies" add constraint "companies_pkey" PRIMARY KEY using index "companies_pkey";

alter table "public"."failed_invites" add constraint "failed_invites_pkey" PRIMARY KEY using index "failed_invites_pkey";

alter table "public"."jobs" add constraint "jobs_pkey" PRIMARY KEY using index "jobs_pkey";

alter table "public"."messages" add constraint "messages_pkey" PRIMARY KEY using index "messages_pkey";

alter table "public"."notes" add constraint "notes_pkey" PRIMARY KEY using index "notes_pkey";

alter table "public"."question_buckets" add constraint "question_buckets_pkey" PRIMARY KEY using index "question_buckets_pkey";

alter table "public"."question_question_buckets" add constraint "question_question_buckets_pkey" PRIMARY KEY using index "question_question_buckets_pkey";

alter table "public"."questions" add constraint "questions_pkey" PRIMARY KEY using index "questions_pkey";

alter table "public"."results" add constraint "results_pkey" PRIMARY KEY using index "results_pkey";

alter table "public"."teams" add constraint "teams_pkey" PRIMARY KEY using index "teams_pkey";

alter table "public"."user_team_mapping" add constraint "user_team_mapping_pkey" PRIMARY KEY using index "user_team_mapping_pkey";

alter table "public"."users" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

alter table "public"."answers" add constraint "answers_campaign_id_fkey" FOREIGN KEY (campaign_id) REFERENCES campaigns(id) not valid;

alter table "public"."answers" validate constraint "answers_campaign_id_fkey";

alter table "public"."answers" add constraint "answers_created_by_fkey" FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."answers" validate constraint "answers_created_by_fkey";

alter table "public"."answers" add constraint "answers_question_id_fkey" FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE not valid;

alter table "public"."answers" validate constraint "answers_question_id_fkey";

alter table "public"."answers" add constraint "answers_updated_by_fkey" FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."answers" validate constraint "answers_updated_by_fkey";

alter table "public"."answers" add constraint "answers_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."answers" validate constraint "answers_user_id_fkey";

alter table "public"."campaign_job" add constraint "campaign_job_campaign_id_fkey" FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE not valid;

alter table "public"."campaign_job" validate constraint "campaign_job_campaign_id_fkey";

alter table "public"."campaign_job" add constraint "campaign_job_company_id_fkey" FOREIGN KEY (company_id) REFERENCES companies(id) not valid;

alter table "public"."campaign_job" validate constraint "campaign_job_company_id_fkey";

alter table "public"."campaign_job" add constraint "campaign_job_job_id_fkey" FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE not valid;

alter table "public"."campaign_job" validate constraint "campaign_job_job_id_fkey";

alter table "public"."campaigns" add constraint "campaigns_company_id_fkey" FOREIGN KEY (company_id) REFERENCES companies(id) not valid;

alter table "public"."campaigns" validate constraint "campaigns_company_id_fkey";

alter table "public"."campaigns" add constraint "campaigns_created_by_fkey" FOREIGN KEY (created_by) REFERENCES users(id) not valid;

alter table "public"."campaigns" validate constraint "campaigns_created_by_fkey";

alter table "public"."chat_room_members" add constraint "chat_room_members_campaign_id_fkey" FOREIGN KEY (campaign_id) REFERENCES campaigns(id) not valid;

alter table "public"."chat_room_members" validate constraint "chat_room_members_campaign_id_fkey";

alter table "public"."chat_room_members" add constraint "chat_room_members_chat_room_id_fkey" FOREIGN KEY (chat_room_id) REFERENCES chat_rooms(id) ON DELETE CASCADE not valid;

alter table "public"."chat_room_members" validate constraint "chat_room_members_chat_room_id_fkey";

alter table "public"."chat_room_members" add constraint "chat_room_members_company_id_fkey" FOREIGN KEY (company_id) REFERENCES companies(id) not valid;

alter table "public"."chat_room_members" validate constraint "chat_room_members_company_id_fkey";

alter table "public"."chat_room_members" add constraint "chat_room_members_job_id_fkey" FOREIGN KEY (job_id) REFERENCES jobs(id) not valid;

alter table "public"."chat_room_members" validate constraint "chat_room_members_job_id_fkey";

alter table "public"."chat_room_members" add constraint "chat_room_members_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."chat_room_members" validate constraint "chat_room_members_user_id_fkey";

alter table "public"."chat_rooms" add constraint "chat_rooms_campaign_id_fkey" FOREIGN KEY (campaign_id) REFERENCES campaigns(id) not valid;

alter table "public"."chat_rooms" validate constraint "chat_rooms_campaign_id_fkey";

alter table "public"."chat_rooms" add constraint "chat_rooms_company_id_fkey" FOREIGN KEY (company_id) REFERENCES companies(id) not valid;

alter table "public"."chat_rooms" validate constraint "chat_rooms_company_id_fkey";

alter table "public"."chat_rooms" add constraint "chat_rooms_created_by_fkey" FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."chat_rooms" validate constraint "chat_rooms_created_by_fkey";

alter table "public"."chat_rooms" add constraint "chat_rooms_job_id_fkey" FOREIGN KEY (job_id) REFERENCES jobs(id) not valid;

alter table "public"."chat_rooms" validate constraint "chat_rooms_job_id_fkey";

alter table "public"."jobs" add constraint "jobs_campaign_id_fkey" FOREIGN KEY (campaign_id) REFERENCES campaigns(id) not valid;

alter table "public"."jobs" validate constraint "jobs_campaign_id_fkey";

alter table "public"."jobs" add constraint "jobs_company_id_fkey" FOREIGN KEY (company_id) REFERENCES companies(id) not valid;

alter table "public"."jobs" validate constraint "jobs_company_id_fkey";

alter table "public"."messages" add constraint "messages_campaign_id_fkey" FOREIGN KEY (campaign_id) REFERENCES campaigns(id) not valid;

alter table "public"."messages" validate constraint "messages_campaign_id_fkey";

alter table "public"."messages" add constraint "messages_chat_room_id_fkey" FOREIGN KEY (chat_room_id) REFERENCES chat_rooms(id) ON DELETE CASCADE not valid;

alter table "public"."messages" validate constraint "messages_chat_room_id_fkey";

alter table "public"."messages" add constraint "messages_company_id_fkey" FOREIGN KEY (company_id) REFERENCES companies(id) not valid;

alter table "public"."messages" validate constraint "messages_company_id_fkey";

alter table "public"."messages" add constraint "messages_job_id_fkey" FOREIGN KEY (job_id) REFERENCES jobs(id) not valid;

alter table "public"."messages" validate constraint "messages_job_id_fkey";

alter table "public"."messages" add constraint "messages_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."messages" validate constraint "messages_user_id_fkey";

alter table "public"."notes" add constraint "notes_company_id_fkey" FOREIGN KEY (company_id) REFERENCES companies(id) not valid;

alter table "public"."notes" validate constraint "notes_company_id_fkey";

alter table "public"."notes" add constraint "notes_created_by_fkey" FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."notes" validate constraint "notes_created_by_fkey";

alter table "public"."notes" add constraint "notes_updated_by_fkey" FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."notes" validate constraint "notes_updated_by_fkey";

alter table "public"."notes" add constraint "notes_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."notes" validate constraint "notes_user_id_fkey";

alter table "public"."question_buckets" add constraint "question_buckets_company_id_fkey" FOREIGN KEY (company_id) REFERENCES companies(id) not valid;

alter table "public"."question_buckets" validate constraint "question_buckets_company_id_fkey";

alter table "public"."question_buckets" add constraint "question_buckets_created_by_fkey" FOREIGN KEY (created_by) REFERENCES users(id) not valid;

alter table "public"."question_buckets" validate constraint "question_buckets_created_by_fkey";

alter table "public"."question_buckets" add constraint "question_buckets_updated_by_fkey" FOREIGN KEY (updated_by) REFERENCES users(id) not valid;

alter table "public"."question_buckets" validate constraint "question_buckets_updated_by_fkey";

alter table "public"."question_question_buckets" add constraint "question_question_buckets_created_by_fkey" FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."question_question_buckets" validate constraint "question_question_buckets_created_by_fkey";

alter table "public"."question_question_buckets" add constraint "question_question_buckets_question_bucket_id_fkey" FOREIGN KEY (question_bucket_id) REFERENCES question_buckets(id) ON DELETE CASCADE not valid;

alter table "public"."question_question_buckets" validate constraint "question_question_buckets_question_bucket_id_fkey";

alter table "public"."question_question_buckets" add constraint "question_question_buckets_question_id_fkey" FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE not valid;

alter table "public"."question_question_buckets" validate constraint "question_question_buckets_question_id_fkey";

alter table "public"."questions" add constraint "questions_created_by_fkey" FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."questions" validate constraint "questions_created_by_fkey";

alter table "public"."questions" add constraint "questions_updated_by_fkey" FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."questions" validate constraint "questions_updated_by_fkey";

alter table "public"."results" add constraint "results_campaign_id_fkey" FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE not valid;

alter table "public"."results" validate constraint "results_campaign_id_fkey";

alter table "public"."results" add constraint "results_job_id_fkey" FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE not valid;

alter table "public"."results" validate constraint "results_job_id_fkey";

alter table "public"."teams" add constraint "teams_company_id_fkey" FOREIGN KEY (company_id) REFERENCES companies(id) not valid;

alter table "public"."teams" validate constraint "teams_company_id_fkey";

alter table "public"."user_team_mapping" add constraint "user_team_mapping_company_id_fkey" FOREIGN KEY (company_id) REFERENCES companies(id) not valid;

alter table "public"."user_team_mapping" validate constraint "user_team_mapping_company_id_fkey";

alter table "public"."user_team_mapping" add constraint "user_team_mapping_team_id_fkey" FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE not valid;

alter table "public"."user_team_mapping" validate constraint "user_team_mapping_team_id_fkey";

alter table "public"."user_team_mapping" add constraint "user_team_mapping_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."user_team_mapping" validate constraint "user_team_mapping_user_id_fkey";

alter table "public"."users" add constraint "users_company_id_fkey" FOREIGN KEY (company_id) REFERENCES companies(id) not valid;

alter table "public"."users" validate constraint "users_company_id_fkey";

alter table "public"."users" add constraint "users_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."users" validate constraint "users_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
    begin
        insert into public.users(id, email, company_id)
        values(
            new.id,
            new.email,
            (select id from public.companies where id = uuid(new.raw_user_meta_data->>'company_id')));

        update auth.users
        set raw_app_meta_data = raw_app_meta_data || new.raw_user_meta_data
        where email = new.email;

        update auth.users
        set raw_user_meta_data = '{}'
        where email = new.email;
        
        return new;
    end;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_team_selected()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
    begin
        update public.users
        set team_selected = true
        where id = new.user_id;
        
        return new;
    end;
$function$
;

CREATE OR REPLACE FUNCTION public.is_room_participant(room_id uuid)
 RETURNS boolean
 LANGUAGE sql
 SECURITY DEFINER
AS $function$
  select exists(
    select 1
    from chat_room_members
    where chat_room_id = is_room_participant.room_id and user_id = auth.uid()
  );
$function$
;

CREATE TRIGGER on_users_teams_created AFTER INSERT ON public.user_team_mapping FOR EACH ROW EXECUTE FUNCTION handle_team_selected();


