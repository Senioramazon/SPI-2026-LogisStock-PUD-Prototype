-- =========================================================================
-- PROYECTO: LogisStock
-- MOTOR: MySQL
-- DESCRIPCIÓN: Esquema relacional para el prototipo operacional (PUD)
-- =========================================================================

-- 1. Creación de la Base de Datos
CREATE DATABASE IF NOT EXISTS logisstock_db
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE logisstock_db;

-- 2. Tabla de Usuarios (Seguridad y Autenticación)
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Se asume almacenamiento de hash (ej. SHA-256)
    rol ENUM('ADMINISTRADOR', 'DEPOSITO', 'VENDEDOR') NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tabla de Proveedores
CREATE TABLE IF NOT EXISTS proveedores (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    razon_social VARCHAR(100) NOT NULL,
    cuit VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    email VARCHAR(100)
);

-- 4. Tabla de Productos (Inventario)
CREATE TABLE IF NOT EXISTS productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio_mayorista DECIMAL(10, 2) NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 0,
    id_proveedor INT,
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO',
    CONSTRAINT fk_producto_proveedor FOREIGN KEY (id_proveedor) 
        REFERENCES proveedores(id_proveedor) ON DELETE SET NULL
);

-- 5. Tabla de Clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    razon_social VARCHAR(100) NOT NULL,
    cuit VARCHAR(20) NOT NULL UNIQUE,
    direccion VARCHAR(200) NOT NULL,
    telefono VARCHAR(20)
);

-- 6. Tabla de Pedidos (Cabecera)
CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    fecha_emision DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_cliente INT NOT NULL,
    id_usuario INT NOT NULL, -- Vendedor que generó el pedido
    estado ENUM('PENDIENTE', 'APROBADO_PICKING', 'EN_RUTA', 'ENTREGADO', 'CANCELADO') DEFAULT 'PENDIENTE',
    total DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) 
        REFERENCES clientes(id_cliente) ON DELETE RESTRICT,
    CONSTRAINT fk_pedido_usuario FOREIGN KEY (id_usuario) 
        REFERENCES usuarios(id_usuario) ON DELETE RESTRICT
);

-- 7. Tabla de Detalle de Pedidos
CREATE TABLE IF NOT EXISTS detalle_pedidos (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(12, 2) NOT NULL,
    CONSTRAINT fk_detalle_pedido FOREIGN KEY (id_pedido) 
        REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) 
        REFERENCES productos(id_producto) ON DELETE RESTRICT
);

-- =========================================================================
-- DATOS DE PRUEBA (MOCK DATA) PARA EL PROTOTIPO
-- =========================================================================

-- Insertar Usuarios de prueba
INSERT INTO usuarios (username, password, rol) VALUES 
('admin_logis', 'hash_password_aqui', 'ADMINISTRADOR'),
('depo_juan', 'hash_password_aqui', 'DEPOSITO'),
('vend_ana', 'hash_password_aqui', 'VENDEDOR');

-- Insertar Proveedores de prueba
INSERT INTO proveedores (razon_social, cuit, telefono, email) VALUES 
('Distribuidora Alimentos S.A.', '30-12345678-9', '011-555-1234', 'ventas@alimentos.com'),
('Bebidas del Sur SRL', '30-98765432-1', '0351-444-5678', 'contacto@bebidasur.com');

-- Insertar Productos de prueba
INSERT INTO productos (nombre, categoria, precio_mayorista, stock_actual, stock_minimo, id_proveedor) VALUES 
('Fideos Secos 500g', 'Alimentos', 450.50, 1500, 200, 1),
('Arroz Blanco 1kg', 'Alimentos', 850.00, 800, 150, 1),
('Gaseosa Cola 2.25L', 'Bebidas', 1200.00, 50, 100, 2); -- Este producto debería disparar la alerta de stock mínimo

-- Insertar Clientes de prueba
INSERT INTO clientes (razon_social, cuit, direccion, telefono) VALUES 
('Supermercado El Centro', '20-11223344-5', 'Av. San Martín 123', '0351-111-2222'),
('Minimercado Las Rosas', '27-55667788-9', 'Calle Las Rosas 456', '0351-333-4444');
