<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Zumba Class - Login</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <main>
        <div>
            <h1>Zumba Class</h1>
            <div class="login-box">
                <form action="login" method="post">
                    <input type="email" name="email" placeholder="Email" required>
                    <input type="password" name="password" placeholder="Password" required>
                    <button type="submit">Login</button>
                </form>
            </div>
            <button onclick="window.location.href='register'">Create Account</button>
        </div>
    </main>
</body>
</html>
