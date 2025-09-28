<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${pageTitle} - Milestone2 Assignment</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #333;
        }
        input[type="text"], input[type="email"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            box-sizing: border-box;
        }
        input[type="text"]:focus, input[type="email"]:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 2px rgba(0,123,255,0.25);
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
            margin-right: 10px;
        }
        .btn-primary {
            background: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background: #0056b3;
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background: #545b62;
        }
        .form-actions {
            margin-top: 30px;
            text-align: center;
        }
        .alert {
            padding: 12px 20px;
            border-radius: 6px;
            margin: 20px 0;
            font-weight: 500;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .form-info {
            background: #e8f4fd;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        .required {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>
            <c:choose>
                <c:when test="${action == 'create'}">➕ Add New User</c:when>
                <c:otherwise>✏️ Edit User</c:otherwise>
            </c:choose>
        </h1>
        
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ❌ ${error}
            </div>
        </c:if>
        
        <div class="form-info">
            <h4>📝 User Information</h4>
            <p>
                <c:choose>
                    <c:when test="${action == 'create'}">
                        Fill in the details below to create a new user. This demonstrates servlet form processing.
                    </c:when>
                    <c:otherwise>
                        Update the user information below. Changes will be processed by the servlet.
                    </c:otherwise>
                </c:choose>
            </p>
        </div>
        
        <form action="users" method="post">
            <input type="hidden" name="action" value="${action}">
            <c:if test="${action == 'update'}">
                <input type="hidden" name="id" value="${user.id}">
            </c:if>
            
            <div class="form-group">
                <label for="name">Full Name <span class="required">*</span></label>
                <input type="text" 
                       id="name" 
                       name="name" 
                       value="${user.name}" 
                       placeholder="Enter full name"
                       required>
            </div>
            
            <div class="form-group">
                <label for="email">Email Address <span class="required">*</span></label>
                <input type="email" 
                       id="email" 
                       name="email" 
                       value="${user.email}" 
                       placeholder="Enter email address"
                       required>
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${action == 'create'}">➕ Create User</c:when>
                        <c:otherwise>💾 Update User</c:otherwise>
                    </c:choose>
                </button>
                <a href="users" class="btn btn-secondary">❌ Cancel</a>
            </div>
        </form>
        
        <div style="margin-top: 40px; padding: 20px; background: #f8f9fa; border-radius: 8px;">
            <h4>🔧 Technical Details</h4>
            <ul>
                <li><strong>Form Method:</strong> POST request to UserServlet</li>
                <li><strong>Validation:</strong> Client-side HTML5 validation + server-side checks</li>
                <li><strong>Action Parameter:</strong> ${action}</li>
                <li><strong>Data Flow:</strong> Form → Servlet → DAO → Model</li>
                <c:if test="${action == 'update'}">
                    <li><strong>User ID:</strong> ${user.id}</li>
                    <li><strong>Created:</strong> ${user.createdAt}</li>
                </c:if>
            </ul>
        </div>
        
        <div style="text-align: center; margin-top: 20px;">
            <a href="index.jsp" class="btn btn-secondary">🏠 Back to Home</a>
        </div>
    </div>
</body>
</html>