<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<a href="listprod.jsp">Begin Shopping</a>  

<a href="listorder.jsp">List All Orders</a>

<a href="login.jsp">Login</a>
<title>Aadil and Ashar's Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	// TODO: Get order id
          
	String orderId = request.getParameter("orderId");


	// TODO: Check if valid order id in database
	
	// Make connection

	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	String uid = "sa";                
		String pw = "304#sa#pw";

		System.out.println("Connecting to database.");
		Connection con = DriverManager.getConnection(url, uid, pw);

	

	//Searching for order

	PreparedStatement queryOrderId = con.prepareStatement("SELECT * FROM orderproduct WHERE orderId = ?");
	queryOrderId.setInt(1, Integer.parseInt(orderId));
	ResultSet rstOrderId = queryOrderId.executeQuery();
	boolean foundOrderId = false;
	while(rstOrderId.next())
	{
		if(orderId.matches(rstOrderId.getString("orderId")))
		{
			foundOrderId = true;
			break;
		}//if
	}//while

	if (!foundOrderId) {
		out.println("<p>Error: Order not found.</p>");
	}//if
	else
	{

		// TODO: Start a transaction (turn-off auto-commit)
		con.setAutoCommit(false);

		
		// TODO: Retrieve all items in order with given id

		PreparedStatement queryOrderItems = con.prepareStatement("SELECT * FROM orderproduct WHERE orderId = ?");
		queryOrderItems.setInt(1, Integer.parseInt(orderId));
		ResultSet rstOrderItems = queryOrderItems.executeQuery();

		// TODO: Create a new shipment record.


		// TODO: For each item verify sufficient quantity available in warehouse 1.

		PreparedStatement queryOrderDate = con.prepareStatement("SELECT * FROM ordersummary WHERE orderId = ?");
		queryOrderDate.setInt(1, Integer.parseInt(orderId));
		ResultSet rstOrderDate = queryOrderDate.executeQuery();
		String dateOfShipment = "";
		while(rstOrderDate.next())
		{
			if(Integer.parseInt(orderId) == rstOrderDate.getInt("orderId"))
			{
				dateOfShipment = rstOrderDate.getString("orderDate");
				dateOfShipment = dateOfShipment.substring(0,dateOfShipment.indexOf(' '));
			}//if
		}//while

		boolean shipped = true;
		ResultSet rstShipment = null;
		int productId = 0;
		//Iterating through the products in the order
		while(rstOrderItems.next())
		{
			productId = rstOrderItems.getInt("productId");

			PreparedStatement queryProductInventory = con.prepareStatement("SELECT * FROM productinventory WHERE productId = ?");
			queryProductInventory.setInt(1, productId);
			ResultSet rstProductInventory = queryProductInventory.executeQuery();

			//Checking if quantity is less than equal to inventory in warehouse
			while(rstProductInventory.next())
			{
				if(rstOrderItems.getInt("quantity") <= rstProductInventory.getInt("quantity"))
				{
					//Calculating old and new inventory
					int prevInv = rstProductInventory.getInt("quantity");
					int newInv = rstProductInventory.getInt("quantity") - rstOrderItems.getInt("quantity");
					
					//Prepared Statement for Updating Inventory to New value
					PreparedStatement queryUpdateProductInventory = con.prepareStatement("UPDATE productinventory SET quantity = ? WHERE product = ?");
					queryUpdateProductInventory.setInt(1, newInv);
					queryUpdateProductInventory.setInt(2, productId);
			

					//Printing Product and inventory details
					out.println("<h3><p>Ordered Product: " + rstOrderItems.getInt("productId") + " Qty: " + rstOrderItems.getInt("quantity") + " Previous inventory: " + prevInv + " New inventory: " + newInv + "</p></h3>");
					
					con.commit();

				}//if
				else
				{
					productId = rstOrderItems.getInt("productId");

					String result = "Shipment not done. Insufficient inventory for product id: " + productId;

					//PreparedStatement queryInsertShipment = con.prepareStatement("INSERT INTO shipment (shipmentDate, shipmentDesc, wareHouseId) VALUES (?, ? , 1) WHERE orderId = ?");
					
					PreparedStatement queryInsertShipment = con.prepareStatement("INSERT INTO shipment (shipmentDate, shipmentDesc, wareHouseId) VALUES (?, ? , ?)");
					queryInsertShipment.setString(1, dateOfShipment);
					queryInsertShipment.setString(2, result);
					queryInsertShipment.setInt(3, 1);
					queryInsertShipment.executeUpdate();

					PreparedStatement queryShipment = con.prepareStatement("SELECT shipment.shipmentDesc FROM shipment JOIN productinventory ON shipment.warehouseId = productinventory.warehouseId JOIN orderproduct ON  orderproduct.productId = productinventory.productId WHERE orderproduct.orderId = ?");
					queryShipment.setInt(1, Integer.parseInt(orderId));
					rstShipment = queryShipment.executeQuery();

					con.rollback();

					shipped = false;
					out.println(result);
					break;

				}//else
			}//while
			if(!shipped)
			{
				break;	
			}//if
		}//while

		if(shipped)
		{
			String result = "Shipment succesfully processed";

			PreparedStatement queryInsertShipment = con.prepareStatement("INSERT INTO shipment (shipmentDate, shipmentDesc, wareHouseId) VALUES (?, ?, ?)");
					queryInsertShipment.setString(1, dateOfShipment);
					queryInsertShipment.setString(2, result);
					queryInsertShipment.setInt(3, 1);
					queryInsertShipment.executeUpdate();
					
					PreparedStatement queryShipment = con.prepareStatement("SELECT * FROM shipment JOIN productinventory ON shipment.warehouseId = productinventory.warehouseId JOIN orderproduct ON  orderproduct.productId = productinventory.productId WHERE orderproduct.orderId = ?");
					queryShipment.setInt(1, Integer.parseInt(orderId));
					rstShipment = queryShipment.executeQuery();
					out.println(result);
					
		}//if
		
		/*
		while(rstShipment.next())
		{
			out.println("<p>" + rstShipment.getInt("shipmentId") + ", " +  rstShipment.getString("shipmentDesc") +  rstShipment.getString("orderId") + "</p>");
		}//while
		*/

		// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
		
		// TODO: Auto-commit should be turned back on

		con.setAutoCommit(true);

	}//else

%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
