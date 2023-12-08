<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Aadil and Ashar's Shopping Cart</title>
	<a href="listprod.jsp">Begin Shopping</a>  

<a href="listorder.jsp">List All Orders</a>

<a href="login.jsp">Login</a>
<style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 20px;
        }
        h1 {
            color: #333;
            text-align: center;
        }
        form {
            text-align: center;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            background-color: #fff;
            margin-bottom: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
        td img {
            max-width: 100px;
            max-height: 100px;
        }
        a {
            color: blue;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit">
<input type="reset" value="Reset"> (Leave blank for all products)

<br><br>

    <label for="categoryName">Search by Category Name:</label>
    <input type="text" id="categoryName" name="categoryName">
    <input type="submit" value="Search by Category"></input>


</form>

<% // Get product name to search for
String name = request.getParameter("productName");
String categoryName = request.getParameter("categoryName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Make the connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";                
	String pw = "304#sa#pw";

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

try
{
	System.out.println("Connecting to database.");
	Connection con = DriverManager.getConnection(url, uid, pw);
	//</br></br>PreparedStatement pstmt = con.prepareStatement("SELECT * FROM product WHERE productName LIKE ?");
	//</input></input>pstmt.setString(1, "%" + name + "%");
	//</input>ResultSet rst = pstmt.executeQuery();
	PreparedStatement pstmt;

    if (categoryName != null && !categoryName.isEmpty()) {
        pstmt = con.prepareStatement("SELECT * FROM product JOIN Category on product.categoryId=Category.categoryId WHERE Category.categoryName LIKE ?");
        pstmt.setString(1, "%" + categoryName + "%");
    } else {
        pstmt = con.prepareStatement("SELECT * FROM product WHERE productName LIKE ?");
        pstmt.setString(1, "%" + name + "%");
    }

    ResultSet rst = pstmt.executeQuery();


	// Print out the ResultSet
%>
<iframe src="http://giphy.com/embed/e6lyxcRngMS1jbTyXS" width="480" height="270" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="http://giphy.com/gifs/smartypants-lavieenslip-e6lyxcRngMS1jbTyXS">via GIPHY</a></p>

<table>
	<tr>
		<th>Product ID</th> 
		<th>Product Name</th>
		<th>Product  Price</th>
		<th>Product  DESC</th>
		<th>Product  categoryId</th>
	</tr>
<%
int i = 0;
while (rst.next()) 
{ 
	%>
	<tr>
	<%
	i++;
	out.println("<td>" + rst.getInt("productId") + "</td>" + "<td>" + rst.getString("productName") + "</td>" +  "<td>" + rst.getDouble("productPrice") + "</td>" + "<td>"  + rst.getString("productDesc") + "</td>" + "<td>" + rst.getInt("categoryId") + "</td>");
	%>
	</tr>
	<%
}//while
if(i == 0)
{
	PreparedStatement pstmt2 = con.prepareStatement("SELECT * FROM product ");
	ResultSet rst2 = pstmt2.executeQuery();
	while (rst2.next()) 
	{ 
		%>
		<tr>
		<%
		i++;
		out.println("<td>" + rst2.getInt("productId") + "</td>" + "<td>" + rst2.getString("productName") + "</td>" +  "<td>" + rst2.getDouble("productPrice") + "</td>" + "<td>" + rst2.getString("productDesc") + "</td>" + "<td>" + rst2.getInt("categoryId") + "</td>");
		%>
		</tr>
		<%

		// For each product create a link of the form
		// addcart.jsp?id=productId&name=productName&price=productPrice

	out.println("<p>" + "<a href= \"product.jsp?productName="+rst2.getString("productName")+"\">" 
	+ rst2.getString("productName") + "</a>" + " - " 
	+ NumberFormat.getCurrencyInstance().format(rst2.getDouble("productPrice")) + "</p>");
	}//while
}//if

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


}//try
catch(SQLException e)
{
	out.println("SQLException: " + e);
}


%>

</body>
</html>