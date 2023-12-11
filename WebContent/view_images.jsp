<%@ include file="jdbc.jsp" %>

<%
   response.setContentType("application/json");
   out.clearBuffer();
   String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	String uid = "sa";                
   String pw = "304#sa#pw";

   // System.out.println("Go");
   Connection con = DriverManager.getConnection(url, uid, pw);
   PreparedStatement queryHistory = con.prepareStatement("SELECT * FROM Image");
   ResultSet rstOrderId = queryHistory.executeQuery();
   out.clearBuffer();

   out.println("[");
   boolean first = true;
   while(rstOrderId.next())
	{
        if(rstOrderId.getString("imageBase64")!=null)
        {

        
      if(!first)
      {
         out.println(",");
      }
         first = false;
      out.print('"');
       out.print(rstOrderId.getString("imageBase64"));
      out.print('"');

	}}
   out.println("]");
%>