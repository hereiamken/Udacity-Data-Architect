create table employee (emp_id varchar(8) primary key,
emp_nm varchar(50),
email varchar(100),
hire_dt date);

create table employee_history ( id SERIAL primary key,
emp_id varchar(8),
job_id int,
salary_id int,
dep_id int,
manager_id varchar(8),
start_dt date,
end_dt date,
location_id int,
education_id int);

create table job (id SERIAL primary key,
job_title varchar(100));

create table department (id SERIAL primary key,
dep_nm varchar(50));

create table location (id SERIAL primary key,
location_nm varchar(50),
address varchar(100),
city_id int);

create table city (id SERIAL primary key,
city_nm varchar(50),
state_id int);

create table state (id SERIAL primary key,
state_nm varchar(2));

create table education (id SERIAL primary key,
education_lvl varchar(50));

create table salary (id SERIAL primary key,
salary int);