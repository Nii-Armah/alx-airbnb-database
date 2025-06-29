CREATE TYPE "roles" AS ENUM (
  'admin',
  'host',
  'guest'
);

CREATE TYPE "booking_statuses" AS ENUM (
  'pending',
  'confirmed',
  'cancelled'
);

CREATE TYPE "payment_methods" AS ENUM (
  'credit_card',
  'paypal',
  'stripe'
);

CREATE TABLE "users" (
  "id" uuid PRIMARY KEY,
  "first_name" varchar NOT NULL,
  "last_name" varchar NOT NULL,
  "email" varchar UNIQUE NOT NULL,
  "password" varchar NOT NULL,
  "phone_number" varchar,
  "role" roles NOT NULL,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "properties" (
  "id" uuid PRIMARY KEY,
  "host_id" uuid,
  "name" varchar NOT NULL,
  "description" text NOT NULL,
  "location" varchar NOT NULL,
  "price_per_night" decimal NOT NULL,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp
);

CREATE TABLE "bookings" (
  "id" uuid PRIMARY KEY,
  "property_id" uuid,
  "guest_id" uuid,
  "start_date" date NOT NULL,
  "end_date" date NOT NULL,
  "total_price" decimal NOT NULL,
  "status" booking_statuses NOT NULL,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "payments" (
  "id" uuid PRIMARY KEY,
  "booking_id" uuid,
  "amount" decimal NOT NULL,
  "paid_at" timestamp DEFAULT (now()),
  "payment_method" payment_methods NOT NULL
);

CREATE TABLE "reviews" (
  "id" uuid PRIMARY KEY,
  "property_id" uuid,
  "user_id" uuid,
  "rating" int NOT NULL,
  "comment" text NOT NULL,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "messages" (
  "id" uuid PRIMARY KEY,
  "sender_id" uuid,
  "recipient_id" uuid,
  "body" text NOT NULL,
  "sent_at" timestamp DEFAULT (now())
);

CREATE INDEX ON "users" ("email");

CREATE INDEX ON "bookings" ("property_id");

CREATE INDEX ON "payments" ("booking_id");

COMMENT ON COLUMN "properties"."updated_at" IS 'Auto-update to now() on row change';

COMMENT ON COLUMN "reviews"."rating" IS 'Must be between 1 and 5';

ALTER TABLE "properties" ADD FOREIGN KEY ("host_id") REFERENCES "users" ("id");

ALTER TABLE "bookings" ADD FOREIGN KEY ("property_id") REFERENCES "properties" ("id");

ALTER TABLE "bookings" ADD FOREIGN KEY ("guest_id") REFERENCES "users" ("id");

ALTER TABLE "payments" ADD FOREIGN KEY ("booking_id") REFERENCES "bookings" ("id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("property_id") REFERENCES "properties" ("id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "messages" ADD FOREIGN KEY ("sender_id") REFERENCES "users" ("id");

ALTER TABLE "messages" ADD FOREIGN KEY ("recipient_id") REFERENCES "users" ("id");
