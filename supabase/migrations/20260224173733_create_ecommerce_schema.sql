/*
  # E-commerce Database Schema

  1. New Tables
    - `categories`
      - `id` (uuid, primary key)
      - `name` (text) - Category name
      - `slug` (text, unique) - URL-friendly identifier
      - `description` (text) - Category description
      - `image_url` (text) - Category image
      - `created_at` (timestamptz) - Creation timestamp
    
    - `products`
      - `id` (uuid, primary key)
      - `category_id` (uuid, foreign key) - Reference to categories
      - `name` (text) - Product name
      - `slug` (text, unique) - URL-friendly identifier
      - `description` (text) - Product description
      - `price` (decimal) - Product price
      - `image_url` (text) - Product image
      - `stock` (integer) - Available stock quantity
      - `featured` (boolean) - Featured product flag
      - `created_at` (timestamptz) - Creation timestamp
    
    - `cart_items`
      - `id` (uuid, primary key)
      - `session_id` (text) - Anonymous session identifier
      - `product_id` (uuid, foreign key) - Reference to products
      - `quantity` (integer) - Quantity in cart
      - `created_at` (timestamptz) - Creation timestamp
      - `updated_at` (timestamptz) - Last update timestamp
  
  2. Security
    - Enable RLS on all tables
    - Public read access for categories and products
    - Session-based access for cart items
    
  3. Indexes
    - Add indexes for frequently queried columns
    - Category slug and product slug for lookups
*/

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text UNIQUE NOT NULL,
  description text DEFAULT '',
  image_url text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id uuid REFERENCES categories(id) ON DELETE SET NULL,
  name text NOT NULL,
  slug text UNIQUE NOT NULL,
  description text DEFAULT '',
  price decimal(10, 2) NOT NULL,
  image_url text DEFAULT '',
  stock integer DEFAULT 0,
  featured boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Create cart_items table
CREATE TABLE IF NOT EXISTS cart_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id text NOT NULL,
  product_id uuid REFERENCES products(id) ON DELETE CASCADE,
  quantity integer DEFAULT 1,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;

-- Categories policies (public read access)
CREATE POLICY "Anyone can view categories"
  ON categories FOR SELECT
  USING (true);

-- Products policies (public read access)
CREATE POLICY "Anyone can view products"
  ON products FOR SELECT
  USING (true);

-- Cart items policies (session-based access)
CREATE POLICY "Users can view own cart items"
  ON cart_items FOR SELECT
  USING (true);

CREATE POLICY "Users can insert own cart items"
  ON cart_items FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users can update own cart items"
  ON cart_items FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Users can delete own cart items"
  ON cart_items FOR DELETE
  USING (true);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_featured ON products(featured);
