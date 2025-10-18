USE shop;

-- Create tables
CREATE TABLE customers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(150) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  price DECIMAL(10,2) CHECK (price > 0),
  stock INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  total DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES customers(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE order_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT CHECK (quantity > 0),
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id)
) ENGINE=InnoDB;

-- Indexes
CREATE INDEX idx_product_price ON products(price);
CREATE INDEX idx_customer_name ON customers(name);

-- Sample data
INSERT INTO customers (name, email) VALUES
('Ali', 'ali@example.com'),
('Sara', 'sara@example.com');

INSERT INTO products (name, price, stock) VALUES
('Notebook', 2.50, 100),
('Pen', 1.25, 200),
('Pencil', 0.75, 300);

-- Example transaction (purchase)
START TRANSACTION;
INSERT INTO orders (customer_id, total) VALUES (1, 3.75);
SET @order_id = LAST_INSERT_ID();
INSERT INTO order_items (order_id, product_id, quantity)
VALUES (@order_id, 1, 1), (@order_id, 2, 1);
COMMIT;

-- Simple query example
SELECT o.id AS order_id, c.name, p.name AS product, oi.quantity, o.total
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON p.id = oi.product_id
JOIN customers c ON c.id = o.customer_id;
