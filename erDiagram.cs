erDiagram
    payment_type {
        int payment_type_id PK
        string payment_type_code UK
        string payment_type_name
    }
    customer {
        int customer_id PK
        string customer_code UK
        string customer_name
        string address
        timestamp create_date
    }
    product {
        int product_id PK
        string product_code UK
        string product_name
        decimal price
        decimal last_purchase_price
    }
    location {
        int location_id PK
        string location_code UK
        string location_name
        string city
    }
    sales_transaction {
        int sales_transaction_id PK
        int location_id FK
        timestamp transaction_date
        int customer_id FK
        int payment_type_id FK
        int product_id FK
        decimal qty
        decimal sub_total
        decimal discount
        decimal tax
    }

    payment_type ||--o{ sales_transaction : "1..*"
    product ||--o{ sales_transaction : "1..*"
    customer ||--o{ sales_transaction : "1..*"
    location ||--o{ sales_transaction : "1..*"