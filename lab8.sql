-------------------------------------------------------------------------
-- Лабораторная 8  -- Кузнецов Д.А -- БИВТ-20-7 -------------------------
-------------------------------------------------------------------------
select A.CountryRegion,
       A.StateProvince,
       sum(SOH.TotalDue) Revenue
from SalesLT.Address A
         inner join SalesLT.CustomerAddress CA ON A.AddressID = CA.AddressID
         inner join SalesLT.Customer C ON CA.CustomerID = C.CustomerID
         inner join SalesLT.SalesOrderHeader SOH ON C.CustomerID = SOH.CustomerID
group by rollup (A.CountryRegion, A.StateProvince)
order by A.CountryRegion, A.StateProvince;
-------------------------------------------------------------------------
select case
           when (grouping_id(A.CountryRegion, A.StateProvince)) = 0 then A.StateProvince + ' subtotal'
           when (grouping_id(A.CountryRegion, A.StateProvince)) = 1 then A.CountryRegion + ' subtotal' -- можно через choose =)
           when (grouping_id(A.CountryRegion, A.StateProvince)) = 3 then 'Total'
           end           Level,
       A.CountryRegion,
       A.StateProvince,
       sum(SOH.TotalDue) Revenue
from SalesLT.Address A
         inner join SalesLT.CustomerAddress CA ON A.AddressID = CA.AddressID
         inner join SalesLT.Customer C ON CA.CustomerID = C.CustomerID
         inner join SalesLT.SalesOrderHeader SOH ON C.CustomerID = SOH.CustomerID
group by grouping sets (A.CountryRegion, A.StateProvince) -- rollup (A.CountryRegion, A.StateProvince)
order by A.CountryRegion, A.StateProvince;
---------------------------------------------------------------------------
select case
           when (grouping_id(A.CountryRegion, A.StateProvince, A.City)) = 1 then A.StateProvince + ' Subtotal'
           when (grouping_id(A.CountryRegion, A.StateProvince, A.City)) = 3 then A.CountryRegion + ' Subtotal'
           when (grouping_id(A.CountryRegion, A.StateProvince, A.City)) = 7 then 'Total'
           else A.City + ' Subtotal'
           end Level,
       A.CountryRegion,
       A.StateProvince,
       A.City,
       sum(SOH.TotalDue) Revenue
from SalesLT.Address A
         inner join SalesLT.CustomerAddress CA ON A.AddressID = CA.AddressID
         inner join SalesLT.Customer C ON CA.CustomerID = C.CustomerID
         inner join SalesLT.SalesOrderHeader SOH ON C.CustomerID = SOH.CustomerID
group by rollup (A.CountryRegion, A.StateProvince, A.City)
order by A.CountryRegion, A.StateProvince, A.City;
----------------------------------------------------------------------------
----------------------------------------------------------------------------
select * from
(select C.CompanyName, sum(SOD.LineTotal) Sum, CAT.ParentProductCategoryName Category
from SalesLT.Customer C
inner join SalesLT.SalesOrderHeader SOH on C.CustomerID = SOH.CustomerID
inner join SalesLT.SalesOrderDetail SOD on SOH.SalesOrderID = SOD.SalesOrderID
inner join SalesLT.Product P on P.ProductID = SOD.ProductID
inner join SalesLT.vGetAllCategories CAT on CAT.ProductCategoryID = P.ProductCategoryID
group by CAT.ParentProductCategoryName, C.CompanyName) SLS
pivot ( sum(Sum) for SLS.Category in ([Bikes], [Accessories], [Clothing])) as PVT;