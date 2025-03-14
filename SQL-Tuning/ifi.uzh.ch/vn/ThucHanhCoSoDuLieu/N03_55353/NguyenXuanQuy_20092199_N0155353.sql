	/*Dua ra danh sach nhan hang ket thuc ban ke tu thang 5 nam 2002,
	 ma truoc do khong co don hang*/
	use AdventureWorks2008
	select P.ProductID, P.Name, P.ListPrice, P.SellEndDate
	from Production.Product P
	where MONTH(P.SellEndDate)>= 5
	      AND YEAR(P.SellEndDate) >= 2002
		  AND ProductID IN ( Select ProductID from Production.Product 
		      MINUS  
				(select distinct SOD.ProductID
				from Sales.SalesOrderDetail SOD, Sales.SalesOrderHeader SOH
				where SOD.SalesOrderID = SOH.SalesOrderID AND
					  MONTH(SOH.OrderDate)<=5 AND YEAR(SOH.OrderDate) <= 2002))
	 
	
	/* Danh sach khach hang co tren 10 don hang gui toi thanh pho Pari trong 2003*/
	select TG.CustomerID, TG.SalesOrderID, TG.TotalDue
	from(
		select SOH.CustomerID, SOH.SalesOrderID, SOH.TotalDue,
				COUNT(SOH.SalesOrderID) over(partition by SOH.CustomerID) tongdonhang
		from Sales.SalesOrderHeader SOH, Person.Address A
		where SOH.ShipToAddressID = A.AddressID AND 
			  A.City = 'Paris' AND YEAR(SOH.OrderDate) = 2003) TG
       where TG.tongdonhang > 10
       
    /* Có bao nhiêu sản phẩm thuộc loại (Product Category) là Clothing đã đặt
    gửi đến thành phố "London" trong tháng 5-2003*/
		use AdventureWorks2008
		select COUNT(TG.productID) countProduct
		from (select P.ProductID productID
			from Production.Product P, Production.ProductCategory PC, 
				Production.ProductSubcategory PS
			where PC.Name='Clothing' and PC.ProductCategoryID = PS.ProductCategoryID
			  and PS.ProductSubcategoryID = P.ProductSubcategoryID) TG, 
			  Sales.SalesOrderDetail SOD, Sales.SalesOrderHeader SOH, Person.Address A
		where SOD.ProductID = TG.productID and SOD.SalesOrderID = SOH.SalesOrderID
			  and YEAR(SOH.OrderDate) = 2003 and MONTH(SOH.OrderDate) = 5 and 
			  (SOH.ShipToAddressID = A.AddressID) and A.City = 'London'
			  
    /* ====4==========*/
    select TG3.nam, TG3.thang, TG3.soluong
    from (
		select *, DENSE_RANK() over(partition by thang order by soluong DESC) thutu
		from (
		select TG1.nam, TG1.thang, TG1.ProductID, COUNT(TG1.SalesOrderID) soluong
		from (
			select TG.*, SOD.ProductID
			from (
				select SOH.SalesOrderID, MONTH(SOH.OrderDate) thang, YEAR(SOH.OrderDate) nam
				from Sales.SalesOrderHeader SOH, Person.Address A
				where YEAR(SOH.OrderDate) = 2003 AND
					  MONTH(SOH.OrderDate) between 4 and 6  AND
					  SOH.BillToAddressID = A.AddressID AND
					  A.City = 'London') TG, Sales.SalesOrderDetail SOD
			where TG.SalesOrderID = SOD.SalesOrderID) AS TG1
		group by TG1.nam, TG1.thang, TG1.ProductID) AS TG2) TG3
    where thutu < 6
    UNION 
         select TG3.nam, TG3.thang, TG3.soluong
		 from (
			select *, DENSE_RANK() over(partition by thang order by soluong DESC) thutu
			from (
			select TG1.nam, TG1.thang, TG1.ProductID, COUNT(TG1.SalesOrderID) soluong
			from (
				select TG.*, SOD.ProductID
				from (
					select SOH.SalesOrderID, MONTH(SOH.OrderDate) thang, YEAR(SOH.OrderDate) nam
					from Sales.SalesOrderHeader SOH, Person.Address A
					where YEAR(SOH.OrderDate) = 2004 AND
						  MONTH(SOH.OrderDate) between 4 and 6  AND
						  SOH.BillToAddressID = A.AddressID AND
						  A.City = 'London') TG, Sales.SalesOrderDetail SOD
				where TG.SalesOrderID = SOD.SalesOrderID) AS TG1
			group by TG1.nam, TG1.thang, TG1.ProductID) AS TG2) TG3
		where thutu < 6
		
		/*toi uu*/
		create view V as select *, DENSE_RANK() over(partition by thang order by soluong DESC) thutu
			from (
			select TG1.nam, TG1.thang, TG1.ProductID, COUNT(TG1.SalesOrderID) soluong
			from (
				select TG.*, SOD.ProductID
				from (
					select SOH.SalesOrderID, MONTH(SOH.OrderDate) thang, YEAR(SOH.OrderDate) nam
					from Sales.SalesOrderHeader SOH, Person.Address A
					where YEAR(SOH.OrderDate) = 2004 AND
						  MONTH(SOH.OrderDate) between 4 and 6  AND
						  SOH.BillToAddressID = A.AddressID AND
						  A.City = 'London') TG, Sales.SalesOrderDetail SOD
				where TG.SalesOrderID = SOD.SalesOrderID) AS TG1
			group by TG1.nam, TG1.thang, TG1.ProductID) AS TG2