--- DDL Source (Denormalization / OLTP)
--- PostgreSQL

create database pos_system;

create table payment_type (
    payment_type_id int not null primary key,
    payment_type_code varchar(10),
    payment_type_name varchar(30)
);

create table customer (
    customer_id int not null primary key,
    customer_code varchar(10) unique,
    customer_name varchar(100),
    address text,
    create_date timestamp
);

create table product (
    product_id int not null primary key,
    product_code varchar(10) unique,
    product_name varchar(100),
    price numeric(20,4),
    last_purchase_price numeric(20,4)
);

create table location (
    location_id int not null primary key,
    location_code varchar(10) unique,
    location_name varchar(100),
    city varchar(50)
);

create table sales_transaction (
    sales_transaction_id int not null primary key,
    location_id int,
    transaction_date timestamp,
    customer_id int,
    payment_type_id int,
    product_id int,
    qty numeric(10,2),
    sub_total numeric(20,4),
    discount numeric(5,2),
    tax numeric(5,2),
    foreign key (payment_type_id) references payment_type (payment_type_id),
    foreign key (customer_id) references customer (customer_id),
    foreign key (product_id) references product (product_id),
    foreign key (location_id) references location (location_id)
);


--- Insert Records into table 
insert into payment_type
select id, 
    concat('PT-0',id::text), 
    concat('Type ',id::text)
from generate_series(1, 100) as id;

insert into customer
select id, 
    concat('Code-0',id::text), 
    concat('Customer ',id::text), 
    concat('Address ',id::text), 
    date_trunc('minutes', now() - (random() * interval '180 days'))
from generate_series(1, 100) as id;

insert into product
select id, 
    concat('PC-0',id::text), 
    concat('Product ',id::text), 
    random() * (1000 - 10) + 10::numeric, 
    random() * (1000 - 10) + 10::numeric
from generate_series(1, 100) as id;

insert into location
select id, 
    concat('L-0',id::text), 
    concat('Location ',id::text), 
    concat('City ',id::text)
from generate_series(1, 100) as id;

insert into sales_transaction
select id,
    id, 
    date_trunc('minutes', now() - (random() * interval '180 days')), 
    id, 
    id, 
    id, 
    (random() * 100 + 1)::int,  
    random() * (1000 - 10) + 10::numeric, 
    random() * 50, random() * 10
from generate_series(1, 100) as id;