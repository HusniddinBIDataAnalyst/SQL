create database sql_2_hw17
use sql_2_hw17

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

1.
with full_r as(
select distinct r2.Region, r3.Distributor from #RegionSales as r2 cross join (Select distinct Distributor from #RegionSales) as r3
)
select full_r.Region, full_r.Distributor,coalesce(r1.Sales, 0) as Sales from full_r left join #RegionSales as r1 on r1.Region = full_r.Region and full_r.Distributor = r1.Distributor
order by full_r.Region, full_r.Distributor;

2.
with five_reports as (
select managerid from Employee
group by managerid
having count(managerid)>=5
)
select e.name from Employee as e
join five_reports on five_reports.managerid = e.id

3.
with hundred_units as (
select product_id, sum(unit) as total from Orders
where month(order_date) = 2
group by month(order_date), product_id
having sum(unit)>=100
)
select p.product_name, hundred_units.total from Products as p
join hundred_units on hundred_units.product_id = p.product_id

4.
with max_vendor as(
select CustomerID, max(Count) as Max1, Vendor from Orders
group by CustomerID, Vendor
),
max_vendor2 as(
select max_vendor.CustomerID,max(max_vendor.Max1) as Max2 from max_vendor
group by max_vendor.CustomerID
)
select o.CustomerID, o.Vendor from Orders as o
join max_vendor2 on max_vendor2.CustomerID = o.CustomerID and max_vendor2.Max2 = o.Count

5.
DECLARE @Check_Prime INT = 91
declare @a int = 0
declare @i int = 0
IF @Check_Prime <= 1
BEGIN
print 'This number is not prime'    
END
else
begin
while @Check_Prime>@i
begin
set @i = @i +1
if @Check_Prime % @i = 0
begin
set @a = @a+1
end
end
if @a > 2
begin
print 'This number is not prime'
end
else
begin
print 'This number is prime'
end
end;

6.
WITH LocationSignalCounts AS (
    SELECT
        Device_id,
        Locations,
        COUNT(*) AS signals_at_location
    FROM
        Device
    GROUP BY
        Device_id,
        Locations
),
RankedLocations AS (
    SELECT
        Device_id,
        Locations AS max_signal_location,
        ROW_NUMBER() OVER (PARTITION BY Device_id ORDER BY signals_at_location DESC, Locations ASC) AS rn
    FROM
        LocationSignalCounts
),
DeviceSummary AS (
    SELECT
        Device_id,
        COUNT(DISTINCT Locations) AS no_of_location,
        SUM(signals_at_location) AS no_of_signals
    FROM
        LocationSignalCounts
    GROUP BY
        Device_id
)
SELECT
    ds.Device_id,
    ds.no_of_location,
    rl.max_signal_location,
    ds.no_of_signals
FROM
    DeviceSummary AS ds
JOIN
    RankedLocations AS rl ON ds.Device_id = rl.Device_id
WHERE
    rl.rn = 1
ORDER BY
    ds.Device_id;

7.
with avg_sal as (
select avg(Salary) as avg_s, DeptID from Employee1
group by DeptID
)
select e.EmpID, e.EmpName, e.Salary from Employee1 as e
join avg_sal on e.DeptID = avg_sal.DeptID and avg_sal.avg_s <= e.Salary
order by e.EmpID

8.
with complete_table as (
select t.TicketID,count(t.Number) as count_winning, 
case 
when count(t.Number) = (select count(number) from WinningNumbers) then 100 
when count(t.Number) < (select count(number) as count_winning from WinningNumbers) then 10
else 0 end as Prize 
from Tickets as t
join WinningNumbers as w on t.Number = w.Number
group by t.TicketID
)
select concat(sum(complete_table.Prize),'$') as TotalWin from complete_table

9.
WITH UserDailyPlatformActivity AS (
    SELECT
        User_id,
        Spend_date,
        SUM(Amount) AS DailyUserAmount,
        MAX(CASE WHEN Platform = 'Mobile' THEN 1 ELSE 0 END) AS HasMobileSpend,
        MAX(CASE WHEN Platform = 'Desktop' THEN 1 ELSE 0 END) AS HasDesktopSpend
    FROM
        Spending
    GROUP BY
        User_id,
        Spend_date
),
CategorizedUserSpend AS (
    SELECT
        Spend_date,
        User_id,
        DailyUserAmount,
        CASE
            WHEN HasMobileSpend = 1 AND HasDesktopSpend = 1 THEN 'Both'
            WHEN HasMobileSpend = 1 THEN 'Mobile'
            WHEN HasDesktopSpend = 1 THEN 'Desktop'
            ELSE 'Unknown'
        END AS PlatformCategory
    FROM
        UserDailyPlatformActivity
),
AggregatedCategorySpend AS (
    SELECT
        Spend_date,
        PlatformCategory AS Platform,
        SUM(DailyUserAmount) AS Total_Amount,
        COUNT(DISTINCT User_id) AS Total_users
    FROM
        CategorizedUserSpend
    GROUP BY
        Spend_date,
        PlatformCategory
),
AllDatePlatforms AS (
    SELECT
        ds.Spend_date,
        ap.Platform
    FROM (SELECT DISTINCT Spend_date FROM Spending) AS ds
    CROSS JOIN (VALUES ('Mobile'), ('Desktop'), ('Both')) AS ap(Platform)
)
SELECT
    ROW_NUMBER() OVER (ORDER BY adp.Spend_date,
                      CASE adp.Platform WHEN 'Mobile' THEN 1 WHEN 'Desktop' THEN 2 WHEN 'Both' THEN 3 END) AS Row,
    adp.Spend_date,
    adp.Platform,
    ISNULL(acs.Total_Amount, 0) AS Total_Amount,
    ISNULL(acs.Total_users, 0) AS Total_users
FROM
    AllDatePlatforms AS adp
LEFT JOIN
    AggregatedCategorySpend AS acs ON adp.Spend_date = acs.Spend_date AND adp.Platform = acs.Platform
ORDER BY
    adp.Spend_date,
    CASE adp.Platform
        WHEN 'Mobile' THEN 1
        WHEN 'Desktop' THEN 2
        WHEN 'Both' THEN 3
    END;

10.
with table1 as(
select Product, 1 as CurrentCount,1 as TerminationNum,Quantity from Grouped
union all
select Product, CurrentCount, TerminationNum+1, Quantity from table1
where TerminationNum < Quantity
)
select Product, CurrentCount as Quantity from table1
order by Product asc, TerminationNum asc

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@






DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);



--2 datasi
CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);


-- 3 datasi

CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);



-- 4 datasi

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
GO
INSERT INTO Orders VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

--5 data
-- homeworkda berilmagan


-- 6
CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
go
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');

-- 7 data
CREATE TABLE Employee1 (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
go
INSERT INTO Employee1 VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

-- 8 data
-- berilmagan , kulrangda yozilgan


-- 9 data

CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
go
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);

-- 10
DROP TABLE IF EXISTS Grouped;
CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
go
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2);
