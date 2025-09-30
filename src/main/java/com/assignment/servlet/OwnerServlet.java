package com.assignment.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

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
        
        // User is authenticated and is an owner, forward to owner dashboard
        request.getRequestDispatcher("owner-dashboard.jsp").forward(request, response);
    }
}