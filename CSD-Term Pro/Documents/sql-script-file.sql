--------------------------------------------------------------
--drop tables and sequences
drop table warehouses cascade constraints;
drop table products cascade constraints;
drop table product_inventory cascade constraints;
drop table orders cascade constraints;
drop table order_lines cascade constraints;
drop table order_customers cascade constraints;
drop table customers cascade constraints;
drop table associates cascade constraints;
drop sequence order_id_seq;
-----------------------------------------------------------------
--create tables
create table warehouses (
    warehouse_id        integer not null,
    region              varchar(40) not null
);

create table products (
    model_id            integer not null,
    serial_number       integer not null,
    item_description    varchar(40) not null,
    height              decimal(5,2),
    width               decimal(5,2),
    item_weight         decimal(5,2),
    unit_price          decimal(5,2)
);

create table product_inventory (
    warehouse_id        integer not null,
    model_id            integer not null,
    model_stock         integer not null
);

create table orders (
    order_id            integer not null,
    order_date          date default current_date,
    total_price         decimal(7,2)
);

create table order_lines (
    order_id        integer not null,
    model_id        integer not null
);

create table order_customers (
    order_id            integer not null,
    customer_id         integer not null
);

--costomers table contains an auto generated identity within the column of customer_id
create table customers (
    customer_id         integer generated always as identity start with 1000 increment by 1 nocache, 
    cust_first_name     varchar(40),
    cust_last_name      varchar(40),
    associate_id        integer not null,
    customer_address    varchar(40)
);

create table associates (
    associate_id            integer not null,
    associate_first_name    varchar(40),
    accociate_last_name     varchar(40),
    salary                  decimal(7,2) not null,
    job_code                varchar(1),
    active_status           varchar(1) default 'T' not null
);
----------------------------------------------------------------
----Constrints (Primary Key, Unique Key, Foreign Key)
--auto generated keys
--customer pk
alter table customers
add constraint customer_id_pk
primary key ( customer_id );

--orders sequence pk
alter table orders
add constraint order_id_pk
primary key ( order_id );

CREATE SEQUENCE order_id_seq
  START WITH 2000 INCREMENT BY 1
  NOCACHE;   

--primary keys
alter table warehouses
add constraint warehouse_id_pk
primary key (warehouse_id);

alter table product_inventory
add constraint warehouse_id_model_id_pk
primary key (warehouse_id, model_id);

alter table products
add constraint model_id_pk
primary key (model_id);

alter table order_customers
add constraint order_id_customer_id_pk
primary key ( order_id, customer_id );

alter table associates
add constraint associate_id_pk
primary key ( associate_id );

alter table order_lines 
add constraint order_lines_id_pk
primary key ( order_id, model_id );

--unique keys
alter table products
add constraint serial_number_uk
unique ( serial_number );

--foreign keys

alter table product_inventory
add constraint model_inventory_id_fk
foreign key (model_id)
references products( model_id );

alter table product_inventory
add constraint warehouse_id_fk
foreign key ( warehouse_id )
references warehouses( warehouse_id );

alter table order_customers
add constraint order_id_customers_fk
foreign key (order_id)
references orders(order_id);

alter table order_customers
add constraint customer_id_order_fk
foreign key (customer_id)
references customers(customer_id);

alter table customers
add constraint associate_id_fk
foreign key (associate_id)
references associates(associate_id)
on delete cascade;
-----------------------------------------------------------
---- ON UPDATE cluase is not currently working
--alter table order_lines 
--add constraint order_id_fk
--foreign key (order_id)
--references orders(order_id);
--on update cascade;

--alter table order_lines
--add constraint model_id_fk
--foreign key (model_id)
--references products ( model_id );
--on update cascade;
--------------------------------------------------------------------------------------
--database population        
--insert into tables
--15 customers

