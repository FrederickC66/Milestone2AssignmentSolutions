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
            <h2>Available Participants</h2>
            <div class="participants-list" id="participantsList">
                <%
                    List<String> participantNames = (List<String>) request.getAttribute("participantNames");
                    List<String> morningBatch = (List<String>) request.getAttribute("morningBatch");
                    List<String> eveningBatch = (List<String>) request.getAttribute("eveningBatch");
                    
                    if (participantNames != null && !participantNames.isEmpty()) {
                        for (String name : participantNames) {
                            // Only show participants not already in a batch
                            boolean inMorning = morningBatch != null && morningBatch.contains(name);
                            boolean inEvening = eveningBatch != null && eveningBatch.contains(name);
                            
                            if (!inMorning && !inEvening) {
                %>
                                <div class="participant-item" draggable="true" data-name="<%= name %>">
                                    <%= name %>
                                </div>
                <%
                            }
                        }
                    } else {
                %>
                        <div class="empty-state">No participants found.</div>
                <%
                    }
                %>
            </div>
        </div>
        
        <div class="batch-containers">
            <div class="batch-container">
                <h2>Morning Batch</h2>
                <div class="batch-list" id="morningBatch" data-batch="morning">
                    <%
                        if (morningBatch != null && !morningBatch.isEmpty()) {
                            for (String name : morningBatch) {
                    %>
                                <div class="participant-item" draggable="true" data-name="<%= name %>">
                                    <span><%= name %></span>
                                    <button class="remove-btn" onclick="removeFromBatch(this)">×</button>
                                </div>
                    <%
                            }
                        } else {
                    %>
                            <div class="empty-state">Drag participants here for morning batch</div>
                    <%
                        }
                    %>
                </div>
            </div>
            
            <div class="batch-container">
                <h2>Evening Batch</h2>
                <div class="batch-list" id="eveningBatch" data-batch="evening">
                    <%
                        if (eveningBatch != null && !eveningBatch.isEmpty()) {
                            for (String name : eveningBatch) {
                    %>
                                <div class="participant-item" draggable="true" data-name="<%= name %>">
                                    <span><%= name %></span>
                                    <button class="remove-btn" onclick="removeFromBatch(this)">×</button>
                                </div>
                    <%
                            }
                        } else {
                    %>
                            <div class="empty-state">Drag participants here for evening batch</div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
    
    <div class="submit-container">
        <button class="submit-btn" id="submitBtn" onclick="submitBatchAssignments()">
            Save Batch Assignments
        </button>
    </div>

    <script>
        let draggedElement = null;

        // Add drag event listeners to all participant items
        function addDragListeners() {
            const participantItems = document.querySelectorAll('.participant-item');
            participantItems.forEach(item => {
                item.addEventListener('dragstart', handleDragStart);
                item.addEventListener('dragend', handleDragEnd);
            });
        }

        // Add drop event listeners to batch areas
        function addDropListeners() {
            const batchLists = document.querySelectorAll('.batch-list');
            batchLists.forEach(list => {
                list.addEventListener('dragover', handleDragOver);
                list.addEventListener('drop', handleDrop);
                list.addEventListener('dragenter', handleDragEnter);
                list.addEventListener('dragleave', handleDragLeave);
            });

            // Also allow dropping back to participants list
            const participantsList = document.getElementById('participantsList');
            participantsList.addEventListener('dragover', handleDragOver);
            participantsList.addEventListener('drop', handleDropToParticipants);
            participantsList.addEventListener('dragenter', handleDragEnter);
            participantsList.addEventListener('dragleave', handleDragLeave);
        }

        function handleDragStart(e) {
            draggedElement = this;
            this.classList.add('dragging');
            e.dataTransfer.effectAllowed = 'move';
            e.dataTransfer.setData('text/html', this.outerHTML);
        }

        function handleDragEnd(e) {
            this.classList.remove('dragging');
            draggedElement = null;
        }

        function handleDragOver(e) {
            e.preventDefault();
            e.dataTransfer.dropEffect = 'move';
        }

        function handleDragEnter(e) {
            e.preventDefault();
            this.classList.add('dragover');
        }

        function handleDragLeave(e) {
            // Only remove dragover if we're actually leaving the element
            if (!this.contains(e.relatedTarget)) {
                this.classList.remove('dragover');
            }
        }

        function handleDrop(e) {
            e.preventDefault();
            this.classList.remove('dragover');

            if (draggedElement && this.classList.contains('batch-list')) {
                const participantName = draggedElement.getAttribute('data-name');
                const batchType = this.getAttribute('data-batch');
                
                // Remove from current location
                draggedElement.remove();
                
                // Add to new batch
                addParticipantToBatch(participantName, batchType, this);
                
                updateEmptyStates();
            }
        }

        function handleDropToParticipants(e) {
            e.preventDefault();
            this.classList.remove('dragover');

            if (draggedElement && draggedElement.querySelector('.remove-btn')) {
                const participantName = draggedElement.getAttribute('data-name');
                
                // Remove from current batch
                draggedElement.remove();
                
                // Add back to participants list
                addParticipantToList(participantName, this);
                
                updateEmptyStates();
            }
        }

        function addParticipantToBatch(name, batchType, container) {
            // Remove empty state if present
            const emptyState = container.querySelector('.empty-state');
            if (emptyState) {
                emptyState.remove();
            }

            // Create new participant element for batch
            const participantDiv = document.createElement('div');
            participantDiv.className = 'participant-item';
            participantDiv.draggable = true;
            participantDiv.setAttribute('data-name', name);
            
            // Create the text content and button separately
            const nameSpan = document.createElement('span');
            nameSpan.textContent = name;
            
            const removeBtn = document.createElement('button');
            removeBtn.className = 'remove-btn';
            removeBtn.textContent = '×';
            removeBtn.onclick = function() { removeFromBatch(this); };
            
            participantDiv.appendChild(nameSpan);
            participantDiv.appendChild(removeBtn);
            
            container.appendChild(participantDiv);
            
            // Add drag listeners to the new element
            participantDiv.addEventListener('dragstart', handleDragStart);
            participantDiv.addEventListener('dragend', handleDragEnd);
        }

        function addParticipantToList(name, container) {
            // Remove empty state if present
            const emptyState = container.querySelector('.empty-state');
            if (emptyState) {
                emptyState.remove();
            }

            // Create new participant element for main list
            const participantDiv = document.createElement('div');
            participantDiv.className = 'participant-item';
            participantDiv.draggable = true;
            participantDiv.setAttribute('data-name', name);
            participantDiv.textContent = name;
            
            container.appendChild(participantDiv);
            
            // Add drag listeners to the new element
            participantDiv.addEventListener('dragstart', handleDragStart);
            participantDiv.addEventListener('dragend', handleDragEnd);
        }

        function removeFromBatch(button) {
            const participantItem = button.parentElement;
            const participantName = participantItem.getAttribute('data-name');
            
            // Remove from batch
            participantItem.remove();
            
            // Add back to participants list
            const participantsList = document.getElementById('participantsList');
            addParticipantToList(participantName, participantsList);
            
            updateEmptyStates();
        }

        function updateEmptyStates() {
            const containers = ['participantsList', 'morningBatch', 'eveningBatch'];
            
            containers.forEach(containerId => {
                const container = document.getElementById(containerId);
                const participants = container.querySelectorAll('.participant-item');
                const emptyState = container.querySelector('.empty-state');
                
                if (participants.length === 0 && !emptyState) {
                    const emptyDiv = document.createElement('div');
                    emptyDiv.className = 'empty-state';
                    
                    if (containerId === 'participantsList') {
                        emptyDiv.textContent = 'All participants assigned to batches';
                    } else if (containerId === 'morningBatch') {
                        emptyDiv.textContent = 'Drag participants here for morning batch';
                    } else {
                        emptyDiv.textContent = 'Drag participants here for evening batch';
                    }
                    
                    container.appendChild(emptyDiv);
                }
            });
        }

        function submitBatchAssignments() {
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.disabled = true;
            submitBtn.textContent = 'Saving...';

            // Collect batch assignments
            const morningParticipants = [];
            const eveningParticipants = [];

            document.querySelectorAll('#morningBatch .participant-item').forEach(item => {
                const name = item.getAttribute('data-name');
                if (name) morningParticipants.push(name);
            });

            document.querySelectorAll('#eveningBatch .participant-item').forEach(item => {
                const name = item.getAttribute('data-name');
                if (name) eveningParticipants.push(name);
            });

            // Create form data as URL-encoded string
            const formParams = new URLSearchParams();
            morningParticipants.forEach(name => formParams.append('morningBatch', name));
            eveningParticipants.forEach(name => formParams.append('eveningBatch', name));

            // Submit to server
            fetch('/owner', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formParams.toString()
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    showNotification('Batch assignments saved successfully!', 'success');
                } else {
                    showNotification('Error saving batch assignments: ' + data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Error saving batch assignments', 'error');
            })
            .finally(() => {
                submitBtn.disabled = false;
                submitBtn.textContent = 'Save Batch Assignments';
            });
        }

        function showNotification(message, type) {
            // Remove existing notification
            const existingNotification = document.querySelector('.notification');
            if (existingNotification) {
                existingNotification.remove();
            }

            // Create new notification
            const notification = document.createElement('div');
            notification.className = `notification ${type}`;
            notification.textContent = message;
            document.body.appendChild(notification);

            // Show notification
            notification.classList.add('show');

            // Hide notification after 3 seconds
            setTimeout(() => {
                notification.classList.remove('show');
                setTimeout(() => notification.remove(), 100);
            }, 3000);
        }

        // Initialize drag and drop when page loads
        document.addEventListener('DOMContentLoaded', function() {
            addDragListeners();
            addDropListeners();
            updateEmptyStates();
        });
    </script>
</body>
</html>