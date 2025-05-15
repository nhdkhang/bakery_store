CREATE DATABASE HomemadeBakery;
USE HomemadeBakery;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(300) NOT NULL UNIQUE,
    password VARCHAR(300) NOT NULL,
    role ENUM('admin', 'customer') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    phone_number VARCHAR(10) NOT NULL,
    address TEXT,
    fullname VARCHAR(300) NOT NULL,
    user_id INT,
    membership_status ENUM('inactive', 'active') DEFAULT 'inactive',
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Admins (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    category_id INT,
    price DECIMAL(10,0) NOT NULL,
    image_url VARCHAR(255),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE SET NULL
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    total_price DECIMAL(10,0) NOT NULL,
    status ENUM('processing', 'accepted','delivering', 'completed', 'cancelled') DEFAULT 'processing',
    reason_id INT,
    promotion_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reason_id) REFERENCES CancellationReasons(reason_id) ON DELETE SET NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (promotion_id) REFERENCES Promotions(promotion_id) ON DELETE SET NULL
);

CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    subtotal DECIMAL(10,0) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
);

CREATE TABLE Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

CREATE TABLE Promotions (
    promotion_id INT AUTO_INCREMENT PRIMARY KEY,
    promotion_code VARCHAR(20) NOT NULL UNIQUE,
    promotion_name VARCHAR(100) NOT NULL,
    description TEXT,
    discount_percentage DECIMAL(5,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    max_uses INT DEFAULT 0,
    current_uses INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_discount CHECK (discount_percentage > 0 AND discount_percentage < 100),
    CONSTRAINT check_dates CHECK (start_date <= end_date)
);

CREATE TABLE Delivery (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    delivery_address TEXT NOT NULL,
    delivery_date DATE,
    delivery_status ENUM('processing', 'accepted', 'delivered') DEFAULT 'processing',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

CREATE TABLE Wishlists (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
);

CREATE TABLE Cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cart_status ENUM ('pending','accepted') DEFAULT 'pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);
CREATE TABLE Cart_Items (
	cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id int,
    product_id int NOT NULL,
    quantity int NOT NULL,
    FOREIGN KEY (cart_id) REFERENCES Cart (cart_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products (product_id) ON DELETE CASCADE
);
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method ENUM('cash', 'deposit') NOT NULL,
    payment_status ENUM('pending', 'paid') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_proof VARCHAR(255),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

CREATE TABLE Membership_Tiers (
    tier_id INT AUTO_INCREMENT PRIMARY KEY,
    tier_name VARCHAR(50) NOT NULL, 
    description TEXT,
    spending_requirement DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE MembershipTracking (
    membership_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    tier_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    is_active BOOLEAN DEFAULT FALSE,
    total_spent DECIMAL(10,0) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (tier_id) REFERENCES Membership_Tiers(tier_id) ON DELETE CASCADE
);

CREATE TABLE CancellationReasons (
    reason_id INT AUTO_INCREMENT PRIMARY KEY,
    reason_text TEXT NOT NULL
);

USE HomemadeBakery;
INSERT INTO Users (email, password, fullname, role)
VALUES ('homemade.bakery04301975@gmail.com', 'scrypt:32768:8:1$uNl1sryGWQGh8r4Z$22ef97048cd8e1f7cb8034021f2f06550fb4c70c7862b7c1c5f6f0a5f44963704bd7dd12c54cecacc8c86d1c3b6e786c94d911011f7f51b1636e7d0bc44cc589', 'Main Admin', 'admin');

SET @last_user_id = LAST_INSERT_ID();
INSERT INTO Admins (user_id)
VALUES (@last_user_id);

INSERT INTO Categories (category_name, description) VALUES
('Cold Treats', 'Best delicacies for cold-serves, recommended by the chef'),
('Cookies', 'Crunchy and delicious'),
('Tart', 'Crumbly shell with an exquisite center'),
('Cupcakes', 'Small but diversified in flavors'),
('Donuts', 'Crispy outside but soft inside - sweet and bubbly in colors'),
('Pies', 'Savoury fillings and a crunchy pastry layer'),
('Soufflés', 'Cloudy, hot and delicious');

INSERT INTO Products (product_name, category_id, price, image_url) VALUES
('Tiramisu', 1, 120000, 'images/tiramisu.jpg'),
('Strawberry Pound Cake', 1, 130000, 'images/strawberry_pound_cake.jpg'),
('Basque Burnt Cheesecake', 1, 150000, 'images/basque_burnt_cheesecake.jpg'),
('Passionfruit Mousse', 1, 140000, 'images/passionfruit_mousse.jpg'),
('Red Velvet Cake', 1, 160000, 'images/red_velvet_cake.jpg'),
('Chocolate Mousse Cake', 1, 135000, 'images/chocolate_mousse_cake.jpg'),

('Chocolate Cookie', 2, 25000, 'images/chocolate_cookie.jpg'),
('Butter Cookie', 2, 20000, 'images/butter_cookie.jpg'),
('Almond Cookie', 2, 30000, 'images/almond_cookie.jpg'),
('Coconut Cookie', 2, 22000, 'images/coconut_cookie.jpg'),
('Oatmeal Cookie', 2, 27000, 'images/oatmeal_cookie.jpg'),
('Ginger Cookie', 2, 25000, 'images/ginger_cookie.jpg'),

('Lemon Tart', 3, 70000, 'images/lemon_tart.jpg'),
('Apple Tart', 3, 75000, 'images/apple_tart.jpg'),
('Strawberry Tart', 3, 80000, 'images/strawberry_tart.jpg'),
('Chocolate Tart', 3, 90000, 'images/chocolate_tart.jpg'),
('Peach Tarte Tatin', 3, 95000, 'images/peach_tart.jpg'),
('Blueberry Tart', 3, 95000, 'images/blueberry_tart.jpg'),

('Vanilla Cupcake', 4, 40000, 'images/vanilla_cupcake.jpg'),
('Chocolate Cupcake', 4, 45000, 'images/chocolate_cupcake.jpg'),
('Strawberry Cupcake', 4, 50000, 'images/strawberry_cupcake.jpg'),
('Lemon Cupcake', 4, 48000, 'images/lemon_cupcake.jpg'),
('Cheese Cupcake', 4, 52000, 'images/cheese_cupcake.jpg'),
('Blueberry Cupcake', 4, 55000, 'images/blueberry_cupcake.jpg'),

('Chocolate Donut', 5, 35000, 'images/chocolate_donut.jpg'),
('Strawberry Donut', 5, 36000, 'images/strawberry_donut.jpg'),
('Cheese Donut', 5, 37000, 'images/cheese_donut.jpg'),
('Lemon Donut', 5, 38000, 'images/lemon_donut.jpg'),
('Blueberry Donut', 5, 39000, 'images/blueberry_donut.jpg'),
('Coconut Donut', 5, 40000, 'images/coconut_donut.jpg'),

('Apple Pie', 6, 135000, 'images/apple_pie.jpg'),
('Lemon Meringue Pie', 6, 136000, 'images/lemon_meringue_pie.jpg'),
('Pumpkin Pie', 6, 137000, 'images/pumpkin_pie.jpg'),
('Shepherd Pie', 6, 168000, 'images/shepherd_pie.jpg'),
('Key Lime Pie', 6, 129000, 'images/key_lime_pie.jpg'),
('Bavarian Cream Pie', 6, 140000, 'images/bavarian_cream_pie.jpg'),

('Chocolate Soufflé', 7, 50000, 'images/chocolate_souffle.jpg'),
('Strawberry Soufflé', 7, 55000, 'images/strawberry_souffle.jpg'),
('Cheese Soufflé', 7, 60000, 'images/cheese_souffle.jpg'),
('Lemon Soufflé', 7, 58000, 'images/lemon_souffle.jpg'),
('Blueberry Soufflé', 7, 62000, 'images/blueberry_souffle.jpg'),
('Coconut Soufflé', 7, 65000, 'images/coconut_souffle.jpg');

INSERT INTO Membership_Tiers (tier_name, description, spending_requirement, discount) VALUES
('Bronze', 'Tier 1', 1000000, 0.05),
('Silver', 'Tier 2', 2000000, 0.1),
('Gold', 'Tier 3', 5000000, 0.15),
('Platinum', 'Tier 4', 10000000, 0.2),
('Diamond', 'Tier 5', 20000000, 0.25),
('VIP', 'Tier 6', 5000000, 0.3);

