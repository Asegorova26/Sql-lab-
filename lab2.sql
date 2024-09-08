select distinct City, StateProvince from AdventureWorksLT2014.SalesLT.Address
select top 10 percent name, Weight from SalesLT.Product order by Weight desc
select name, Weight from SalesLT.Product order by Weight desc offset 10 rows fetch next 100 rows only;
select Name, Color, Size from SalesLT.Product where ProductModelID = 1;
select Name, ProductNumber from SalesLT.Product where Color in ('black', 'red', 'white') and Size in ('S', 'M')
select productnumber,Name, ListPrice from SalesLT.Product where ProductNumber like 'BK-%';
select productnumber,Name, ListPrice from SalesLT.Product where ProductNumber like 'BK-[^R]%-[0-9][0-9]';
