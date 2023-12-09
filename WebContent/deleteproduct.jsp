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
    String productId = request.getParameter("productId");

    PreparedStatement queryFindProduct = con.prepareStatement("SELECT * FROM product WHERE productName = ? AND productId = ?;");
    queryFindProduct.setString(1, productName);
    queryFindProduct.setInt(2, Integer.parseInt(productId));
    ResultSet productFound = queryFindProduct.executeQuery();

    if(!productFound.next())
    {
        out.println("<h3>Product not found </h3>");
        out.println("<h2><a href=\"deleteproduct.jsp\">Go Back</a></h2>");
    }//if

    else
    {

        PreparedStatement queryDeleteProduct = con.prepareStatement("DELETE FROM product WHERE productName = ? AND productId = ?;");
        queryDeleteProduct.setString(1, productName);
        queryDeleteProduct.setInt(2, Integer.parseInt(productId));

        queryDeleteProduct.executeUpdate();

        out.println("<h3>Product Deleted </h3>");
        out.println("<h2><a href=\"index.jsp\">Go to Home Page</a></h2>");
    }//else

}//if

else
{
    %>

    <h3>Product Name: </h3>

    <form method="post" action="deleteproduct.jsp">
    <input type="text" name="productName" size="50">

   <h3>Product ID: </h3>

    <input type="text" name="productId" size="50">

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

