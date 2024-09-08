-------------------------------------------------------------------------
-- Лабораторная 9  -- Егорова А.С. -- БИВТ-20-7 -------------------------
-------------------------------------------------------------------------
insert into SalesLT.Product (Name, ProductNumber, Color, StandardCost, ListPrice, Size, Weight, ProductCategoryID, ProductModelID, SellStartDate, SellEndDate, DiscontinuedDate, ThumbNailPhoto, ThumbnailPhotoFileName)
values ('LED Lights', 'LT-L123', null, 2.56, 12.99, default, default, 37, default, current_timestamp, null, null, null, null)
select scope_identity()
select * from SalesLT.Product where ProductID = scope_identity()
-------------------------------------------------------------------------
insert into SalesLT.ProductCategory (ParentProductCategoryID, Name)
values (4,'Bells and Horns')
insert into SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
values ('Bicycle Bell', 'BB-RING', 2.47, 4.99, scope_identity(), current_timestamp),
       ('Bicycle Horn', 'BB-PARP', 1.29, 3.75, scope_identity(), current_timestamp)
select * from  SalesLT.Product P inner join SalesLT.ProductCategory PC on P.ProductCategoryID = PC.ProductCategoryID
where P.ProductCategoryID in (select ProductCategoryID from SalesLT.Product where ProductID = scope_identity())
---------------------------------------------------------------------------
---------------------------------------------------------------------------
update SalesLT.Product
set ListPrice = ListPrice + ListPrice * 0.1
where ProductCategoryID = (select ProductCategoryID from SalesLT.ProductCategory where Name = 'Bells and Horns')
----------------------------------------------------------------------------
update SalesLT.Product
set DiscontinuedDate = current_timestamp
where ProductCategoryID = 37 and ProductNumber != 'LT-L123'
----------------------------------------------------------------------------
----------------------------------------------------------------------------
delete from SalesLT.Product where ProductCategoryID = (select ProductCategoryID from SalesLT.ProductCategory where Name = 'Bells and Horns')
delete from SalesLT.ProductCategory where Name = 'Bells and Horns'
