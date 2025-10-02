package com.assignment.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.assignment.util.DatabaseUtil;

@WebServlet("/owner")
public class OwnerServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is authenticated
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("isLoggedIn") == null || 
            !(Boolean)session.getAttribute("isLoggedIn")) {
            // User not logged in, redirect to login page
            response.sendRedirect("index.jsp?error=please_login");
            return;
        }
        
        // Check if user is an owner
        String userType = (String) session.getAttribute("user_type");
        if (!"owner".equals(userType)) {
            // User is not an owner, redirect to regular dashboard
            response.sendRedirect("dashboard");
            return;
        }
        
        // Fetch participant names from database
        List<String> participantNames = new ArrayList<>();
        Map<String, String> morningBatch = new HashMap<>();
        Map<String, String> eveningBatch = new HashMap<>();
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            // Get all participants
            String sql = "SELECT id, name FROM users WHERE user_type = 'participant' ORDER BY name";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            Map<Integer, String> participantMap = new HashMap<>();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                participantNames.add(name);
                participantMap.put(id, name);
            }
            
            // Get batch assignments
            String batchSql = "SELECT participant_id, participant_name, batch_type FROM batch_assignments";
            PreparedStatement batchStmt = conn.prepareStatement(batchSql);
            ResultSet batchRs = batchStmt.executeQuery();
            
            while (batchRs.next()) {
                String name = batchRs.getString("participant_name");
                String batchType = batchRs.getString("batch_type");
                
                if ("morning".equals(batchType)) {
                    morningBatch.put(name, name);
                } else if ("evening".equals(batchType)) {
                    eveningBatch.put(name, name);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            // If there's an error, continue with empty lists
        }
        
        // Add data to request
        request.setAttribute("participantNames", participantNames);
        request.setAttribute("morningBatch", new ArrayList<>(morningBatch.keySet()));
        request.setAttribute("eveningBatch", new ArrayList<>(eveningBatch.keySet()));
        
        // User is authenticated and is an owner, forward to owner dashboard
        request.getRequestDispatcher("owner-dashboard.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is authenticated and is an owner
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("isLoggedIn") == null || 
            !(Boolean)session.getAttribute("isLoggedIn") || 
            !"owner".equals(session.getAttribute("user_type"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        // Get batch assignment data from request
        String[] morningParticipants = request.getParameterValues("morningBatch");
        String[] eveningParticipants = request.getParameterValues("eveningBatch");
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            // Clear existing batch assignments
            String clearSql = "DELETE FROM batch_assignments";
            PreparedStatement clearStmt = conn.prepareStatement(clearSql);
            clearStmt.executeUpdate();
            
            // Insert morning batch assignments
            if (morningParticipants != null) {
                for (String participantName : morningParticipants) {
                    if (participantName != null && !participantName.trim().isEmpty()) {
                        insertBatchAssignment(conn, participantName.trim(), "morning");
                    }
                }
            }
            
            // Insert evening batch assignments
            if (eveningParticipants != null) {
                for (String participantName : eveningParticipants) {
                    if (participantName != null && !participantName.trim().isEmpty()) {
                        insertBatchAssignment(conn, participantName.trim(), "evening");
                    }
                }
            }
            
            // Send success response
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"success\",\"message\":\"Batch assignments updated successfully\"}");
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Database error occurred\"}");
        }
    }
    
    private void insertBatchAssignment(Connection conn, String participantName, String batchType) throws SQLException {
        // First get the participant ID
        String getIdSql = "SELECT id FROM users WHERE name = ? AND user_type = 'participant'";
        PreparedStatement getIdStmt = conn.prepareStatement(getIdSql);
        getIdStmt.setString(1, participantName);
        ResultSet rs = getIdStmt.executeQuery();
        
        if (rs.next()) {
            int participantId = rs.getInt("id");
            
            // Insert batch assignment
            String insertSql = "INSERT INTO batch_assignments (participant_id, participant_name, batch_type) VALUES (?, ?, ?)";
            PreparedStatement insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setInt(1, participantId);
            insertStmt.setString(2, participantName);
            insertStmt.setString(3, batchType);
            insertStmt.executeUpdate();
        }
    }
}