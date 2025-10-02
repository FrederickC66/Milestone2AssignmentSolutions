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
import org.mindrot.jbcrypt.BCrypt;

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
            String sql = "SELECT id, name, email, user_type, created_at FROM users";
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
        String password = request.getParameter("password");
        
        // Validate required fields
        if (name == null || email == null || password == null ||
            name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("register.jsp?error=missing_fields");
            return;
        }
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            // Check if user already exists in both tables
            boolean emailExists = false;
            
            // Check users table
            String checkUserSql = "SELECT id FROM users WHERE email = ?";
            PreparedStatement checkUserStmt = conn.prepareStatement(checkUserSql);
            checkUserStmt.setString(1, email.trim());
            ResultSet userRs = checkUserStmt.executeQuery();
            
            if (userRs.next()) {
                emailExists = true;
            }
            
            // Check owners table
            if (!emailExists) {
                String checkOwnerSql = "SELECT id FROM owners WHERE email = ?";
                PreparedStatement checkOwnerStmt = conn.prepareStatement(checkOwnerSql);
                checkOwnerStmt.setString(1, email.trim());
                ResultSet ownerRs = checkOwnerStmt.executeQuery();
                
                if (ownerRs.next()) {
                    emailExists = true;
                }
            }
            
            if (emailExists) {
                response.sendRedirect("register.jsp?error=email_exists");
                return;
            }
            
            // Hash the password using BCrypt
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            
            // Insert into users table (all registrations are participants)
            String insertSql = "INSERT INTO users (name, email, password, user_type) VALUES (?, ?, ?, ?)";
            PreparedStatement insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setString(1, name.trim());
            insertStmt.setString(2, email.trim());
            insertStmt.setString(3, hashedPassword);
            insertStmt.setString(4, "participant");
            
            int rowsAffected = insertStmt.executeUpdate();
            
            if (rowsAffected > 0) {
                response.sendRedirect("index.jsp?success=registration_successful");
            } else {
                response.sendRedirect("register.jsp?error=registration_failed");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=database_error");
        }
    }
}