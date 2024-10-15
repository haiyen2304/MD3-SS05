create database s05_bt3;
use s05_bt3;
create table class(
	class_id int primary key auto_increment,
    class_name varchar(100),
    start_date datetime,
    status bit
);
create table students(
	student_id int primary key auto_increment,
    student_name varchar(100),
    address varchar(255),
    phone varchar(11),
    class_id int,
    CONSTRAINT lien_ket_01 FOREIGN KEY(class_id) REFERENCES class(class_id)
);
create table subject(
	subject_id int primary key auto_increment,
    subject_name varchar(100),
    credit int,
    status bit
);
create table mark(
	id int primary key auto_increment,
    subject_id int,
	CONSTRAINT lien_ket_02 FOREIGN KEY(subject_id) REFERENCES subject(subject_id),
    student_id int,
	CONSTRAINT lien_ket_03 FOREIGN KEY(student_id) REFERENCES students(student_id),
    point double,
    exam_time datetime
);
insert into class(class_name,start_date,status) values
('HN-JV231103',str_to_date("03/11/2023",'%d/%c/%Y'),True),('HN-JV231229',str_to_date("29/12/2023",'%d/%c/%Y'),True),
('HN-JV230615',str_to_date("15/06/2023",'%d/%c/%Y'),True);

insert into students(student_name,address,phone,class_id) values
('Lê Minh Quang','Hà Nội','09838442',1),('Trần Trọng Đức','Hải Phòng','9827374',1),
('Phan Đình Tạc','Thái Bình','123123',2);

insert into students(student_name,address,phone,class_id) values
('Nguyễn Thị Viện','Hải Dương','123123',2),('Nguyễn Đức Anh','Bắc Giang','322354',3),
('Lê Quang Tiệp','Bắc Ninh','65745',1),('Nguyễn Trường Sơn','Hưng Yên','123123',3);

insert into subject(subject_name,credit,status) values
('Toán',3,True),('Văn',3,True),('Anh',2,True);

insert into mark(student_id,subject_id,point,exam_time) values
(1,1,7,str_to_date("12/05/2024",'%d/%c/%Y')),(1,1,7,str_to_date("15/03/2024",'%d/%c/%Y')),
(2,2,8,str_to_date("15/05/2024",'%d/%c/%Y')),(2,3,9,str_to_date("08/03/2024",'%d/%c/%Y')),
(3,3,10,str_to_date("11/02/2024",'%d/%c/%Y'));

DELIMITER //
CREATE PROCEDURE class_totalStudent()
BEGIN
	select * from class where class_id IN (
	select class_id from students group by class_id having count(class_id) > 2);
END //
DELIMITER ;
call class_totalStudent();

DELIMITER //
CREATE PROCEDURE subject_point()
BEGIN
select subject_name from subject where subject_id IN (
	select subject_id from mark where point = 10);
END //
DELIMITER ;
call subject_point();

DELIMITER //
CREATE PROCEDURE student_point_ten()
BEGIN
	select distinct c.* from class as c 
    inner join students as s on  c.class_id = s.class_id
    inner join mark as m on m.student_id = s.student_id
    where m.point = 10;
END //
DELIMITER ;
call student_point_ten();

DELIMITER //
CREATE PROCEDURE add_new_student(IN student_name_IN varchar(100), address_IN varchar(100),phone_IN varchar(100), class_id_IN int, OUT getNewId int)
BEGIN
	insert into students(student_name,address,phone,class_id) VALUES (student_name_IN,address_IN,phone_IN,class_id_IN);
    select last_insert_id() from students limit 1 into getNewId;
END //
DELIMITER ;
call add_new_student('DucHai','Ha Noi','12343123',1,@getNewId);
select @getNewId;

DELIMITER //
CREATE PROCEDURE subject_nobody()
BEGIN
	select * from subject WHERE subject_id NOT IN (select subject_id from mark);
END //    
DELIMITER ;
call subject_nobody();