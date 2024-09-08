-------------------------------------------------------------------------
-- Лабораторная 3  -- Кузнецов Д.А -- БИВТ-20-7 -------------------------
-------------------------------------------------------------------------
select CST.CompanyName, SOH.SalesOrderID, SOH.TotalDue
from SalesLT.Customer as CST
join SalesLT.SalesOrderHeader as SOH on CST.CustomerID = SOH.CustomerID
-------------------------------------------------------------------------
select CST.CompanyName, SOH.SalesOrderID, SOH.TotalDue, AddressLine1, AddressLine2, City, StateProvince,PostalCode, CountryRegion
from SalesLT.Customer as CST
join SalesLT.SalesOrderHeader as SOH on CST.CustomerID = SOH.CustomerID
inner join SalesLT.CustomerAddress as CA on SOH.CustomerID = CA.CustomerID
inner join SalesLT.Address as A on CA.AddressID = A.AddressID
where CA.AddressType = 'Main Office'
-------------------------------------------------------------------------
-------------------------------------------------------------------------
select C.CompanyName, C.FirstName, C.LastName, SOH.SalesOrderID, SOH.TotalDue
from SalesLT.SalesOrderHeader as SOH
    right join SalesLT.Customer as C on C.CustomerID = SOH.CustomerID
order by TotalDue DESC;
-------------------------------------------------------------------------
select C.CustomerID, C.CompanyName, C.FirstName, C.LastName, C.Phone, CA.AddressID
from SalesLT.Customer as C
left join SalesLT.CustomerAddress as CA on C.CustomerID = CA.CustomerID
where AddressID is null
-------------------------------------------------------------------------
select C.CustomerID, SOD.ProductID
from SalesLT.Customer as C
left outer join SalesLT.SalesOrderHeader as SOH on SOH.CustomerID = C.CustomerID
left outer join SalesLT.SalesOrderDetail as SOD on SOD.SalesOrderID = SOH.SalesOrderID
where ProductID is null
union
select SOH.CustomerID, P.ProductID
from SalesLT.Product as P
left outer join SalesLT.SalesOrderDetail as SOD on SOD.ProductID = P.ProductID
left join SalesLT.SalesOrderHeader as SOH on SOD.SalesOrderID = SOH.SalesOrderID
where SOD.SalesOrderID is null
--------------------------------------------------------------------------
select P.ProductID, c.CustomerID
from SalesLT.Customer as c
full outer join SalesLT.SalesOrderHeader as SOH on SOH.CustomerID = c.CustomerID
full outer join SalesLT.SalesOrderDetail as SOD on SOD.SalesOrderID = SOH.SalesOrderID
full outer join SalesLT.Product as P on SOD.ProductID = P.ProductID
where SOH.SalesOrderID is null
--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------