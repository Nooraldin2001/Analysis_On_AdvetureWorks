-----------------------------اكتر منتج مبيعاً اخر 3 شهور-----------------------------
SELECT sod.ProductID AS ID,pp.Name AS ProductName, SUM(sod.OrderQty) AS total_sold
FROM Sales.SalesOrderDetail sod left join Production.Product pp 
ON pp.ProductID = sod.ProductID
WHERE sod.ModifiedDate >= DATEADD(MONTH, -3, '2014-06-30 00:00:00.000')  -- Get the date 3 months ago from the current date
GROUP BY sod.ProductID,pp.Name
ORDER BY total_sold DESC

-----------------------------عدد العروض على كل منتج-----------------------------
SELECT sod.ProductID AS ID,pp.Name AS ProductName, sum(sod.SpecialOfferID) AS total_Special_Offers
FROM Sales.SalesOrderDetail sod left join Production.Product pp 
ON pp.ProductID = sod.ProductID
GROUP BY sod.ProductID,pp.Name
ORDER BY total_Special_Offers DESC

-----------------------------كام عميل جديد في اخر سنة-----------------------------
SELECT COUNT(*)
FROM Sales.Customer ct 
WHERE ct.ModifiedDate >= DATEADD(YEAR, -1, '2014-09-12 11:15:07.263') 

-----------------------------اكتر مندوب تحقيقاً للمبيعا-----------------------------
select sod.SalesPersonID AS Sales_Person_ID, sps.FullName AS Sales_Person_Name, SUM(sod.TotalDue) AS Total_Sales
from Sales.SalesOrderHeader sod left join Sales.vSalesPersonSalesByFiscalYears sps
ON sod.SalesPersonID = sps.SalesPersonID
where sod.SalesPersonID is not null and sps.FullName is not null
group by sod.SalesPersonID, sps.FullName
ORDER BY Total_Sales DESC

-----------------------------اكتر الدول مبيعاً-----------------------------
select st.Name,SUM(soh.TotalDue) total
from Sales.SalesOrderHeader soh join Sales.SalesTerritory st
on soh.TerritoryID=st.TerritoryID
group by st.Name
order by total

-----------------------------اكتر فئة منتجات مطلوبة-----------------------------
--Change it to category 
select pps.ProductSubcategoryID AS Category_ID, pps.Name AS Category_Name, sum(sod.OrderQty) AS Number_off_Peices_Saled
from Sales.SalesOrderDetail sod join Production.ProductSubcategory pps
on pps.ProductSubcategoryID = pps.ProductSubcategoryID
group by pps.ProductSubcategoryID, pps.Name
order by Number_off_Peices_Saled DESC

-----------------------------كم عدد الموظفين المعينين خلال اخر عام -----------------------------
select COUNT(*)
from HumanResources.Employee he
WHERE he.HireDate >= DATEADD(YEAR, -1, '2012-05-30') 

-----------------------------اكثر وسيلة شحن مستخدمة-----------------------------
select psm.ShipMethodID AS Ship_Method_ID, psm.Name AS Ship_Method_Name, COUNT(sod.SalesOrderID) AS Ship_Method_Used_Times
from Sales.SalesOrderHeader sod left join Purchasing.ShipMethod psm
on sod.ShipMethodID = psm.ShipMethodID
group by psm.ShipMethodID, psm.Name
order by Ship_Method_Used_Times 

-----------------------------متوسط مرتبات الموظفين لكل قسم-----------------------------
--[EmployeePayHistory] >> Rate is the salary 

----------------------------- عدد الاوردرات في اخر شهر-----------------------------
SELECT count(sod.SalesOrderID) AS 'Total Orders'
FROM Sales.SalesOrderDetail sod 
WHERE sod.ModifiedDate >= DATEADD(MONTH, -1, '2014-06-30 00:00:00.000')  

-----------------------------اعلى سنة تحقيقا للمبيعات-----------------------------
select YEAR(soh.DueDate) AS Year, sum(soh.TotalDue) AS Total_Sales_Ber_Year
from Sales.SalesOrderHeader soh
group by YEAR(soh.DueDate)
order by Total_Sales_Ber_Year DESC

------------------------------- العملاء مع كل موظف-----------------------------
select sod.SalesPersonID AS Sales_Person_ID, sps.FullName AS Sales_Person_Name, count(sod.CustomerID) AS Total_Customers
from Sales.SalesOrderHeader sod left join Sales.vSalesPersonSalesByFiscalYears sps
ON sod.SalesPersonID = sps.SalesPersonID
where sod.SalesPersonID is not null and sps.FullName is not null
group by sod.SalesPersonID, sps.FullName
ORDER BY Total_Customers DESC

