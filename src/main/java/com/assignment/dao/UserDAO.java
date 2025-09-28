package com.assignment.dao;

import com.assignment.model.User;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * User Data Access Object
 * This class demonstrates JDBC concepts and database operations
 * Note: For now, this uses an in-memory list to simulate database operations
 * When MySQL is added later, this will be updated to use actual JDBC connections
 */
public class UserDAO {
    
    // For demonstration purposes, using an in-memory list
    // This will be replaced with actual database operations when MySQL is configured
    private static List<User> users = new ArrayList<>();
    private static int nextId = 1;
    
    static {
        // Initialize with some sample data
        users.add(new User(nextId++, "John Doe", "john@example.com", LocalDateTime.now().minusDays(5)));
        users.add(new User(nextId++, "Jane Smith", "jane@example.com", LocalDateTime.now().minusDays(3)));
        users.add(new User(nextId++, "Bob Johnson", "bob@example.com", LocalDateTime.now().minusDays(1)));
    }
    
    /**
     * Get all users
     * In actual implementation, this would execute: SELECT * FROM users
     */
    public List<User> getAllUsers() {
        return new ArrayList<>(users);
    }
    
    /**
     * Get user by ID
     * In actual implementation, this would execute: SELECT * FROM users WHERE id = ?
     */
    public User getUserById(int id) {
        return users.stream()
                   .filter(user -> user.getId() == id)
                   .findFirst()
                   .orElse(null);
    }
    
    /**
     * Add a new user
     * In actual implementation, this would execute: INSERT INTO users (name, email, created_at) VALUES (?, ?, ?)
     */
    public boolean addUser(User user) {
        try {
            user.setId(nextId++);
            user.setCreatedAt(LocalDateTime.now());
            users.add(user);
            return true;
        } catch (Exception e) {
            System.err.println("Error adding user: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Update an existing user
     * In actual implementation, this would execute: UPDATE users SET name = ?, email = ? WHERE id = ?
     */
    public boolean updateUser(User user) {
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getId() == user.getId()) {
                users.set(i, user);
                return true;
            }
        }
        return false;
    }
    
    /**
     * Delete a user by ID
     * In actual implementation, this would execute: DELETE FROM users WHERE id = ?
     */
    public boolean deleteUser(int id) {
        return users.removeIf(user -> user.getId() == id);
    }
    
    /**
     * Find users by name (partial match)
     * In actual implementation, this would execute: SELECT * FROM users WHERE name LIKE ?
     */
    public List<User> findUsersByName(String name) {
        return users.stream()
                   .filter(user -> user.getName().toLowerCase().contains(name.toLowerCase()))
                   .toList();
    }
    
    /**
     * Get user count
     * In actual implementation, this would execute: SELECT COUNT(*) FROM users
     */
    public int getUserCount() {
        return users.size();
    }
    
    // TODO: When MySQL is configured, add these methods:
    
    /*
    private Connection getConnection() throws SQLException {
        // Database connection configuration
        String url = "jdbc:mysql://localhost:3306/assignment_db";
        String username = "your_username";
        String password = "your_password";
        return DriverManager.getConnection(url, username, password);
    }
    
    public List<User> getAllUsersFromDB() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT id, name, email, created_at FROM users ORDER BY created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                users.add(user);
            }
        }
        return users;
    }
    
    public boolean addUserToDB(User user) throws SQLException {
        String sql = "INSERT INTO users (name, email, created_at) VALUES (?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setTimestamp(3, Timestamp.valueOf(user.getCreatedAt()));
            
            return stmt.executeUpdate() > 0;
        }
    }
    */
}