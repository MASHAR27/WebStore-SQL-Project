<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Aadil, Ashar and Wayne's Grocery Order Processing</title>
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

<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})

String passwordEntered = request.getParameter("passwordEntered");
@SuppressWarnings({"unchecked"})

String name = request.getParameter("name");
@SuppressWarnings({"unchecked"})

String number = request.getParameter("number");
@SuppressWarnings({"unchecked"})

String CVV = request.getParameter("CVV");
@SuppressWarnings({"unchecked"})

String month = request.getParameter("month");
@SuppressWarnings({"unchecked"})



HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

	// Make connection

	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	String uid = "sa";                
		String pw = "304#sa#pw";

		System.out.println("Connecting to database.");
		Connection con = DriverManager.getConnection(url, uid, pw);

	
// Determine if valid customer id was entered

Statement queryCustomerId = con.createStatement();
ResultSet rstCustomerId = queryCustomerId.executeQuery("SELECT customerId FROM customer");
boolean foundCustomerId = false;
while(rstCustomerId.next())
{
	if(custId.matches(String.valueOf(rstCustomerId.getInt("customerId"))))
	{
		foundCustomerId = true;
		break;
	}//if
}//while

if (!foundCustomerId) {
    out.println("<p>Error: Invalid customer id.</p>");
}

// Bonus marks for customer's password validation

// Determine if valid password was entered

PreparedStatement queryPassword = con.prepareStatement("SELECT password FROM customer WHERE customerId = ? AND password = ?");
queryPassword.setString(1, custId);
queryPassword.setString(2, passwordEntered);
ResultSet rstPassword = queryPassword.executeQuery();

boolean foundPassword = false;
try
{

while(rstPassword.next())
{
	if(passwordEntered.matches(rstPassword.getString("password")))
	{
		foundPassword = true;
		break;
	}//if
}//while
}
catch(Exception e)
{
	out.println("Exception is : "+e.getMessage());
}
if (!foundPassword) {
    out.println("<p>Error: Password does not match.</p>");
}

// Determine if there are products in the shopping cart
// If either are not true, display an error message

