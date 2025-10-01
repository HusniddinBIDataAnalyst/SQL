create database SQL_2_CLASS_18
USE SQL_2_CLASS_18


-- ========================================================================================
-- Today is 20.09.2025 Saturday 12:18 beforhand lesson preparation
-- Lesson 18 ---- View, Temp Tables, Temp variables, Functions  

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Samsung Galaxy S23', 'Electronics', 899.99),
(2, 'Apple iPhone 14', 'Electronics', 999.99),
(3, 'Sony WH-1000XM5 Headphones', 'Electronics', 349.99),
(4, 'Dell XPS 13 Laptop', 'Electronics', 1249.99),
(5, 'Organic Eggs (12 pack)', 'Groceries', 3.49),
(6, 'Whole Milk (1 gallon)', 'Groceries', 2.99),
(7, 'Alpen Cereal (500g)', 'Groceries', 4.75),
(8, 'Extra Virgin Olive Oil (1L)', 'Groceries', 8.99),
(9, 'Mens Cotton T-Shirt', 'Clothing', 12.99),
(10, 'Womens Jeans - Blue', 'Clothing', 39.99),
(11, 'Unisex Hoodie - Grey', 'Clothing', 29.99),
(12, 'Running Shoes - Black', 'Clothing', 59.95),
(13, 'Ceramic Dinner Plate Set (6 pcs)', 'Home & Kitchen', 24.99),
(14, 'Electric Kettle - 1.7L', 'Home & Kitchen', 34.90),
(15, 'Non-stick Frying Pan - 28cm', 'Home & Kitchen', 18.50),
(16, 'Atomic Habits - James Clear', 'Books', 15.20),
(17, 'Deep Work - Cal Newport', 'Books', 14.35),
(18, 'Rich Dad Poor Dad - Robert Kiyosaki', 'Books', 11.99),
(19, 'LEGO City Police Set', 'Toys', 49.99),
(20, 'Rubiks Cube 3x3', 'Toys', 7.99);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate)
VALUES
(1, 1, 2, '2025-04-01'),
(2, 1, 1, '2025-04-05'),
(3, 2, 1, '2025-04-10'),
(4, 2, 2, '2025-04-15'),
(5, 3, 3, '2025-04-18'),
(6, 3, 1, '2025-04-20'),
(7, 4, 2, '2025-04-21'),
(8, 5, 10, '2025-04-22'),
(9, 6, 5, '2025-04-01'),
(10, 6, 3, '2025-04-11'),
(11, 10, 2, '2025-04-08'),
(12, 12, 1, '2025-04-12'),
(13, 12, 3, '2025-04-14'),
(14, 19, 2, '2025-04-05'),
(15, 20, 4, '2025-04-19'),
(16, 1, 1, '2025-03-15'),
(17, 2, 1, '2025-03-10'),
(18, 5, 5, '2025-02-20'),
(19, 6, 6, '2025-01-18'),
(20, 10, 1, '2024-12-25'),
(21, 1, 1, '2024-04-20');



-- demak biz 2 table created => sales and products



-- 1
create table #MonthlySales 
(ProductID int,
TotalQuantity int,
TotalRevenue Decimal(10,2))

insert into #MonthlySales
select * from (
select s.ProductID,sum(s.Quantity) as TotalQuantity, sum(p.Price * s.Quantity) as TotalRevenue from Sales as s
join Products as p on p.ProductID=s.ProductID
where year(s.SaleDate) = year(GETDATE()) and month(s.SaleDate) = month(GETDATE())
group by s.ProductID
) as Table1

select*from #MonthlySales
select*from sales

--2

create view vw_ProductSalesSummary 
as 
select p.ProductID,p.ProductName,p.Category, sum(s.Quantity) as TotalQuantitySold from Products as p
join Sales as s on s.ProductID = p.ProductID
group by p.ProductID,p.ProductName,p.Category;
select*from vw_ProductSalesSummary

