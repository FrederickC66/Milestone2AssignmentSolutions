package com.assignment.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Sample servlet demonstrating basic servlet functionality
 * This servlet handles both GET and POST requests
 */
@WebServlet(name = "HelloServlet", urlPatterns = {"/hello", "/greeting"})
public class HelloServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    @Override
    public void init() throws ServletException {
        super.init();
        // Initialization code here
        System.out.println("HelloServlet initialized at: " + LocalDateTime.now());
    }
    
    /**
     * Handle GET requests
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set response content type
        response.setContentType("text/html;charset=UTF-8");
        
        // Get request parameters
        String name = request.getParameter("name");
        String message = request.getParameter("message");
        
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Hello Servlet Response</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; margin: 40px; }");
            out.println(".container { max-width: 600px; margin: 0 auto; }");
            out.println(".info { background: #f0f0f0; padding: 15px; border-radius: 5px; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<div class='container'>");
            out.println("<h1>Hello from Servlet!</h1>");
            
            if (name != null && !name.trim().isEmpty()) {
                out.println("<h2>Welcome, " + escapeHtml(name) + "!</h2>");
            }
            
            if (message != null && !message.trim().isEmpty()) {
                out.println("<p><strong>Your message:</strong> " + escapeHtml(message) + "</p>");
            }
            
            out.println("<div class='info'>");
            out.println("<h3>Request Information:</h3>");
            out.println("<p><strong>Method:</strong> " + request.getMethod() + "</p>");
            out.println("<p><strong>Request URI:</strong> " + request.getRequestURI() + "</p>");
            out.println("<p><strong>Context Path:</strong> " + request.getContextPath() + "</p>");
            out.println("<p><strong>Server Time:</strong> " + 
                       LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) + "</p>");
            out.println("</div>");
            
            out.println("<h3>Try these links:</h3>");
            out.println("<ul>");
            out.println("<li><a href='hello?name=John&message=Hello%20World'>Hello with parameters</a></li>");
            out.println("<li><a href='users.jsp'>View Users JSP</a></li>");
            out.println("<li><a href='index.jsp'>Back to Home</a></li>");
            out.println("</ul>");
            
            out.println("</div>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    
    /**
     * Handle POST requests
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");
        
        // Set attributes for JSP
        request.setAttribute("submittedName", name);
        request.setAttribute("submittedEmail", email);
        request.setAttribute("submittedMessage", message);
        request.setAttribute("submissionTime", LocalDateTime.now());
        
        // Forward to JSP for display
        request.getRequestDispatcher("/result.jsp").forward(request, response);
    }
    
    /**
     * Simple HTML escaping to prevent XSS
     */
    private String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#x27;");
    }
    
    @Override
    public void destroy() {
        System.out.println("HelloServlet destroyed at: " + LocalDateTime.now());
        super.destroy();
    }
}