-------------------------------اقل موظف حصولا على الاجازات-------------------------------
select hre.LoginID AS Emp_Login_ID, (pp.FirstName + pp.LastName) AS Emp_Name, hre.VacationHours + SickLeaveHours AS Total_Off_Days
from HumanResources.Employee hre left join Person.Person pp
ON hre.BusinessEntityID = pp.BusinessEntityID
ORDER BY Total_Off_Days 

-------------------------------؟هل يوجد علاقة مابين النوع والمبيعات-------------------------------
--لا يوجد
select sod.SalesPersonID AS Sales_Person_ID, SPSF.FullName AS Sales_Person_Name, HRE.Gender AS Gender, SUM(sod.TotalDue) AS Total_Sales
from Sales.SalesOrderHeader sod
join Sales.vSalesPersonSalesByFiscalYears SPSF
ON SPSF.SalesPersonID = sod.SalesPersonID
join Sales.SalesPerson SPS
ON SPS.TerritoryID = sod.TerritoryID
join HumanResources.Employee HRE 
ON HRE.BusinessEntityID = SPS.BusinessEntityID
--where sod.SalesPersonID is not null and SPSF.FullName is not null
group by 
sod.SalesPersonID , SPSF.FullName ,HRE.Gender
Order by 
Total_Sales DESC


-------------------------------افضل وسيلة شحن لكل مقاطعة -------------------------------
--change to the shipmethod 
select psm.ShipMethodID AS Ship_Method_ID, psm.Name AS Ship_Method_Name, psm.ShipRate AS Ship_Method_Rate
from Purchasing.ShipMethod psm
order by Ship_Method_Rate DESC

-------------------------------عدد الموظفين المتخارجين من الشركة كل سنة-------------------------------
--Employee department history select where enddate is not null 
select HRE.BusinessEntityID,datediff(YEAR ,Min(HireDate),Max(HireDate)) period
from HumanResources.Employee HRE
group by HRE.BusinessEntityID
order by period desc

-------------------------------نسبة الضرائب للمبيعات-------------------------------
select YEAR(sod.DueDate) AS 'Year',(SUM(sod.TaxAmt)/sum(sod.TotalDue))*100 AS 'Diffrence Between Tax and Sales'
from Sales.SalesOrderHeader sod 
group by YEAR(sod.DueDate)
order by YEAR(sod.DueDate) desc
--, sum(sod.SubTotal) AS 'Sales ber year', SUM(sod.TaxAmt) AS 'Tax on Sales ber year', 

-------------------------------المقارنة مابين المبيعات  والمشتريات لكل منتج-------------------------------
select pp.ProductID AS ID, pp.Name AS Product_Name, SUM(pod.LineTotal) AS 'Product total Purchase', SUM(sod.LineTotal) AS 'Product total Sales'
from Purchasing.PurchaseOrderDetail pod 
join Sales.SalesOrderDetail sod
ON pod.ProductID = sod.ProductID
join Production.Product pp
ON pp.ProductID = pod.ProductID
group by pp.ProductID,pp.Name 
order by ID desc

--22420
select pod.ProductID, sum(pod.LineTotal)
from Purchasing.PurchaseOrderDetail pod 
where pod.ProductID = 710 
group by pod.ProductID


-------------------------------product sale in 2011 but not in 2014-------------------------------
select distinct sod.ProductID
from Sales.SalesOrderDetail sod full join
Sales.SalesOrderHeader soh 
on soh.SalesOrderID = sod.SalesOrderID
where year(soh.DueDate) = 2011
except
select distinct sod.ProductID
from Sales.SalesOrderDetail sod full join
Sales.SalesOrderHeader soh 
on soh.SalesOrderID = sod.SalesOrderID
where year(soh.DueDate) = 2014

-----------------------------------------------------------------------------------
-------------------------------Foreach product total sales-------------------------
-----------------------------------------------------------------------------------
select distinct sod.ProductID, (select sum(sod.LineTotal)) total
from Sales.SalesOrderDetail sod full join
Sales.SalesOrderHeader soh 
on soh.SalesOrderID = sod.SalesOrderID
where year(soh.DueDate) = 2011
group by sod.ProductID
except
select distinct sod.ProductID, (select sum(sod.LineTotal)) total
from Sales.SalesOrderDetail sod full join
Sales.SalesOrderHeader soh 
on soh.SalesOrderID = sod.SalesOrderID
where year(soh.DueDate) = 2014
group by sod.ProductID;