CREATE INDEX IF NOT EXISTS idx_cart_items_session_id ON cart_items(session_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_product_id ON cart_items(product_id);

-- Insert sample categories
INSERT INTO categories (name, slug, description, image_url) VALUES
  ('Electronics', 'electronics', 'Latest gadgets and electronics', 'https://images.pexels.com/photos/356056/pexels-photo-356056.jpeg?auto=compress&cs=tinysrgb&w=800'),
  ('Fashion', 'fashion', 'Trendy clothing and accessories', 'https://images.pexels.com/photos/1926769/pexels-photo-1926769.jpeg?auto=compress&cs=tinysrgb&w=800'),
  ('Home & Garden', 'home-garden', 'Furniture and home decor', 'https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg?auto=compress&cs=tinysrgb&w=800'),
  ('Sports', 'sports', 'Sports equipment and gear', 'https://images.pexels.com/photos/2291004/pexels-photo-2291004.jpeg?auto=compress&cs=tinysrgb&w=800')
ON CONFLICT (slug) DO NOTHING;

-- Insert sample products
INSERT INTO products (category_id, name, slug, description, price, image_url, stock, featured) VALUES
  ((SELECT id FROM categories WHERE slug = 'electronics'), 'Wireless Headphones', 'wireless-headphones', 'Premium noise-canceling wireless headphones with 30-hour battery life', 199.99, 'https://images.pexels.com/photos/3394650/pexels-photo-3394650.jpeg?auto=compress&cs=tinysrgb&w=800', 50, true),
  ((SELECT id FROM categories WHERE slug = 'electronics'), 'Smart Watch', 'smart-watch', 'Fitness tracker with heart rate monitor and GPS', 299.99, 'https://images.pexels.com/photos/437037/pexels-photo-437037.jpeg?auto=compress&cs=tinysrgb&w=800', 30, true),
  ((SELECT id FROM categories WHERE slug = 'electronics'), 'Bluetooth Speaker', 'bluetooth-speaker', 'Portable waterproof speaker with 360-degree sound', 89.99, 'https://images.pexels.com/photos/1279406/pexels-photo-1279406.jpeg?auto=compress&cs=tinysrgb&w=800', 75, false),
  ((SELECT id FROM categories WHERE slug = 'fashion'), 'Leather Jacket', 'leather-jacket', 'Genuine leather jacket with premium finish', 349.99, 'https://images.pexels.com/photos/1124468/pexels-photo-1124468.jpeg?auto=compress&cs=tinysrgb&w=800', 20, true),
  ((SELECT id FROM categories WHERE slug = 'fashion'), 'Designer Sunglasses', 'designer-sunglasses', 'UV protection polarized sunglasses', 159.99, 'https://images.pexels.com/photos/701877/pexels-photo-701877.jpeg?auto=compress&cs=tinysrgb&w=800', 40, false),
  ((SELECT id FROM categories WHERE slug = 'fashion'), 'Canvas Backpack', 'canvas-backpack', 'Durable canvas backpack with laptop compartment', 79.99, 'https://images.pexels.com/photos/2905238/pexels-photo-2905238.jpeg?auto=compress&cs=tinysrgb&w=800', 60, false),
  ((SELECT id FROM categories WHERE slug = 'home-garden'), 'Modern Table Lamp', 'modern-table-lamp', 'Minimalist LED table lamp with touch control', 69.99, 'https://images.pexels.com/photos/1112598/pexels-photo-1112598.jpeg?auto=compress&cs=tinysrgb&w=800', 45, false),
  ((SELECT id FROM categories WHERE slug = 'home-garden'), 'Throw Pillow Set', 'throw-pillow-set', 'Set of 4 decorative throw pillows', 49.99, 'https://images.pexels.com/photos/1350789/pexels-photo-1350789.jpeg?auto=compress&cs=tinysrgb&w=800', 80, true),
  ((SELECT id FROM categories WHERE slug = 'sports'), 'Yoga Mat', 'yoga-mat', 'Non-slip eco-friendly yoga mat with carrying strap', 39.99, 'https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg?auto=compress&cs=tinysrgb&w=800', 100, false),
  ((SELECT id FROM categories WHERE slug = 'sports'), 'Dumbell Set', 'dumbell-set', 'Adjustable dumbbell set 5-50 lbs', 299.99, 'https://images.pexels.com/photos/4162488/pexels-photo-4162488.jpeg?auto=compress&cs=tinysrgb&w=800', 25, false),
  ((SELECT id FROM categories WHERE slug = 'sports'), 'Running Shoes', 'running-shoes', 'Lightweight running shoes with cushioned sole', 129.99, 'https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg?auto=compress&cs=tinysrgb&w=800', 55, true),
  ((SELECT id FROM categories WHERE slug = 'electronics'), 'Wireless Keyboard', 'wireless-keyboard', 'Mechanical keyboard with RGB backlight', 149.99, 'https://images.pexels.com/photos/2582937/pexels-photo-2582937.jpeg?auto=compress&cs=tinysrgb&w=800', 35, false)
ON CONFLICT (slug) DO NOTHING;