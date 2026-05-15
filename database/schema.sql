-- =========================================================================
-- PROYECTO: LogisStock
-- MOTOR: MySQL 8.0+
-- DESCRIPCIÓN: Script de inicialización y datos de prueba limpios
-- =========================================================================

DROP DATABASE IF EXISTS logisstock_db;
CREATE DATABASE logisstock_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE logisstock_db;

-- Evitar conflictos de claves foráneas durante la creación
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Tabla de Usuarios
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol ENUM('ADMINISTRADOR', 'DEPOSITO', 'VENDEDOR') NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

-- 2. Tabla de Proveedores
CREATE TABLE proveedores (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    razon_social VARCHAR(100) NOT NULL,
    cuit VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20)
);

-- 3. Tabla de Productos
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio_mayorista DECIMAL(10, 2) NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 0,
    id_proveedor INT,
    CONSTRAINT fk_producto_proveedor FOREIGN KEY (id_proveedor) 
        REFERENCES proveedores(id_proveedor) ON DELETE SET NULL
);

-- 4. Tabla de Clientes
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    razon_social VARCHAR(100) NOT NULL,
    cuit VARCHAR(20) NOT NULL UNIQUE,
    direccion VARCHAR(200) NOT NULL
);

-- 5. Tabla de Pedidos (Cabecera)
CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_cliente INT NOT NULL,
    id_usuario INT NOT NULL,
    estado ENUM('PENDIENTE', 'APROBADO_PICKING', 'EN_RUTA', 'ENTREGADO', 'CANCELADO') DEFAULT 'PENDIENTE',
    total DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_pedido_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- 6. Tabla de Detalle de Pedidos
CREATE TABLE detalle_pedidos (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(12, 2) NOT NULL,
    CONSTRAINT fk_detalle_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================================
-- INSERCIÓN DE DATOS DEMO (MOCK DATA)
-- =========================================================================

INSERT INTO usuarios (username, password, rol) VALUES 
('admin', 'admin123', 'ADMINISTRADOR'),
('juan_deposito', 'depo123', 'DEPOSITO'),
('ana_ventas', 'ventas123', 'VENDEDOR');

INSERT INTO proveedores (razon_social, cuit, telefono) VALUES 
('Distribuidora Alimentos Central', '30-11111111-9', '011-4555-1234'),
('Bebidas del Sur SRL', '30-22222222-9', '0351-444-5678');

INSERT INTO productos (nombre, categoria, precio_mayorista, stock_actual, stock_minimo, id_proveedor) VALUES 
('Fideos Secos 500g', 'Alimentos', 450.00, 500, 100, 1),
('Arroz Integral 1kg', 'Alimentos', 900.00, 12, 50, 1), -- Dispara alerta de stock mínimo
('Gaseosa Cola 2.25L', 'Bebidas', 1300.00, 80, 40, 2);

INSERT INTO clientes (razon_social, cuit, direccion) VALUES 
('Supermercado Cordillera', '20-33333333-5', 'Av. Colón 1400'),
('Almacén de Barrio SRL', '27-44444444-9', 'Belgrano 450');
