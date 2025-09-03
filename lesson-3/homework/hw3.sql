Create database sql_lesson_3;
use sql_lesson_3;

BULK INSERT Inventory
FROM 'C:\Data\inventory_data.txt'
WITH (
firstrow=2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
   ]
);
INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0',
   'Excel 12.0;Database=C:\Data\Exported_Inventory.xlsx;HDR=YES;',
   'SELECT * FROM [Sheet1$]')
SELECT * FROM Inventory;
--Option 2: SQL Server Management Studio (SSMS Wizard)
--1. Right-click on the database > Tasks > Export Data...

--2. Choose SQL Server Native Client as source.

--3. Choose Microsoft Excel as destination.

--4. Specify the Excel file path and sheet.

--5. Follow wizard to map columns and export.

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50)
);
/*IDENTITY(1,1) means:

Start from 1

Increment by 1 for each new row */
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Description VARCHAR(255) NULL,
    Price DECIMAL(10,2) NOT NULL
);
/* Purpose:
Ensures all values in a column (or combination of columns) are unique, but allows one NULL (in SQL Server).*/

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Email VARCHAR(100) UNIQUE  -- ensures no duplicate emails
);
ALTER TABLE Employees
ADD CONSTRAINT UQ_Email UNIQUE (Email);
/*
PRIMARY Key
 Purpose:
Uniquely identifies each record in a table.

Only one PRIMARY KEY per table.

Cannot contain NULL values.*/
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);
/*Constraint  Description
PRIMARY KEY  Uniquely identifies each row in a table. Cannot contain NULL values.
UNIQUE KEY  Ensures all values in a column (or group of columns) are unique. NULL is allowed.
*/
BULK INSERT TableName
FROM 'C:\Path\To\File.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
/* Purpose of BULK INSERT:
To quickly load external data (especially large datasets) into a SQL Server table.

Ideal for importing data from flat files during data migration, ETL processes, or one-time data loads.

Offers better performance than row-by-row INSERT statements. */
/*
1. CSV (Comma-Separated Values)
One of the most common formats.

Columns are separated by commas.

Easily imported using BULK INSERT, bcp, or the Import Wizard.

plaintext

ProductID,ProductName,Price
1,Notebook,3.99
2. TXT (Text File)
Plain text files, often delimited by tabs (\t), pipes (|), or other custom separators.

Supported via BULK INSERT and Import Wizard.

plaintext

1|Notebook|3.99
2|Pen|0.99
3. Excel Files (.xls / .xlsx)
Can be imported using:

SQL Server Import and Export Wizard

OPENROWSET or OPENDATASOURCE

SSIS (SQL Server Integration Services)

 4. XML (eXtensible Markup Language)
Used for structured hierarchical data.

Can be imported using OPENXML, XML datatype, or nodes() method in SQL Server.

xml

<Products>
  <Product>
    <ProductID>1</ProductID>
    <ProductName>Notebook</ProductName>
    <Price>3.99</Price>
  </Product>
</Products>
📝 Bonus Formats:
JSON – via OPENJSON() or BULK INSERT (in SQL Server 2016+)

Flat Files – Structured fixed-width text files, supported via SSIS */

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10, 2)
);
/* Explanation:
ProductID INT PRIMARY KEY: Unique identifier for each product.

ProductName VARCHAR(50): Stores the name of the product (up to 50 characters).

Price DECIMAL(10,2): Stores price with precision:

Up to 10 digits total.

2 digits after the decimal point (e.g., 99999999.99).

Let me know if you'd like to add more columns like stock, category, or constraints.
*/
INSERT INTO Products (ProductID, ProductName, Price)
VALUES 
(1, 'Notebook', 3.99),
(2, 'Pen', 1.49),
(3, 'Backpack', 24.95);
/* Explanation:
Each row matches the column order: (ProductID, ProductName, Price)

Ensure that ProductID values are unique to avoid primary key violations.

Let me know if you'd like to insert more data or retrieve it using SELECT.*/
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50) NULL
);
/* MiddleName can be left blank.

FirstName must have a value.*/
-- Check for NULL values
SELECT * FROM Employees
WHERE MiddleName IS NULL;

-- This will NOT work correctly:
SELECT * FROM Employees
WHERE MiddleName = NULL; -- ❌ incorrect

ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);
/* Explanation:
ALTER TABLE Products: Modifies the existing table.

ADD CONSTRAINT UQ_ProductName: Adds a named constraint (UQ_... is a common naming convention).

UNIQUE (ProductName): Ensures all values in ProductName are unique, preventing duplicates.

 */
 -- This query selects all products with a price greater than 10
