<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Aadil, Ashar and Wayne's Shopping Cart</title>
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
      h2{
		color: rgb(174, 115, 21);
		font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	  }
	</style>
</head>
<body>

<h1>Warehouse Inventory </h1>

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

// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";                
	String pw = "304#sa#pw";

System.out.println("Connecting to database.");
Connection con = DriverManager.getConnection(url, uid, pw);

// Write query to retrieve all order summary records
String sql = "SELECT * FROM warehouse";
Statement stmt = con.createStatement();
ResultSet rst = stmt.executeQuery(sql);


// For each order in the ResultSet

	// Print out the warehouse information
	
	while(rst.next())
	{
		out.println("<h2><p> Warehouse: " + rst.getString("warehouseName") + "</p></h2>");
		%>
		
		<table>
			<tr>
				<th>Product ID</th> 
				<th>Product Name</th>
				<th>Quantity</th>
				<th>Price</th>
			</tr>

		<%

		String sql2 = "SELECT * FROM productInventory JOIN warehouse " +
        "ON productInventory.warehouseId = warehouse.warehouseId JOIN " +
        "product ON product.productId = productInventory.productId " +
        "WHERE warehouse.warehouseId = ?";
		PreparedStatement pstmt = con.prepareStatement(sql2);
		pstmt.setInt(1, rst.getInt("warehouseId"));
		ResultSet rst2 = pstmt.executeQuery();

		
		while(rst2.next())
		{
			%>
			<tr>
			<%
			out.println("<td>"+rst2.getInt("productId")+"</td>"+"<td>"+rst2.getString("productName") + "</td>" + "<td>" + rst2.getInt("quantity")+"</td>"+"<td>"+"$"+rst2.getDouble("price")+"</td>");
			%>
			</tr>
			<%
		}
        %>
    </table>
    <%
	}//while
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

