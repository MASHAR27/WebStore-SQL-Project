<!DOCTYPE html>
<html>
<head>
<a href="listprod.jsp">Begin Shopping</a>  

<a href="listorder.jsp">List All Orders</a>

<a href="login.jsp">Login</a>
<title>Customer Page</title>
<style>
	table, th, td {
	  border: 4px solid blue;
	  border-collapse: collapse;
	  font-size: 22px
	   
	}
	td {
		background-color: rgb(166, 166, 236); /* Set the background color for table cells */
		padding: 8px; /* Add padding for better spacing */
	  }
	th {
		background-color: yellow; /* Set the background color for table cells */
		padding: 8px; /* Add padding for better spacing */
	  }
	  h1{
		color: blue;
		font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	  }
	</style>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userid = (String) session.getAttribute("authenticatedUser");
%>

<%

// Make connection

	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	String uid = "sa";                
		String pw = "304#sa#pw";

		System.out.println("Connecting to database.");
		Connection con = DriverManager.getConnection(url, uid, pw);

	

// TODO: Print Customer information

PreparedStatement queryCustomerInfo = con.prepareStatement("SELECT * FROM customer WHERE userid = ?");
queryCustomerInfo.setString(1, userid);
ResultSet rstCustomerInfo = queryCustomerInfo.executeQuery();

%>

<h2> Customer Information </h2>

<table>

<%

while(rstCustomerInfo.next())
{
	out.println("<tr> <td> ID </td>" + "<td>" + rstCustomerInfo.getInt("customerId") + "</td> </tr>" + 
	"<tr> <td> First Name </td>" + "<td>" + rstCustomerInfo.getString("firstName") + "</td> </tr>" + 
	"<tr> <td> Last Name </td>" + "<td>" + rstCustomerInfo.getString("lastName") + "</td> </tr>" + 
	"<tr> <td> Email </td>" + "<td>" + rstCustomerInfo.getString("email") + "</td> </tr>" + 
	"<tr> <td> Phone </td>" + "<td>" + rstCustomerInfo.getString("phonenum") + "</td> </tr>" + 
	"<tr> <td> Address </td>" + "<td>" + rstCustomerInfo.getString("address") + "</td> </tr>" + 
	"<tr> <td> City </td>" + "<td>" + rstCustomerInfo.getString("city") + "</td> </tr>" + 
	"<tr> <td> State </td>" + "<td>" + rstCustomerInfo.getString("state") + "</td> </tr>" + 
	"<tr> <td> Postal Code </td>" + "<td>" + rstCustomerInfo.getString("postalCode") + "</td> </tr>" + 
	"<tr> <td> Country </td>" + "<td>" + rstCustomerInfo.getString("country") + "</td> </tr>" + 
	"<tr> <td> User ID </td>" + "<td>" + rstCustomerInfo.getString("userid") + "</td> </tr>" );
}//while

%>

</table>

<%

// Make sure to close connection

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

