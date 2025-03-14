use AdventureWorks2008
-- Phan 1:
-- Câu 1 : 
select p2.ProductNumber, p2.Name, p2.ListPrice 
from (select P.ProductID, COUNT(Sod.SalesOrderID) as num_order
		from Production.Product as P,
			 Sales.SalesOrderDetail as Sod
		where  P.ProductID = Sod.ProductID
		   and MONTH(P.SellEndDate)=5
		   and YEAR(P.SellEndDate)=2002 
		group by p.ProductID 
	  ) as Result, Production.Product as P2
where Result.ProductID = P2.ProductID
  and Result.num_order = 0

-- Câu 2 :
select Per.BusinessEntityID, SalH.SalesOrderID, SalH.TotalDue 
from Person.Person as Per,
	 Sales.Customer as SalC,
	 Person.Address as PerA,
	 Person.EmailAddress as PerE,
	 Sales.SalesOrderHeader as SalH
where ((select P.ProductID, COUNT(Sod.SalesOrderID) as num_order
		from Production.Product as P,
			 Sales.SalesOrderDetail as Sod
		where  P.ProductID = Sod.ProductID
		   and MONTH(P.SellEndDate)=5
		   and YEAR(P.SellEndDate)=2002 
		group by p.ProductID 
	  ) as Result, Production.Product as P2)
  and Year(SalH.OrderDate)=2003
  and PerA.City='Paris'
  and SalH.CustomerID = SalC.CustomerID
  and SalC.PersonID = Per.BusinessEntityID
  and Per.BusinessEntityID = PerE.BusinessEntityID
  and SalH.BillToAddressID=PerA.AddressID
order by EmailAddress

-- Câu 3 :
select COUNT(Pc.ProductCategoryID) as num
from Production.Product as PP,
     Production.ProductCategory as PC,
     Production.ProductSubcategory as PS,
     Sales.SalesOrderHeader as SalH,
     Sales.SalesOrderDetail as SalD,
     Person.Address as PerA
where SalH.SalesOrderID = SalD.SalesOrderID
  and SalD.ProductID = PP.ProductID
  and PP.ProductSubcategoryID = Ps.ProductSubcategoryID
  and PS.ProductCategoryID = Pc.ProductCategoryID
  and SalH.ShipToAddressID = PerA.AddressID
  and PC.Name='Clothing'
  and PerA.City ='Paris'
  and ShipDate>='20030501'
  and ShipDate<='20030530'
  --tang hieu nang cua cau truy van
  CREATE INDEX myindex ON Sales.SalesOrderHeader(ShipDate)
  DROP INDEX myindex ON Sales.SalesOrderHeader
  
-- Câu 4 :

select  MONTH(SalH1.OrderDate) as months,YEAR(SalH1.OrderDate) as years, SUM(SalD1.OrderQty) as Nums, SalD1.ProductID
from Person.Address as PerA1,
	 Sales.SalesOrderDetail as SalD1,
     Sales.SalesOrderHeader as SalH1
where SalD1.ProductID in(
			select top 5 SalD.ProductID
			from Person.Address as PerA,
				 Sales.SalesOrderDetail as SalD,
				 Sales.SalesOrderHeader as SalH
			where SalH.SalesOrderID = SalD.SalesOrderID
			  and SalH.BillToAddressID = PerA.AddressID
			  and PerA.City='London'
			  and Month(SalH.OrderDate)=Month(SalH1.OrderDate)
			  and SalH.OrderDate>='20030101'
			  and SalH.OrderDate<='20041231'
			group by SalD.ProductID, MONTH(SalH.OrderDate)
			order by Sum(SalD.OrderQty) desc
		) 
  and SalH1.SalesOrderID = SalD1.SalesOrderID
  and PerA1.City='London'
  and Month(SalH1.OrderDate) in (4,5,6,7,8,9)
  and Year(SalH1.OrderDate)= 2003 OR  Year(SalH1.OrderDate)= 2004
group by SalD1.ProductID, MONTH(SalH1.OrderDate),YEAR(SalH1.OrderDate)
order by years, months, Nums



			