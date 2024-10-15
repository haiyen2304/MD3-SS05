create database s05_bt2;
use s05_bt2;
create table account(
	id int primary key auto_increment,
    user_name varchar(100) unique not null,
    password varchar(255) not null,
    address varchar(255) not null,
    status bit default True
);
create table bill(
	id int primary key auto_increment,
    bill_type bit default True,
    acc_id int not null,
    created datetime,
    auth_date datetime,
    constraint fk_bill01 foreign key (acc_id) references account(id) 
);
create table product(
	id int primary key auto_increment,
    name varchar(255) not null unique,
    created date not null,
    price double check(price > 0),
    stock int not null,
    status bit default True
);
create table bill_detail(
	id int primary key auto_increment,
    bill_id int not null,
    product_id int not null,
    quantity int not null,
    price double check(price>0),
    constraint fk_bd01 foreign key (bill_id) references bill(id),
    constraint fk_bd02 foreign key (product_id) references product(id)
);

insert into account(user_name,password,address,status) values
('Hùng','123456','Hà Nội',True),('Cường','654321','Hà Nội',True),('Bách','135790','Bắc Ninh',True);

insert into bill(bill_type,acc_id,created,auth_date) values
(0,1,str_to_date("11/02/2022",'%d/%c/%Y'),str_to_date("12/03/2022",'%d/%c/%Y')),
(0,1,str_to_date("05/10/2023",'%d/%c/%Y'),str_to_date("10/10/2023",'%d/%c/%Y')),
(1,2,str_to_date("15/05/2024",'%d/%c/%Y'),str_to_date("20/05/2024",'%d/%c/%Y')),
(1,3,str_to_date("01/02/2022",'%d/%c/%Y'),str_to_date("10/02/2022",'%d/%c/%Y'));

insert into product(name,created,price,stock,status) values
('Quần dài',str_to_date("12/03/2022",'%d/%c/%Y'),1200,5,True),
('Áo dài',str_to_date("15/03/2023",'%d/%c/%Y'),1500,8,True),
('Mũ cối',str_to_date("08/03/1999",'%d/%c/%Y'),1600,10,True);

insert into bill_detail(bill_id,product_id,quantity,price) values
(1,1,3,1200),(1,2,4,1500),(2,1,1,1200),(3,2,4,1500),(4,3,7,1600);

DELIMITER //
CREATE PROCEDURE infor_Account()
BEGIN
	select user_name from account where id IN (
	Select acc_id from bill 
    group by acc_id having count(acc_id)>1);
END //
DELIMITER ;
call infor_Account();

DELIMITER //
CREATE PROCEDURE product_NotSell()
BEGIN
	select name from product where id NOT IN(
	select product_id from bill_detail);
END //
DELIMITER ;
call product_NotSell();

DELIMITER //
CREATE PROCEDURE top2_Sell()
BEGIN
	select p.name,topProduct.product_id from(
	select product_id,count(product_id) as totalCount from bill_detail 
    group by product_id
    order by count(product_id) desc limit 2) as topProduct 
    inner join product as p on topProduct.product_id = p.id
    order by topProduct.totalCount asc limit 1;
END //
DELIMITER ;
call top2_Sell();

DELIMITER //
CREATE PROCEDURE add_Account(IN userName varchar(255), newPass varchar(255), newAddress varchar(255), newStatus bit)
BEGIN
	INSERT INTO account (user_name,password,address,status) VALUES(userName,newPass,newAddress,newStatus);
END //
DELIMITER ;
call add_Account('Vien','123456','Hai Duong',1);


DELIMITER //
CREATE PROCEDURE find_BillDetailById(IN bill_Id_In INT)
BEGIN
	select * from bill_detail where bill_id = bill_Id_In;
END //
DELIMITER ;
call find_BillDetailById(1);

DELIMITER //
CREATE PROCEDURE return_NewId(IN bill_type_IN bit, acc_id_IN int, created_IN datetime, auth_date_IN datetime, OUT getNewId int)
BEGIN
	insert into bill(bill_type,acc_id,created,auth_date) VALUES(bill_type_IN,acc_id_IN,created_IN,auth_date_IN);
    select last_insert_id() from bill limit 1 into getNewId;
END // 
DELIMITER ;
call return_NewId(1,2,str_to_date("11/02/2022",'%d/%c/%Y'),str_to_date("12/03/2022",'%d/%c/%Y'),@getNewId);
select @getNewId;
DROP procedure return_NewId

DELIMITER //
CREATE PROCEDURE list_sell()
BEGIN
	select name from product  where id IN (
	select product_id as soluong from bill_detail group by product_id having soluong > 1) ;
END //
DELIMITER ;
call list_sell();