package com.logisstock.controller;

import com.logisstock.dao.ProductoDAO;
import com.logisstock.model.Producto;
import java.util.List;

public class StockController {
    private final ProductoDAO productoDAO = new ProductoDAO();

    public void mostrarCatalogoCompleto() {
        System.out.println("\n--- CATÁLOGO ACTUAL EN SISTEMA ---");
        List<Producto> productos = productoDAO.listarTodos();
        for (Producto p : productos) {
            System.out.println(p.toString());
        }
    }

    public void verificarAlertasStockCritico() {
        System.out.println("\n--- ALERTAS DE REPOSICIÓN ACTIVAS ---");
        List<Producto> productos = productoDAO.listarTodos();
        boolean sinAlertas = true;
        for (Producto p : productos) {
            if (p.getStockActual() <= p.getStockMinimo()) {
                System.out.printf("[⚠️ CRÍTICO] El producto '%s' está por debajo del mínimo. Stock: %d / Mínimo: %d\n", 
                        p.getNombre(), p.getStockActual(), p.getStockMinimo());
                sinAlertas = false;
            }
        }
        if (sinAlertas) {
            System.out.println("No se detectaron productos en condición de quiebre de stock.");
        }
    }

    public void procesarSalidaVenta(int idProducto, int cantidadAVender) {
        System.out.println("\n--- PROCESANDO SOLICITUD DE PEDIDO ---");
        Producto producto = productoDAO.buscarPorId(idProducto);

        if (producto == null) {
            System.out.println("❌ Operación rechazada: El producto seleccionado no existe.");
            return;
        }

        // Lógica de validación requerida por el CU-07 (Requerimiento Funcional)
        if (producto.getStockActual() >= cantidadAVender) {
            int stockFinal = producto.getStockActual() - cantidadAVender;
            boolean exito = productoDAO.actualizarStock(idProducto, stockFinal);
            if (exito) {
                System.out.printf("✅ Pedido aprobado para Picking. Remito generado. Ítem: %s. Cantidad: %d. Total: $%.2f\n", 
                        producto.getNombre(), cantidadAVender, (producto.getPrecioMayorista() * cantidadAVender));
            }
        } else {
            System.out.printf("❌ Venta Rechazada por validación automatizada: Stock insuficiente. Unidades físicas en góndola: %d\n", 
                    producto.getStockActual());
        }
    }
}
