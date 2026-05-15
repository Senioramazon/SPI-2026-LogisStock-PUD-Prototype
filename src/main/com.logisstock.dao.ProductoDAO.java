package com.logisstock.dao;

import com.logisstock.config.DBConnection;
import com.logisstock.model.Producto;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    public List<Producto> listarTodos() {
        List<Producto> lista = new ArrayList<>();
        String query = "SELECT * FROM productos";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                lista.add(new Producto(
                    rs.getInt("id_producto"),
                    rs.getString("nombre"),
                    rs.getString("categoria"),
                    rs.getDouble("precio_mayorista"),
                    rs.getInt("stock_actual"),
                    rs.getInt("stock_minimo")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar productos: " + e.getMessage());
        }
        return lista;
    }

    public boolean actualizarStock(int idProducto, int nuevoStock) {
        String sql = "UPDATE productos SET stock_actual = ? WHERE id_producto = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstm = conn.prepareStatement(sql)) {
            
            pstm.setInt(1, nuevoStock);
            pstm.setInt(2, idProducto);
            return pstm.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al modificar inventario: " + e.getMessage());
            return false;
        }
    }

    public Producto buscarPorId(int idProducto) {
        String sql = "SELECT * FROM productos WHERE id_producto = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstm = conn.prepareStatement(sql)) {
            
            pstm.setInt(1, idProducto);
            try (ResultSet rs = pstm.executeQuery()) {
                if (rs.next()) {
                    return new Producto(
                        rs.getInt("id_producto"),
                        rs.getString("nombre"),
                        rs.getString("categoria"),
                        rs.getDouble("precio_mayorista"),
                        rs.getInt("stock_actual"),
                        rs.getInt("stock_minimo")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar producto: " + e.getMessage());
        }
        return null;
    }
}
