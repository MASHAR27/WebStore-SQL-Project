<!DOCTYPE html>
<html>
<head>
<a href="listprod.jsp">Begin Shopping</a>  

<a href="listorder.jsp">List All Orders</a>

<a href="login.jsp">Login</a>
        <title>Aadil, Ashar and Wayne's' Grocery Main Page</title>
</head>
<body>
<h1 align="center">Welcome to Aadil, Ashar and Wayne's Grocery</h1>

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>
<h2 align="center"><a href="customerOrders.jsp">Customer Orders</a></h2>
<h2 align="center"><a href="warehouseList.jsp">Warehouse Inventory</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
	if (userName != null)
		out.println("<h3 align=\"center\">Signed in as: "+userName+"</h3>");
%>

<h4 align="center"><a href="ship.jsp?orderId=1">Test Ship orderId=1</a></h4>

<h4 align="center"><a href="ship.jsp?orderId=3">Test Ship orderId=3</a></h4>

</body>
</head>


