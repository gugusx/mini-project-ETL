#!python config

#--- Setup connection to Source
oltp_conn_string = {
    'user': 'gugus',
    'password': 'gugus12345',
    'host': 'localhost',
    'port': '5432',
    'database': 'pos_system'
}

#--- Setup connection to Destination
warehouse_conn_string = {
    'user': 'gugus',
    'password': 'gugus12345',
    'host': 'localhost',
    'port': '5432',
    'database': 'data_warehouse'
}

#--- Mapping from Source to Destination
etl_config = {
    "payment": {
        "source_table": "payment_type",
        "destination_table": "dim_payment_type",
        "column_mapping": {
            "payment_type_id": "payment_type_id",
            "payment_type_code": "payment_type_code",
            "payment_type_name": "payment_type_name"
        },
        "query": "SELECT * FROM payment_type"
    },
    "customer": {
        "source_table": "customer",
        "destination_table": "dim_customer",
        "column_mapping": {
            "customer_id": "customer_id",
            "customer_code": "customer_code",
            "customer_name": "customer_name",
            "address": "address",
            "create_date": "create_date"
        },
        "query": "SELECT * FROM customer"
    },
    "product": {
        "source_table": "product",
        "destination_table": "dim_product",
        "column_mapping": {
            "product_id": "product_id",
            "product_code": "product_code",
            "product_name": "product_name",
            "price": "price",
            "last_purchase_price": "last_purchase_price"
        },
        "query": "SELECT * FROM product"
    },
    "location": {
        "source_table": "location",
        "destination_table": "dim_location",
        "column_mapping": {
            "location_id": "location_id",
            "location_code": "location_code",
            "location_name": "location_name",
            "city": "city"
        },
        "query": "SELECT * FROM location"
    },
    "sales": {
        "source_table": ["sales_transaction", "payment_type", "customer", "product", "location"],
        "destination_table": "fact_sales_transaction",
        "column_mapping": {
            "sales_transaction_id": "sales_transaction_id",
            "location_id": "location_id",
            "month": "month",
            "year": "year",
            "customer_id": "customer_id",
            "payment_type_id": "payment_type_id",
            "product_id": "product_id",
            "qty": "qty",
            "sub_total": "sub_total",
            "discount": "discount",
            "tax": "tax"
        },
        "query": """
            SELECT 
                s.sales_transaction_id,
                l.location_id,
                extract(month from s.transaction_date) as month,
                extract(year from s.transaction_date) as year,
                c.customer_id,
                pt.payment_type_id,
                p.product_id,
                sum(s.qty) qty,
                sum(s.sub_total) sub_total,
                s.discount,
                s.tax
            FROM sales_transaction s
            INNER JOIN location l ON s.location_id = l.location_id
            INNER JOIN payment_type pt ON s.payment_type_id = pt.payment_type_id
            INNER JOIN customer c ON s.customer_id = c.customer_id
            INNER JOIN product p ON s.product_id = p.product_id
            GROUP BY 1,2,3,4,5,6,7,10,11
        """
    }
}