else if (productList == null || productList.isEmpty()) 
{
    out.println("<p>Error: Shopping cart is empty.</p>");
}
else
{

	// Save order information to database

	int orderIdRetrieved = -1; // Default value if insertion fails or ID retrieval fails

    String insertOrderQuery = "INSERT INTO OrderSummary (CustomerId) VALUES (?)";
    String retrieveIdQuery = "SELECT SCOPE_IDENTITY() AS Last_Inserted_Id";

    try (PreparedStatement insertStmt = con.prepareStatement(insertOrderQuery, Statement.RETURN_GENERATED_KEYS)) {
        insertStmt.setString(1, custId);

        int rowsAffected = insertStmt.executeUpdate();

        if (rowsAffected == 0) {
            throw new SQLException("Insertion into OrderSummary failed, no rows affected.");
        }

        try (ResultSet generatedKeys = insertStmt.getGeneratedKeys()) {
            if (generatedKeys.next()) {
                orderIdRetrieved = generatedKeys.getInt(1);
				if (rowsAffected == 0) {
					throw new SQLException("Insertion into paymentmethod failed, no rows affected.");
				}

            } else {
                throw new SQLException("Failed to retrieve auto-generated ID for OrderSummary.");
            }
        } catch (SQLException e) {
            throw new SQLException("Failed to retrieve auto-generated ID for OrderSummary.", e);
        }
    } catch (SQLException e) {
        throw new SQLException("Error inserting into OrderSummary: " + e.getMessage(), e);
    }
		String CredtCardInsert = "INSERT INTO paymentmethod (paymentType, paymentNumber, paymentExpiryDate, customerId) VALUES ('Credit', ?, ?, ?)";
		try(PreparedStatement insertCred = con.prepareStatement(CredtCardInsert, Statement.RETURN_GENERATED_KEYS))
		{
			insertCred.setString(1, number);
			insertCred.setString(2, month);
			insertCred.setString(3, custId);
			int rowsAffected2 = insertCred.executeUpdate();
			// ResultSet generatedKeys2 = insertCred.getGeneratedKeys()
			// generatedKeys2.next()
			// int creditId = generatedKeys2.getInt(1);
		} catch (SQLException e) {
       	 throw new SQLException("Error inserting " + e.getMessage(), e);
    }

		/*
		// Use retrieval of auto-generated keys.
		PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
		ResultSet keys = pstmt.getGeneratedKeys();
		keys.next();
		int orderIdRetrieved = keys.getInt(1);
		*/

	// Insert each item into OrderProduct table using OrderId from previous INSERT

	
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
				while (iterator.hasNext())
				{ 
					Map.Entry<String, ArrayList<Object>> entry = iterator.next();
					ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
					String productId= String.valueOf(product.get(0));
					try
					{
						String productName= String.valueOf(product.get(1));
						String price = String.valueOf(product.get(2));
						double pr = Double.parseDouble(price);
						int qty = ( (Integer)product.get(3)).intValue();
						
						PreparedStatement pstmt = con.prepareStatement("INSERT INTO OrderProduct " +
						"(orderId, productId, quantity, price) VALUES(?, ?, ?, ?)",
						Statement.RETURN_GENERATED_KEYS);
		
						pstmt.setInt(1, orderIdRetrieved);
						pstmt.setInt(2, Integer.parseInt(productId));
						pstmt.setInt(3,qty);
						pstmt.setDouble(4, pr);

						int rowsAffected = pstmt.executeUpdate();
					}//try
					catch(Exception e)
					{
						out.println("NumberExceptionHere: "+e);
					}//catch
				}//while

	// Update total amount for order record

		String sql = "UPDATE OrderSummary SET totalAmount = " +
								"(SELECT SUM(op.quantity * op.price) " +
								"FROM orderproduct AS op " +
								"JOIN product p ON op.productId = p.productId " +
								"WHERE op.orderId = ?) " +
								"WHERE orderId = ?";

		try (PreparedStatement updateStatement =
			con.prepareStatement(sql)) 
		{
			updateStatement.setInt(1, orderIdRetrieved);
			updateStatement.setInt(2, orderIdRetrieved);

			int rowsAffected = updateStatement.executeUpdate();

			if (rowsAffected == 0)
			{
				throw new SQLException("Updating total amount failed, no rows affected.");
			}
		} 	
		catch (SQLException e) 
		{
			out.println("Exception: "+ e);
		}


	// Here is the code to traverse through a HashMap
	// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price

	/*
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
		while (iterator.hasNext())
		{ 
			Map.Entry<String, ArrayList<Object>> entry = iterator.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			String productId = (String) product.get(0);
			String price = (String) product.get(2);
			double pr = Double.parseDouble(price);
			int qty = ( (Integer)product.get(3)).intValue();
				...
		}
	*/

	// Print out order summary


	out.println("<h2>Ordered Products</h2>");
    out.println("<p><strong>Order ID:</strong> " + orderIdRetrieved + "</p>");
    out.println("<h3>Ordered Items:</h3>");
    out.println("<table border='1'>");
    out.println("<tr><th>Product ID</th><th>Product Name</th><th>Quantity</th><th>Price</th></tr>");

    //for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator2 = productList.entrySet().iterator();
		while(iterator2.hasNext())
		{
			Map.Entry<String, ArrayList<Object>> entry = iterator2.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
        String productId = (String) product.get(0);
        String productName = (String) product.get(1);
        String quantity = String.valueOf(product.get(3));
		String priceStr = (String)(product.get(2));
        double price = Double.parseDouble(priceStr);

        out.println("<tr>");
        out.println("<td>" + productId + "</td>");
        out.println("<td>" + productName + "</td>");
        out.println("<td>" + quantity + "</td>");
        out.println("<td>" + price + "</td>");

		/*out.println("<td>"+<form method="get" action="updatequantity.jsp">
			<input type="text" name="newQuantity" size="50">
			<input type="submit" value="Submit">
			<input type="reset" value="Reset"> (Leave blank for all products)
			</form>+</td>) 
			*/
        out.println("</tr>");
    }//while

    out.println("</table>");
	out.println("	<script>	function remove(a)	{		cvv = prompt('Enter Your CVV to confirm')		fetch('/shop/remove.jsp?creditId='+a+'&CVV='+cvv).then(x=>x.json()).then((x)=>{alert('x')}))	}	</script>");
	out.println("<button onclick='remove()'>Remove Credit Card Info (ajax)</button>");
	// Clear cart if order placed successfully

	session.removeAttribute("productList");

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
		
}
%>
</BODY>
</HTML>

