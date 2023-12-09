<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);
	

	try
	{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;
		String sqlexc= null;
	

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

		try 
		{
			getConnection();
			
		// TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
			//retStr = "";	
			// Making  connection
			//String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            //String uid = "sa";                
	        //String pw = "304#sa#pw";
			//Connection con = DriverManager.getConnection(url, uid, pw);
			// Creating the query
			String sql = "SELECT userid, password FROM customer " ;
            Statement stmt = con.createStatement();
            ResultSet rst = stmt.executeQuery(sql);


		// check every sql customer record to see if it's a valid id and password
		while(rst.next()){
           String cuser = rst.getString("userid");
		   String cpass = rst.getString("password");
		   if(cuser.equals(username) && cpass.equals(password) ){
			retStr= username;
			break;
		   }


		}
			
			
			
		} 
		catch (SQLException ex) {
			
			out.println(ex);
			sqlexc=ex.getMessage();
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
		}
		else
			session.setAttribute("loginMessage","Could not connect to the system using that username/password."+sqlexc);

		return retStr;
	}
%>

