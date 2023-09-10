--Obtener lista de productos y sus categor�as, ordenados por el nombre del producto de forma ascendente--
SELECT Products.ProductName AS NombreProducto, Categories.CategoryName AS NombreCategoria
FROM Products
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
ORDER BY Products.ProductName;
--Obtener una lista de empleados y sus jefes, ordenados por el apellido del empleado de forma ascendente
SELECT Employees.LastName AS ApellidoEmpleado, Managers.LastName AS ApellidoJefe
FROM Employees
INNER JOIN Employees AS Managers ON Employees.ReportsTo = Managers.EmployeeID
ORDER BY Employees.LastName;
--Obtener una lista de pedidos y los nombres de los empleados que los realizaron, ordenados por la fecha del pedido de forma descendente
SELECT Orders.OrderID, Employees.FirstName, Employees.LastName
FROM Orders
INNER JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
ORDER BY Orders.OrderDate DESC;
--Lista de empleados y los productos que han vendido, ordenados por el nombre del empleado de forma ascendente:
SELECT Employees.FirstName, Employees.LastName, Products.ProductName
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN Products ON [Order].ProductID = Products.ProductID
ORDER BY Employees.LastName, Employees.FirstName;
--Productos, sus precios y los nombres de los proveedores, ordenados por el nombre del proveedor de forma ascendente
SELECT Products.ProductName, Products.UnitPrice, Suppliers.CompanyName AS NombreProveedor
FROM Products
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
ORDER BY NombreProveedor;
--Empleados y sus territorios asignados, ordenados por el apellido del empleado y el nombre del territorio de forma ascendente
SELECT Employees.FirstName, Employees.LastName, Territories.TerritoryDescription
FROM Employees
INNER JOIN EmployeeTerritories ON Employees.EmployeeID = EmployeeTerritories.EmployeeID
INNER JOIN Territories ON EmployeeTerritories.TerritoryID = Territories.TerritoryID
ORDER BY Employees.LastName, Territories.TerritoryDescription;
----Nn�mero de pedidos realizados por cada empleado
SELECT Employees.FirstName, Employees.LastName, COUNT(Orders.OrderID) AS NumeroPedidos
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.FirstName, Employees.LastName
ORDER BY NumeroPedidos DESC;
--Cantidad total de productos vendidos por cada a�o
SELECT YEAR(Orders.OrderDate) AS Anio, SUM(OrderDetails_Log.Quantity) AS CantidadTotalVendida
FROM Orders
INNER JOIN [OrderDetails_Log]ON Orders.OrderID = OrderDetails_Log.log_id
GROUP BY YEAR(Orders.OrderDate)
ORDER BY Anio;
--Cantidad promedio de productos en stock por categor�a
SELECT Categories.CategoryName, AVG(Products.UnitsInStock) AS CantidadPromedioEnStock
FROM Categories
INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName
ORDER BY CantidadPromedioEnStock DESC;
--Nn�mero de productos por categor�a, excluyendo las categor�as que tienen menos de 5 productos
SELECT Categories.CategoryName, COUNT(Products.ProductID) AS NumeroProductos
FROM Categories
INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName
HAVING COUNT(Products.ProductID) >= 5
ORDER BY NumeroProductos DESC;
--cantidad total de proveedores �nicos en la base de datos y la cantidad total de productos en stock, ordenados por la cantidad total en stock en orden descendente.
SELECT COUNT(DISTINCT Suppliers.SupplierID) AS TotalProveedores, SUM(Products.UnitsInStock) AS CantidadTotalEnStock
FROM Suppliers
INNER JOIN Products ON Suppliers.SupplierID = Products.SupplierID
ORDER BY CantidadTotalEnStock DESC;
--Promedio de la cantidad de productos en stock por empleado
SELECT Employees.FirstName, Employees.LastName, AVG(Products.UnitsInStock) AS CantidadPromedioEnStock
FROM Employees
INNER JOIN Products ON Employees.EmployeeID = Products.CategoryID
GROUP BY Employees.FirstName, Employees.LastName
ORDER BY CantidadPromedioEnStock DESC;
--Cantidad total de productos vendidos por cada proveedor, excluyendo aquellos cuya cantidad total vendida sea inferior a 100
SELECT Suppliers.CompanyName AS NombreProveedor, SUM([Order Details].Quantity) AS CantidadTotalVendida
FROM Suppliers
INNER JOIN Products ON Suppliers.SupplierID = Products.SupplierID
INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID
GROUP BY CompanyName
HAVING SUM([Order Details].Quantity) >= 100
ORDER BY CantidadTotalVendida DESC;
--Nn�mero de productos en stock por proveedor, incluyendo proveedores que no tienen productos en stock
SELECT Suppliers.ContactName AS ProductName, COALESCE(SUM(Products.UnitsInStock), 0) AS CantidadEnStock
FROM Suppliers
LEFT JOIN Products ON Suppliers.SupplierID = Products.SupplierID
GROUP BY ProductName
ORDER BY CantidadEnStock DESC;
--Clientes que han realizado m�s de 10 pedidos
SELECT Customers.CompanyName, COUNT(Orders.OrderID) AS NumeroPedidos
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CompanyName
HAVING COUNT(Orders.OrderID) > 10;
--Numero total de pedidos manejados por cada empleado
SELECT Employees.FirstName, Employees.LastName, COUNT(Orders.OrderID) AS NumeroTotalPedidos
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.FirstName, Employees.LastName
HAVING COUNT(Orders.OrderID) > 10; 
--para obtener la fecha del pedido m�s reciente manejado por cada empleado
SELECT Employees.FirstName, Employees.LastName, MAX(Orders.OrderDate) AS FechaPedidoMasReciente
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.FirstName, Employees.LastName;
-- cantidad y el precio unitario de los productos vendidos en cada pedido y calcular el monto total de ventas
SELECT Customers.CompanyName, COUNT(Orders.OrderID) AS NumeroPedidos, SUM([Order Details].Quantity * Products.UnitPrice) AS MontoTotalVentas
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
INNER JOIN Products ON [Order Details].ProductID = Products.ProductID
GROUP BY Customers.CompanyName
HAVING COUNT(Orders.OrderID) > 10 AND SUM([Order Details].Quantity * Products.UnitPrice) > 5000;
-- Empleados que han manejado pedidos con una cantidad total de productos vendidos superior a 200
SELECT Employees.FirstName, Employees.LastName, COUNT([Order Details].ProductID) AS TotalProductosVendidos
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
GROUP BY Employees.FirstName, Employees.LastName
HAVING COUNT([Order Details].ProductID) > 200;
--
SELECT Suppliers.CompanyName AS UnitPrice, COUNT(Products.ProductID) AS NumeroProductos
FROM Suppliers
INNER JOIN Products ON Suppliers.SupplierID = Products.SupplierID
WHERE Products.UnitPrice > 50
GROUP BY UnitPrice
HAVING COUNT(Products.ProductID) >= 5;
--Categor�as de productos que tienen un promedio de existencias (UnitsInStock) inferior a 20
SELECT Categories.CategoryName, AVG(Products.UnitsInStock) AS PromedioExistencias
FROM Categories
INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName
HAVING AVG(Products.UnitsInStock) > 20;
--Empleados que han manejado pedidos con al menos 3 productos distintos
SELECT Employees.FirstName, Employees.LastName, COUNT(DISTINCT [Order Details].ProductID) AS ProductosDistintosManejados
FROM Employees
INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
GROUP BY Employees.FirstName, Employees.LastName
HAVING COUNT(DISTINCT [Order Details].ProductID) >= 3;
--
SELECT Customers.Address, YEAR(Orders.OrderDate) AS Anio
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.Address, anio
HAVING COUNT(DISTINCT YEAR(Orders.OrderDate)) = (SELECT COUNT(DISTINCT YEAR(OrderDate)) FROM Orders);
--SUM con OrderBy
--Suma de los montos totales de todas las �rdenes y ordenar por la suma en orden descendente
SELECT CustomerID, SUM(OrderDate) AS TotalOrderAmount
FROM Orders
GROUP BY CustomerID
ORDER BY TotalOrderAmount DESC;
--Suma de los montos totales de todos los productos vendidos y ordenar por la suma en orden ascendente
SELECT ProductID, SUM(Quantity * UnitPrice) AS TotalSales
FROM [Order Details]
GROUP BY ProductID
ORDER BY TotalSales ASC;
--Suma de los montos totales de ventas para cada categor�a de productos y ordenar por la suma en orden descendente
SELECT Categories.CategoryName, SUM([Order Details].Quantity * [Order Details].UnitPrice) AS TotalSales
FROM Categories
INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID
GROUP BY Categories.CategoryName
ORDER BY TotalSales DESC;
--Suma de los montos totales de ventas por empleado y ordenar por la suma en orden descendente
SELECT Employees.EmployeeID, CONCAT(Employees.FirstName, ' ', Employees.LastName) AS EmployeeName, SUM([Order Details].Quantity * [Order Details].UnitPrice) AS TotalSales
FROM Employees
LEFT JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
LEFT JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
GROUP BY Employees.EmployeeID, LastName
ORDER BY TotalSales DESC;
--Suma de los montos totales de env�o para cada cliente y ordenar por la suma en orden ascendente
SELECT Customers.CustomerID, CONCAT(Customers.ContactName, ' (', Customers.CompanyName, ')') AS CustomerName, SUM(Orders.Freight) AS TotalFreightCost
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, CustomerID
ORDER BY TotalFreightCost ASC;
--Suma de las unidades en stock para cada producto y ordenar por la suma en orden descendente
SELECT Products.ProductName, SUM(Products.UnitsInStock) AS TotalUnitsInStock
FROM Products
GROUP BY Products.ProductName
ORDER BY TotalUnitsInStock DESC;
--Suma de los gastos de env�o por proveedor y ordenar por la suma en orden descendente
SELECT Suppliers.SupplierID, Suppliers.CompanyName, SUM(Orders.Freight) AS TotalFreightCost
FROM Suppliers
LEFT JOIN Products ON Suppliers.SupplierID = Products.SupplierID
LEFT JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID
LEFT JOIN Orders ON [Order Details].OrderID = Orders.OrderID
GROUP BY Suppliers.SupplierID, Suppliers.CompanyName
ORDER BY TotalFreightCost DESC;
--Suma de los montos totales de ventas por a�o y ordenar por la suma en orden descendente
SELECT EXTRACT(YEAR FROM Orders.OrderDate) AS OrderYear, SUM(OrderDetails.Quantity * OrderDetails.UnitPrice) AS TotalSales
FROM Orders
LEFT JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
GROUP BY OrderYear
ORDER BY TotalSales DESC;
--SUM con Group by
--Suma de los montos totales de ventas por categor�a de productos
SELECT Categories.CategoryName, SUM([Order Details].UnitPrice * [Order Details].Quantity) AS TotalSales
FROM Categories
INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID
GROUP BY Categories.CategoryName;
--Suma de los montos totales de env�o por pa�s de destino
SELECT ShipCountry, SUM(Freight) AS TotalFreightCost
FROM Orders
GROUP BY ShipCountry;
--Suma de los salarios anuales por t�tulo de trabajo de los empleados
SELECT Employees.TitleOfCourtesy, SUM(Employees.Salary) AS AnnualSalary
FROM Employees
GROUP BY Employees.TitleOfCourtesy;
--Suma de las cantidades de productos en cada orden y ordenar por la suma en orden ascendente
SELECT Orders.OrderID, SUM([Order Details].Quantity) AS TotalQuantity
FROM Orders
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
GROUP BY Orders.OrderID
ORDER BY TotalQuantity ASC;
--Suma de las unidades vendidas por producto y filtro de productos con unidades vendidas superiores a un valor espec�fico
SELECT Products.ProductName, SUM([Order Details].Quantity) AS TotalUnitsSold
FROM Products
INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID
GROUP BY Products.ProductName
HAVING SUM([Order Details].Quantity) > 1000;
--Suma de las cantidades de productos en cada orden y filtro de �rdenes con cantidades totales superiores a un valor espec�fico
SELECT Orders.OrderID, SUM([Order Details].Quantity) AS TotalQuantity
FROM Orders
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
GROUP BY Orders.OrderID
HAVING SUM([Order Details].Quantity) > 50;
--Obtener la cantidad m�nima de productos vendidos por categor�a de producto
SELECT Categories.CategoryName, MIN([Order Details].Quantity) AS CantidadMinimaVendida
FROM Categories
INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID
GROUP BY Categories.CategoryName;
--Obtener las categor�as de productos con el precio unitario m�nimo superior a $10
SELECT CategoryID, MIN(UnitPrice) AS PrecioUnitarioMinimo
FROM Products
GROUP BY CategoryID
HAVING MIN(UnitPrice) > 10;
--OBbtener las categor�as de productos con al menos 10 productos y el precio unitario m�nimo superior a $5
SELECT CategoryID, MIN(UnitPrice) AS PrecioUnitarioMinimo
FROM Products
GROUP BY CategoryID
HAVING COUNT(*) >= 10 AND MIN(UnitPrice) > 5;
--Obtener el n�mero de pedidos realizados por cada cliente y ordenarlos por n�mero de pedidos en orden descendente
SELECT Customers.CustomerID, 'NuevoNombreCliente' AS CustomerName, COUNT(Orders.OrderID) AS NumeroPedidos
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID
ORDER BY NumeroPedidos DESC;
---btener el n�mero de productos en cada categor�a y ordenarlos por n�mero de productos en orden ascendente
SELECT Categories.CategoryName, COUNT(Products.ProductID) AS NumeroProductos
FROM Categories
LEFT JOIN Products ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName
ORDER BY NumeroProductos;
--	productos y las categor�as a las que pertenecen, ordenados por el nombre del producto
SELECT Products.ProductName, Categories.CategoryName
FROM Products
LEFT JOIN Categories ON Products.CategoryID = Categories.CategoryID
ORDER BY Products.ProductName;
--Lista de clientes y sus �rdenes, ordenados por el nombre del cliente y la fecha de pedido
SELECT Customers.CustomerID, Orders.OrderID, Orders.OrderDate
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
ORDER BY Customers.CustomerID, Orders.OrderDate;
---Lista de empleados y los territorios a los que est�n asignados, ordenados por el apellido del empleado y el nombre del territorio
SELECT Employees.LastName, Employees.FirstName, Territories.TerritoryDescription
FROM Employees
LEFT JOIN EmployeeTerritories ON Employees.EmployeeID = EmployeeTerritories.EmployeeID
LEFT JOIN Territories ON EmployeeTerritories.TerritoryID = Territories.TerritoryID
ORDER BY Employees.LastName, Territories.TerritoryDescription;
-- productos y sus proveedores, ordenados por el nombre del producto y el nombre del proveedor
SELECT Products.ProductName, Suppliers.CompanyName
FROM Products
LEFT JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
ORDER BY Products.ProductName, Suppliers.CompanyName;
--Categor�as de productos y la cantidad de productos en cada categor�a, ordenados por el nombre de la categor�a
SELECT Categories.CategoryName, COUNT(Products.ProductID) AS ProductCount
FROM Categories
LEFT JOIN Products ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName
ORDER BY Categories.CategoryName;
-- clientes y la cantidad de pedidos que han realizado, mostrando solo clientes con m�s de 10 pedidos
SELECT Customers.CustomerID, COUNT(Orders.OrderID) AS OrderCount
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID
HAVING COUNT(Orders.OrderID) > 10
ORDER BY Customers.CustomerID;
--Empleados y la cantidad de �rdenes que han manejado, mostrando solo empleados con m�s de 50 �rdenes manejadas
SELECT Employees.LastName, Employees.FirstName, COUNT(Orders.OrderID) AS OrderCount
FROM Employees
LEFT JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.LastName, Employees.FirstName
HAVING COUNT(Orders.OrderID) > 50
ORDER BY Employees.LastName, Employees.FirstName;
-- Combinar listas de clientes y empleados ordenadas alfab�ticamente
SELECT Customers.CustomerID AS Name
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
UNION
SELECT CONCAT(Employees.FirstName, ' ', Employees.LastName) AS Name
FROM Employees
RIGHT JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
ORDER BY Name;
-- Combinar pedidos y detalles de pedidos con clientes y empleados involucrados
SELECT Customers.CustomerID AS Name
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
UNION
SELECT CONCAT(Employees.FirstName, ' ', Employees.LastName) AS Name
FROM Employees
RIGHT JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
ORDER BY Name;
-- Combinar productos y proveedores en una lista de productos con sus proveedores
SELECT Products.ProductName, Suppliers.CompanyName
FROM Products
LEFT JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
UNION
SELECT Products.ProductName, Suppliers.CompanyName
FROM Products
RIGHT JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
ORDER BY Products.ProductName;
-- Combinar productos con sus categor�as
SELECT Products.ProductName, Categories.CategoryName
FROM Products
LEFT JOIN Categories ON Products.CategoryID = Categories.CategoryID
UNION
SELECT Products.ProductName, Categories.CategoryName
FROM Products
RIGHT JOIN Categories ON Products.CategoryID = Categories.CategoryID
WHERE Categories.CategoryName IS NOT NULL
ORDER BY Categories.CategoryName;
-- Combinar clientes y pedidos con la cantidad total de pedidos por cliente
SELECT Customers.CustomerID, SUM(Orders.OrderID) AS TotalOrders
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID
UNION
SELECT Customers.CustomerID, SUM(Orders.OrderID) AS TotalOrders
FROM Customers
RIGHT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID
ORDER BY TotalOrders DESC;
-- Combinar productos y proveedores en una lista de productos con sus proveedores
SELECT Products.ProductName, Suppliers.CompanyName
FROM Products
LEFT JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
UNION
SELECT Products.ProductName, Suppliers.CompanyName
FROM Products
RIGHT JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
ORDER BY Products.ProductName;
--Obtener el producto m�s caro de la base de datos
SELECT ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC;
--Obtener el precio m�ximo por categor�a de producto
SELECT CategoryID, MAX(UnitPrice) AS PrecioMaximo
FROM Products
GROUP BY CategoryID;
--btener la fecha de pedido m�s reciente por cliente
SELECT CustomerID, MAX(OrderDate) AS FechaPedidoMasReciente
FROM Orders
GROUP BY CustomerID;
--Obtener la cantidad m�xima de productos en stock por proveedor
SELECT SupplierID, MAX(UnitsInStock) AS CantidadMaximaEnStock
FROM Products
GROUP BY SupplierID;
--Tener las categor�as de productos con el precio unitario m�ximo superior a $100
SELECT CategoryID, MAX(UnitPrice) AS PrecioUnitarioMaximo
FROM Products
GROUP BY CategoryID
HAVING MAX(UnitPrice) > 100;
--Obtener los clientes que han realizado pedidos con el monto m�ximo superior a $5,000
SELECT CustomerID, MAX(OrderTotal) AS MontoMaximo
FROM (
    SELECT CustomerID, OrderID, SUM(TotalAmount) AS OrderTotal
    FROM Orders
    GROUP BY CustomerID, OrderID
) AS CustomerOrders
GROUP BY CustomerID
HAVING MAX(OrderTotal) > 5000;
--Obtener el producto m�s barato de la base de datos
SELECT ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice
--	Obtener la cantidad m�nima de productos en stock por categor�a de producto
SELECT CategoryID, MIN(UnitsInStock) AS CantidadMinimaEnStock
FROM Products
GROUP BY CategoryID;
--Obtener la fecha de pedido m�s antigua por cliente
SELECT CustomerID, MIN(OrderDate) AS PrimerPedido
FROM Orders
GROUP BY CustomerID;
--Obtener el precio unitario m�nimo por proveedor
SELECT SupplierID, MIN(UnitPrice) AS PrecioUnitarioMinimo
FROM Products
GROUP BY SupplierID;
--	
SELECT Employees.Title, COUNT(Employees.EmployeeID) AS NumeroEmpleados
FROM Employees
GROUP BY Employees.Title
ORDER BY Employees.Title;
---Obtener el n�mero de empleados por t�tulo y ordenarlos alfab�ticamente por t�tulo
SELECT TitleOfCourtesy, COUNT(EmployeeID) AS NumeroEmpleados
FROM Employees
GROUP BY TitleOfCourtesy
ORDER BY TitleOfCourtesy;
--Obtener el n�mero de productos vendidos por proveedor y ordenarlos por n�mero de productos en orden descendente
SELECT Suppliers.CompanyName, COUNT(Products.ProductID) AS NumeroProductosVendidos
FROM Suppliers
LEFT JOIN Products ON Suppliers.SupplierID = Products.SupplierID
GROUP BY Suppliers.CompanyName
ORDER BY NumeroProductosVendidos DESC;
--n�mero de pedidos realizados por cada empleado y ordenarlos por n�mero de pedidos en orden ascendente
SELECT Employees.EmployeeID, Employees.FirstName, Employees.LastName, COUNT(Orders.OrderID) AS NumeroPedidos
FROM Employees
LEFT JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID, Employees.FirstName, Employees.LastName
ORDER BY NumeroPedidos;
---n�mero de productos por categor�a
SELECT Categories.CategoryName, COUNT(Products.ProductID) AS NumeroProductos
FROM Categories
LEFT JOIN Products ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName;
--Obtener el n�mero de pedidos por cliente
SELECT Customers.CustomerID, 'ClienteNuevo' AS CustomerName, COUNT(Orders.OrderID) AS NumeroPedidos
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID
ORDER BY NumeroPedidos DESC;
--n�mero de empleados por t�tulo de cortes�a
SELECT Employees.TitleOfCourtesy, COUNT(Employees.EmployeeID) AS NumeroEmpleados
FROM Employees
GROUP BY Employees.TitleOfCourtesy;
--n�mero de productos por proveedor y ordenarlos por n�mero de productos en orden descendente
SELECT Suppliers.CompanyName, COUNT(Products.ProductID) AS NumeroProductos
FROM Suppliers
LEFT JOIN Products ON Suppliers.SupplierID = Products.SupplierID
GROUP BY Suppliers.CompanyName
ORDER BY NumeroProductos DESC;
--productos vendidos por categor�a de productos y ordenarlos por categor�a en orden alfab�tico
SELECT Categories.CategoryName, COUNT(Products.ProductID) AS NumeroProductosVendidos
FROM Categories
INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
INNER JOIN [Order Details] ON Products.ProductID = [Order Details].ProductID
GROUP BY Categories.CategoryName
ORDER BY Categories.CategoryName;
--Obtener el n�mero de pedidos por cliente
SELECT Customers.CustomerID, 'NuevoNombreCliente' AS CustomerName, COUNT(Orders.OrderID) AS NumeroPedidos
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID
HAVING COUNT(Orders.OrderID) > 10;
--Obtener el n�mero de productos en cada categor�a y mostrar solo aquellas categor�as con menos de 20 productos
SELECT Categories.CategoryName, COUNT(Products.ProductID) AS NumeroProductos
FROM Categories
LEFT JOIN Products ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName
HAVING COUNT(Products.ProductID) < 20;
--pedidos realizados por a�o y mostrar solo aquellos a�os en los que se hayan realizado m�s de 100 pedidos
SELECT YEAR(Orders.OrderDate) AS Anio, COUNT(Orders.OrderID) AS NumeroPedidos
FROM Orders
GROUP BY Anio
HAVING COUNT(Orders.OrderID) > 100;
--empleados por pa�s y mostrar solo aquellos pa�ses en los que haya al menos 2 empleados
SELECT Employees.Country, COUNT(Employees.EmployeeID) AS NumeroEmpleados
FROM Employees
GROUP BY Employees.Country
HAVING COUNT(Employees.EmployeeID) >= 2;
-- productos ordenados alfab�ticamente por nombre de producto en min�sculas
SELECT ProductName, LOWER(ProductName) AS NombreProductoEnMinusculas
FROM Products
ORDER BY NombreProductoEnMinusculas;
--lista de compa�ias ordenados alfab�ticamente por nombre de ciudad en min�sculas:
SELECT CompanyName, LOWER(City) AS CiudadEnMinusculas
FROM Customers
ORDER BY CiudadEnMinusculas;
--empleados ordenados alfab�ticamente por apellidos en min�sculas
SELECT FirstName, LastName, LOWER(LastName) AS ApellidoEnMinusculas
FROM Employees
ORDER BY ApellidoEnMinusculas;
--en MAYUSCULAS
SELECT FirstName, LastName, UPPER(LastName) AS ApellidoEnMayusculas
FROM Employees
ORDER BY ApellidoEnMayusculas;
--productos con sus nombres y categor�as concatenadas y ordenarlos alfab�ticamente por la columna concatenada
SELECT ProductName, CategoryName, CONCAT(ProductName, ' - ', CategoryName) AS NombreYCategoria
FROM Products
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
ORDER BY NombreYCategoria;
-- clientes por pa�s y mostrar solo aquellos pa�ses en los que haya al menos 3 clientes (ignorando diferencias de may�sculas y min�sculas
SELECT LOWER(Country) AS Country, COUNT(CustomerID) AS NumeroClientes
FROM Customers
GROUP BY Country
HAVING COUNT(CustomerID) >= 3;
--
SELECT LOWER(Suppliers.CompanyName) AS NombreProveedorEnMinusculas, COUNT(Products.ProductID) AS NumeroProductos
FROM Suppliers
INNER JOIN Products ON Suppliers.SupplierID = Products.SupplierID
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
WHERE LOWER(Categories.CategoryName) = 'bebidas'
GROUP BY ContactTitle
HAVING COUNT(Products.ProductID) >= 5;
--+Empleados y las �rdenes que han manejado, ordenados por el apellido del empleado:
SELECT Employees.FirstName, Employees.LastName, Orders.OrderID, Orders.OrderDate
FROM Employees
LEFT JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
ORDER BY Employees.LastName;
--productos y sus categor�as, ordenados por el nombre del producto
SELECT Products.ProductName, Categories.CategoryName
FROM Products
LEFT JOIN Categories ON Products.CategoryID = Categories.CategoryID
ORDER BY Products.ProductName;
--Clientes y sus �rdenes, ordenados por el nombre del cliente
SELECT Customers.CustomerID, Orders.OrderID, Orders.OrderDate
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
ORDER BY Customers.CustomerID;

























		

























