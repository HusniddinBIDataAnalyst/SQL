create database sql_2_hw16
use sql_2_hw16

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


1.
with recursion as(
select 1 as n
union all
select n+1 from recursion
where n<1000
)
select n from recursion option (maxrecursion 1000)

2.
select * from (select e.EmployeeID,FirstName,LastName,sum(s.SalesAmount) as TotalSales from Employees as e
join Sales as s on s.EmployeeID = e.EmployeeID
group by e.EmployeeID, FirstName,LastName) as Total_Table

3.
with avg_salary as (
select avg(Salary) as Avg_Salary from Employees
)
select Avg_salary from avg_salary

4.
select * from (select p.ProductID,ProductName, max(s.SalesAmount) as HighestSale from Products as p
join Sales as s on s.ProductID = p.ProductID
group by p.ProductID,ProductName) as MaxSaleTable

5.
with doubleNumber as (
select 1 as n 
union all
select n * 2 from doubleNumber
where n < 524288
)
select n from doubleNumber
option (maxrecursion 19)

6.
with sales_cte as (
select EmployeeID, count(SalesID) as Count from Sales
group by EmployeeID
)
select FirstName from Employees as e
join sales_cte as s on s.EmployeeID = e.EmployeeID

7.
with product_sales as(
select distinct ProductName, p.ProductID from Products as p
join Sales as s on s.ProductID = p.ProductID
where SalesAmount > 500
)
select * from product_sales

8.
with avgSalary as(
select EmployeeID, FirstName,LastName,Salary from Employees
where Salary>(select avg(Salary) from Employees)
)
select * from avgSalary

9.
select * from (select top 5 e.EmployeeID,e.FirstName,e.LastName, count(s.SalesID) as OrderCount from Employees as e
join Sales as s on s.EmployeeID = e.EmployeeID
group by e.EmployeeID,e.FirstName,e.LastName) as MostOrders

10.
select * from (select p.CategoryID, sum(s.SalesAmount) as TotalSales from Products as p
join Sales as s on s.ProductID = p.ProductID
group by p.CategoryID) as SalesCategory

11.
DECLARE @MaxN INT;
SELECT @MaxN = MAX(Number) FROM Numbers1;
WITH FactorialCalculator AS (
        SELECT
            1 AS N_Value,
            CAST(1 AS BIGINT) AS Factorial_Value
        WHERE 1 <= @MaxN
        UNION ALL
        SELECT
            fc.N_Value + 1,
            CAST((fc.N_Value + 1) * fc.Factorial_Value AS BIGINT)
        FROM
            FactorialCalculator AS fc
        WHERE
            fc.N_Value < @MaxN
            AND fc.N_Value < 20
    )
    SELECT
        n.Number,
        fc.Factorial_Value AS Factorial
    FROM
        Numbers1 AS n
    JOIN
        FactorialCalculator AS fc ON n.Number = fc.N_Value

12.
WITH StringSplitter AS (
    SELECT
        Id,
        String,           
        1 AS CurrentPosition, 
        SUBSTRING(String, 1, 1) AS CharValue
    FROM
        Example
    WHERE
        LEN(String) >= 1
    UNION ALL
    SELECT
        ss.Id,
        ss.String,
        ss.CurrentPosition + 1,
        SUBSTRING(ss.String, ss.CurrentPosition + 1, 1)
    FROM
        StringSplitter AS ss
    WHERE
        ss.CurrentPosition < LEN(ss.String)
)
SELECT
    CharValue AS Character
FROM
    StringSplitter
ORDER BY
    id;

13.
WITH MonthlySales AS (
        SELECT
        CAST(FORMAT(SaleDate, 'yyyy-MM-01') AS DATE) AS MonthStart, -- Get the start of the month for grouping
        SUM(SalesAmount) AS TotalSales
    FROM
        Sales
    GROUP BY
        CAST(FORMAT(SaleDate, 'yyyy-MM-01') AS DATE) -- Group by the start of the month
),
SalesWithLaggedMonth AS (
     SELECT
        MonthStart,
        TotalSales AS CurrentMonthSales,
        LAG(TotalSales, 1, 0.00) OVER (ORDER BY MonthStart) AS PreviousMonthSales
    FROM
        MonthlySales
)
SELECT
    MonthStart,
    CurrentMonthSales,
    PreviousMonthSales,
    (CurrentMonthSales - PreviousMonthSales) AS SalesDifference