--3
CREATE FUNCTION dbo.fn_GetTotalRevenue (@ProductID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(10,2);
    SELECT @TotalRevenue = SUM(s.Quantity * p.Price)
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    WHERE s.ProductID = @ProductID
    RETURN ISNULL(@TotalRevenue, 0.00)
END;

--4
create function fn_GetSalesByCategory(@Category VARCHAR(50))
returns table
as return
(
select p.ProductName, sum(s.Quantity) as TotalQuantity, cast(sum(p.Price*s.Quantity) as decimal(10,2)) as TotalRevenue from Products as p
join Sales as s on s.ProductID = p.ProductID
where p.Category = @Category
group by p.ProductName
)

--5

CREATE FUNCTION fn_IsPrime (@Number INT)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @a INT = 1;
    DECLARE @b INT = 0;
    DECLARE @isprime VARCHAR(50);
    WHILE @Number >= @a
    BEGIN
        IF @Number % @a = 0
        BEGIN
            SET @b = @b + 1;
        END;
        SET @a = @a + 1;
    END;
    IF @b = 2
    BEGIN
        SET @isprime = 'Yes';
    END
    ELSE
    BEGIN
        SET @isprime = 'No';
    END;
    RETURN @isprime;
END;

-- 6
create function fn_GetNumbersBetween(@Start INT,
@End INT)
returns @Result table (
Number int
)
as
begin
with NumbersCTE as(
select @Start as Number
union all 
select Number+1 from NumbersCTE
where Number+1<=@End
)
insert into @Result
select Number from NumbersCTE
return
end;

-- 7

CREATE FUNCTION getNthHighestSalary(@N INT) RETURNS INT AS
BEGIN
     IF @N <= 0
        RETURN NULL;

    RETURN (
 SELECT Salary
        FROM (
            SELECT DISTINCT Salary
            FROM Employee
        ) AS DistinctSalaries
     ORDER BY Salary DESC
        OFFSET @N - 1 ROWS FETCH NEXT 1 ROWS ONLY
    );
END

-- 8
SELECT TOP 1 id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id FROM RequestAccepted
) AS all_friends
GROUP BY id
ORDER BY num DESC;

-- 9

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE,
    amount DECIMAL(10,2)
);

-- Customers
INSERT INTO Customers (customer_id, name, city)
VALUES
(1, 'Alice Smith', 'New York'),
(2, 'Bob Jones', 'Chicago'),
(3, 'Carol White', 'Los Angeles');

-- Orders
INSERT INTO Orders (order_id, customer_id, order_date, amount)
VALUES
(101, 1, '2024-12-10', 120.00),
(102, 1, '2024-12-20', 200.00),
(103, 1, '2024-12-30', 220.00),
(104, 2, '2025-01-12', 120.00),
(105, 2, '2025-01-20', 180.00);



-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
create view vw_CustomerOrderSummary 
as
select c.customer_id, c.name, count(o.order_id) as total_orders, sum(o.amount) as total_amount, max(o.order_date) as last_order_date from Customers as c
join Orders as o on o.customer_id = c.customer_id
group by c.customer_id, c.name

select * from vw_CustomerOrderSummary

-- 10
SELECT 
    RowNumber,
    (
        SELECT TOP 1 TestCase
        FROM Gaps g2
        WHERE g2.RowNumber <= g1.RowNumber AND g2.TestCase IS NOT NULL
        ORDER BY g2.RowNumber DESC
    ) AS Workflow
FROM Gaps g1
ORDER BY RowNumber;

DROP TABLE IF EXISTS Gaps;



CREATE TABLE Gaps
(
RowNumber   INTEGER PRIMARY KEY,
TestCase    VARCHAR(100) NULL
);

INSERT INTO Gaps (RowNumber, TestCase) VALUES
(1,'Alpha'),(2,NULL),(3,NULL),(4,NULL),
(5,'Bravo'),(6,NULL),(7,NULL),(8,NULL),(9,NULL),(10,'Charlie'), (11, NULL), (12, NULL)
