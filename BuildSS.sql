IF NOT EXISTS (SELECT * FROM sys.databases
              WHERE name = N'DWCoffeeMerchant')
              CREATE DATABASE DWCoffeeMerchant
GO
USE DWCoffeeMerchant
GO
 
-- Drop Fact Table
IF EXISTS(
       SELECT *
       FROM sys.tables
       WHERE name = N'FactSales'
       )
       DROP TABLE [FactSales];
--Drop Inventory
IF EXISTS(
  SELECT *
  FROM sys.tables
  WHERE name = N'dimInventory'
  )
  DROP TABLE dimInventory;
 
--Drop State
IF EXISTS(
       SELECT *
       FROM sys.tables
       WHERE name = N'dimState'
       )
       DROP TABLE [dimState];
--
--Drop Employee
--
IF EXISTS(
       SELECT *
       FROM sys.tables
       WHERE name = N'dimEmployee'
       )
       DROP TABLE dimEmployee;
--
--
--Drop Dates
--
IF EXISTS(
       SELECT *
       FROM sys.tables
       WHERE name = N'dimDates'
       )
       DROP TABLE dimDates;
--
--
--Drop Customer
IF EXISTS(
       SELECT *
       FROM sys.tables
       WHERE name = N'dimCustomer'
       )
       DROP TABLE [dimCustomer];
 
GO
--
--Create Inventory
CREATE TABLE dimInventory (
      Inventory_SK INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
         Inventory_AK INT NOT NULL,
         Inventory_Name nvarchar(50) NOT NULL,
         ItemType nchar(1) NOT NULL
     );
GO
--
--Create State
CREATE TABLE [dbo].[dimState]
       ([State_SK] [INT] IDENTITY(1,1) NOT NULL PRIMARY KEY,
       [State_AK]   [NVARCHAR](2) NOT NULL,
       [StateName]  [NVARCHAR](25) NOT NULL,
       [Population] [INT] NOT NULL,
       [LandArea]   [INT] NOT NULL);
      
GO
--
--Create Employee
CREATE TABLE [dbo].[dimEmployee]
       ([Employee_SK] [INT] IDENTITY(1,1) NOT NULL PRIMARY KEY,
       [Employee_AK] [INT] NOT NULL,
       [EmployeeName] [NVARCHAR](60) NOT NULL, -- Would I need to do any concatenate here for both fname and lname?
       [EmployeeGender] [NVARCHAR](1) NOT NULL,
       [EmployeeBirthDate] [DATETIME] NOT NULL,
       [EmployeeHireDate] [DATETIME] NOT NULL,
       [EmployeeCommissionRate] NUMERIC (4,4) NOT NULL);
      
GO
--
--Create Dates
CREATE TABLE [dbo].[dimDates](
       [Date_SK] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
       [Date] [datetime] NOT NULL UNIQUE,
       [DateName] [nvarchar](50) NULL,
       [Month] [int] NOT NULL,
       [MonthName] [nvarchar](50) NOT NULL,
       [Quarter] [int] NOT NULL,
       [QuarterName] [nvarchar](50) NOT NULL,
       [Year] [int] NOT NULL,
       [YearName] [nvarchar](50) NOT NULL,
);
GO
--
-- Create Customer
CREATE TABLE [dbo].[dimCustomer]
       ([Customer_SK] [INT] IDENTITY (1,1) NOT NULL PRIMARY KEY,
       [Customer_AK] [INT] NOT NULL,
       [Customer_Credit_Limit] [INT] NOT NULL
       );
GO
--
--Create Fact Table
CREATE TABLE [dbo].[FactSales]
       ([Customer_SK] INT NOT NULL FOREIGN KEY ([Customer_SK]) REFERENCES [dbo].[dimCustomer] ([Customer_SK]),
       [Employee_SK] INT NOT NULL FOREIGN KEY ([Employee_SK]) REFERENCES [dbo].[dimEmployee] ([Employee_SK]),
       [Inventory_SK] INT NOT NULL FOREIGN KEY ([Inventory_SK]) REFERENCES [dbo].[dimInventory] ([Inventory_SK]),
       [State_SK] INT NOT NULL FOREIGN KEY ([State_SK]) REFERENCES [dbo].[dimState] ([State_SK]),
       [OrderDate] DATETIME NOT NULL FOREIGN KEY ([OrderDate]) REFERENCES [dbo].[dimDates] ([Date]),
       [Price] NUMERIC (6, 2) NOT NULL,
       [LineItem] INT NOT NULL,
       [OnHand] INT NOT NULL,
       [SalesQuantity] INT NOT NULL,
       [Discount] NUMERIC (4, 4) NOT NULL,
       [TaxRate] NUMERIC (7, 4) NOT NULL
CONSTRAINT [FactSales_PK] PRIMARY KEY CLUSTERED
       ( [Customer_SK] ASC,[Employee_SK] ASC, [Inventory_SK] ASC, [LineItem] ASC, [OrderDate] ASC )
)
GO
 
 