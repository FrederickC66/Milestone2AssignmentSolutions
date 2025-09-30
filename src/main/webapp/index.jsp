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
            
            <%-- Display error messages --%>
            <%
                String error = request.getParameter("error");
                if (error != null) {
                    String errorMessage = "";
                    switch (error) {
                        case "invalid_credentials":
                            errorMessage = "Invalid email or password. Please try again.";
                            break;
                        case "missing_fields":
                            errorMessage = "Please enter both email and password.";
                            break;
                        case "database_error":
                            errorMessage = "System error. Please try again later.";
                            break;
                        case "please_login":
                            errorMessage = "Please log in to access the dashboard.";
                            break;
                    }
                    if (!errorMessage.isEmpty()) {
            %>
                        <div style="color: red; text-align: center; margin-bottom: 15px; padding: 10px; background-color: #ffe6e6; border: 1px solid #ff9999; border-radius: 5px;">
                            <%= errorMessage %>
                        </div>
            <%
                    }
                }
            %>
            
            <div class="login-box">
                <form action="login" method="post">
                    <input type="email" name="email" placeholder="Email" required>
                    <input type="password" name="password" placeholder="Password" required>
                    <button type="submit">Login</button>
                </form>
            </div>
            <button onclick="window.location.href='register.jsp'">Create Account</button>
        </div>
    </main>
</body>
</html>
