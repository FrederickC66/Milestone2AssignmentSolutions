<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Form Submission Result - Milestone2 Assignment</title>
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
            max-width: 700px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #28a745;
            text-align: center;
            margin-bottom: 30px;
        }
        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #c3e6cb;
            margin: 20px 0;
            text-align: center;
        }
        .result-details {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #e9ecef;
        }
        .detail-row:last-child {
            border-bottom: none;
        }
        .label {
            font-weight: 600;
            color: #333;
        }
        .value {
            color: #666;
        }
        .btn {
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            display: inline-block;
            margin: 10px 5px;
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
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background: #545b62;
        }
        .actions {
            text-align: center;
            margin-top: 30px;
        }
        .demo-info {
            background: #e8f4fd;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>✅ Form Submitted Successfully!</h1>
        
        <div class="success-message">
            <h3>🎉 Thank you for your submission!</h3>
            <p>Your form data has been processed by the servlet and is displayed below.</p>
        </div>
        
        <div class="result-details">
            <h4>📋 Submitted Information</h4>
            
            <div class="detail-row">
                <span class="label">Name:</span>
                <span class="value">${submittedName != null ? submittedName : 'Not provided'}</span>
            </div>
            
            <div class="detail-row">
                <span class="label">Email:</span>
                <span class="value">${submittedEmail != null ? submittedEmail : 'Not provided'}</span>
            </div>
            
            <div class="detail-row">
                <span class="label">Message:</span>
                <span class="value">${submittedMessage != null ? submittedMessage : 'Not provided'}</span>
            </div>
            
            <div class="detail-row">
                <span class="label">Submission Time:</span>
                <span class="value">
                    <fmt:formatDate value="${submissionTime}" pattern="yyyy-MM-dd HH:mm:ss" />
                </span>
            </div>
            
            <div class="detail-row">
                <span class="label">Processing Method:</span>
                <span class="value">POST request handled by HelloServlet</span>
            </div>
        </div>
        
        <div class="demo-info">
            <h4>🔧 Technical Flow</h4>
            <ol>
                <li><strong>Form Submission:</strong> User filled out form and clicked submit</li>
                <li><strong>HTTP POST:</strong> Browser sent POST request to HelloServlet</li>
                <li><strong>Parameter Extraction:</strong> Servlet extracted form parameters</li>
                <li><strong>Request Attributes:</strong> Data set as request attributes</li>
                <li><strong>Forward to JSP:</strong> Request forwarded to this result page</li>
                <li><strong>JSP Rendering:</strong> Dynamic content displayed using JSTL</li>
            </ol>
        </div>
        
        <div class="actions">
            <a href="hello" class="btn btn-primary">🔄 Try Another Submission</a>
            <a href="users" class="btn btn-success">👥 Manage Users</a>
            <a href="index.jsp" class="btn btn-secondary">🏠 Back to Home</a>
        </div>
        
        <div style="margin-top: 40px; padding: 20px; background: #f8f9fa; border-radius: 8px; text-align: center;">
            <h4>💡 What This Demonstrates</h4>
            <ul style="text-align: left; display: inline-block;">
                <li>✅ Servlet POST request handling</li>
                <li>✅ Form parameter processing</li>
                <li>✅ Request attribute forwarding</li>
                <li>✅ JSP dynamic content rendering</li>
                <li>✅ JSTL tag library usage</li>
                <li>✅ MVC pattern implementation</li>
            </ul>
        </div>
    </div>
</body>
</html>