package com.logisstock.model;

public class Producto {
    private int idProducto;
    private String nombre;
    private String categoria;
    private double precioMayorista;
    private int stockActual;
    private int stockMinimo;

    public Producto(int idProducto, String nombre, String categoria, double precioMayorista, int stockActual, int stockMinimo) {
        this.idProducto = idProducto;
        this.nombre = nombre;
        this.categoria = categoria;
        this.precioMayorista = precioMayorista;
        this.stockActual = stockActual;
        this.stockMinimo = stockMinimo;
    }

    // Getters y Setters
    public int getIdProducto() { return idProducto; }
    public String getNombre() { return nombre; }
    public double getPrecioMayorista() { return precioMayorista; }
    public int getStockActual() { return stockActual; }
    public void setStockActual(int stockActual) { this.stockActual = stockActual; }
    public int getStockMinimo() { return stockMinimo; }

    @Override
    public String toString() {
        return String.format("[%d] %s | Cat: %s | Precio: $%.2f | Stock: %d (Mín: %d)", 
                idProducto, nombre, categoria, precioMayorista, stockActual, stockMinimo);
    }
}
