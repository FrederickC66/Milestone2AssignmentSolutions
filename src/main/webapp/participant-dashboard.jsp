<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Participant Dashboard</title>
    <link rel="stylesheet" type="text/css" href="css/participant-dashboard.css">
</head>
<body>
    <a href="/logout" class="logout-btn">Logout</a>
    
    <div class="main-container">
        <%
            String participantBatch = (String) request.getAttribute("participantBatch");
            List<String> batchMembers = (List<String>) request.getAttribute("batchMembers");
            String currentUsername = (String) session.getAttribute("username");
        %>
        
        <div class="batch-section">
            <% if (participantBatch != null) { %>
                <div class="batch-container">
                    <h2><%= participantBatch.substring(0, 1).toUpperCase() + participantBatch.substring(1) %> Batch</h2>
                    <div class="batch-list">
                        <%
                            if (batchMembers != null && !batchMembers.isEmpty()) {
                                for (String memberName : batchMembers) {
                                    boolean isCurrentUser = memberName.equals(currentUsername);
                        %>
                                    <div class="participant-item <%= isCurrentUser ? "current-participant" : "" %>">
                                        <span><%= memberName %><%= isCurrentUser ? " (You)" : "" %></span>
                                    </div>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
            <% } else { %>
                <div class="batch-status unassigned">
                    No batch, await from owner.
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>