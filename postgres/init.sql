CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tables
CREATE TABLE customers (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE products (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  price NUMERIC(10,2) CHECK (price > 0),
  attributes JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE orders (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  customer_id UUID REFERENCES customers(id) ON DELETE CASCADE,
  order_date TIMESTAMP DEFAULT now(),
  total NUMERIC(10,2)
);

CREATE TABLE order_items (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id),
  quantity INT CHECK (quantity > 0)
);

-- Indexes
CREATE INDEX idx_product_price ON products(price);
CREATE INDEX idx_product_json_attr ON products USING GIN (attributes);

-- Sample data
INSERT INTO customers (name, email) VALUES
('Omar', 'omar@example.com'),
('Lina', 'lina@example.com');

INSERT INTO products (name, price, attributes) VALUES
('Notebook', 2.50, '{"color":"blue","pages":100}'),
('Pen', 1.20, '{"color":"black"}');

-- Example: create order and order_item
DO $$
DECLARE
  new_order UUID;
BEGIN
  INSERT INTO orders (customer_id, total) VALUES (
    (SELECT id FROM customers WHERE name='Omar'),
    3.70
  ) RETURNING id INTO new_order;

  INSERT INTO order_items (order_id, product_id, quantity)
  VALUES (new_order, (SELECT id FROM products WHERE name='Notebook'), 1);

END $$;

-- Example query
SELECT c.name, p.name AS product, p.attributes->>'color' AS color, o.total
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON p.id = oi.product_id
JOIN customers c ON c.id = o.customer_id;
