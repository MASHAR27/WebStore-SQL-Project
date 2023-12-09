<%@ include file="jdbc.jsp" %>
<%
   // Returns all employees (active and terminated) as json.
   response.setContentType("application/json");
   String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	String uid = "sa";                
   String pw = "304#sa#pw";

   // System.out.println("Go");
   Connection con = DriverManager.getConnection(url, uid, pw);
	PreparedStatement queryHistory = con.prepareStatement("SELECT productName from product WHERE productId IN (SELECT orderproduct.productId FROM orderproduct WHERE orderproduct.orderId IN (SELECT orderId from ordersummary WHERE customerId=?))");
   queryHistory.setInt(1, Integer.parseInt(request.getParameter("uid")));
   ResultSet rstOrderId = queryHistory.executeQuery();
   System.out.println(rstOrderId);
   out.clearBuffer();

   out.println("[");
   boolean first = true;
   while(rstOrderId.next())
	{
      if(!first)
      {
         out.println(",");
      }
         first = false;
      out.print('"');
       out.print(rstOrderId.getString("productName"));
      out.print('"');

	}
   out.println("]");
%>