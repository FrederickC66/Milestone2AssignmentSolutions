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
import java.util.List;
import com.assignment.util.DatabaseUtil;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    
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
        
        // Get current participant's batch information
        String currentUsername = (String) session.getAttribute("username");
        String participantBatch = null;
        List<String> batchMembers = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            // Check if current participant is in a batch
            String checkBatchSql = "SELECT batch_type FROM batch_assignments WHERE participant_name = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkBatchSql);
            checkStmt.setString(1, currentUsername);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                participantBatch = rs.getString("batch_type");
                
                // Get all members of the same batch
                String membersSql = "SELECT participant_name FROM batch_assignments WHERE batch_type = ? ORDER BY participant_name";
                PreparedStatement membersStmt = conn.prepareStatement(membersSql);
                membersStmt.setString(1, participantBatch);
                ResultSet membersRs = membersStmt.executeQuery();
                
                while (membersRs.next()) {
                    batchMembers.add(membersRs.getString("participant_name"));
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            // Continue with empty data if there's an error
        }
        
        // Add batch information to request
        request.setAttribute("participantBatch", participantBatch);
        request.setAttribute("batchMembers", batchMembers);
        
        // User is authenticated, forward to dashboard page
        request.getRequestDispatcher("participant-dashboard.jsp").forward(request, response);
    }
}