insert into customers values(default, 'Rodrigo', 'Valanzuela', 5000, 'Westmont, IL');
insert into customers values(default, 'Sydney', 'Huffman', 5001, 'Paterson, NJ');
insert into customers values(default, 'Zavier', 'Mendoza', 5002, 'Duluth, GA');
insert into customers values(default, 'Paula', 'Gould', 5003, 'Winter Park, FL');
insert into customers values(default, 'Sofia', 'Hardin', 5004, 'Conyers, GA');
insert into customers values(default, 'Cason', 'Baker', 5005, 'Marlton, NJ');
insert into customers values(default, 'Allison', 'Robbins', 5006, 'Queensbury, NY');
insert into customers values(default, 'Lexi', 'Ortiz', 5007, 'De Pere, WI');
insert into customers values(default, 'Uriah', 'Parsons', 5008, 'Maineville, OH');
insert into customers values(default, 'Mary', 'Armstrong', 5009, 'Dickson, TN');
insert into customers values(default, 'Ramon', 'Quinn', 5000, 'Ooltewah, TN');
insert into customers values(default, 'Presley', 'Levine', 5001, 'Andover, MA');
insert into customers values(default, 'Pheobe', 'Pineda', 5002, 'Fairfax, VA');
insert into customers values(default, 'Tessa', 'Russel', 5003, 'Westhaven, CT');
insert into customers values(default, 'Semaj', 'Pugh', 5004, 'Lakeland, FL');

--10 associates
insert all 
into associates values (5000, 'Busta', 'Rhymes', 97000, 'A', 'T')
into associates values (5001, 'Lil', 'Wayne', 95000, 'B', 'T')
into associates values (5002, 'Jay', 'Z', 90000, 'C', default)
into associates values (5003, 'Method', 'Man', 85000, 'D', default)
into associates values (5004, 'A$AP', 'Ferg', 80000, 'A', default)
into associates values (5005, 'Young', 'M.A', 75000, 'B', default)
into associates values (5006, 'Arctic', 'Monkeys', 70000, 'C', default)
into associates values (5007, 'Post', 'Malone', 65000, 'D', default)
into associates values (5008, 'Ice', 'Cube', 60000, 'A', default)
into associates values (5009, 'Dr', 'Dre', 55000, 'B', default)
select 1 from dual;

--30 products
--insert into products values(3030, 31, 'thirty-one', 10.00, 10.00, 5.00, 10.00);
insert all 
into products values(3000, 1, 'First', 10.00, 10.00, 5.00, 10.00)
into products values(3001, 2, 'second', 10.00, 10.00, 5.00, 10.00)
into products values(3002, 3, 'third', 10.00, 10.00, 5.00, 10.00)
into products values(3003, 4, 'Four', 10.00, 10.00, 5.00, 10.00)
into products values(3004, 5, 'five', 10.00, 10.00, 5.00, 10.00)
into products values(3005, 6, 'six', 10.00, 10.00, 5.00, 10.00)
into products values(3006, 7, 'seven', 10.00, 10.00, 5.00, 10.00)
into products values(3007, 8, 'eight', 10.00, 10.00, 5.00, 10.00)
into products values(3008, 9, 'nine', 10.00, 10.00, 5.00, 10.00)
into products values(3009, 10, 'ten', 10.00, 10.00, 5.00, 10.00)
into products values(3010, 11, 'eleven', 10.00, 10.00, 5.00, 10.00)
into products values(3011, 12, 'twelve', 10.00, 10.00, 5.00, 10.00)
into products values(3012, 13, 'thirteen', 10.00, 10.00, 5.00, 10.00)
into products values(3013, 14, 'fourteen', 10.00, 10.00, 5.00, 10.00)
into products values(3014, 15, 'fivteen', 10.00, 10.00, 5.00, 10.00)
into products values(3015, 16, 'sixteen', 10.00, 10.00, 5.00, 10.00)
into products values(3016, 17, 'seventeen', 10.00, 10.00, 5.00, 10.00)
into products values(3017, 18, 'eighteen', 10.00, 10.00, 5.00, 10.00)
into products values(3018, 19, 'nineteen', 10.00, 10.00, 5.00, 10.00)
into products values(3019, 20, 'twenty', 10.00, 10.00, 5.00, 10.00)
into products values(3020, 21, 'twenty-one', 10.00, 10.00, 5.00, 10.00)
into products values(3021, 22, 'twenty-two', 10.00, 10.00, 5.00, 10.00)
into products values(3022, 23, 'twenty-three', 10.00, 10.00, 5.00, 10.00)
into products values(3023, 24, 'twenty-four', 10.00, 10.00, 5.00, 10.00)
into products values(3024, 25, 'twenty-five', 10.00, 10.00, 5.00, 10.00)
into products values(3025, 26, 'twenty-six', 10.00, 10.00, 5.00, 10.00)
into products values(3026, 27, 'twenty-seven', 10.00, 10.00, 5.00, 10.00)
into products values(3027, 28, 'twenty-eight', 10.00, 10.00, 5.00, 10.00)
into products values(3028, 29, 'twenty-nine', 10.00, 10.00, 5.00, 10.00)
into products values(3029, 30, 'thirty', 10.00, 10.00, 5.00, 10.00)
select 1 from dual;

