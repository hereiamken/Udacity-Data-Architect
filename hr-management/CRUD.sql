--Question #1
select
	ps.emp_id ,
	ps.emp_nm ,
	ps.job_title ,
	ps.department_nm
from
	proj_stg ps;
--Question #2
insert
	into
	job
(job_title)
values('Web Programmer');

select
	*
from
	job j ;
--Question #3
update
	job
set
	job_title = 'Web Developer'
where
	job_title = 'Web Programmer';

select
	*
from
	job;
--Question #4
delete
from
	job
where
	job_title = 'Web Developer';

select
	*
from
	job;
--Question #5
select
	d.id ,
	d.dep_nm ,
	count(eh.*)
from
	employee_history eh
inner join department d on
	d.id = eh.dep_id
group by
	d.id;
--Question #6
select
	e.emp_nm ,
	j.job_title ,
	d.dep_nm ,
	(
	select
		em.emp_nm as manager_nm
	from
		employee em
	where
		em.emp_id = eh.manager_id),
	eh.start_dt ,
	eh.end_dt
from
	employee_history eh
inner join employee e on
	e.emp_id = eh.emp_id
inner join job j on
	j.id = eh.job_id
inner join department d 
on
	d.id = eh.dep_id
where
	e.emp_nm = 'Toni Lembeck';
--Challenge #1
create view human_readable_view as (
select
	e.emp_id ,
	e.emp_nm ,
	e.email ,
	e.hire_dt,
	j.job_title ,
	eh.salary,
	d.dep_nm ,
	(
	select
		em.emp_nm as manager
	from
		employee em
	where
		em.emp_id = eh.emp_id),
	eh.start_dt ,
	eh.end_dt ,
	l.location_nm ,
	l.address ,
	ed.education_lvl
from
	employee_history eh
inner join employee e 
on
	e.emp_id = eh.emp_id
inner join job j 
on
	j.id = eh.job_id
inner join department d 
on
	d.id = eh.dep_id
inner join "location" l 
on
	l.id = eh.location_id
inner join city c 
on
	c.id = l.city_id
inner join state s 
on 
	s.id = c.state_id
inner join education ed 
on
	ed.id = eh.education_id 
);

select
	*
from
	human_readable_view;
--Challenge #2
create or replace
function employee_data_func (name VARCHAR) 
    returns table (
        emp_nm varchar,
		job_title varchar,
		department_nm varchar,
		manager varchar,
		start_dt date,
		end_dt date
) 
as $$
begin
    return query
select
	p.emp_nm,
	p.job_title,
	p.department_nm,
	p.manager,
	p.start_dt,
	p.end_dt
from
	proj_stg p
where
	p.emp_nm = name;
end;

$$ 
language 'plpgsql';

select
	employee_data_func ('Toni Lembeck');
--Challenge #3
create user NoMgr;

grant
select
	on
	employee to NoMgr;
