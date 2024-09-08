-------------------------------------------------------------------------
-- Лабораторная 4  -- Кузнецов Д.А -- БИВТ-20-7 -------------------------
-------------------------------------------------------------------------
select  C.CompanyName, A.AddressLine1, A.City, 'Shipping' as AddressType
from SalesLT.Customer C
inner join SalesLT.CustomerAddress CA on CA.CustomerID = C.CustomerID
inner join SalesLT.Address A on A.AddressID = CA.AddressID
where CA.AddressType = 'Shipping'
union
select C.CompanyName, A.AddressLine1, A.City, 'Billing' as AddressType
from SalesLT.Customer C
inner join SalesLT.CustomerAddress CA on CA.CustomerID = C.CustomerID
inner join SalesLT.Address A on A.AddressID = CA.AddressID
where CA.AddressType = 'Main Office'
order by AddressType, CompanyName
-------------------------------------------------------------------------
-------------------------------------------------------------------------
select  C.CompanyName
from SalesLT.Customer C
inner join SalesLT.CustomerAddress CA on CA.CustomerID = C.CustomerID
inner join SalesLT.Address A on A.AddressID = CA.AddressID
where CA.AddressType = 'Main Office'
except
select  C.CompanyName
from SalesLT.Customer C
inner join SalesLT.CustomerAddress CA on CA.CustomerID = C.CustomerID
inner join SalesLT.Address A on A.AddressID = CA.AddressID
where CA.AddressType = 'Shipping'
-------------------------------------------------------------------------
-------------------------------------------------------------------------
select  C.CompanyName
from SalesLT.Customer C
inner join SalesLT.CustomerAddress CA on CA.CustomerID = C.CustomerID
inner join SalesLT.Address A on A.AddressID = CA.AddressID
where CA.AddressType = 'Main Office'
intersect
select  C.CompanyName
from SalesLT.Customer C
inner join SalesLT.CustomerAddress CA on CA.CustomerID = C.CustomerID
inner join SalesLT.Address A on A.AddressID = CA.AddressID
where CA.AddressType = 'Shipping'
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------