--30 orders
--^10 w/ one product
select * from orders;
select * from order_lines;
insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3000)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3001)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3002)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3003)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3004)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3005)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3006)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3007)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3008)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3009)
select 1 from dual;

--^10 w/ 2 products
select * from orders;
insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3010)
into order_lines values (order_id_seq.currval, 3011)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3012)
into order_lines values (order_id_seq.currval, 3013)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3014)
into order_lines values (order_id_seq.currval, 3015)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3016)
into order_lines values (order_id_seq.currval, 3017)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3018)
into order_lines values (order_id_seq.currval, 3019)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3020)
into order_lines values (order_id_seq.currval, 3021)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3022)
into order_lines values (order_id_seq.currval, 3023)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3024)
into order_lines values (order_id_seq.currval, 3025)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3026)
into order_lines values (order_id_seq.currval, 3027)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3028)
into order_lines values (order_id_seq.currval, 3029)
select 1 from dual;

--^10 w/ 3 products
insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3001)
into order_lines values (order_id_seq.currval, 3002)
into order_lines values (order_id_seq.currval, 3003)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3004)
into order_lines values (order_id_seq.currval, 3005)
into order_lines values (order_id_seq.currval, 3006)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3007)
into order_lines values (order_id_seq.currval, 3008)
into order_lines values (order_id_seq.currval, 3009)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3010)
into order_lines values (order_id_seq.currval, 3012)
into order_lines values (order_id_seq.currval, 3013)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3014)
into order_lines values (order_id_seq.currval, 3015)
into order_lines values (order_id_seq.currval, 3016)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3017)
into order_lines values (order_id_seq.currval, 3018)
into order_lines values (order_id_seq.currval, 3019)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3020)
into order_lines values (order_id_seq.currval, 3022)
into order_lines values (order_id_seq.currval, 3023)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3024)
into order_lines values (order_id_seq.currval, 3025)
into order_lines values (order_id_seq.currval, 3026)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3027)
into order_lines values (order_id_seq.currval, 3028)
into order_lines values (order_id_seq.currval, 3029)
select 1 from dual;

insert all
into orders values (order_id_seq.nextval, default, 10.00)
into order_lines values (order_id_seq.currval, 3001)
into order_lines values (order_id_seq.currval, 3002)
into order_lines values (order_id_seq.currval, 3003)
select 1 from dual;

--5 warehouses
insert all 
into warehouses values(1, 'Deltona, FL')
into warehouses values(2, 'South Plainfield, NJ')
into warehouses values(3, 'Brockton, MA')
into warehouses values(4, 'Bay Shore, NY')
into warehouses values(5, 'Hackensack, NJ')
select 1 from dual;
--60 rows for product inventory

insert all 
into product_inventory values (1, 3000, 5)
into product_inventory values (1, 3001, 6)
into product_inventory values (1, 3002, 0)
into product_inventory values (1, 3003, 7)
into product_inventory values (1, 3004, 8)
into product_inventory values (1, 3005, 2)
into product_inventory values (1, 3006, 3)
into product_inventory values (1, 3007, 4)
into product_inventory values (1, 3008, 5)
into product_inventory values (1, 3009, 10)
into product_inventory values (1, 3010, 5)
into product_inventory values (1, 3011, 14)
into product_inventory values (1, 3012, 7)
into product_inventory values (1, 3013, 12)
into product_inventory values (1, 3014, 4)
into product_inventory values (2, 3001, 6)
into product_inventory values (2, 3002, 1)
into product_inventory values (2, 3003, 4)
into product_inventory values (2, 3004, 5)
into product_inventory values (2, 3006, 8)
into product_inventory values (2, 3007, 4)
into product_inventory values (2, 3008, 5)
into product_inventory values (2, 3009, 12)
into product_inventory values (2, 3010, 7)
into product_inventory values (2, 3011, 2)
into product_inventory values (2, 3012, 6)
into product_inventory values (2, 3013, 14)
into product_inventory values (3, 3015, 4)
into product_inventory values (3, 3016, 7)
into product_inventory values (3, 3017, 8)
into product_inventory values (3, 3018, 3)
into product_inventory values (3, 3019, 9)
into product_inventory values (3, 3020, 10)
into product_inventory values (3, 3021, 7)
select 1 from dual;

