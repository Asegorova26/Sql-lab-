-------------------------------------------------------------------------
-- Лабораторная 5  -- Кузнецов Д.А -- БИВТ-20-7 -------------------------
-------------------------------------------------------------------------
select P.ProductID, upper(P.Name) ProductName,
       round(P.Weight, 0) ApproxWeight,
       year(P.SellStartDate) SellStartYear,
       datename(month,P.SellStartDate) SellStartMonth,
       left(P.ProductNumber, 2) ProductType
from SalesLT.Product P
where isnumeric(P.Size) = 1;
-------------------------------------------------------------------------
-------------------------------------------------------------------------
select C.CompanyName, SOH.TotalDue Revenue,
       rank() over (order by SOH.TotalDue desc) RankByRevenue
from SalesLT.Customer C
left join SalesLT.SalesOrderHeader SOH on SOH.CustomerID = C.CustomerID -- или inner если null'овый revenue не нужен
-------------------------------------------------------------------------
-------------------------------------------------------------------------
select P.Name,
       sum(SOD.LineTotal) TotalRevenue
from SalesLT.Product P
inner join SalesLT.SalesOrderDetail SOD on SOD.ProductID = P.ProductID
where P.StandardCost > 1000
group by P.Name
having sum(SOD.LineTotal) > 20000
order by TotalRevenue desc
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------
select datediff(day,getdate(), '01.01.2022')