<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Owner Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }
        
        .dashboard-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        h1 {
            color: #333;
            margin: 0;
        }
        
        .logout-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
            transition: transform 0.2s;
        }
        
        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        .welcome-message {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #667eea;
        }
        
        .user-info {
            color: #666;
            margin-bottom: 10px;
        }
        
        .owner-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            display: inline-block;
            margin-left: 10px;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="header">
            <h1>Owner Dashboard <span class="owner-badge">OWNER</span></h1>
            <a href="/logout" class="logout-btn">Logout</a>
        </div>
        
        <div class="welcome-message">
            <h3>Welcome, <%= session.getAttribute("username") %>!</h3>
            <p class="user-info">User Type: <%= session.getAttribute("user_type") %></p>
            <p class="user-info">Session ID: <%= session.getId() %></p>
            <p class="user-info">Access Level: <strong>Owner - Full Access</strong></p>
        </div>
        
        <div class="content">
            <h2>Owner Management Features</h2>
            <p>Welcome to your owner dashboard. Here you can access all owner-specific management features and controls.</p>
            
            <!-- Add more owner-specific content here -->
            <div class="features">
                <h3>Available Features:</h3>
                <ul>
                    <li>User Management</li>
                    <li>System Administration</li>
                    <li>Reports and Analytics</li>
                    <li>Configuration Settings</li>
                </ul>
            </div>
        </div>
    </div>
</body>
</html>