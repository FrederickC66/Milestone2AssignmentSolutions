<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                <c:choose>
                    <c:when test="${not empty participantNames}">
                        <c:forEach var="name" items="${participantNames}">
                            <c:set var="currentBatch" value="" />
                            <c:if test="${morningBatch.contains(name)}">
                                <c:set var="currentBatch" value="morning" />
                            </c:if>
                            <c:if test="${eveningBatch.contains(name)}">
                                <c:set var="currentBatch" value="evening" />
                            </c:if>
                            
                            <div class="participant-row">
                                <span class="participant-name">${name}</span>
                                <select class="batch-select" data-participant="${name}" onchange="updateBatchAssignment(this)">
                                    <option value="" ${currentBatch == '' ? 'selected' : ''}>Unassigned</option>
                                    <option value="morning" ${currentBatch == 'morning' ? 'selected' : ''}>Morning Batch</option>
                                    <option value="evening" ${currentBatch == 'evening' ? 'selected' : ''}>Evening Batch</option>
                                </select>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">No participants found.</div>
                    </c:otherwise>
                </c:choose>
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
            });
        }
    </script>
</body>
</html>