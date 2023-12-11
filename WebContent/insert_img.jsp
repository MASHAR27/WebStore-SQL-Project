"OK"
<%@ include file="jdbc.jsp" %>

<%
response.setContentType("application/json");

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";                
String pw = "304#sa#pw";

System.out.println("Connecting to database.");
Connection con = DriverManager.getConnection(url, uid, pw);
String insertImage= "INSERT INTO Image (imageBase64) VALUES (?)";
PreparedStatement insertStmt = con.prepareStatement(insertImage);
out.print(request.getParameter("img"));
insertStmt.setString(1, request.getParameter("img"));
insertStmt.executeUpdate();
%>