insert all
into product_inventory values (3, 3022, 4)
into product_inventory values (3, 3023, 1)
into product_inventory values (3, 3024, 0)
into product_inventory values (3, 3025, 6)
into product_inventory values (3, 3026, 8)
into product_inventory values (4, 3027, 4)
into product_inventory values (4, 3028, 5)
into product_inventory values (4, 3029, 1)
into product_inventory values (4, 3001, 2)
into product_inventory values (4, 3002, 3)
into product_inventory values (4, 3004, 4)
into product_inventory values (4, 3005, 1)
into product_inventory values (4, 3006, 8)
into product_inventory values (4, 3007, 5)
into product_inventory values (4, 3008, 6)
into product_inventory values (4, 3009, 4)
into product_inventory values (4, 3010, 5)
into product_inventory values (5, 3011, 1)
into product_inventory values (5, 3012, 5)
into product_inventory values (5, 3013, 0)
into product_inventory values (5, 3014, 6)
into product_inventory values (5, 3015, 8)
into product_inventory values (5, 3016, 9)
into product_inventory values (5, 3017, 7)
into product_inventory values (5, 3018, 5)
into product_inventory values (5, 3019, 4)
into product_inventory values (5, 3020, 3)
into product_inventory values (5, 3021, 2)
into product_inventory values (5, 3022, 1)
into product_inventory values (5, 3023, 0)
into product_inventory values (5, 3024, 7)
into product_inventory values (5, 3025, 8)
select 1 from dual;

--20 rows in other tables
insert into order_customers values (2029, 1011);
insert into order_customers values (2030, 1012);
insert into order_customers values (2031, 1013);
insert into order_customers values (2032, 1014);
insert into order_customers values (2033, 1015);
insert into order_customers values (2034, 1016);
insert into order_customers values (2035, 1017);
insert into order_customers values (2036, 1000);
insert into order_customers values (2037, 1001);
insert into order_customers values (2038, 1002);
insert into order_customers values (2039, 1004);
insert into order_customers values (2040, 1004);
insert into order_customers values (2041, 1005);
insert into order_customers values (2042, 1006);
insert into order_customers values (2044, 1007);
insert into order_customers values (2045, 1008);
insert into order_customers values (2046, 1009);
insert into order_customers values (2047, 1010);
insert into order_customers values (2048, 1011);
insert into order_customers values (2049, 1012);
insert into warehouses values (6, 'Sarnia, ON');
--10 rows in intersection tables

insert into order_customers values (2018, 1000);
insert into order_customers values (2019, 1001);
insert into order_customers values (2020, 1002);
insert into order_customers values (2021, 1003);
insert into order_customers values (2022, 1004);
insert into order_customers values (2023, 1005);
insert into order_customers values (2024, 1006);
insert into order_customers values (2025, 1007);
insert into order_customers values (2026, 1008);
insert into order_customers values (2027, 1009);
insert into order_customers values (2028, 1010);


---- Constraint Test: Data Types
--Constraint test 1
--Confirm data type: integer in associates table
--valid test
---- expected result: insert adds row to associates table
---- action
insert into associates values (5100, 'Joe', 'Seph', 51000, 'A', 'F');
---- test results
---- 1 row inserted

---- Invalid test 
---- expected results: insert fails with ORA-00001: unique constraint (WKSP_LC7377F23.ASSOCIATE_ID_PK) violated
---- action
insert into associates values ('5101', 'Joe', 'Seph', 51000, 'A', 'F');
---- Test results
---- 

--Constraint test 2
--Confirm data type: varchar in associates table
--valid test
---- expected result: insert adds row to associates table
---- action
insert into associates values (5200, 'Slim', 'Jim', 51000, 'A', 'F');
---- test results
---- 1 row inserted

---- Invalid test 
---- expected results: insert fails with Error at line 1/38: ORA-00984: column not allowed here
---- action
insert into associates values (5202, wrong , 'Seph', 51000, 'A', 'F');
---- Test results
---- Error at line 1/38: ORA-00984: column not allowed here

--Constraint test 3
--Confirm data type: decimal in associates table
--valid test
---- expected result: insert adds row to associates table
---- action
insert into associates values (5300, 'Slick' , 'Rick', 51000, 'A', 'F');
---- test results
---- 1 row inserted

