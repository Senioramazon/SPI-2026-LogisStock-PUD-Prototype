package com.logisstock.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3006/logisstock_db?serverTimezone=UTC";
    private static final String USER = "root"; // Cambia por tu usuario de MySQL
    private static final String PASSWORD = "root"; // Cambia por tu contraseña de MySQL

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver JDBC de MySQL no encontrado en el classpath.");
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
