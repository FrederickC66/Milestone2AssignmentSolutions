package com.assignment.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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

@WebServlet("/api/batches")
public class BatchApiServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            // Get all batch assignments
            String sql = "SELECT participant_id, participant_name, batch_type FROM batch_assignments ORDER BY batch_type, participant_name";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            List<Map<String, Object>> morningBatch = new ArrayList<>();
            List<Map<String, Object>> eveningBatch = new ArrayList<>();
            
            while (rs.next()) {
                Map<String, Object> assignment = new HashMap<>();
                assignment.put("participant_id", rs.getInt("participant_id"));
                assignment.put("participant_name", rs.getString("participant_name"));
                assignment.put("batch_type", rs.getString("batch_type"));
                
                if ("morning".equals(rs.getString("batch_type"))) {
                    morningBatch.add(assignment);
                } else if ("evening".equals(rs.getString("batch_type"))) {
                    eveningBatch.add(assignment);
                }
            }
            
            // Create response JSON
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", true);
            responseData.put("morning_batch", morningBatch);
            responseData.put("evening_batch", eveningBatch);
            responseData.put("total_assignments", morningBatch.size() + eveningBatch.size());
            
            // Simple JSON serialization (for more complex scenarios, consider using Jackson)
            String jsonResponse = buildJsonResponse(responseData, morningBatch, eveningBatch);
            response.getWriter().write(jsonResponse);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            
            String errorJson = "{"
                + "\"success\": false,"
                + "\"error\": \"Database error: " + e.getMessage().replace("\"", "\\\"") + "\","
                + "\"morning_batch\": [],"
                + "\"evening_batch\": [],"
                + "\"total_assignments\": 0"
                + "}";
            response.getWriter().write(errorJson);
        }
    }
    
    private String buildJsonResponse(Map<String, Object> responseData, 
                                   List<Map<String, Object>> morningBatch, 
                                   List<Map<String, Object>> eveningBatch) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\": true,");
        json.append("\"total_assignments\": ").append(morningBatch.size() + eveningBatch.size()).append(",");
        
        // Morning batch
        json.append("\"morning_batch\": [");
        for (int i = 0; i < morningBatch.size(); i++) {
            if (i > 0) json.append(",");
            Map<String, Object> assignment = morningBatch.get(i);
            json.append("{");
            json.append("\"participant_id\": ").append(assignment.get("participant_id")).append(",");
            json.append("\"participant_name\": \"").append(assignment.get("participant_name")).append("\",");
            json.append("\"batch_type\": \"").append(assignment.get("batch_type")).append("\"");
            json.append("}");
        }
        json.append("],");
        
        // Evening batch
        json.append("\"evening_batch\": [");
        for (int i = 0; i < eveningBatch.size(); i++) {
            if (i > 0) json.append(",");
            Map<String, Object> assignment = eveningBatch.get(i);
            json.append("{");
            json.append("\"participant_id\": ").append(assignment.get("participant_id")).append(",");
            json.append("\"participant_name\": \"").append(assignment.get("participant_name")).append("\",");
            json.append("\"batch_type\": \"").append(assignment.get("batch_type")).append("\"");
            json.append("}");
        }
        json.append("]");
        
        json.append("}");
        return json.toString();
    }
}