FROM
    SalesWithLaggedMonth
ORDER BY
    MonthStart;
14.
select * from Sales
select * from Employees
select * from (
select EmployeeID, sum(SalesAmount) as totalSales,DATEPART(QUARTER,SaleDate) as quarter from Sales
group by EmployeeID, DATEPART(QUARTER, SaleDate)
having sum(SalesAmount)>45000) as sales_quarter

15.
DECLARE @NthTerm INT = 10;
IF @NthTerm <= 0
BEGIN
    SELECT 'Please provide a positive integer for Nth term.' AS Result;
END
ELSE
BEGIN
    WITH FibonacciCTE AS (
          SELECT
            1 AS TermNumber,
            CAST(0 AS BIGINT) AS CurrentFib,  
            CAST(1 AS BIGINT) AS NextFib     
        WHERE 1 <= @NthTerm
        UNION ALL
        SELECT
            f.TermNumber + 1,
            f.NextFib,                         
            f.CurrentFib + f.NextFib           
        FROM
            FibonacciCTE AS f
        WHERE
            f.TermNumber < @NthTerm
            AND f.TermNumber < 90
    )
    SELECT
        TermNumber,
        CurrentFib AS FibonacciValue
    FROM
        FibonacciCTE
    WHERE
        TermNumber <= @NthTerm
    ORDER BY
        TermNumber;
END;

16.
SELECT
    Id,
    Vals
FROM
    FindSameCharacters
WHERE
    Vals IS NOT NULL
    AND LEN(Vals) > 1
    AND PATINDEX('%[^' + LEFT(Vals, 1) + ']%', Vals) = 0;

17.
DECLARE @n INT = 5;
    WITH NumberSequence AS (
        SELECT
            1 AS CurrentNum,
            CAST('1' AS VARCHAR(MAX)) AS SequenceValue
        WHERE 1 <= @n
        UNION ALL
        SELECT
            ns.CurrentNum + 1,
            ns.SequenceValue + CAST(ns.CurrentNum + 1 AS VARCHAR(MAX))
        FROM
            NumberSequence AS ns
        WHERE
            ns.CurrentNum < @n
    )
    SELECT
        SequenceValue
    FROM
        NumberSequence
    ORDER BY
        CurrentNum;

18.
declare @CurrentDate date
select @CurrentDate = GETDATE();
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    QuarterlySales.TotalSales AS SalesAmountLast6Months
FROM
    Employees AS e
JOIN
    (
        SELECT
            EmployeeID,
            SUM(SalesAmount) AS TotalSales,
            ROW_NUMBER() OVER (ORDER BY SUM(SalesAmount) DESC) AS SalesRank
        FROM
            Sales
        WHERE
            SaleDate >= DATEADD(month, -6, @CurrentDate)
            AND SaleDate <= @CurrentDate
        GROUP BY
            EmployeeID
    ) AS QuarterlySales
ON
    e.EmployeeID = QuarterlySales.EmployeeID
WHERE
    QuarterlySales.SalesRank = 1;

