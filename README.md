# 🗄️ Dual-Database Project (MySQL + PostgreSQL)

This project demonstrates a compact **dual-database environment** using **Docker Compose**, combining two major database systems:
- **MySQL 8.0** – Classic relational database
- **PostgreSQL 16** – Advanced relational database with JSONB support

---

## 🚀 Overview

The project simulates a **simple e-commerce system** that manages:
- Customers
- Products
- Orders & Order Items

Both databases implement the same business logic with differences in storage and advanced features:
- MySQL → Relational schema with foreign keys and constraints
- PostgreSQL → UUID primary keys, JSONB columns, and GIN indexing for JSONB

---

## 🧩 Project Structure

```
db-multi-no-mongo/
│
├── docker-compose.yml
│
├── mysql/
│   ├── init.sql
│   └── my.cnf
│
└── postgres/
    ├── init.sql
    └── postgresql.conf
```

---

## ⚙️ How to Run

### 1️⃣ Start the environment
```bash
docker-compose up -d
```

### 2️⃣ Connect to each database

#### MySQL
```bash
docker exec -it mysql_lab mysql -ushopuser -pshoppass shop
```

#### PostgreSQL
```bash
docker exec -it postgres_lab psql -U appuser -d appdb
```

---

## 💾 Database Details

### 🐬 MySQL
- File: `mysql/init.sql`
- Features:
  - Tables with **foreign keys**, **indexes**, and **transactions**
  - `customers`, `products`, `orders`, `order_items`
  - Sample CRUD operations and joins

Example query:
```sql
SELECT o.id AS order_id, c.name, p.name AS product, oi.quantity, o.total
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON p.id = oi.product_id
JOIN customers c ON c.id = o.customer_id;
```

---

### 🐘 PostgreSQL
- File: `postgres/init.sql`
- Features:
  - **UUID primary keys**
  - **JSONB columns** for flexible product attributes
  - **GIN index** for JSONB search
  - Full relational design with referential integrity

Example query:
```sql
SELECT c.name, p.name AS product, p.attributes->>'color' AS color, o.total
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON p.id = oi.product_id
JOIN customers c ON c.id = o.customer_id;
```

---

## 🧠 Skills Demonstrated

✅ SQL Schema Design & Normalization
✅ Data Modeling in Relational Systems
✅ Joins, Foreign Keys, and Transactions
✅ JSONB and Index Optimization (PostgreSQL)
✅ Docker Compose Multi-Service Deployment

---

## 🔐 Production Checklist (Summary)

| Category | Recommendation |
|-----------|----------------|
| **Security** | Use strong passwords and SSL connections. Never expose DB ports publicly. |
| **Backups** | Automate `mysqldump` and `pg_dump` regularly. |
| **Monitoring** | Use Prometheus + Grafana for performance metrics. |
| **Indexes** | Use `EXPLAIN` / `EXPLAIN ANALYZE` to check query plans. |
| **Replication & Scaling** | MySQL Replication, PostgreSQL Streaming Replication. |
| **Testing** | Regularly test backup restoration in a staging environment. |

---

## 📄 License
MIT License – free to use, modify, and learn from.

---

## 👤 Author
**Your Name**
Database Engineer | SQL Developer
📧 youremail@example.com
🌐 [github.com/yourusername](https://github.com/yourusername)
