CREATE DATABASE PhoneMarket
GO
USE PhoneMarket

-- Таблица Моделей товара (телефона) 
CREATE TABLE dbo.ProductModel 
(
	ProductModelID INT PRIMARY KEY NOT NULL IDENTITY,	
	Name NVARCHAR(32) NOT NULL
)

INSERT INTO ProductModel VALUES ('Nokia'),( 'Apple'),('Samsung'),('Huawei')

-- Таблица Товаров (телефонов) и их хар-ки
CREATE TABLE dbo.Product 
(
	ProductID INT PRIMARY KEY NOT NULL IDENTITY,
	ProductModelID INT FOREIGN KEY (ProductModelID) REFERENCES ProductModel(ProductModelID) ON DELETE CASCADE NOT NULL ,
	Name NVARCHAR(50) NOT NULL,
	Color NVARCHAR(50) NULL,
	Price INT NOT NULL
)


INSERT INTO Product VALUES 
(1,'3310','black',1000),
(2,'Iphone 8','white',10000),
(1,'Lunia','black',1000),
(2,'Iphone 10','white',15000),
(3,'Galaxy A71','black',1000),
(2,'Iphone 12','white',20000),
(4,'p40','white',20000)




CREATE TABLE dbo.Warehouse
(
	WarehouseID INT NOT NULL PRIMARY KEY IDENTITY,
	ProductID INT FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON DELETE CASCADE NOT NULL,
	Quantity INT NOT NULL DEFAULT 0
)

INSERT INTO Warehouse VALUES
(1,20),
(2,11),
(3,20),
(4,14),
(5,6)



-- Таблица Поставщиков
CREATE TABLE dbo.ProviderCompany
(
	ProviderCompanyID INT PRIMARY KEY IDENTITY NOT NULL,
	CompanyName NVARCHAR(50) NOT NULL,
	Phone NVARCHAR(20) NOT NULL Check( Phone like ('+7([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')) UNIQUE
)

INSERT INTO ProviderCompany VALUES
('МобильникиРу','+7(999)880-34-34'),
('ReStore','+7(999)452-00-04'),
('Связной','+7(999)275-02-00'),
('Днс','+7(999)876-50-02'),
('Ситилинк','+7(999)426-45-35'),
('Мвидео','+7(999)112-54-75')

-- Таблица Доставки от поставщиков
CREATE TABLE dbo.SupplyDetail
(
	SupplyDetailID INT PRIMARY KEY IDENTITY NOT NULL,
	WarehouseID INT FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID) ON DELETE CASCADE NOT NULL,
	ProviderCompanyID INT FOREIGN KEY (ProviderCompanyID) REFERENCES ProviderCompany(ProviderCompanyID) ON DELETE CASCADE NOT NULL ,
	SupplyQuantity INT NOT NULL DEFAULT 10,
	SupplyDate DATETIME NOT NULL DEFAULT GETDATE(),
	Status NVARCHAR(70) NOT NULL CHECK (Status IN ('Посылка в пути','Посылка получена')) DEFAULT  'Посылка в пути' 
)

-- Область
CREATE TABLE dbo.Region
(
	RegionID INT NOT NULL PRIMARY KEY IDENTITY,
	Name NVARCHAR(100) NOT NULL
)

INSERT INTO dbo.Region VALUES 
('Московская область'),
('Волгоградская область'),
('Краснодарский край')

--Город
CREATE TABLE dbo.City
(
	CityID INT NOT NULL PRIMARY KEY IDENTITY,
	RegionID INT NOT NULL FOREIGN KEY (RegionID) REFERENCES Region(RegionID),
	Name NVARCHAR(100) NOT NULL
)

INSERT INTO dbo.City VALUES 
(1,'Москва'),
(2,'Волгоград'),
(2,'Волжский'),
(3,'Кореновск')

