<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Owner Dashboard</title>
    <link rel="stylesheet" type="text/css" href="css/owner-dashboard.css">
</head>
<body>
    <a href="/logout" class="logout-btn">Logout</a>
    
    <div class="main-container">
        <div class="participants-container">
            <h2>Participant Batch Assignments</h2>
            <div class="participants-list">
                <%
                    List<String> participantNames = (List<String>) request.getAttribute("participantNames");
                    List<String> morningBatch = (List<String>) request.getAttribute("morningBatch");
                    List<String> eveningBatch = (List<String>) request.getAttribute("eveningBatch");
                    
                    if (participantNames != null && !participantNames.isEmpty()) {
                        for (String name : participantNames) {
                            String currentBatch = "";
                            if (morningBatch != null && morningBatch.contains(name)) {
                                currentBatch = "morning";
                            } else if (eveningBatch != null && eveningBatch.contains(name)) {
                                currentBatch = "evening";
                            }
                %>
                            <div class="participant-row">
                                <span class="participant-name"><%= name %></span>
                                <select class="batch-select" data-participant="<%= name %>" onchange="updateBatchAssignment(this)">
                                    <option value="" <%= currentBatch.equals("") ? "selected" : "" %>>Unassigned</option>
                                    <option value="morning" <%= currentBatch.equals("morning") ? "selected" : "" %>>Morning Batch</option>
                                    <option value="evening" <%= currentBatch.equals("evening") ? "selected" : "" %>>Evening Batch</option>
                                </select>
                            </div>
                <%
                        }
                    } else {
                %>
                        <div class="empty-state">No participants found.</div>
                <%
                    }
                %>
            </div>
        </div>
    </div>

    <script>
        function updateBatchAssignment(selectElement) {
            const participantName = selectElement.getAttribute('data-participant');
            const newBatch = selectElement.value;
            
            const originalText = selectElement.options[selectElement.selectedIndex].text;
            selectElement.disabled = true;
            
            fetch('owner', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=updateBatch&participantName=' + encodeURIComponent(participantName) + '&batch=' + encodeURIComponent(newBatch)
            })
            .then(response => response.json())
            .then(data => {
                selectElement.disabled = false;
                if (!data.success) {
                    location.reload();
                }
            })
            .catch(error => {
                selectElement.disabled = false;
                console.error('Error:', error);
                location.reload();
            });
        }
    </script>
</body>
</html>