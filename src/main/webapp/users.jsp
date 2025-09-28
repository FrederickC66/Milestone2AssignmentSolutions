<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Management - Milestone2 Assignment</title>
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
            max-width: 1000px;
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
        .alert {
            padding: 12px 20px;
            border-radius: 6px;
            margin: 20px 0;
            font-weight: 500;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 20px 0;
            flex-wrap: wrap;
            gap: 10px;
        }
        .btn {
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            border: none;
            cursor: pointer;
            display: inline-block;
            transition: all 0.3s;
        }
        .btn-primary {
            background: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background: #0056b3;
        }
        .btn-success {
            background: #28a745;
            color: white;
        }
        .btn-success:hover {
            background: #218838;
        }
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        .btn-danger:hover {
            background: #c82333;
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background: #545b62;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background: white;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #333;
        }
        tr:hover {
            background-color: #f8f9fa;
        }
        .stats {
            background: #e8f4fd;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            text-align: center;
        }
        .no-users {
            text-align: center;
            color: #666;
            font-style: italic;
            padding: 40px;
        }
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        .action-buttons a {
            padding: 6px 12px;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>👥 User Management</h1>
        
        <!-- Display success/error messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                ✅ ${success}
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ❌ ${error}
            </div>
        </c:if>
        
        <div class="stats">
            <h3>📊 Statistics</h3>
            <p>Total Users: <strong>${userCount}</strong></p>
            <p>This demonstrates servlet-DAO integration with JDBC concepts</p>
        </div>
        
        <div class="actions">
            <div>
                <a href="users?action=add" class="btn btn-success">➕ Add New User</a>
                <a href="users" class="btn btn-primary">🔄 Refresh</a>
            </div>
            <div>
                <a href="index.jsp" class="btn btn-secondary">🏠 Home</a>
                <a href="hello" class="btn btn-secondary">📝 Hello Servlet</a>
            </div>
        </div>
        
        <c:choose>
            <c:when test="${not empty users}">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Created At</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr>
                                <td>${user.id}</td>
                                <td>${user.name}</td>
                                <td>${user.email}</td>
                                <td>
                                    <fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" />
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="users?action=edit&id=${user.id}" class="btn btn-primary">✏️ Edit</a>
                                        <a href="users?action=delete&id=${user.id}" 
                                           class="btn btn-danger"
                                           onclick="return confirm('Are you sure you want to delete ${user.name}?')">
                                           🗑️ Delete
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="no-users">
                    <h3>No users found</h3>
                    <p>Start by adding some users to see them listed here.</p>
                    <a href="users?action=add" class="btn btn-success">➕ Add First User</a>
                </div>
            </c:otherwise>
        </c:choose>
        
        <div style="margin-top: 40px; padding: 20px; background: #f8f9fa; border-radius: 8px;">
            <h4>💡 About This Demo</h4>
            <ul>
                <li><strong>Servlet Integration:</strong> UserServlet handles all CRUD operations</li>
                <li><strong>JSP Display:</strong> This page uses JSTL tags for dynamic content</li>
                <li><strong>DAO Pattern:</strong> UserDAO manages data operations (currently in-memory)</li>
                <li><strong>JDBC Ready:</strong> Code structure prepared for MySQL integration</li>
                <li><strong>Maven Dependencies:</strong> All required libraries configured</li>
            </ul>
        </div>
    </div>
</body>
</html>