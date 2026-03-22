/*use database */
USE bankdb;

/*Create Database*/
CREATE DATABASE bankdb;
 
 /*Create Table */
 -- Customers
 CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    phone VARCHAR(15),
    city VARCHAR(50)
);

-- Account table 
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    balance DECIMAL(12,2),
    account_type VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Transactions Table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    amount DECIMAL(12,2),
    transaction_type VARCHAR(20),
    transaction_date DATE,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- insert value in Customers 
INSERT INTO Customers (name, phone, city) VALUES
('Rahul Sharma', '9876543210', 'Mumbai'),
('Priya Patil', '9123456780', 'Pune'),
('Amit Verma', '9988776655', 'Nagpur'),
('Sneha Joshi', '9090909090', 'Nashik'),
('Rohit Gupta', '9812345678', 'Delhi'),
('Anjali Deshmukh', '9765432109', 'Thane'),
('Vikas Yadav', '9898989898', 'Lucknow'),
('Pooja Singh', '9345678123', 'Indore'),
('Karan Mehta', '9234567812', 'Ahmedabad'),
('Neha Kulkarni', '9456123789', 'Kolhapur');

-- insert value in Accounts
INSERT INTO Accounts (customer_id, balance, account_type) VALUES
(1, 50000, 'Savings'),
(2, 120000, 'Current'),
(3, 75000, 'Savings'),
(4, 98000, 'Savings'),
(5, 200000, 'Current'),
(6, 65000, 'Savings'),
(7, 87000, 'Current'),
(8, 54000, 'Savings'),
(9, 110000, 'Current'),
(10, 72000, 'Savings');


-- insert value in Transactions  
INSERT INTO Transactions (account_id, amount, transaction_type, transaction_date) VALUES
(1, 10000, 'Credit', '2026-02-01'),
(2, 5000, 'Debit', '2026-02-02'),
(3, 25000, 'Credit', '2026-02-03'),
(4, 15000, 'Debit', '2026-02-04'),
(5, 40000, 'Credit', '2026-02-05'),
(6, 8000, 'Debit', '2026-02-06'),
(7, 30000, 'Credit', '2026-02-07'),
(8, 12000, 'Debit', '2026-02-08'),
(9, 45000, 'Credit', '2026-02-09'),
(10, 7000, 'Debit', '2026-02-10');

--  Show Table 
SELECT * FROM Customers;

SELECT * FROM Accounts;

SELECT * FROM Transactions;

-- Data Extraction 

-- METHOD 1: Simple SELECT Extraction

-- Customer Data
SELECT * FROM Customers;

-- Specific Columns Only
SELECT name, city FROM Customers;

-- METHOD 2: WHERE Condition Extraction 

-- Mumbai Customers
SELECT * 
FROM Customers
WHERE city = 'Mumbai';

-- Balance > 80,000
SELECT * 
FROM Accounts
WHERE balance > 80000;

-- Credit Transactions Only
SELECT * 
FROM Transactions
WHERE transaction_type = 'Credit';

-- METHOD 3: AND / OR Conditions 
SELECT * 
FROM Accounts
WHERE balance > 70000 AND account_type = 'Savings';

SELECT * 
FROM Customers
WHERE city = 'Mumbai' OR city = 'Pune';

-- METHOD 4: ORDER BY (Sorting Extraction) 

-- Highest Balance First
SELECT * 
FROM Accounts
ORDER BY balance DESC;

-- Latest Transactions First
SELECT * 
FROM Transactions
ORDER BY transaction_date DESC;

-- METHOD 5: LIMIT (Large Data Handle)
SELECT * 
FROM Transactions
LIMIT 5;


-- METHOD 6: JOIN (Most Important)

-- Customer + Account
SELECT c.name, a.account_type, a.balance
FROM Customers c
JOIN Accounts a 
ON c.customer_id = a.customer_id;

-- Customer + Account + Transaction
SELECT c.name, a.account_type, t.amount, t.transaction_type
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Transactions t ON a.account_id = t.account_id;


-- METHOD 7: Aggregate Functions (Report Type Extraction)

-- Total Transaction Amount
SELECT SUM(amount) AS total_bank_transaction
FROM Transactions;

-- Average Balance
SELECT AVG(balance) AS average_balance
FROM Accounts;

-- Transaction Count
SELECT COUNT(*) AS total_transactions
FROM Transactions;

-- METHOD 8: GROUP BY

 -- Total Transaction Per Customer
 SELECT c.name, SUM(t.amount) AS total_amount
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Transactions t ON a.account_id = t.account_id
GROUP BY c.name;

-- METHOD 9: HAVING (Advanced Filter)
SELECT c.name, SUM(t.amount) AS total_amount
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Transactions t ON a.account_id = t.account_id
GROUP BY c.name
HAVING total_amount > 20000;

-- METHOD 10: Subquery (Advanced Extraction)

-- Highest Balance Account Holder
SELECT name
FROM Customers
WHERE customer_id = (
    SELECT customer_id
    FROM Accounts
    ORDER BY balance DESC
    LIMIT 1
);

-- METHOD 11: VIEW Create  Extraction 

-- View Create 

CREATE VIEW CustomerTransactionView AS
SELECT c.name, a.account_type, t.amount, t.transaction_date
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Transactions t ON a.account_id = t.account_id;

--  Data Extract using View
SELECT * FROM CustomerTransactionView;


-- METHOD 12: Export Data (Professional)
SELECT *
INTO OUTFILE '/tmp/bank_export.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
FROM Transactions;

-- INDEXING FOR PERFORMANCE

-- Without Index (Normal Query)
SELECT * FROM Accounts
WHERE balance > 80000;

-- Create Index on balance
CREATE INDEX idx_balance
ON Accounts(balance);

-- Index on Foreign Key (Important)
CREATE INDEX idx_customer_id
ON Accounts(customer_id);

CREATE INDEX idx_account_id
ON Transactions(account_id);

-- Check Indexes
SHOW INDEX FROM Accounts;

-- TRIGGER (Automatic Action)

-- Trigger Create 
DELIMITER $$

CREATE TRIGGER update_balance_after_transaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    IF NEW.transaction_type = 'Debit' THEN
        UPDATE Accounts
        SET balance = balance - NEW.amount
        WHERE account_id = NEW.account_id;
    ELSEIF NEW.transaction_type = 'Credit' THEN
        UPDATE Accounts
        SET balance = balance + NEW.amount
        WHERE account_id = NEW.account_id;
    END IF;
END$$

DELIMITER ;


-- Test  Trigger

INSERT INTO Transactions (account_id, amount, transaction_type, transaction_date)
VALUES (1, 5000, 'Debit', '2026-03-01');

-- check 
SELECT * FROM Accounts WHERE account_id = 1;





