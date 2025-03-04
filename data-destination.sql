--- DDL Destinaton (Star Schema)
--- PostgreSQL

create database data_warehouse;

create table dim_payment_type (
    payment_type_id int not null primary key,
    payment_type_code varchar(10),
    payment_type_name varchar(30)
);

create table dim_customer (
    customer_id int not null primary key,
    customer_code varchar(10) unique,
    customer_name varchar(100),
    address text,
    create_date timestamp
);

create table dim_product (
    product_id int not null primary key,
    product_code varchar(10) unique,
    product_name varchar(100),
    price numeric(20,4),
    last_purchase_price numeric(20,4)
);

create table dim_location (
    location_id int not null primary key,
    location_code varchar(10) unique,
    location_name varchar(100),
    city varchar(50)
);

create table fact_sales_transaction (
    sales_transaction_id int not null primary key,
    location_id int,
    month int,
    year int,
    customer_id int,
    payment_type_id int,
    product_id int,
    qty numeric(10,2),
    sub_total numeric(20,4),
    discount numeric(5,2),
    tax numeric(5,2),
    foreign key (payment_type_id) references dim_payment_type (payment_type_id),
    foreign key (customer_id) references dim_customer (customer_id),
    foreign key (product_id) references dim_product (product_id),
    foreign key (location_id) references dim_location (location_id)
);