---- Invalid test 
---- expected results: insert fails with ORA-01438: value larger than specified precision 
---- action
insert into associates values (5303, 'Slick' , 'Rick', 5100000, 'A', 'F');
---- Test results
---- ORA-01438: value larger than specified precision 

--Constraint test 4
--Confirm data type: boolean in associates table
--valid test
---- expected result: insert adds row to associates table
---- action
insert into associates values (5400, 'Bobby' , 'Brown', 51000, 'A', 'F');
---- test results
---- 1 row inserted

---- Invalid test 
---- expected results: insert fails with ORA-02290: check constraint (WKSP_LC7377F23.ACTIVE_STATUS_CK) violated
---- action
insert into associates values (5400, 'Bobby' , 'Brown', 51000, 'A', 'A');
---- Test results
---- ORA-02290: check constraint (WKSP_LC7377F23.ACTIVE_STATUS_CK) violated

--Constraint test 5
--Confirm data type: date in orders table
--valid test
---- expected result: insert adds row to orders table
---- action
insert into orders values (order_id_seq.nextval, '2023-10-02', 10.00);
---- test results
---- 1 row inserted

---- Invalid test 
---- expected results: insert fails with Error at line 1/57: ORA-00932: inconsistent datatypes: expected DATE got NUMBER
---- action
insert into orders values (order_id_seq.nextval, 2023-10-02, 10.00);
---- Test results
---- Error at line 1/57: ORA-00932: inconsistent datatypes: expected DATE got NUMBER

---- Constraint Test: Primary, Unique, Foreign keys

---- Primary Key Test

--Constraint test: PK 1
--Confirm primary key in associates table
--valid test
---- expected result: insert adds row to associates table
---- action
insert into associates values (5500, 'Jimmy' , 'Johns', 51000, 'A', 'F');

---- test results
---- 1 row inserted

---- Invalid test 
---- expected results: insert fails with ORA-00001: unique constraint (WKSP_LC7377F23.ASSOCIATE_ID_PK) violated
---- action
insert into associates values (5500, 'Johnny' , 'Johns', 51000, 'A', 'F');
---- Test results
---- ORA-00001: unique constraint (WKSP_LC7377F23.ASSOCIATE_ID_PK) violated

--Constraint test: PK 2
--Confirm primary key in orders table
--valid test
---- expected result: insert adds row to orders table
---- action
insert into orders values (order_id_seq.nextval, default, 10.00);
---- test results
---- 1 row inserted
---- find the value of order id that was inserted
select * from orders;
---- Invalid test 
---- expected results: insert fails with ORA-00001: unique constraint (WKSP_LC7377F23.ORDER_ID_PK) violated
---- action
insert into orders values (2042, default, 10.00);
---- Test results
---- ORA-00001: unique constraint (WKSP_LC7377F23.ORDER_ID_PK) violated

---- Unique Key Test

--Constraint test UK 1
--Confirm primary key in products table
--valid test
---- expected result: insert adds row to products table
---- action
select * from products;
insert into products values (3050, 50, 'fifty', 10.00, 10.00, 5.00, 10.00);
---- test results
---- 1 row inserted

---- Invalid test 
---- expected results: insert fails with ORA-00001: unique constraint (WKSP_LC7377F23.SERIAL_NUMBER_UK) violated
---- action
insert into products values (3051, 50, 'fifty', 10.00, 10.00, 5.00, 10.00);
---- Test results
---- ORA-00001: unique constraint (WKSP_LC7377F23.SERIAL_NUMBER_UK) violated

---- Foreign Key Test

--Constraint test FK 1
--Confirm primary key in customers table
--valid test
---- expected result: insert adds row to customers table
---- action
select * from customers;
insert into customers values (default, 'Cole', 'Sprouse', 5000, 'Applebees');
---- test results
---- 1 row inserted

---- Invalid test 
---- expected results: insert fails with ORA-02291: integrity constraint (WKSP_LC7377F23.ASSOCIATE_ID_FK) violated - parent key not found
---- action
insert into customers values (default, 'Mole', 'Mouse', 5700, 'Pearbees');
---- Test results
---- ORA-02291: integrity constraint (WKSP_LC7377F23.ASSOCIATE_ID_FK) violated - parent key not found

--Constraint test FK 2
--Confirm foreign key in product_associates table
--valid test
---- expected result: insert adds row to product_associates  table
---- action
select * from product_inventory;
insert into product_inventory values (1, 3022, 10);
---- test results
---- 1 row inserted

