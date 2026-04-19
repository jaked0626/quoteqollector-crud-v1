CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE "quote_type" AS ENUM ('quote', 'note');

CREATE TABLE "quotes" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4 ()),
  "type" quote_type DEFAULT ('quote'),
  "body" text,
  "work_id" uuid,
  "author_id" uuid,
  "contributor_id" uuid,
  "likes" int NOT NULL DEFAULT 1,
  "created_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "deleted_at" timestamptz
);

CREATE TABLE "user_quotes" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4 ()),
  "user_id" uuid,
  "quote_id" uuid,
  "created_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "deleted_at" timestamptz
);

CREATE TABLE "authors" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4 ()),
  "name" varchar NOT NULL,
  "birth" date,
  "death" date,
  "description" varchar,
  "profile_uri" varchar,
  "user_id" uuid,
  "created_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "deleted_at" timestamptz
);

CREATE TABLE "author_quotes" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4 ()),
  "quote_id" uuid,
  "author_id" uuid,
  "created_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "deleted_at" timestamptz
);

CREATE TABLE "works" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4 ()),
  "title" varchar NOT NULL,
  "year_published" int,
  "description" varchar,
  "cover_uri" varchar,
  "created_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "deleted_at" timestamptz
);

CREATE TABLE "author_works" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4 ()),
  "work_id" uuid,
  "author_id" uuid,
  "created_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "deleted_at" timestamptz
);

CREATE TABLE "tags" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4 ()),
  "value" varchar NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "deleted_at" timestamptz
);

CREATE TABLE "quote_tags" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4 ()),
  "quote_id" uuid,
  "tag_id" uuid,
  "created_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "deleted_at" timestamptz
);

CREATE TABLE "work_tags" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4 ()),
  "work_id" uuid,
  "tag_id" uuid,
  "created_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "deleted_at" timestamptz
);

CREATE TABLE "users" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4 ()),
  "name" varchar NOT NULL,
  "email" varchar,
  "birth" date,
  "description" varchar,
  "profile_uri" varchar,
  "has_author_profile" bool DEFAULT (FALSE),
  "created_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "deleted_at" timestamptz
);

CREATE TABLE "related_quotes" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v4 ()),
  "quote1_id" uuid,
  "quote2_id" uuid,
  "created_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamptz NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  "deleted_at" timestamptz
);

CREATE INDEX ON "quote_tags" ("quote_id");

CREATE INDEX ON "quote_tags" ("tag_id");

CREATE INDEX ON "work_tags" ("work_id");

CREATE INDEX ON "work_tags" ("tag_id");

COMMENT ON COLUMN "authors"."user_id" IS 'sometimes, an author is a user';

COMMENT ON COLUMN "author_quotes"."author_id" IS 'Sometimes the author(s) of a quote is not the author(s) of the work. For example, Michel Foucault wrote the preface of Anti-Oedipus and contributed a number of memorable quotes but it was Gilles Deleuze and Felix Guattari that authored the work.';

ALTER TABLE "quotes" ADD FOREIGN KEY ("work_id") REFERENCES "works" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "quotes" ADD FOREIGN KEY ("author_id") REFERENCES "authors" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "quotes" ADD FOREIGN KEY ("contributor_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "user_quotes" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "user_quotes" ADD FOREIGN KEY ("quote_id") REFERENCES "quotes" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "authors" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "author_quotes" ADD FOREIGN KEY ("quote_id") REFERENCES "quotes" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "author_quotes" ADD FOREIGN KEY ("author_id") REFERENCES "authors" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "author_works" ADD FOREIGN KEY ("work_id") REFERENCES "works" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "author_works" ADD FOREIGN KEY ("author_id") REFERENCES "authors" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "quote_tags" ADD FOREIGN KEY ("quote_id") REFERENCES "quotes" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "quote_tags" ADD FOREIGN KEY ("tag_id") REFERENCES "tags" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "work_tags" ADD FOREIGN KEY ("work_id") REFERENCES "works" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "work_tags" ADD FOREIGN KEY ("tag_id") REFERENCES "tags" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "related_quotes" ADD FOREIGN KEY ("quote1_id") REFERENCES "quotes" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "related_quotes" ADD FOREIGN KEY ("quote2_id") REFERENCES "quotes" ("id") DEFERRABLE INITIALLY IMMEDIATE;
