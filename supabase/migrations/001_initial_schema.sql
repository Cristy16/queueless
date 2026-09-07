-- QueueLess Database Schema

-- 1. Services
create table services (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  estimated_duration integer not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 2. Staff
create table staff (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  email text not null unique,
  role text not null default 'STAFF',
  created_at timestamptz not null default now()
);

-- 3. Queue Entries
create table queue_entries (
  id uuid primary key default gen_random_uuid(),
  queue_number integer not null,
  customer_name text not null,
  service_id uuid not null references services(id),
  status text not null default 'WAITING',
  joined_at timestamptz not null default now(),
  called_at timestamptz,
  service_started_at timestamptz,
  completed_at timestamptz,
  cancelled_at timestamptz,
  created_at timestamptz not null default now()
);

-- 4. Daily Queue Counters
create table queue_daily_counters (
  id uuid primary key default gen_random_uuid(),
  queue_date date not null unique,
  last_number integer not null default 0
);