-- Адрес
CREATE TABLE dbo.Address
(
	AddressID INT NOT NULL PRIMARY KEY IDENTITY,
	CityID INT NOT NULL FOREIGN KEY (CityID) REFERENCES City(CityID),
	AddressLine NVARCHAR(100) NOT NULL
)

INSERT INTO dbo.Address VALUES
(1,'ул. Автозаводский 1-й Проезд, дом 53, квартира 190'),
(1,'ул. Черкизовская 3-я, дом 7, квартира 275'),
(1,'ул. Писемского, дом 65, квартира 38'),
(1,'ул. Митинский 2-й Переулок, дом 15, квартира 224'),
(1,'ул. Открытое Шоссе, дом 35, квартира 108'),
(1,'ул. Новые Сады 5-я, дом 41, квартира 291'),
(2,'ул. Литовский Бульвар, дом 36, квартира 11'),
(2,'ул. Кожевнический 2-й Переулок, дом 40, квартира 198'),
(3,'ул. Нагатинский Проезд, дом 61, квартира 92'),
(1,'ул. Дальний Переулок, дом 96, квартира 21'),
(1,'ул. Глебовский Переулок, дом 63, квартира 61'),
(1,'ул. Никольская, дом 91, квартира 264'),
(1,'ул. Паршина, дом 8, квартира 221')

--Адреса поставщиков
CREATE TABLE dbo.ProviderAddress
(
	ProviderAddressID INT PRIMARY KEY NOT NULL IDENTITY,
	ProviderCompanyID INT FOREIGN KEY (ProviderCompanyID) REFERENCES ProviderCompany(ProviderCompanyID) ON DELETE CASCADE NOT NULL,
	AddressID INT NOT NULL FOREIGN KEY (AddressID) REFERENCES Address(AddressID),
	PostalCode INT NOT NULL
)

INSERT INTO dbo.ProviderAddress VALUES
(1,1,117312),
(2,2,654835),
(3,3,243562),
(4,4,124353),
(5,5,124723),
(6,6,574323)

--Телефоны поставщиков
CREATE TABLE dbo.ProviderCompanyProduct
(
	ProviderProductID INT NOT NULL PRIMARY KEY IDENTITY,
	ProductID INT FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON DELETE CASCADE NOT NULL,
	ProviderCompanyID INT FOREIGN KEY (ProviderCompanyID) REFERENCES ProviderCompany(ProviderCompanyID) ON DELETE CASCADE NOT NULL ,
	Price INT NOT NULL
)

INSERT INTO dbo.ProviderCompanyProduct VALUES
(1, 1,100),
(1, 2,234),
(2, 1,99),
(2, 1,513),
(3, 2,2135),
(3, 1,4623),
(4, 1,4356),
(5, 2,2345),
(6, 1,341),
(7, 2,432),
(6, 4,2124),
(7, 3,654)


CREATE TABLE dbo.Shop 
(
	ShopID INT NOT NULL PRIMARY KEY IDENTITY,
	Name NVARCHAR(200) NOT NULL,
	AddressID INT NOT NULL FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
)

INSERT INTO Shop VALUES
('Связной', 3),
('Мвидео', 4)

CREATE TABLE dbo.StoreWarehouse
(
	StoreWarehouseID INT NOT NULL PRIMARY KEY IDENTITY,
	ShopID INT FOREIGN KEY (ShopID) REFERENCES Shop(ShopID) ON DELETE CASCADE NOT NULL,
	ProductID INT FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON DELETE CASCADE NOT NULL,
	Quantity INT NOT NULL DEFAULT 0,
)

INSERT INTO StoreWarehouse VALUES
(1,1,1),
(1,2,10),
(2,2,4)

CREATE TABLE dbo.Sale
(
	SaleID INT NOT NULL PRIMARY KEY IDENTITY,
	ProductID INT FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON DELETE CASCADE NOT NULL,
	DiscountPercent INT NOT NULL DEFAULT 0
)	