---- Invalid test 
---- expected results: insert fails with ORA-02291: integrity constraint (WKSP_LC7377F23.MODEL_INVENTORY_ID_FK) violated - parent key not found
---- action
insert into product_inventory values (1, 3722, 10);
---- Test results
---- ORA-02291: integrity constraint (WKSP_LC7377F23.MODEL_INVENTORY_ID_FK) violated - parent key not found

-------------------------------------------------------------------------
----Foreign Key on update currently not working
--Constraint test FK on update
--Confirm primary key in associates table
--valid test
---- expected result: insert adds row to associates table
---- action
insert into  values ()
---- test results
---- 1 row inserted

---- Invalid test 
---- expected results: insert fails with (error)
---- action
insert into  values
---- Test results
---- (error)
----------------------------------------------------------------

--Constraint test FK on delete
--Confirm Forign key on delete in customers table
--valid test
---- expected result: deletes row(associate_id) in customers table and associates table
---- action
delete
from associates
where associate_id = 5000
select * from customers
where associate_id = 5000;
---- test results
---- associate_id = 5000 row deleted in both tables

---- Invalid test 
---- expected results: delete fails with Error at line 3/22: ORA-00904: "WRONG": invalid identifier
---- action
delete
from associates
where associate_id = wrong
---- Test results
---- Error at line 3/22: ORA-00904: "WRONG": invalid identifier


---- Check Constraint Test
---- Check Constraint: 1

alter table associates
add constraint associates_salary_ck
check ((salary < 125000) and (salary between 50000 and 100000));

--Confirm range of salary in associates table
--valid test
---- expected result: insert adds row to associates table
---- action
insert into associates values (5800, 'Test Busta', 'Rhymes', 97000, 'A', 'T');
---- test results
---- 1 row inserted

---- Invalid test 
---- expected results: insert fails with ORA-01438: value larger than specified precision allowed for this column
---- action
insert into associates values (5800, 'Test Busta', 'Rhymes', 125001, 'A', 'T');

---- Test results
---- ORA-01438: value larger than specified precision allowed for this column

---- Check Constraint: 2

alter table associates
add constraint job_code_ck
check (job_code in ('A','B','C','D'));

--Confirm list of characters of job_code in associates table
--valid test
---- expected result: insert adds row to associates table
---- action
insert into associates values (5801, 'Test 2 Busta', 'Rhymes', 97000, 'A', 'T');
---- test results
---- 1 row inserted

---- Invalid test 
---- expected results: insert fails with ORA-02290: check constraint (WKSP_LC7377F23.JOB_CODE_CK) violated
---- action
insert into associates values (5801, 'Test 2 Busta', 'Rhymes', 97000, 'E', 'T');
---- Test results
---- ORA-02290: check constraint (WKSP_LC7377F23.JOB_CODE_CK) violated

---- Check Constraint: 3

alter table warehouses
add constraint warehouse_id_ck
check (warehouse_id between 1 and 1000);

--Confirm range of warehouse_id in warehouses table
--valid test
---- expected result: insert adds row to associates table
---- action
insert into warehouses values(100, 'test Deltona, FL');
---- test results
---- 1 row inserted

---- Invalid test 
---- expected results: insert fails with ORA-02290: check constraint (WKSP_LC7377F23.WAREHOUSE_ID_CK) violated
---- action
insert into warehouses values(1001, 'test Deltona, FL');
---- Test results
---- ORA-02290: check constraint (WKSP_LC7377F23.WAREHOUSE_ID_CK) violated

---- Check Constraint Boolean Test

--check constraint that simulates boolean data type
alter table associates
add constraint active_status_ck
check (active_status in ('T','F'));

--Confirm active status bool value in associates table
--valid test
---- expected result: insert adds row to associates table
---- action
insert into associates values (5802, 'Test bool Busta', 'Rhymes', 97000, 'A', 'T');
---- test results
---- 1 row inserted

---- Invalid test 
---- expected results: insert fails with ORA-02290: check constraint (WKSP_LC7377F23.ACTIVE_STATUS_CK) violated
---- action
insert into associates values (5802, 'Test bool Busta', 'Rhymes', 97000, 'A', 'L');
---- Test results
---- ORA-02290: check constraint (WKSP_LC7377F23.ACTIVE_STATUS_CK) violated