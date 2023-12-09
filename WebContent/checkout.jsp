<!DOCTYPE html>
<html>
<head>
<a href="listprod.jsp">Begin Shopping</a>  

<a href="listorder.jsp">List All Orders</a>

<a href="login.jsp">Login</a>
<title>Aadil, Ashar and Wayne's Grocery CheckOut Line</title>
</head>
<body>

<h1>Enter your customer id to complete the transaction:</h1>

<form method="get" action="order.jsp">
<input type="text" name="customerId" size="50">

<!-- Bonus marks for customer's password. Validation done in order.jsp-->

<h1>Enter your password to complete the transaction:</h1>

<input type="text" name="passwordEntered" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset">
</form>

</body>
</html>

