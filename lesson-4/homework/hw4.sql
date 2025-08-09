
1
SELECT *
FROM Employees
ORDER BY Salary DESC
LIMIT 5;

2
SELECT DISTINCT Category
FROM Products;
3
SELECT *
FROM Products
WHERE Price > 100;
4
SELECT *
FROM Customers
WHERE FirstName LIKE 'A%';
5
SELECT *
FROM Products
ORDER BY Price ASC;

6
SELECT *
FROM Employees
WHERE Salary >= 60000
  AND Department = 'HR';

7
SELECT 
  ISNULL(Email, 'noemail@example.com') AS Email,
  *
FROM Employees;

8
SELECT *
FROM Products
WHERE Price BETWEEN 50 AND 100;

9
SELECT DISTINCT Category, ProductName
FROM Products;

10

SELECT DISTINCT Category, ProductName
FROM Products
ORDER BY ProductName DESC;

11
SELECT *
FROM Products
ORDER BY Price DESC
LIMIT 10;

12
SELECT COALESCE(FirstName, LastName) AS Name
FROM Employees;

13
SELECT DISTINCT Category, Price
FROM Products;

14
SELECT *
FROM Employees
WHERE (Age BETWEEN 30 AND 40)
   OR Department = 'Marketing';

15
SELECT *
FROM Employees
ORDER BY Salary DESC
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

16
SELECT *
FROM Products
WHERE Price <= 1000
  AND Stock > 50
ORDER BY Stock ASC;

17

SELECT *
FROM Products
WHERE ProductName LIKE '%e%';

18

SELECT *
FROM Employees
WHERE Department IN ('HR', 'IT', 'Finance');

19

SELECT *
FROM Customers
ORDER BY City ASC, PostalCode DESC;

20

SELECT TOP(5) *
FROM Products
ORDER BY SalesAmount DESC;

21

SELECT FirstName + ' ' + LastName AS FullName
FROM Employees;

22

SELECT DISTINCT Category, ProductName, Price
FROM Products
WHERE Price > 50;

23

SELECT *
FROM Products
WHERE Price < 0.1 * (SELECT AVG(Price) FROM Products);

24

SELECT *
FROM Employees
WHERE Age < 30
  AND Department IN ('HR', 'IT');

25

SELECT *
FROM Customers
WHERE Email LIKE '%@gmail.com%';

26

SELECT *
FROM Employees
WHERE Salary > ALL (
    SELECT Salary
    FROM Employees
    WHERE Department = 'Sales'
);

27


SELECT *
FROM Employees
WHERE Salary > ALL (
    SELECT Salary
    FROM Employees
    WHERE Department = 'Sales'
);



