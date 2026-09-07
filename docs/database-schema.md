# QueueLess Database Schema

## Overview

The QueueLess database supports customer queue management,
staff management, service management, and daily queue numbering.

## Tables

The schema contains the four tables below. No customer account table is
required for MVP v1.

### 1. services

Stores the services offered by Luna Beauty Studio.

| Column | Type | Description |
|---|---|---|
| id | UUID | Primary key |
| name | TEXT | Required service name |
| description | TEXT | Service description |
| estimated_duration | INTEGER | Required estimated service duration in minutes |
| is_active | BOOLEAN | Whether the service is currently available; defaults to `true` |
| created_at | TIMESTAMPTZ | Record creation time; defaults to `now()` |
| updated_at | TIMESTAMPTZ | Last update time; defaults to `now()` |

### 2. staff

Stores staff members who can access the staff dashboard.

| Column | Type | Description |
|---|---|---|
| id | UUID | Primary key |
| name | TEXT | Required staff member's name |
| email | TEXT | Required, unique staff email address |
| role | TEXT | Required role (`STAFF` or `ADMIN`); defaults to `STAFF` |
| created_at | TIMESTAMPTZ | Record creation time; defaults to `now()` |

Authentication will be handled by Supabase Auth.

### 3. queue_entries

Stores each customer's queue entry.

| Column | Type | Description |
|---|---|---|
| id | UUID | Primary key |
| queue_number | INTEGER | Required customer's queue number |
| customer_name | TEXT | Required customer's name |
| service_id | UUID | Required selected service; references `services.id` |
| status | TEXT | Required current queue status; defaults to `WAITING` |
| joined_at | TIMESTAMPTZ | Time customer joined; defaults to `now()` |
| called_at | TIMESTAMPTZ | Time customer was called |
| service_started_at | TIMESTAMPTZ | Time service started |
| completed_at | TIMESTAMPTZ | Time service was completed |
| cancelled_at | TIMESTAMPTZ | Time queue entry was cancelled |
| created_at | TIMESTAMPTZ | Record creation time; defaults to `now()` |

### 4. queue_daily_counters

Stores the latest queue number for each business day.

| Column | Type | Description |
|---|---|---|
| id | UUID | Primary key |
| queue_date | DATE | Required, unique business date |
| last_number | INTEGER | Required last queue number issued; defaults to `0` |

## Relationships

- One service can have many queue entries.
- Each queue entry belongs to one service.
- Queue numbers reset each business day.
- Queue history is preserved.

## Queue Statuses

Queue entries can have the following statuses:

- WAITING
- CALLED
- SERVING
- COMPLETED
- SKIPPED
- CANCELLED

## Authentication

Customer accounts are not required for MVP v1.

Staff and admin authentication will use Supabase Auth.
The `staff` table stores application-specific staff information
and role information.

## Business Rules

1. Queue numbers are unique within a business day.
2. Queue numbers reset on the next business day.
3. Completed and cancelled queue entries remain in the database.
4. A customer cannot have multiple active queue entries.
5. Only active services can be selected by customers.
6. Queue history must be preserved for reporting.
