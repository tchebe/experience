/*Đưa ra mặt hàng được bắt đầu bán vào 5-2002 và truoc do khong co don hang */
    use AdventureWorks2008
	select P.Name, P.ListPrice, P.ProductNumber
	from Production.Product P
	where P.ProductID IN (
		select ProductID
		from Sales.SalesOrderDetail SOD
		group by SOD.ProductID
		having COUNT(SalesOrderID) = 0)
	AND MONTH(P.SellStartDate) = 5
	AND YEAR(P.SellStartDate) = 2002
	
    /* cho cau lenh select vao trong from*/
	select P.ProductID, P.Name, P.ListPrice, P.ProductNumber
	from Production.Product P, (
		select ProductID
		from Sales.SalesOrderDetail SOD
		group by SOD.ProductID
		having COUNT(SalesOrderID) = 0) TG
	where P.ProductID = TG.ProductID AND
	     MONTH(P.SellStartDate) = 5 AND 
	     YEAR(P.SellStartDate) = 2002
	     
    /*Toi uu*/
    create index index_product_productID on Production.Product(ProductID)
    create index index_SalesOrderDetail_SalesOrderID on Sales.SalesOrderDetail(SalesOrderID)
/*===============================================*/
/*thông tin khách hàng có tren 10 don hang trong năm 2003 tại Paris*/
select C.CustomerID as CusID, TG.totalDue
from Sales.Customer C, (Select S.CustomerID id, S.TotalDue totalDue
	from Sales.SalesOrderHeader S, Person.Address A
	where S.SalesOrderID > 10
	and YEAR(S.OrderDate) = 2003
	and (S.BillToAddressID = A.AddressID)
	and (A.City = 'Paris')) AS TG, Person.Person P, Person.EmailAddress Email
where C.CustomerID = TG.id and C.PersonID = P.BusinessEntityID and P.BusinessEntityID = Email.BusinessEntityID
order by CusID, totalDue
/* Có bao nhiêu sản phẩm thuộc loại (Product Category) là Clothing đã đặt
gửi đến thành phố "London" trong tháng 5-2003*/
select COUNT(TG.productID) countProduct
from (select P.ProductID productID
	from Production.Product P, Production.ProductCategory PC, 
		Production.ProductSubcategory PS
	where PC.Name='Clothing' and PC.ProductCategoryID = PS.ProductCategoryID
      and PS.ProductSubcategoryID = P.ProductSubcategoryID) TG, 
      Sales.SalesOrderDetail SOD, Sales.SalesOrderHeader SOH, Person.Address A
where SOD.ProductID = TG.productID and SOD.SalesOrderID = SOH.SalesOrderID
	  and YEAR(SOH.OrderDate) = 2003 and MONTH(SOH.OrderDate) = 5 and 
	  (SOH.BillToAddressID = A.AddressID) and A.City = 'London'
