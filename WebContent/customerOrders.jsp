<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
	<b><title>Aadil, Ashar and Wayne's Shopping Cart</title></b>
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

String username = (String) session.getAttribute("authenticatedUser");
out.println(username);
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

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

String sql = "SELECT * FROM ordersummary JOIN customer ON ordersummary.customerId = customer.customerId WHERE customer.userid = ? ";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setString(1, username);
ResultSet rst = pstmt.executeQuery();
	
	while(rst.next())
	{
        out.println("<h2><p> Order ID: " + rst.getInt("orderId") + " </p></h2>");
        out.println("<h2><p> Order Date: " + rst.getString("orderDate") + " </p></h2>");

        String sql2 = "SELECT * FROM ordersummary JOIN customer ON ordersummary.customerId" + 
        " = customer.customerId JOIN orderproduct ON orderproduct.orderId = ordersummary.orderId JOIN product ON orderproduct.productId = product.productId WHERE customer.userid = ? AND ordersummary.orderId = ? ";
        PreparedStatement pstmt2 = con.prepareStatement(sql2);
        pstmt2.setString(1, username);
        pstmt2.setString(2, String.valueOf(rst.getInt("orderId")));
        ResultSet rst2 = pstmt2.executeQuery();
        %>
		<table>
        <%
        while(rst2.next())
        {
		    out.println("<tr><td>"+rst2.getInt("productId")+"</td>"+"<td>"+rst2.getString("productName")+"</td>"+"<td>"+rst2.getInt("quantity")+"</td>"+"<td>"+rst2.getDouble("price")+"</td></tr>");
        }//while
            out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
                +"<td>"+currFormat.format(rst.getDouble("totalAmount"))+"</td></tr>");       
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

