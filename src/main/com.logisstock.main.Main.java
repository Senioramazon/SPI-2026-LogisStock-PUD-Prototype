package com.logisstock.main;

import com.logisstock.controller.StockController;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        StockController sistema = new StockController();
        Scanner teclado = new Scanner(System.in);
        int opcion = 0;

        System.out.println("=================================================");
        System.out.println(" LOGISSTOCK: PROTOTIPO OPERACIONAL INICIAL (PUD)");
        System.out.println("=================================================");

        do {
            System.out.println("\n--- MENÚ OPERATIVO GENERAL ---");
            System.out.println("1. Ver Catálogo de Productos Completo");
            System.out.println("2. Ejecutar Simulación de Pedido de Ventas (CU-04 / CU-07)");
            System.out.println("3. Comprobar Alertas Automáticas de Reposición (CU-02)");
            System.out.println("4. Salir");
            System.out.print("Seleccione una opción de control: ");
            
            try {
                opcion = Integer.parseInt(teclado.nextLine());
                switch (opcion) {
                    case 1:
                        sistema.mostrarCatalogoCompleto();
                        break;
                    case 2:
                        System.out.print("Ingrese ID del Producto solicitado: ");
                        int id = Integer.parseInt(teclado.nextLine());
                        System.out.print("Ingrese cantidad para el pedido mayorista: ");
                        int cant = Integer.parseInt(teclado.nextLine());
                        sistema.procesarSalidaVenta(id, cant);
                        break;
                    case 3:
                        sistema.verifyAlertasStockCritico();
                        break;
                    case 4:
                        System.out.println("Finalizando ejecución del entorno de pruebas de LogisStock.");
                        break;
                    default:
                        System.out.println("Opción incorrecta. Intente nuevamente.");
                }
            } catch (NumberFormatException e) {
                System.out.println("Error: Por favor introduzca un valor numérico válido.");
            }
        } while (opcion != 4);
        
        teclado.close();
    }
}
