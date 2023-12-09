<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
<style>
	  h3{
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

// Make connection

	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	String uid = "sa";                
		String pw = "304#sa#pw";

		System.out.println("Connecting to database.");
		Connection con = DriverManager.getConnection(url, uid, pw);

if (request.getMethod().equalsIgnoreCase("post"))
{
    String productName = request.getParameter("productName");
    String categoryID = request.getParameter("categoryID");
    String productDesc = request.getParameter("productDesc");
    String productPrice = request.getParameter("productPrice");


    PreparedStatement queryAddProduct = con.prepareStatement("INSERT product(productName, categoryId, productDesc, productPrice) VALUES (?, ?, ?,?);");
    queryAddProduct.setString(1, productName);
    queryAddProduct.setInt(2, Integer.parseInt(categoryID));
    queryAddProduct.setString(3, productDesc);
    queryAddProduct.setDouble(4, Double.parseDouble(productPrice));

    queryAddProduct.executeUpdate();

    out.println("<h3>Product Added </h3>");

    out.println("<h2><a href=\"index.jsp\">Go to Home Page</a></h2>");


}//if

else
{
    %>

    <h3>Product Name: </h3>

    <form method="post" action="addproduct.jsp">
    <input type="text" name="productName" size="50">

   <h3>Category ID: </h3>

    <input type="text" name="categoryID" size="50">

    <h3>Product Description: </h3>

    <input type="text" name="productDesc" size="50">

    <h3>Price: </h3>

    <input type="text" name="productPrice" size="50">

    <input type="submit" value="Submit"><input type="reset" value="Reset">


    </form>

    <%

}//else

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

