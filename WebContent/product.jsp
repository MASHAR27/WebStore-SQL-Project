<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>

<a href="listprod.jsp">Begin Shopping</a>  

<a href="listorder.jsp">List All Orders</a>

<a href="login.jsp">Login</a>
<title>Aadil, Ashar and Wayne's Grocery - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
// Get product name to search for
// TODO: Retrieve and display info for the product

String productName = request.getParameter("productName");

// Make connection

	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	String uid = "sa";                
		String pw = "304#sa#pw";

		System.out.println("Connecting to database.");
		Connection con = DriverManager.getConnection(url, uid, pw);

	

//Searching for product

PreparedStatement queryProductName = con.prepareStatement("SELECT * FROM product WHERE product.productName = ?");
queryProductName.setString(1, productName);
ResultSet rstProductName = queryProductName.executeQuery();
boolean foundProductName = false;
while(rstProductName.next())
{
	if(productName.matches(rstProductName.getString("productName")))
	{
		foundProductName = true;
		break;
	}//if
}//while

if (!foundProductName) {
    out.println("<p>Error: Product not found.</p>");
}
else
{
    out.println("<h3>" + rstProductName.getString("productName") + "</h3>");
    %>
    <br>
    <%
    out.println("<img src = ' " + rstProductName.getString("productImageURL") + " ' alt = 'Product Image'>");
    out.println("<img src=\"displayImage.jsp?id="+rstProductName.getInt("productId")+"\">");
	%>
    <br>
    <%
	out.println("<h3> id " + rstProductName.getInt("productId") + "</h3>");
	%>
    <br>
    <%
    out.println("<h3> Price: $ " + rstProductName.getDouble("productPrice") + "</h3>");
	%>
    <br>
    <%
	out.println("<h3><a href=\"addcart.jsp?id="+rstProductName.getInt("productId")+ "&name=" + rstProductName.getString(2)
	+ "&price=" + rstProductName.getDouble(3)+"\">Add to Cart</a></h3>");	
	
	%>
    <br>
    <%

}

String sql = "";

// TODO: If there is a productImageURL, display using IMG tag
		
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
		
// TODO: Add links to Add to Cart and Continue Shopping

//out.println(<h3><a href="continueShopping.jsp"> Continue Shopping </a></h3>);

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



<h3><a href="listprod.jsp"> Continue Shopping </a></h3>
<br>

</body>
</html>

