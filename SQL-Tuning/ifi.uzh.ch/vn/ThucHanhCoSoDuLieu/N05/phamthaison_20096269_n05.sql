1.

select distinct pr.ProductID, pr.Name
from Production.Product pr, Production.ProductCategory prca, Production.ProductSubcategory prsu, Sales.SalesOrderDetail sade, Sales.SalesOrderHeader sahe, Person.Address adr
where adr.City='London' and adr.AddressID= sahe.BillToAddressID and sahe.SalesOrderID=sade.SalesOrderID and sade.ProductID= pr.ProductID and pr.ProductSubcategoryID=prsu.ProductSubcategoryID and prsu.ProductCategoryID= prca.ProductCategoryID and prca.Name='Clothing' and year(sahe.DueDate)=2003 and month(sahe.DueDate)=5
 
 2.
 
  
 
 select pr.ProductID, pr.Name , sum(sade.LineTotal)
 from  Production.Product pr, Sales.SalesOrderDetail sade, Sales.SalesOrderHeader sahe
 where year(pr.SellStartDate)>=2002 and month(pr.SellStartDate)>=5 and pr.ProductID=sade.ProductID and sade.SalesOrderID=sahe.SalesOrderID and year(sahe.OrderDate)<=2004 and month(sahe.OrderDate)<=10  
 group by pr.ProductID, pr.Name
 having SUM(sade.LineTotal)>10000