<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Milestone2 Assignment - Java 21 Web Application</title>
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
            max-width: 800px;
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
        .tech-stack {
            background: #e8f4fd;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        .feature {
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
            text-align: center;
            border-left: 4px solid #007bff;
        }
        .nav-links {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        .nav-links a {
            padding: 12px 24px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            transition: background-color 0.3s;
        }
        .nav-links a:hover {
            background: #0056b3;
        }
        .form-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }
        .form-section form {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }
        .form-section input[type="text"] {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-section button {
            padding: 8px 16px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .form-section button:hover {
            background: #218838;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Milestone2 Assignment Solution</h1>
        <p style="text-align: center; color: #666; font-size: 18px;">
            Java 21 LTS Web Application with Modern Technologies
        </p>
        
        <div class="tech-stack">
            <h3>🛠️ Technology Stack</h3>
            <div class="features">
                <div class="feature">
                    <h4>☕ Java 21 LTS</h4>
                    <p>Latest Long Term Support version with modern features</p>
                </div>
                <div class="feature">
                    <h4>🌐 Jakarta Servlets</h4>
                    <p>Server-side request handling and business logic</p>
                </div>
                <div class="feature">
                    <h4>📄 JSP Pages</h4>
                    <p>Dynamic web pages with Java integration</p>
                </div>
                <div class="feature">
                    <h4>🏗️ Maven</h4>
                    <p>Project management and dependency handling</p>
                </div>
                <div class="feature">
                    <h4>🗄️ JDBC Ready</h4>
                    <p>Database connectivity and data persistence</p>
                </div>
                <div class="feature">
                    <h4>🚀 Jetty Server</h4>
                    <p>Embedded web server for development</p>
                </div>
            </div>
        </div>
        
        <div class="form-section">
            <h3>🧪 Test Servlet with Parameters</h3>
            <form action="hello" method="get">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" placeholder="Enter your name">
                <label for="message">Message:</label>
                <input type="text" id="message" name="message" placeholder="Enter a message">
                <button type="submit">Send to Servlet</button>
            </form>
        </div>
        
        <div class="nav-links">
            <a href="hello">📝 Hello Servlet</a>
            <a href="users">👥 User Management</a>
            <a href="users?action=add">➕ Add User</a>
        </div>
        
        <div style="margin-top: 40px; padding: 20px; background: #e9ecef; border-radius: 8px; text-align: center;">
            <h3>🔗 What's Next?</h3>
            <p>Ready to add MySQL database integration when you're ready!</p>
            <ul style="text-align: left; display: inline-block;">
                <li>✅ Java 21 LTS configured</li>
                <li>✅ Servlets and JSP working</li>
                <li>✅ Maven dependencies set</li>
                <li>✅ JDBC framework ready</li>
                <li>⏳ MySQL integration (coming next)</li>
            </ul>
        </div>
        
        <footer style="text-align: center; margin-top: 30px; color: #666; font-size: 14px;">
            <p>Server Time: <%= new java.util.Date() %></p>
            <p>Java Version: <%= System.getProperty("java.version") %></p>
        </footer>
    </div>
</body>
</html>
