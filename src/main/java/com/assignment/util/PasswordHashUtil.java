package com.assignment.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for generating BCrypt password hashes
 * Use this to create properly formatted password hashes for owner accounts
 */
public class PasswordHashUtil {
    
    /**
     * Generate a BCrypt hash for a plain text password
     * @param plainTextPassword The plain text password to hash
     * @return BCrypt hashed password
     */
    public static String hashPassword(String plainTextPassword) {
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt());
    }
    
    /**
     * Verify a plain text password against a BCrypt hash
     * @param plainTextPassword The plain text password
     * @param hashedPassword The BCrypt hash to verify against
     * @return true if password matches, false otherwise
     */
    public static boolean verifyPassword(String plainTextPassword, String hashedPassword) {
        return BCrypt.checkpw(plainTextPassword, hashedPassword);
    }
    
    /**
     * Main method for generating password hashes
     * Run this to generate BCrypt hashes for your owner passwords
     */
    public static void main(String[] args) {
        // Example passwords - replace these with your actual owner passwords
        String[] passwords = {
            "admin123",
            "owner123", 
            "manager123"
        };
        
        System.out.println("=== BCrypt Password Hash Generator ===");
        System.out.println("Use these hashes to update your owners table:\n");
        
        for (String password : passwords) {
            String hash = hashPassword(password);
            System.out.println("Password: " + password);
            System.out.println("BCrypt Hash: " + hash);
            System.out.println("SQL Update: UPDATE owners SET password = '" + hash + "' WHERE email = 'your-email@example.com';");
            System.out.println("---");
        }
    }
}