--here this approach dos'nt work 
--hard luck );
--we can try using another approaches 
with product_2011
as
(select distinct sod.ProductID
from Sales.SalesOrderDetail sod  join
Sales.SalesOrderHeader soh 
on soh.SalesOrderID = sod.SalesOrderID
where year(soh.DueDate) = 2011
except
select distinct sod.ProductID
from Sales.SalesOrderDetail sod join
Sales.SalesOrderHeader soh 
on soh.SalesOrderID = sod.SalesOrderID
where year(soh.DueDate) = 2014
)
select sod.ProductID, sum(sod.LineTotal) total
from Sales.SalesOrderDetail sod
where sod.ProductID in (select product_2011.ProductID from product_2011)
group by sod.ProductID
--------------------------------------------------------------------------------------
-------------------------------مبيعات ربع ثنويه-------------------------------
select YEAR(OrderDate), DATEPART(QUARTER, soh.OrderDate), SUM(totalDue)
from Sales.SalesOrderHeader soh
group by YEAR(OrderDate), DATEPART(QUARTER, soh.OrderDate)
order by YEAR(OrderDate) desc, DATEPART(QUARTER, soh.OrderDate)

-------------------------------مبيعات باليوم -------------------------------
select YEAR(OrderDate), DATENAME(DW, soh.OrderDate), SUM(totalDue)
from Sales.SalesOrderHeader soh
where DATENAME(DW, soh.OrderDate) = 'Friday'
group by YEAR(OrderDate), DATENAME(DW, soh.OrderDate)
order by YEAR(OrderDate) desc, DATENAME(DW, soh.OrderDate)


-------------------------------list best sales and most purchases category-------------------------------
--category name 
with bestCategorySales
as(
select top (1) pc.name,sum(sod.linetotal) sales
from production.ProductCategory pc join Production.ProductSubcategory psc
on pc.ProductCategoryID = psc.ProductCategoryID
join Production.Product p 
on p.ProductSubcategoryID = psc.ProductSubcategoryID
join Sales.SalesOrderDetail sod
on sod.ProductID = p.ProductID
group by pc.name
order by sales desc 
),
bestCategoryPurchase
as
(
select top (1) pc.name,sum(pod.linetotal) purchases
from production.ProductCategory pc join Production.ProductSubcategory psc
on pc.ProductCategoryID = psc.ProductCategoryID
join Production.Product p 
on p.ProductSubcategoryID = psc.ProductSubcategoryID
join [Purchasing].[PurchaseOrderDetail] pod
on pod.productid = p.productid
group by pc.name
order by purchases desc
)
select bcs.name sales,bcp.name purchase
from bestCategorysales bcs,bestCategoryPurchase bcp

--sub query 
--join between querys not tables 
select *
from
(
select sod.ProductID, sum(sod.LineTotal) AS sum_sales
from Sales.SalesOrderDetail sod
group by sod.ProductID) AS salessdt join
(
select pod.ProductID, sum(pod.LineTotal) AS sum_purchasing
from Purchasing.PurchaseOrderDetail pod
group by pod.ProductID) AS purchasdt
on salessdt.ProductID = purchasdt.ProductID


--see which products is the sales and not on the purchasing 
select *
from
(select sod.ProductID, sum(sod.LineTotal) AS sum_sales
from Sales.SalesOrderDetail sod
group by sod.ProductID) AS salessdt left join
(select pod.ProductID, sum(pod.LineTotal) AS sum_purchasing
from Purchasing.PurchaseOrderDetail pod
group by pod.ProductID) AS purchasdt
on salessdt.ProductID = purchasdt.ProductID


--Difference between them 
select salessdt.ProductID, salessdt.sum_sales, purchasdt.sum_purchasing, salessdt.sum_sales-purchasdt.sum_purchasing Gross
from
(select sod.ProductID, sum(sod.LineTotal) AS sum_sales
from Sales.SalesOrderDetail sod
group by sod.ProductID) AS salessdt  join
(select pod.ProductID, sum(pod.LineTotal) AS sum_purchasing
from Purchasing.PurchaseOrderDetail pod
group by pod.ProductID) AS purchasdt
on salessdt.ProductID = purchasdt.ProductID

select DATEDIFF(YEAR,e.BirthDate,GETDATE())
from HumanResources.Employee e

select DATEDIFF(YEAR,e.HireDate,GETDATE())
from HumanResources.Employee e

select avg(DATEDIFF(YEAR,e.BirthDate,GETDATE()))
from HumanResources.Employee e


