-- Users table
CREATE TABLE Users (
    userId SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Categories table
CREATE TABLE Categories (
    categoryId SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

-- Products table
CREATE TABLE Products (
    productId SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    categoryId INT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (categoryId) REFERENCES Categories(categoryId)
);

-- Orders table
CREATE TABLE Orders (
    orderId SERIAL PRIMARY KEY,
    userId INT NOT NULL,
    totalAmount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES Users(userId)
);

-- OrderItems table
CREATE TABLE OrderItems (
    orderItemId SERIAL PRIMARY KEY,
    orderId INT NOT NULL,
    productId INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (orderId) REFERENCES Orders(orderId) ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES Products(productId)
);

-- ShoppingCarts table
CREATE TABLE ShoppingCarts (
    cartId SERIAL PRIMARY KEY,
    userId INT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE
);

-- CartItems table
CREATE TABLE CartItems (
    cartItemId SERIAL PRIMARY KEY,
    cartId INT NOT NULL,
    productId INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (cartId) REFERENCES ShoppingCarts(cartId) ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES Products(productId)
);

-- Payments table
CREATE TABLE Payments (
    paymentId SERIAL PRIMARY KEY,
    orderId INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    paymentMethod VARCHAR(50) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (orderId) REFERENCES Orders(orderId) ON DELETE CASCADE
);

-- Trigger function to update the updatedAt column
CREATE
OR REPLACE FUNCTION update_updated_at_column() RETURNS TRIGGER AS $ $ BEGIN NEW.updatedAt = NOW();

RETURN NEW;

END;

$ $ LANGUAGE plpgsql;

-- Trigger to automatically update the updatedAt field in Users
CREATE TRIGGER trigger_update_users_updated_at BEFORE
UPDATE
    ON Users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger to automatically update the updatedAt field in Products
CREATE TRIGGER trigger_update_products_updated_at BEFORE
UPDATE
    ON Products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger to automatically update the updatedAt field in Orders
CREATE TRIGGER trigger_update_orders_updated_at BEFORE
UPDATE
    ON Orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO
    Users (name, email, password)
VALUES
    (
        'John Doe',
        'john.doe@example.com',
        'password123'
    ),
    (
        'Jane Smith',
        'jane.smith@example.com',
        'securepassword'
    ),
    (
        'Robert Brown',
        'robert.brown@example.com',
        'robert2023'
    );

INSERT INTO
    Categories (name, description)
VALUES
    ('Electronics', 'Devices and gadgets'),
    ('Clothing', 'Apparel and accessories'),
    ('Books', 'Wide variety of books');

INSERT INTO
    Products (
        name,
        description,
        price,
        stock,
        categoryId,
        createdAt
    )
VALUES
    (
        'Laptop',
        'A powerful gaming laptop',
        1500.00,
        25,
        1,
        NOW()
    ),
    (
        'Smartphone',
        'Latest model smartphone',
        999.99,
        50,
        1,
        NOW()
    ),
    (
        'T-Shirt',
        'Comfortable cotton t-shirt',
        19.99,
        100,
        2,
        NOW()
    ),
    (
        'Novel Book',
        'A popular fiction book',
        12.50,
        200,
        3,
        NOW()
    );

INSERT INTO
    ShoppingCarts (userId, createdAt)
VALUES
    (1, NOW()),
    -- Cart for John Doe
    (2, NOW());

-- Cart for Jane Smith
INSERT INTO
    CartItems (cartId, productId, quantity)
VALUES
    (1, 1, 1),
    -- John Doe added 1 Laptop to his cart
    (1, 3, 2),
    -- John Doe added 2 T-Shirts to his cart
    (2, 2, 1);

-- Jane Smith added 1 Smartphone to her cart
INSERT INTO
    Orders (userId, totalAmount, status, createdAt)
VALUES
    (1, 1539.98, 'completed', NOW()),
    -- John Doe placed an order
    (2, 999.99, 'pending', NOW());

-- Jane Smith placed an order
INSERT INTO
    OrderItems (orderId, productId, quantity, price)
VALUES
    (1, 1, 1, 1500.00),
    -- 1 Laptop in John Doe's order
    (1, 3, 2, 19.99),
    -- 2 T-Shirts in John Doe's order
    (2, 2, 1, 999.99);

-- 1 Smartphone in Jane Smith's order
INSERT INTO
    Payments (
        orderId,
        amount,
        status,
        paymentMethod,
        createdAt
    )
VALUES
    (1, 1539.98, 'completed', 'credit_card', NOW()),
    -- Payment for John Doe's order
    (2, 999.99, 'pending', 'paypal', NOW());

-- Payment for Jane Smith's order