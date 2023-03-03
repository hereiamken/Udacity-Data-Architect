insert
	into
	education(education_lvl)
select
	distinct(education_lvl)
from
	proj_stg;

select
	*
from
	education e ;

insert
	into
	job(job_title)
select
	distinct(job_title)
from
	proj_stg;

select
	*
from
	job j ;

insert
	into
	department(dep_nm)
select
	distinct(department_nm)
from
	proj_stg;

select
	*
from
	department d ;

insert
	into
	state(state_nm)
select
	distinct(state)
from
	proj_stg;

select
	*
from
	state s ;

insert
	into
	city(city_nm,
	state_id)
select
	distinct p.city,
	st.id
from
	proj_stg as p
inner join state as st
on
	p.state = st.state_nm;

select
	*
from
	city c ;

insert
	into
	location(location_nm,
	address,
	city_id)
select
	distinct p.location,
	p.address,
	c.id
from
	proj_stg as p
inner join city as c 
on
	p.city = c.city_nm;

select
	*
from
	"location" l ;

insert
	into
	employee (emp_id,
	emp_nm,
	email,
	hire_dt)
select
	distinct p.emp_id ,
	p.emp_nm ,
	p.email ,
	p.hire_dt
from
	proj_stg as p;

select
	*
from
	employee e ;

insert
	into
	salary (salary)
select
	distinct salary
from
	proj_stg ;

select
	*
from
	salary ;

insert
	into
	employee_history (emp_id,
	job_id,
	salary_id ,
	dep_id,
	manager_id,
	start_dt,
	end_dt,
	location_id,
	education_id)
select
	p.emp_id,
	job.id,
	s.id ,
	dep.id ,
	(
	select
		emp_id
	from
		employee
	where
		emp_nm = p.manager),
	p.start_dt,
	p.end_dt,
	loc.id,
	edu.id
from
	proj_stg as p
inner join job as job 
on
	job.job_title = p.job_title
inner join department dep 
on
	dep.dep_nm = p.department_nm
inner join "location" loc
on
	loc.location_nm = p."location"
inner join education edu
on
	edu.education_lvl = p.education_lvl
inner join salary s 
on
	s.salary = p.salary ;

select
	*
from
	employee_history eh ;