19.
WITH ReducedDuplicates AS (
    -- Anchor Member: Start with the original string.
    SELECT
        PawanName,
        -- FIX: Explicitly cast to VARCHAR(MAX) to ensure type compatibility
        CAST(Pawan_slug_name AS VARCHAR(MAX)) AS CurrentString,
        CAST(1 AS INT) AS IterationNum
    FROM
        RemoveDuplicateIntsFromNames

    UNION ALL

    -- Recursive Member: Repeatedly replace 'DD' with 'D' for each digit until no more duplicates are found.
    SELECT
        rd.PawanName,
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        REPLACE(
                                            REPLACE(
                                                rd.CurrentString, '00', '0'
                                            ), '11', '1'
                                        ), '22', '2'
                                    ), '33', '3'
                                ), '44', '4'
                            ), '55', '5'
                        ), '66', '6'
                    ), '77', '7'
                ), '88', '8'
            ), '99', '9'
        ),
        rd.IterationNum + 1
    FROM
        ReducedDuplicates AS rd
    WHERE
        -- Termination Condition: Continue if any double digit ('DD') pattern is still found.
        PATINDEX('%00%', rd.CurrentString) > 0 OR
        PATINDEX('%11%', rd.CurrentString) > 0 OR
        PATINDEX('%22%', rd.CurrentString) > 0 OR
        PATINDEX('%33%', rd.CurrentString) > 0 OR
        PATINDEX('%44%', rd.CurrentString) > 0 OR
        PATINDEX('%55%', rd.CurrentString) > 0 OR
        PATINDEX('%66%', rd.CurrentString) > 0 OR
        PATINDEX('%77%', rd.CurrentString) > 0 OR
        PATINDEX('%88%', rd.CurrentString) > 0 OR
        PATINDEX('%99%', rd.CurrentString) > 0
),
FinalReducedString AS (
    -- Select the final string after all consecutive duplicates have been reduced.
    SELECT
        PawanName,
        CurrentString
    FROM
        ReducedDuplicates
    WHERE
        -- This ensures we pick the last state (highest iteration) for each PawanName.
        IterationNum = (SELECT MAX(IterationNum) FROM ReducedDuplicates WHERE PawanName = ReducedDuplicates.PawanName)
)
SELECT
    frs.PawanName,
    REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        REPLACE(
                                            frs.CurrentString, '0', ''
                                        ), '1', ''
                                    ), '2', ''
                                ), '3', ''
                            ), '4', ''
                        ), '5', ''
                    ), '6', ''
                ), '7', ''
            ), '8', ''
        ), '9', ''
    ) AS Cleaned_Pawan_slug_name
FROM
    FinalReducedString AS frs;







-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-- data 1

CREATE TABLE Numbers1(Number INT)
go
INSERT INTO Numbers1 VALUES (5),(9),(8),(6),(7)

CREATE TABLE FindSameCharacters
(
     Id INT
    ,Vals VARCHAR(10)
)
 go
INSERT INTO FindSameCharacters VALUES
(1,'aa'),
(2,'cccc'),
(3,'abc'),
(4,'aabc'),
(5,NULL),
(6,'a'),
(7,'zzz'),
(8,'abc')



CREATE TABLE RemoveDuplicateIntsFromNames
(
      PawanName INT
    , Pawan_slug_name VARCHAR(1000)
)
 
 go
INSERT INTO RemoveDuplicateIntsFromNames VALUES
(1,  'PawanA-111'  ),
(2, 'PawanB-123'   ),
(3, 'PawanB-32'    ),
(4, 'PawanC-4444' ),
(5, 'PawanD-3'  )





CREATE TABLE Example
(
Id       INTEGER IDENTITY(1,1) PRIMARY KEY,
String VARCHAR(30) NOT NULL
);


INSERT INTO Example VALUES('123456789'),('abcdefghi');


CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    DepartmentID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2)
);
go
INSERT INTO Employees (EmployeeID, DepartmentID, FirstName, LastName, Salary) VALUES
(1, 1, 'John', 'Doe', 60000.00),
(2, 1, 'Jane', 'Smith', 65000.00),
(3, 2, 'James', 'Brown', 70000.00),
(4, 3, 'Mary', 'Johnson', 75000.00),
(5, 4, 'Linda', 'Williams', 80000.00),
(6, 2, 'Michael', 'Jones', 85000.00),
(7, 1, 'Robert', 'Miller', 55000.00),
(8, 3, 'Patricia', 'Davis', 72000.00),
(9, 4, 'Jennifer', 'García', 77000.00),
(10, 1, 'William', 'Martínez', 69000.00);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);
go
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'Sales'),
(3, 'Marketing'),
(4, 'Finance'),
(5, 'IT'),
(6, 'Operations'),
(7, 'Customer Service'),
(8, 'R&D'),
(9, 'Legal'),
(10, 'Logistics');

