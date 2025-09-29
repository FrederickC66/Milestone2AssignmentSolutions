package com.assignment.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import io.github.cdimascio.dotenv.Dotenv;

public class DatabaseUtil {
    private static final Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
    private static final String URL = dotenv.get("DB_URL", "jdbc:mysql://localhost:3306/zumba_class");
    private static final String USERNAME = dotenv.get("DB_USERNAME", "root");
    private static final String PASSWORD = dotenv.get("DB_PASSWORD", "password");
    
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
    
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}