SELECT ProductID, ProductName, Price
FROM Products
WHERE Price > 10;
/*  Types of Comments in SQL Server:
Single-line comment:
Uses --

-- This is a single-line comment
Multi-line comment:
Uses /* ... */

/* 
  This query retrieves all products 
  that cost more than 10 units 
*/ */
SELECT * FROM Products
WHERE Price > 10;.
ALTER TABLE Products
ADD CategoryID INT;
/* Explanation:
ALTER TABLE Products: Specifies the table to modify.

ADD CategoryID INT: Adds a new column named CategoryID of type INT.*/

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE
);
/* Purpose of the IDENTITY Column in SQL Server:
The IDENTITY column in SQL Server is used to automatically generate sequential numeric values for a column — typically used for primary keys or unique identifiers.

 Why Use IDENTITY?
Auto-increments values without manual input.

Guarantees uniqueness (especially when used with PRIMARY KEY).

Simplifies insert operations — no need to specify values for that column.
   */
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10,2)
);

BULK INSERT Products
FROM 'C:\Data\products.txt'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2 -- Skip header row, if present
);

ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories
FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID);

CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Email VARCHAR(100) UNIQUE
);
/* UserID: Cannot be NULL, must be unique (primary identity).

Email: Must be unique but can be NULL (optional contact). */

/*
| Feature            | PRIMARY KEY         | UNIQUE KEY       |
| ------------------ | ------------------- | ---------------- |
| Ensures Uniqueness | ✅ Yes               | ✅ Yes            |
| Allows NULLs       | ❌ No                | ✅ Yes            |
| Number per table   | 1 only              | Multiple allowed |
| Default index type | Clustered (default) | Non-clustered    |
*/

ALTER TABLE Products
ADD CONSTRAINT CHK_Price_Positive
CHECK (Price > 0);

/* Clause  Purpose
ALTER TABLE Products  Modifies the existing table
ADD CONSTRAINT CHK_Price_Positive  Names the check constraint
CHECK (Price > 0)  Enforces that all values in Price > 0

📌 Notes:
This prevents inserting or updating rows where Price is 0 or negative.

If you try to insert a product with Price = 0, you'll get an error.

Let me know if you’d like to add similar constraints to other columns (like StockQuantity >= 0, etc.). */
ALTER TABLE Products
ADD Stock INT NOT NULL;

SELECT 
    ProductID,
    ProductName,
    ISNULL(Price, 0) AS Price,
    Stock
FROM Products;

/*  Purpose and Usage of FOREIGN KEY Constraints in SQL Server
A FOREIGN KEY constraint is used to enforce referential integrity between two tables. It ensures that a value in one table (the child) must match a value in another table (the parent).

 Purpose:
Maintains Data Consistency
Prevents inserting invalid data that doesn't exist in the referenced (parent) table.

Enforces Relationships
Models real-world relationships between tables (e.g., Products and Categories, Orders and Customers).
Prevents Orphan Records
Stops you from deleting a record in the parent table if it's still referenced by a child table (unless cascading is enabled).*/
-- Valid (passes the check)
INSERT INTO Customers (CustomerID, CustomerName, Email, Age)
VALUES (1, 'Alice Smith', 'alice@example.com', 25);

-- Invalid (fails the check)
INSERT INTO Customers (CustomerID, CustomerName, Email, Age)
VALUES (2, 'Bob Jones', 'bob@example.com', 16);  -- Error: Age < 18

CREATE TABLE Orders (
    OrderID INT IDENTITY(100, 10) PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2)
);

CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    -- Define composite PRIMARY KEY
    CONSTRAINT PK_OrderDetails PRIMARY KEY (OrderID, ProductID)
);

SELECT ISNULL(Price, 0) AS Price
FROM Products;
If Price is NULL, it returns 0.

/* Key Points:

Only takes 2 arguments.

Returns the data type of the first argument.

Simple and fast for single fallback value.*/

/* COALESCE() Function
Purpose:
Returns the first non-NULL value from a list of expressions.

*/

--COALESCE(expr1, expr2, ..., exprN)


SELECT COALESCE(Price, DiscountPrice, 0) AS FinalPrice
FROM Products;
--Returns the first non-NULL among Price, DiscountPrice, or 0.

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    HireDate DATE,
    Position VARCHAR(50)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
