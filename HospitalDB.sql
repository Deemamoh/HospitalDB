use HospitalDB;

create table Patients(
patientID int primary key not null,
patient_name varchar(50) not null,
email varchar(255) unique not null,
patient_password varchar(255) not null,
gender enum('Male','Female') not null 
);

create table Appointments(
appointmentID int primary key not null,
patientID int not null ,
doctor_name varchar(50),
ap_time date not null,
foreign key (patientID) references Patients(patientID)
);

create table Doctors(
doctorID int primary key not null,
doctor_name varchar(50) not null,
email varchar(255) unique not null, 
passowrd varchar(255) not null ,
gender enum('Male','Female') not null 
);

-- modify column name 
alter table Doctors
rename column passowrd to doctor_password;

select * from Doctors;
select * from Patients;
select * from Appointments;

-- i added fk whitout add constraints names so it named automatically
alter table Appointments
add doctorID int, -- add column first then add the fk 
add foreign key (doctorID) references Doctors(doctorID);


-- now i will name the constraints 
alter table Appointments
add constraint fk_patient foreign key(patientID) references Patients(patientID),
add constraint fk_doctor foreign key(doctorID) references Doctors(doctorID);

-- now delete prvious foreign keys 
alter table Appointments
drop foreign key appointments_ibfk_1,
drop foreign key appointments_ibfk_2;

create table Departments(
deptID int primary key,
dept_name varchar(50)
);

-- in prev table i forgot not null so here is the update 
alter table Departments
modify dept_name varchar(50) not null;

create table MediaclHistory(
historyID int primary key,
patientID int not null,
diagnosis varchar(255) not null,
treatment varchar(255) not null,
visit_date date,
foreign key (patientID) references Patients(patientID)
);

create table Schedules(
scheduleID int primary key,
doctorID int not null,
available_day enum ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday') not null,
start_time time not null,
end_time time not null,
foreign key (doctorID) references Doctors(doctorID)
);


-- now adding values 
insert into Patients(patientID, patient_name, email, patient_password, gender)
values
(1, 'Marwa Ahmed', 'x1@gmail.com', '123456','Female'),
(2, 'Ali Daham', 'x2@gmail.com', '3456', 'Male'),
(3, 'Layan Saleh Abdu', 'x3@gmail.com', 'gfgye6354', 'Female'),
(4, 'faisal auob', 'x4@gmail.com', 'gf6354', 'Male'),
(5, 'Saud saeed', 'x5@gmail.com', 'gf635234', 'Male'),
(6,'Amer amin', 'x6@gmail.com', 'gf1226354', 'Male'),
(7,'auob subhan', 'x7@gmail.com', '24564', 'Male'),
(8,'Asmaa osama', 'x8@gmail.com', '12f6354', 'Female'),
(9, 'Rawan radi', 'x9@gmail.com', '12f986354', 'Female'),
(10,'rami osama', 'x10@gmail.com', '12f6354', 'Female');

insert into Doctors(doctorID, doctor_name, email, doctor_password, gender)
values
(80, 'Mari Ami', '80@gmail.com', '123456', 'Female'),
(17, 'Nafea Raji', '17@gmail.com', '1236456', 'Male'),
(39, 'Qamar Nasr', '39@gmail.com', '98765', 'Female'),
(11, 'Shawqii ghazli', '11@gmail.com', '129856', 'Female'),
(22, 'Khamees bin jumaa', '22@gmail.com', '1sjn8476', 'Male');

insert into Departments (deptID, dept_name)
values
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Orthopedics');

-- now i want to modify on ap_time type in appointment to be datetime 
alter table Appointments
modify ap_time datetime not null;

-- i dont need doctor name column 
alter table Appointments
drop column doctor_name;

-- complete 
insert into Appointments (appointmentID, patientID, ap_time, doctorID)
values
(444, 6, '2025-09-05 10:00:00', 22),
(241, 1, '2025-09-07 09:30:00', 17),
(132, 4, '2025-11-02 11:00:00', 11),
(54, 10, '2025-11-02 11:00:00', 11);

insert into MediaclHistory(historyID, patientID, diagnosis, treatment, visit_date)
values 
(1, 6, 'Hypertension', 'Medication A', '2025-09-05'),
(2, 1, 'Migraine', 'Medication B', '2025-09-06'),
(3, 4, 'Back Pain', 'Physiotherapy', '2025-09-10'),
(4, 10, 'Fracture', 'Cast', '2025-09-12');

insert into Schedules (scheduleID, doctorID, available_day, start_time, end_time)
values
(1, 22, 'Monday', '09:00:00', '12:00:00'),
(2, 17, 'Tuesday', '13:00:00', '16:00:00'),
(3, 11, 'Wednesday', '10:00:00', '14:00:00');

select * from Appointments;
select * from Departments;
select * from Doctors;
select * from MediaclHistory;
select * from Patients;
select * from Schedules;

-- now doing some management queries

-- show all paitents with thier appointments and doctors 
select 
p.patient_name as patient,
d.doctor_name as doctor,
app.ap_time as appointment
from Patients p 
join Appointments app on p.patientID = app.patientID
join Doctors d on d.doctorID = app.doctorID
order by app.ap_time;

-- show doctor's schedule
select 
d.doctor_name as doctor,
s.scheduleID ,
s.available_day as day,
s.start_time as start,
s.end_time as end
from Doctors d join Schedules s on d.doctorID = s.doctorID
order by d.doctor_name desc;

-- show patient' medical history 
select 
p.patient_name as name, 
p.gender,
m.diagnosis,
m.treatment,
m.visit_date
from Patients p join MediaclHistory m on p.patientID = m.patientID
where m.patientID = 10;

-- count appointments per doctor 
select d.doctor_name doctor,
count(app.appointmentID) as TotalAppointments
from Doctors d left join Appointments app on d.doctorID = app.doctorID
group by d.doctor_name 
order by TotalAppointments desc;