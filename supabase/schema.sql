-- MM ILSUNGTECH NEW DATABASE - run in a BRAND NEW Supabase project.
-- This schema is intentionally separate from the old manpower project.
create extension if not exists pgcrypto;

create table public.employees (
 id uuid primary key default gen_random_uuid(),
 employee_code text not null unique,
 full_name text not null,
 department text,
 hire_date date,
 work_group text not null default 'Ca A' check(work_group in ('Ca A','Ca C','Hành Chính')),
 shift_mode text not null default 'rotating' check(shift_mode in ('rotating','day','night','admin')),
 employee_type text not null default 'Chính thức',
 is_active boolean not null default true,
 created_at timestamptz not null default now()
);

create table public.attendance_records (
 id uuid primary key default gen_random_uuid(),
 employee_id uuid not null references public.employees(id) on delete cascade,
 work_date date not null,
 shift text not null check(shift in ('day','night','admin')),
 status text not null default 'present' check(status in ('present','absent','leave','sick')),
 check_in time,
 check_out time,
 notes text,
 created_at timestamptz not null default now(),
 unique(employee_id,work_date)
);
create table public.overtime_records (
 id uuid primary key default gen_random_uuid(),
 employee_id uuid not null references public.employees(id) on delete cascade,
 ot_date date not null,
 shift text not null check(shift in ('day','night','admin')),
 hours numeric(5,2) not null check(hours>0 and hours<=16),
 notes text,
 created_at timestamptz not null default now()
);
create table public.leave_requests (
 id uuid primary key default gen_random_uuid(),
 employee_id uuid not null references public.employees(id) on delete cascade,
 start_date date not null,
 end_date date not null,
 leave_type text not null,
 reason text,
 status text not null default 'Chờ duyệt' check(status in ('Chờ duyệt','Đã duyệt','Từ chối')),
 created_at timestamptz not null default now(),
 check(end_date>=start_date)
);
create table public.salary_records (
 id uuid primary key default gen_random_uuid(),
 employee_id uuid not null references public.employees(id) on delete cascade,
 salary_month date not null,
 base_salary numeric(14,2) not null default 0,
 allowance numeric(14,2) not null default 0,
 bonus numeric(14,2) not null default 0,
 deduction numeric(14,2) not null default 0,
 created_at timestamptz not null default now(),
 unique(employee_id,salary_month)
);
create table public.mbo_records (
 id uuid primary key default gen_random_uuid(),
 employee_id uuid not null references public.employees(id) on delete cascade,
 mbo_year integer not null check(mbo_year between 2020 and 2100),
 mbo_quarter integer not null check(mbo_quarter between 1 and 4),
 objective text not null,
 kpi_target text,
 actual_result text,
 achievement_pct numeric(6,2) not null default 0 check(achievement_pct between 0 and 200),
 rating text check(rating is null or rating in ('Xuất sắc','Tốt','Đạt','Chưa đạt')),
 notes text,
 created_at timestamptz not null default now()
);
create index employees_active_idx on public.employees(is_active);
create index attendance_date_idx on public.attendance_records(work_date);
create index overtime_date_idx on public.overtime_records(ot_date);
create index leave_status_idx on public.leave_requests(status);
create index mbo_period_idx on public.mbo_records(mbo_year,mbo_quarter);

-- Lịch Ca A/C: không định nghĩa chu kỳ tự động. Ca thực tế được chọn theo kế hoạch công ty từng ngày.
-- Mỗi nhân viên chỉ có một bản ghi chấm công cho một ngày làm việc.

-- Initial deployment policy: authenticated staff may use the app.
-- Before production, refine these policies by role (admin, HR, manager, employee).
do $$
declare t text;
begin
 foreach t in array array['employees','attendance_records','overtime_records','leave_requests','salary_records','mbo_records'] loop
  execute format('alter table public.%I enable row level security',t);
  execute format('create policy %I on public.%I for all to authenticated using (true) with check (true)',t||'_authenticated_access',t);
  execute format('grant select,insert,update,delete on public.%I to authenticated',t);
 end loop;
end $$;

select table_name from information_schema.tables
where table_schema='public' and table_name in
('employees','attendance_records','overtime_records','leave_requests','salary_records','mbo_records')
order by table_name;
