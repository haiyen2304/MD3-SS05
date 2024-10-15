create database s05_bt1;
use s05_bt1;
create table customer(
	c_id int primary key auto_increment,
    c_name varchar(255),
    c_age int
);
create table orders(
	o_id int primary key auto_increment,
    c_id int,
    o_date datetime,
    o_totalprice double,
    constraint fk_04 foreign key (c_id) references customer(c_id)
);
create table products(
	p_id int primary key auto_increment,
    p_name varchar(255),
    p_price double
);
create table order_detail(
	o_id int,
    p_id int,
    od_QTY int,
    primary key(o_id,p_id),
    constraint fk_05 foreign key (o_id) references orders(o_id),
    constraint fk_06 foreign key (p_id) references products(p_id)
);
insert into customer(c_name,c_age) values
('Minh Quan',10),('Ngoc Oanh',20),('Hong Ha',50);
insert into orders(c_id,o_date,o_totalprice) values
(1,str_to_date('3/21/2006','%c/%d/%Y'),150000),(2,str_to_date('3/23/2006','%c/%d/%Y'),200000),(1,str_to_date('3/16/2006','%c/%d/%Y'),170000);
insert into orders(c_id,o_date,o_totalprice) values
(1,str_to_date('3/21/2006','%c/%d/%Y'),150000);
insert into products(p_name,p_price) values
('May Giat',300),('Tu Lanh',500),('Dieu Hoa',700),('Quat',100),('Bep Dien',200),('May Hut Mui',500);
insert into order_detail(o_id,p_id,od_QTY) values
(1,1,3),(1,3,7),(1,4,2),(2,1,1),(3,1,8),(2,5,4),(2,3,3);

#CREATE VIEW SHOW ALL CUSTOMER
CREATE VIEW show_AllCustomer AS
    SELECT 
        *
    FROM
        customer;

select* from show_AllCustomer;

#CREATE VIEW SHOW ORDER TOTAL PRICE GREATER THAN 150000
create view show_TotalPrice AS
select * from orders where o_totalprice > 150000;

select * from show_TotalPrice;

#CREATE INDEX FOR CUSTOMER IN cName
ALTER TABLE customer ADD INDEX idx_customerName (c_name);
#CREATE INDEX FOR PRODUCT IN pName
ALTER TABLE products ADD INDEX idx_productsName (p_name);

#CREATE PROCEDURE ORDER SUM SMALLEST
DELIMITER //
CREATE PROCEDURE findSumOrder()
BEGIN
	SELECT * FROM orders WHERE o_totalprice = (SELECT MIN(o_totalprice) FROM orders);
END //
DELIMITER ;
call findSumOrder();

#CREATE PROCEDURE SHOW USER USER BUY MAY GIAT AT LEAST
DELIMITER //
CREATE PROCEDURE findUserBuyProduct()
BEGIN
	SELECT c_name, count(productName) as totalProduct
    from(
		SELECT c.c_name,od.o_id,count(od.p_id) as productName FROM order_detail as od
		INNER JOIN products as p on od.p_id = p.p_id
		INNER JOIN orders as o on o.o_id = od.o_id
		INNER JOIN customer as c on c.c_id = o.c_id
		where p.p_name = 'May Giat'
		group by od.o_id) as abc
        group by c_name
        order by totalProduct asc limit 1;
END //
DELIMITER ;

call findUserBuyProduct();