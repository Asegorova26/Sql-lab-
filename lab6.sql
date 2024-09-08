-------------------------------------------------------------------------
-- Лабораторная 6  -- Егорова А.С.-- БИВТ-20-7 -------------------------
-------------------------------------------------------------------------
select P.ProductID, P.Name, P.ListPrice
from SalesLT.Product P
where P.ListPrice > (select avg(ListPrice) from SalesLT.Product)
-------------------------------------------------------------------------
select P.ProductID, P.Name, P.ListPrice
from SalesLT.Product P
where P.ListPrice > 100 and P.ProductID in (select ProductID
                                            from SalesLT.SalesOrderDetail
                                            where UnitPrice < 100)
-------------------------------------------------------------------------
select P.ProductID, P.Name, P.StandardCost, P.ListPrice, A.AvgSellingPrice
from SalesLT.Product P
outer apply (select avg(SOD.UnitPrice) AvgSellingPrice
             from SalesLT.SalesOrderDetail SOD
             where SOD.ProductID = P.ProductID) A
where P.StandardCost > A.AvgSellingPrice
-------------------------------------------------------------------------
-------------------------------------------------------------------------
select SOH.SalesOrderID, SOH.CustomerID, CI.FirstName, CI.LastName, SOH.TotalDue
from SalesLT.SalesOrderHeader SOH
outer apply dbo.ufnGetCustomerInformation(SOH.CustomerID) CI
order by SOH.SalesOrderID
-------------------------------------------------------------------------
select CA.CustomerID, CI.FirstName, CI.LastName, A.AddressLine1, A.City
from SalesLT.Address A
inner join SalesLT.CustomerAddress CA on CA.AddressID = A.AddressID
outer apply dbo.ufnGetCustomerInformation(CA.CustomerID) CI
order by CA.CustomerID
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------
