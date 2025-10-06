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
import com.assignment.util.DatabaseUtil;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward to the login JSP page
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Validate required fields
        if (email == null || password == null || 
            email.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("index.jsp?error=missing_fields");
            return;
        }
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            boolean userFound = false;
            String userName = null;
            String userType = null;
            int userId = 0;
            
            // First, check the users table for participants
            String userSql = "SELECT id, name, email, password, user_type FROM users WHERE email = ?";
            PreparedStatement userStmt = conn.prepareStatement(userSql);
            userStmt.setString(1, email.trim());
            ResultSet userRs = userStmt.executeQuery();
            
            if (userRs.next()) {
                // User found in users table, verify password
                String storedHashedPassword = userRs.getString("password");
                
                if (BCrypt.checkpw(password, storedHashedPassword)) {
                    userFound = true;
                    userId = userRs.getInt("id");
                    userName = userRs.getString("name");
                    userType = userRs.getString("user_type");
                }
            }
            
            // If not found in users table, check owners table
            if (!userFound) {
                String ownerSql = "SELECT id, name, email, password, user_type FROM owners WHERE email = ?";
                PreparedStatement ownerStmt = conn.prepareStatement(ownerSql);
                ownerStmt.setString(1, email.trim());
                ResultSet ownerRs = ownerStmt.executeQuery();
                
                if (ownerRs.next()) {
                    // Owner found, verify password
                    String storedHashedPassword = ownerRs.getString("password");
                    
                    if (BCrypt.checkpw(password, storedHashedPassword)) {
                        userFound = true;
                        userId = ownerRs.getInt("id");
                        userName = ownerRs.getString("name");
                        userType = "owner"; // Set as owner type
                    }
                }
            }
            
            if (userFound) {
                // Authentication successful - create session
                HttpSession session = request.getSession();
                session.setAttribute("user_id", userId);
                session.setAttribute("username", userName);
                session.setAttribute("user_email", email.trim());
                session.setAttribute("user_type", userType);
                session.setAttribute("isLoggedIn", true);
                
                // Set session timeout (30 minutes)
                session.setMaxInactiveInterval(1800);
                
                // Redirect based on user type
                if ("owner".equals(userType)) {
                    response.sendRedirect("owner");
                } else {
                    response.sendRedirect("dashboard");
                }
            } else {
                // Authentication failed
                response.sendRedirect("index.jsp?error=invalid_credentials");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=database_error");
        }
    }
}
