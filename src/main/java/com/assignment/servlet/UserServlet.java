package com.assignment.servlet;

import com.assignment.dao.UserDAO;
import com.assignment.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * User servlet demonstrating servlet-JDBC integration
 * Handles CRUD operations for users
 */
@WebServlet(name = "UserServlet", urlPatterns = {"/users"})
public class UserServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
        System.out.println("UserServlet initialized with UserDAO");
    }
    
    /**
     * Handle GET requests - Display users or user form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listUsers(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }
    
    /**
     * Handle POST requests - Create or update users
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createUser(request, response);
        } else if ("update".equals(action)) {
            updateUser(request, response);
        } else {
            listUsers(request, response);
        }
    }
    
    /**
     * List all users
     */
    private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.setAttribute("userCount", userDAO.getUserCount());
        
        // Forward to JSP for display
        request.getRequestDispatcher("/users.jsp").forward(request, response);
    }
    
    /**
     * Show add user form
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setAttribute("action", "create");
        request.setAttribute("pageTitle", "Add New User");
        request.getRequestDispatcher("/user-form.jsp").forward(request, response);
    }
    
    /**
     * Show edit user form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User user = userDAO.getUserById(id);
            
            if (user != null) {
                request.setAttribute("user", user);
                request.setAttribute("action", "update");
                request.setAttribute("pageTitle", "Edit User");
                request.getRequestDispatcher("/user-form.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "User not found");
                listUsers(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid user ID");
            listUsers(request, response);
        }
    }
    
    /**
     * Create a new user
     */
    private void createUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        
        if (name != null && !name.trim().isEmpty() && email != null && !email.trim().isEmpty()) {
            User user = new User(name.trim(), email.trim());
            
            if (userDAO.addUser(user)) {
                request.setAttribute("success", "User added successfully!");
            } else {
                request.setAttribute("error", "Failed to add user");
            }
        } else {
            request.setAttribute("error", "Name and email are required");
        }
        
        listUsers(request, response);
    }
    
    /**
     * Update an existing user
     */
    private void updateUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            
            if (name != null && !name.trim().isEmpty() && email != null && !email.trim().isEmpty()) {
                User user = userDAO.getUserById(id);
                if (user != null) {
                    user.setName(name.trim());
                    user.setEmail(email.trim());
                    
                    if (userDAO.updateUser(user)) {
                        request.setAttribute("success", "User updated successfully!");
                    } else {
                        request.setAttribute("error", "Failed to update user");
                    }
                } else {
                    request.setAttribute("error", "User not found");
                }
            } else {
                request.setAttribute("error", "Name and email are required");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid user ID");
        }
        
        listUsers(request, response);
    }
    
    /**
     * Delete a user
     */
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            if (userDAO.deleteUser(id)) {
                request.setAttribute("success", "User deleted successfully!");
            } else {
                request.setAttribute("error", "Failed to delete user");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid user ID");
        }
        
        listUsers(request, response);
    }
}