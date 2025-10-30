use northwind;

                   
-- Question 1 (Marks: 2)
-- Objective: Retrieve data using basic SELECT statements
-- List the names of all customers in the database.
-- Question Template: Display CustomerName Column

-- Write your SQL solution here
select CustomerName
from customers;


-- Question 2 (Marks: 2)
-- Objective: Apply filtering using the WHERE clause
-- Retrieve the names and prices of all products that cost less than $15.
-- Question Template: Display ProductName Column

-- Write your SQL solution here
select ProductName
from products
where price<15;

-- Question 3 (Marks: 2)
-- Objective: Use SELECT to extract multiple fields
-- Display all employees first and last names.
-- Question Template: Display FirstName, LastName Columns

-- Write your SQL solution here
select FirstName, LastName
from employees;

-- Question 4 (Marks: 2)
-- Objective: Filter data using a function on date values
-- List all orders placed in the year 1997.
-- Question Template: Display OrderID, OrderDate Columns

-- Write your SQL solution here
Select OrderID, OrderDate
from orders
where OrderDate Between '1997-01-01' and '1997-12-31';


-- Question 5 (Marks: 2)
-- Objective: Apply numeric filters
-- List all products that have a price greater than $50.
-- Question Template: Display ProductName, Price Column

-- Write your SQL solution here
select ProductName, Price
from products
where Price>50;

-- Question 6 (Marks: 3)
-- Objective: Perform multi-table JOIN operations
-- Show the names of customers and the names of the employees who handled their orders.
-- Question Template: Display CustomerName, FirstName, LastName Columns

-- Write your SQL solution here
with x1 as (
select b.FirstName, b.LastName, a.EmployeeID, a.CustomerID
from orders as a
join employees as b
on a.EmployeeID=b.EmployeeID)

select c.FirstName, c.LastName, d.CustomerName
from x1 c
join customers d
on c.CustomerID = d.CustomerID;


-- Question 7 (Marks: 3)
-- Objective: Use GROUP BY for aggregation
-- List each country along with the number of customers from that country.
-- Question Template: Display Country, CustomerCount Columns

-- Write your SQL solution here
Select country, sum(CustomerID) as Customer_Count
from customers
group by 1;

-- Question 8 (Marks: 3)
-- Objective: Group data by a foreign key relationship and apply aggregation
-- Find the average price of products grouped by category.
-- Question Template: Display CategoryName, AvgPrice Columns

-- Write your SQL solution here
select CategoryName, avg(Price) as Avg_Price
from categories a
join products b
on a.CategoryID=b.CategoryID
group by 1;

-- Question 9 (Marks: 3)
-- Objective: Use aggregation to count records per group
-- Show the number of orders handled by each employee.
-- Question Template: Display EmployeeID, OrderCount Columns

-- Write your SQL solution here
select b.EmployeeID, sum(a.orderID) as OrderCount
from orders a
join employees b
on a.EmployeeID= b.EmployeeID
group by 1;

-- Question 10 (Marks: 3)
-- Objective: Filter results using values from a joined table
-- List the names of products supplied by "Exotic Liquids".
-- Question Template: Display ProductName Column

-- Write your SQL solution here
Select b.ProductName
from suppliers a
join products b
on a.SupplierID=b.SupplierID
where SupplierName='Exotic Liquid';

-- Question 11 (Marks: 5)
-- Objective: Rank records using aggregation and sort
-- List the top 3 most ordered products (by quantity).
-- Question Template: Display ProductID, TotalOrdered Columns

-- Write your SQL solution here
select  ProductID, Sum(Quantity) as TotalOrdered
from orderdetails
group by 1;

-- Question 12 (Marks: 5)
-- Objective: Use GROUP BY and HAVING to filter on aggregates
-- Find customers who have placed orders worth more than $10,000 in total.
-- Question Template: Display CustomerName, TotalSpent Columns

-- Write your SQL solution here
with x2 as(
With x1 as(
select b.CustomerName, a.OrderID
from orders a
join customers b
on a.CustomerID=b.CustomerID)

select c.CustomerName, d.Quantity, d.ProductID
from x1 c
join Orderdetails d
on c.OrderID=d.OrderID)

Select e.CustomerName, SUM(e.Quantity * f.Price) AS TotalSpent
from x2 e
join products f
on e.ProductID = f.ProductID
group by 1
having SUM(e.Quantity * f.Price) > 10000
order by TotalSpent desc;


-- Question 13 (Marks: 5)
-- Objective: Aggregate and filter at the order level
-- Display order IDs and total order value for orders that exceed $2,000 in value.
-- Question Template: Display OrderID, OrderValue Columns

-- Write your SQL solution here
select od.OrderID,sum(od.Quantity * p.Price) as OrderValue
from OrderDetails od
join Products p
    on od.ProductID = p.ProductID
group by od.OrderID
having sum(od.Quantity * p.Price) > 2000
order by OrderValue desc;


-- Question 14 (Marks: 5)
-- Objective: Use subqueries in HAVING clause
-- Find the name(s) of the customer(s) who placed the largest single order (by value).
-- Question Template: Display CustomerName, OrderID, TotalValue Column

-- Write your SQL solution here
with OrderTotals as (
    select o.OrderID,c.CustomerName,sum(od.Quantity * p.Price) as TotalValue
    from Orders o
    join Customers c
        on o.CustomerID = c.CustomerID
    join OrderDetails od
        on o.OrderID = od.OrderID
    join Products p
        on od.ProductID = p.ProductID
    group by o.OrderID, c.CustomerName
)
select CustomerName,OrderID,TotalValue
from OrderTotals
where TotalValue = (
    select max(TotalValue)
    from OrderTotals
);


-- Question 15 (Marks: 5)
-- Objective: Identify records using NOT IN with subquery
-- Get a list of products that have never been ordered.
-- Question Template: Display ProductName Columns

-- Write your SQL solution here
select ProductName
from Products
where ProductID not in (
    select distinct ProductID
    from OrderDetails
);