-------------------------------------------------------------------------
-- Лабораторная 7  -- Егорова А.С.-- БИВТ-20-7 -------------------------
-------------------------------------------------------------------------
select P.Name ProductName, PMCD.Name ProductModel, PMCD.Summary
from SalesLT.Product P
inner join SalesLT.vProductModelCatalogDescription PMCD on PMCD.ProductModelID = P.ProductModelID
-------------------------------------------------------------------------
declare @Colors table (Color NVARCHAR(50))
insert into @Colors
select distinct P.Color from SalesLT.Product P where Color is not null
select P.Name ProductName, P.Color
from SalesLT.Product P
cross join @Colors C
where C.Color = P.Color
--------------------------------------------------------------------------
create table #Sizes (Size NVARCHAR(50) collate SQL_Latin1_General_CP1_CI_AS)
---
insert into #Sizes
select distinct P.Size from SalesLT.Product P where P.Size is not null
---
select P.Name ProductName, P.Size
from SalesLT.Product P
where P.Size in (select * from #Sizes S)
order by P.Size desc
--------------------------------------------------------------------------
select P.ProductID, P.Name, GAC.ParentProductCategoryName ParentCategory,  GAC.ProductCategoryName Category
from SalesLT.Product P
inner join dbo.ufnGetAllCategories() GAC on GAC.ProductCategoryID = P.ProductCategoryID
order by ParentCategory, Category desc
-------------------------------------------------------------------------
-------------------------------------------------------------------------
select CompanyContact, sum(TotalDue) as Revenue from
(select (CompanyName + ' ('+ FirstName + ' ' + LastName + ')') as CompanyContact, TotalDue
from SalesLT.Customer C
join SalesLT.SalesOrderHeader as SOH on C.CustomerID = SOH.CustomerID) CC
group by CompanyContact order by CompanyContact
-------------------------------------------------------------------------
with cte_company (CompanyContact, TotalDue)
as (
    select (C.CompanyName + ' ('+ C.FirstName + ' ' + C.LastName + ')') as CompanyContact, SOH.TotalDue
    from SalesLT.Customer C
    join SalesLT.SalesOrderHeader SOH on SOH.CustomerID = C.CustomerID
    join SalesLT.SalesOrderDetail SOD on SOH.SalesOrderID = SOD.SalesOrderID
    )
select CompanyContact, sum(TotalDue) as Revenue from cte_company
group by CompanyContact order by CompanyContact

