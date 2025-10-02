<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Participant Dashboard</title>
    <link rel="stylesheet" type="text/css" href="css/participant-dashboard.css">
</head>
<body>
    <a href="/logout" class="logout-btn">Logout</a>
    
    <div class="main-container">
        <div class="batch-section">
            <c:choose>
                <c:when test="${not empty participantBatch}">
                    <div class="batch-container">
                        <h2>${fn:toUpperCase(fn:substring(participantBatch, 0, 1))}${fn:substring(participantBatch, 1, -1)} Batch</h2>
                        <div class="batch-list">
                            <c:forEach var="memberName" items="${batchMembers}">
                                <c:set var="isCurrentUser" value="${memberName eq sessionScope.username}" />
                                <div class="participant-item ${isCurrentUser ? 'current-participant' : ''}">
                                    <span>${memberName}${isCurrentUser ? ' (You)' : ''}</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="batch-status unassigned">
                        No batch, await from owner.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>