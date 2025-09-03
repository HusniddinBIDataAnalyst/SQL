CREATE database hwk2sql;
use hwk2sql;
-- ==================================================================================================================================
-- Q1 => Create a table Employees with columns: EmpID INT, Name (VARCHAR(50)), and Salary (DECIMAL(10,2)).
-- S1 => Solution
CREATE TABLE Employees (
EmpID INT,
Name VARCHAR(50),
Salary DECIMAL (10,2)
);

SELECT*FROM Employees;

-- ==================================================================================================================================

-- Q2 => Insert three records into the Employees table using different INSERT INTO approaches (single-row insert and multiple-row insert).
-- S2 => Solution

-- 1. Single-row insert (basic form):
INSERT INTO Employees (EmpID, Name, Salary)
VALUES (1, 'Alice Johnson', 60000.00);

-- 2. Another single-row insert (with column order rearranged):
INSERT INTO Employees (Name, EmpID, Salary)
VALUES ('Bob Smith', 2, 55000.50);

-- 3. Multiple-row insert (in a single statement):
INSERT INTO Employees (EmpID, Name, Salary)
VALUES 
    (3, 'Carol Davis', 72000.75),
    (4, 'David Lee', 48000.00);

	SELECT*FROM Employees;

-- ==================================================================================================================================

-- Q3 => Update the Salary of an employee to 7000 where EmpID = 1.
-- S3 => Solution
UPDATE Employees
SET Salary = 7000.00
WHERE EmpID = 1;

SELECT*FROM Employees;

-- ==================================================================================================================================

-- Q4 => Delete a record from the Employees table where EmpID = 2.
-- S4 => Solution

DELETE FROM Employees
WHERE EmpID = 2;

SELECT*FROM Employees;


-- ==================================================================================================================================

-- Q5 => Give a brief definition for difference between DELETE, TRUNCATE, and DROP.
-- S5 => Solution
Use DELETE when you want to remove specific rows.

Use TRUNCATE when you want to quickly clear all data but keep the table.

Use DROP when you want to completely remove the table from the database.


-- ==================================================================================================================================

-- Q6 => Modify the Name column in the Employees table to VARCHAR(100).
-- S6 => Solution
ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100);
SELECT*FROM Employees;

-- ==================================================================================================================================

-- Q7 => Add a new column Department (VARCHAR(50)) to the Employees table.
-- S7 => Solution

ALTER TABLE Employees
ADD Department VARCHAR(50);

SELECT*FROM Employees;

-- ==================================================================================================================================

-- Q8 => Change the data type of the Salary column to FLOAT.
-- S8 => Solution
ALTER TABLE Employees
ALTER COLUMN Salary FLOAT;


SELECT*FROM Employees;
-- ==================================================================================================================================

-- Q9 => Create another table Departments with columns DepartmentID (INT, PRIMARY KEY) and DepartmentName (VARCHAR(50)).
-- S9 => Solution
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

SELECT*FROM Employees;

-- ==================================================================================================================================

-- Q10 => Remove all records from the Employees table without deleting its structure.
-- S10 => Solution
TRUNCATE TABLE Employees;

SELECT*FROM Employees;


-- ==================================================================================================================================

-- Q11 => Insert five records into the Departments table using INSERT INTO SELECT method(you can write anything you want as data).
-- S11 => Solution
INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT 1, 'Human Resources' UNION ALL
SELECT 2, 'Finance' UNION ALL
SELECT 3, 'IT' UNION ALL
SELECT 4, 'Marketing' UNION ALL
SELECT 5, 'Sales';

SELECT*FROM Employees;

-- ==================================================================================================================================

-- Q12 => Update the Department of all employees where Salary > 5000 to 'Management'.
-- S12 => Solution
UPDATE Employees
SET Department = 'Management'
WHERE Salary < 5000;

SELECT*FROM Employees;

-- ==================================================================================================================================

-- Q13 => Write a query that removes all employees but keeps the table structure intact.
-- S13 => Solution

DELETE FROM Employees;

-- ==================================================================================================================================

-- Q14 => Drop the Department column from the Employees table.
-- S14 => Solution
ALTER TABLE Employees
DROP COLUMN Department;
SELECT*FROM Employees;

-- ==================================================================================================================================

-- Q15 => Rename the Employees table to StaffMembers using SQL commands.
-- S15 => Solution
EXEC sp_rename 'Employees', 'StaffMembers';
SELECT*FROM Employees;

-- ==================================================================================================================================

-- Q16 => Write a query to completely remove the Departments table from the database.
-- S16 => Solution
DROP TABLE Departments;
SELECT*FROM Employees;








-- ==================================================================================================================================

-- Q3 => 
-- S3 => Solution