CREATE TABLE Sales (
    SalesID INT PRIMARY KEY,
    EmployeeID INT,
    ProductID INT,
    SalesAmount DECIMAL(10, 2),
    SaleDate DATE
);
go
INSERT INTO Sales (SalesID, EmployeeID, ProductID, SalesAmount, SaleDate) VALUES
-- January 2025
(1, 1, 1, 1550.00, '2025-01-02'),
(2, 2, 2, 2050.00, '2025-01-04'),
(3, 3, 3, 1250.00, '2025-01-06'),
(4, 4, 4, 1850.00, '2025-01-08'),
(5, 5, 5, 2250.00, '2025-01-10'),
(6, 6, 6, 1450.00, '2025-01-12'),
(7, 7, 1, 2550.00, '2025-01-14'),
(8, 8, 2, 1750.00, '2025-01-16'),
(9, 9, 3, 1650.00, '2025-01-18'),
(10, 10, 4, 1950.00, '2025-01-20'),
(11, 1, 5, 2150.00, '2025-02-01'),
(12, 2, 6, 1350.00, '2025-02-03'),
(13, 3, 1, 2050.00, '2025-02-05'),
(14, 4, 2, 1850.00, '2025-02-07'),
(15, 5, 3, 1550.00, '2025-02-09'),
(16, 6, 4, 2250.00, '2025-02-11'),
(17, 7, 5, 1750.00, '2025-02-13'),
(18, 8, 6, 1650.00, '2025-02-15'),
(19, 9, 1, 2550.00, '2025-02-17'),
(20, 10, 2, 1850.00, '2025-02-19'),
(21, 1, 3, 1450.00, '2025-03-02'),
(22, 2, 4, 1950.00, '2025-03-05'),
(23, 3, 5, 2150.00, '2025-03-08'),
(24, 4, 6, 1700.00, '2025-03-11'),
(25, 5, 1, 1600.00, '2025-03-14'),
(26, 6, 2, 2050.00, '2025-03-17'),
(27, 7, 3, 2250.00, '2025-03-20'),
(28, 8, 4, 1350.00, '2025-03-23'),
(29, 9, 5, 2550.00, '2025-03-26'),
(30, 10, 6, 1850.00, '2025-03-29'),
(31, 1, 1, 2150.00, '2025-04-02'),
(32, 2, 2, 1750.00, '2025-04-05'),
(33, 3, 3, 1650.00, '2025-04-08'),
(34, 4, 4, 1950.00, '2025-04-11'),
(35, 5, 5, 2050.00, '2025-04-14'),
(36, 6, 6, 2250.00, '2025-04-17'),
(37, 7, 1, 2350.00, '2025-04-20'),
(38, 8, 2, 1800.00, '2025-04-23'),
(39, 9, 3, 1700.00, '2025-04-26'),
(40, 10, 4, 2000.00, '2025-04-29'),
(41, 1, 5, 2200.00, '2025-05-03'),
(42, 2, 6, 1650.00, '2025-05-07'),
(43, 3, 1, 2250.00, '2025-05-11'),
(44, 4, 2, 1800.00, '2025-05-15'),
(45, 5, 3, 1900.00, '2025-05-19'),
(46, 6, 4, 2000.00, '2025-05-23'),
(47, 7, 5, 2400.00, '2025-05-27'),
(48, 8, 6, 2450.00, '2025-05-31'),
(49, 9, 1, 2600.00, '2025-06-04'),
(50, 10, 2, 2050.00, '2025-06-08'),
(51, 1, 3, 1550.00, '2025-06-12'),
(52, 2, 4, 1850.00, '2025-06-16'),
(53, 3, 5, 1950.00, '2025-06-20'),
(54, 4, 6, 1900.00, '2025-06-24'),
(55, 5, 1, 2000.00, '2025-07-01'),
(56, 6, 2, 2100.00, '2025-07-05'),
(57, 7, 3, 2200.00, '2025-07-09'),
(58, 8, 4, 2300.00, '2025-07-13'),
(59, 9, 5, 2350.00, '2025-07-17'),
(60, 10, 6, 2450.00, '2025-08-01');

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    CategoryID INT,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2)
);
go
INSERT INTO Products (ProductID, CategoryID, ProductName, Price) VALUES
(1, 1, 'Laptop', 1000.00),
(2, 1, 'Smartphone', 800.00),
(3, 2, 'Tablet', 500.00),
(4, 2, 'Monitor', 300.00),
(5, 3, 'Headphones', 150.00),
(6, 3, 'Mouse', 25.00),
(7, 4, 'Keyboard', 50.00),
(8, 4, 'Speaker', 200.00),
(9, 5, 'Smartwatch', 250.00),
(10, 5, 'Camera', 700.00);
