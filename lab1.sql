select * from SalesLT.Customer
select  FirstName,MiddleName,LastName,Suffix from SalesLT.Customer
select SalesPerson, (Title + ' ' + LastName) as CustomerName, Phone from SalesLT.Customer
select (Cast(CustomerID as VARCHAR(10)) + ':' + CompanyName) as CustomerCompany from SalesLT.Customer
select (PurchaseOrderNumber + '(' + Cast(RevisionNumber as VARCHAR(10)) + ')') as OrderRevision,(CONVERT(nvarchar(30), OrderDate, 102)) as OrderDate from SalesLT.SalesOrderHeader
select (ISNULL(FirstName, '') + ' ' + ISNULL(MiddleName, '') + ' ' + ISNULL(LastName, ''))  as CustomerName from SalesLT.Customer
-- UPDATE SalesLT.CustomerSET EmailAddress = NULLWHERE CustomerID % 7 = 1;
select (COALESCE(EmailAddress, Phone))  as PrimaryCntact from SalesLT.Customer
-- UPDATE SalesLT.SalesOrderHeaderSET ShipDate = NULL WHERE SalesOrderID > 71899;
select (CONVERT(nvarchar(30), SalesOrderID, 102)+ ' ' +ISNULL(CONVERT(nvarchar(30), ShipDate, 102), 'Awaiting Shipment')) as ShippingStatus from SalesLT.SalesOrderHeader