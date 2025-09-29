package com.assignment.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.assignment.util.DatabaseUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // For testing: return all users as JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "SELECT id, name, email, phone, user_type, created_at FROM users";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            out.println("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    out.println(",");
                }
                out.println("  {");
                out.println("    \"id\": " + rs.getInt("id") + ",");
                out.println("    \"name\": \"" + rs.getString("name") + "\",");
                out.println("    \"email\": \"" + rs.getString("email") + "\",");
                out.println("    \"phone\": \"" + rs.getString("phone") + "\",");
                out.println("    \"user_type\": \"" + rs.getString("user_type") + "\",");
                out.println("    \"created_at\": \"" + rs.getTimestamp("created_at") + "\"");
                out.print("  }");
                first = false;
            }
            out.println();
            out.println("]");
            
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.println("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get form parameters
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String userType = request.getParameter("user_type");
        
        // Set default user type if not provided
        if (userType == null || userType.trim().isEmpty()) {
            userType = "participant";
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        // Validate required fields
        if (name == null || email == null || password == null || 
            name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("{\"error\": \"Name, email, and password are required\"}");
            return;
        }
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            // Check if user already exists
            String checkSql = "SELECT id FROM users WHERE email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                out.println("{\"error\": \"User with this email already exists\"}");
                return;
            }
            
            // Insert new user
            String insertSql = "INSERT INTO users (name, email, phone, password, user_type) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement insertStmt = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS);
            insertStmt.setString(1, name);
            insertStmt.setString(2, email);
            insertStmt.setString(3, phone);
            insertStmt.setString(4, password); // Note: In production, you should hash this password
            insertStmt.setString(5, userType);
            
            int rowsAffected = insertStmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = insertStmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int userId = generatedKeys.getInt(1);
                    response.setStatus(HttpServletResponse.SC_CREATED);
                    out.println("{");
                    out.println("  \"success\": true,");
                    out.println("  \"message\": \"User created successfully\",");
                    out.println("  \"user_id\": " + userId);
                    out.println("}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.println("{\"error\": \"Failed to create user\"}");
            }
            
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.println("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        }
    }
}