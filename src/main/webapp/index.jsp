<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Zumba Class - Login</title>
    <link rel="stylesheet" type="text/css" href="css/index.css">
</head>
<body>
    <main>
        <div>
            <h1>Zumba Class</h1>
            
            <%-- Display error messages --%>
            <c:if test="${not empty param.error}">
                <c:choose>
                    <c:when test="${param.error == 'invalid_credentials'}">
                        <c:set var="errorMessage" value="Invalid email or password. Please try again." />
                    </c:when>
                    <c:when test="${param.error == 'missing_fields'}">
                        <c:set var="errorMessage" value="Please enter both email and password." />
                    </c:when>
                    <c:when test="${param.error == 'database_error'}">
                        <c:set var="errorMessage" value="System error. Please try again later." />
                    </c:when>
                    <c:when test="${param.error == 'please_login'}">
                        <c:set var="errorMessage" value="Please log in to access the dashboard." />
                    </c:when>
                </c:choose>
                
                <c:if test="${not empty errorMessage}">
                    <div style="color: red; text-align: center; margin-bottom: 15px; padding: 10px; background-color: #ffe6e6; border: 1px solid #ff9999; border-radius: 5px;">
                        ${errorMessage}
                    </div>
                </c:if>
            </c:if>
            
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
