=======================
Question №1: Define the following terms: data, database, relational database, and table.
Answer №1:

Data is raw, unprocessed facts or information, which can be in various forms like numbers, text, images, etc.

Database is an organized collection of data that is stored and managed to allow easy access, retrieval, and manipulation.

Relational Database is a type of database that stores data in structured tables with defined relationships between them, typically using rows and columns.

Table is a structured set of data organized in rows and columns within a database, where each row represents a record and each column represents a field or attribute.

===========================================================================================================================================

Question №2: List five key features of SQL Server.
Answer №2:

01. Relational Database Management System (RDBMS): SQL Server organizes data into tables with relationships, supporting complex queries using SQL.

02. Security: Provides robust security features like authentication, encryption, role-based access control, and auditing to protect data.

03. High Availability and Disaster Recovery: Supports features like Always On Availability Groups, database mirroring, and backups to ensure data availability and recovery.

04. Integration Services (SSIS): Offers tools for data integration, transformation, and migration between different data sources.

05. Business Intelligence (BI) Tools: Includes built-in support for reporting (SSRS), analysis (SSAS), and data mining to help analyze and visualize data.


======================================================================================================================================================

Question №3: What are the different authentication modes available when connecting to SQL Server? (Give at least 2)
Answer №3:

Here are the two main authentication modes in SQL Server:

01. Windows Authentication:
Uses the Windows user account credentials to connect to SQL Server. It relies on Active Directory for authentication and is considered more secure because it integrates with Windows security features.

02. SQL Server Authentication:
Uses a username and password created and managed within SQL Server itself. This mode is useful when users don’t have Windows accounts or when connecting from non-Windows systems.

======================================================================================================================================================

Question №4: Create a new database in SSMS named SchoolDB.
Answer №4: Code here:

Create database SchoolDB
use SchoolDB

==================================================================

Question №5 : Write and execute a query to create a table called Students with columns: StudentID (INT, PRIMARY KEY), Name (VARCHAR(50)), Age (INT).
Answer №5: Code here:
drop table students
CREATE TABLE Students (StudentID INT primary key , Name VARCHAR(50), Age int);
select * from students
insert into students values (1, 'Ahmad', 15)


==================================================================

--Question №6 : Describe the differences between SQL Server, SSMS, and SQL.
--Answer №6: 


1. SQL Server
 What it is: The software that stores and manages your databases.
 Think of it as: A warehouse where all your data lives.

2. SSMS (SQL Server Management Studio)
 What it is: A tool you use to talk to SQL Server.
 Think of it as: A remote control or dashboard for managing your warehouse.

3. SQL (Structured Query Language)
 What it is: The language you use to ask questions or give commands to the database.
 Think of it as: The instructions or commands you type.

======================================================================================================================================================

--Question №7: Research and explain the different SQL commands: DQL, DML, DDL, DCL, TCL with examples.
--Answer №7: 

1. DQL (Data Query Language)
 What it does: Gets data from a table.

 Main command: SELECT

 Example:

sql
Копировать
Редактировать
SELECT * FROM Students;
 Show me everything from the Students table.

2. DML (Data Manipulation Language)
What it does: Changes data in the table (add, edit, delete).

 Commands:

INSERT – Add new data

UPDATE – Change existing data

DELETE – Remove data

 Examples:

sql
Копировать
Редактировать
INSERT INTO Students (name) VALUES ('John');
UPDATE Students SET name = 'Johnny' WHERE name = 'John';
DELETE FROM Students WHERE name = 'Johnny';
3. DDL (Data Definition Language)
 What it does: Creates or changes the structure of the database (like tables).

 Commands:

CREATE – Make a new table

ALTER – Change a table

DROP – Delete a table

 Examples:

sql
Копировать
Редактировать
CREATE TABLE Students (id INT, name TEXT);
ALTER TABLE Students ADD age INT;
DROP TABLE Students;
4. DCL (Data Control Language)
What it does: Gives or removes access to data.

Commands:

GRANT – Give permission

REVOKE – Take permission away

 Examples:

sql
Копировать
Редактировать
GRANT SELECT ON Students TO user1;
REVOKE SELECT ON Students FROM user1;
5. TCL (Transaction Control Language)
 What it does: Controls changes (like save or undo).

 Commands:

COMMIT – Save changes

ROLLBACK – Undo changes

SAVEPOINT – Set a point to roll back to

 Examples:

sql
Копировать
Редактировать
BEGIN;
DELETE FROM Students WHERE id = 1;
ROLLBACK;  -- undoes the delete
Quick Cheat Sheet:
Type	What it Does	Example Command
DQL	Get data	SELECT
DML	Change data	INSERT, UPDATE, DELETE
DDL	Change structure	CREATE, ALTER, DROP
DCL	Control permissions	GRANT, REVOKE
TCL	Control transactions	COMMIT, ROLLBACK

======================================================================================================================================================

--Question №8: Write a query to insert three records into the Students table.
--Answer №8: 

CREATE TABLE Students (StudentID INT primary key , Name VARCHAR(50), Age int);
select * from students
insert into students values (1, 'Ahmad', 15)



======================================================================================================================================================

--Question №9: Create a new database in SSMS named SchoolDB.
--Answer №9: Code here:

Restore AdventureWorksDW2022.bak file to your server. (write its steps to submit) You can find the database from this link :https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2022.bak
