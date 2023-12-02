<!DOCTYPE html>
<html>
<head>
<a href="listprod.jsp">Begin Shopping</a>  

<a href="listorder.jsp">List All Orders</a>

<a href="login.jsp">Login</a>
<title>Login Screen</title>
</head>
<body>

<div style="margin:0 auto;text-align:center;display:inline">

<h3>Please Login to System</h3>

<%
if (session.getAttribute("loginMessage") != null) {
    out.println("<p>" + session.getAttribute("loginMessage").toString() + "</p>");
}
%>

<br>
<form name="MyForm" method=post action="validateLogin.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Username:</font></div></td>
	<td><input type="text" name="username"  size=10 maxlength=10></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Password:</font></div></td>
	<td><input type="password" name="password" size=10 maxlength="10"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Log In">
</form>

</div>

</body>
</html>

