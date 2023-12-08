<%@ page language="java" import="java.io.*,java.sql.*, java.text.*, java.util.*, java.util.Map, java.util.HashMap" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<!DOCTYPE html>
<html>
<a href="listprod.jsp">Begin Shopping</a>  

<a href="listorder.jsp">List All Orders</a>

<a href="login.jsp">Login</a>
<head>
<title>Administrator Page</title>
</head>
<body>

<%
// TODO: Include files auth.jsp and jdbc.jsp






%>
<%

try{
// TODO: Write SQL query that prints out total order amount by day
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String uid = "sa";                
	        String pw = "304#sa#pw";
			Connection con = DriverManager.getConnection(url, uid, pw);
            String sql = "SELECT orderDate,totalAmount FROM ordersummary";
            PreparedStatement pstmt = con.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
            
      
                      HashMap<String,Double> jk = new HashMap<>();


                           while(rs.next()){
                            String orderDateWithTime = rs.getString("orderDate"); 
                            String orderDateWithoutTime = orderDateWithTime.substring(0, 10);
                            if(jk.containsKey(orderDateWithoutTime) ){
                             double k= jk.get(orderDateWithoutTime);
                             double result = k+ rs.getDouble("totalAmount");
                             jk.put(orderDateWithoutTime,result);


                            }
                            else
                            {
                                jk.put(orderDateWithoutTime,rs.getDouble("totalAmount"));
                                out.println("Hello");
                            }//else

                        
                            out.println("Hello");

                           }//while

                           for (Map.Entry<String, Double> entry : jk.entrySet()) {
                            out.println(" Order Date: " + entry.getKey() + ", Total Order Amount: " + entry.getValue()+ "<br>"); 
                        }//for

                           
                           %>
                           

<%


                    }//try


catch (Exception e) {
     out.println("Exception: "+e);
 // Handle exceptions properly
}//catch


%>



</body>
</html>

