<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Create Account</title>
</head>
<body>
    <h1>Create Account</h1>
    <form action="CreateAccountServlet" method="post">
        Username: <input type="text" name="username" required><br>
        Password: <input type="password" name="password" required><br>
        Email: <input type="email" name="email" required><br>
        Address: <input type="text" name="address" required><br>
        <input type="submit" value="Create Account">
    </form>
</body>
</html>
