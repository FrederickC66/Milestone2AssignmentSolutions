<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>
    <link href="css/style.css" rel="stylesheet" type="text/css">
</head>
<body>
    <main>
        <div>
            <h1>Create Account</h1>
            <form action="register" method="post">
                <div class="login-box">
                    <input type="text" name="name" placeholder="Name" required>
                </div>
                <div class="login-box">
                    <input type="email" name="email" placeholder="Email Address" required>
                </div>
                <div class="login-box">
                    <input type="tel" name="phone" placeholder="Phone Number" required>
                </div>
                <div class="login-box">
                    <input type="password" name="password" placeholder="Password" required>
                </div>
                <button type="submit">Create Account</button>
            </form>
            <button type="button" onclick="window.location.href='index.jsp'">Back to Login</button>
        </div>
    </main>
</body>
</html>