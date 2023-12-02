<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<a href="listprod.jsp">Begin Shopping</a>  

<a href="listorder.jsp">List All Orders</a>

<a href="login.jsp">Login</a>
	<b><title>Aadil and Ashar's Shopping Cart</title></b>
<!-- Page Header -->
<div class="header">
    <h1>Aadil and Ashar's Grocery Store</h1>
    <nav>
        <ul>
            <li><a href="/listprod.jsp">Products</a></li>
            <li><a href="/listorder.jsp">List Orders</a></li>
            <li><a href="/showcart.jsp">Shopping Cart</a></li>
        </ul>
    </nav>
</div>
<style>
	table, th, td {
	  border: 4px solid blue;
	  border-collapse: collapse;
	  font-size: 22px
	  
	}
	td {
		background-color: rgb(166, 166, 236); 
		padding: 8px; 
	  }
	th {
		background-color: yellow; 
		padding: 8px; 
	  }
	  h1{
		color: rgb(21, 174, 26);
		font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	  }
	</style>
</head>
<body>

<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0));  // Prints $5.00

// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";                
	String pw = "304#sa#pw";

System.out.println("Connecting to database.");
Connection con = DriverManager.getConnection(url, uid, pw);

// Write query to retrieve all order summary records
String sql = "SELECT ordersummary.orderId, ordersummary.orderDate, customer.customerId, " +
"customer.firstName, customer.lastName, ordersummary.totalAmount " +
"FROM ordersummary JOIN customer ON ordersummary.customerId = " +
"customer.customerId";
Statement stmt = con.createStatement();
ResultSet rst = stmt.executeQuery(sql);


// For each order in the ResultSet

	// Print out the order summary information
	
	%>
		<table>
			<tr>
				<th>Order ID</th> 
				<th>Order Date</th>
				<th>Customer Id</th>
				<th>Customer Name</th>
				<th></th>
				<th>Total Amount</th>
			</tr>
	<%
	
	while(rst.next())
	{
		out.println("<td>"+rst.getInt(1)+"</td>"+"<td>"+rst.getDate(2)+"</td>"+"<td>"+rst.getInt(3)+"</td>"+"<td>"+rst.getString(4)+"</td>"+"<td>"+rst.getString(5)+"</td>"+"<td>"+"$"+rst.getDouble(6)+"</td>");
		%>
		
		<tr>
				<th>Product ID</th> 
				<th>Quantity</th>
				<th>Price</th>
		</tr>

		<%

		String sql2 = "SELECT orderproduct.orderID, orderproduct.productId, orderproduct.quantity, orderproduct.price FROM orderproduct JOIN ordersummary ON orderproduct.orderId = ordersummary.orderId WHERE orderproduct.orderId = ?";
	
		PreparedStatement pstmt = con.prepareStatement(sql2);
		pstmt.setInt(1, rst.getInt(3));
		ResultSet rst2 = pstmt.executeQuery();

		
		while(rst2.next())
		{
			%>
			<tr>
			<%
			out.println("<td>"+rst2.getInt(2)+"</td>"+"<td>"+rst2.getInt(3)+"</td>"+"<td>"+"$"+rst2.getDouble(4)+"</td>");
			%>
			</tr>
			<%
		}

	}//while
	%>
</table>
<%
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
	// Write out product information 

// Close connection

System.out.println("Closing database connection.");
		try
		{
			if (con != null)
	            con.close();
		}
		catch (SQLException e)
		{
			System.out.println(e);
		}
%>

</body>
</html>

