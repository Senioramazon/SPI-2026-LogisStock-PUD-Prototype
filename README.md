# SPI-2026-LogisStock-PUD-Prototype
Trabajo para el Seminario de Práctica de Informática

# LogisStock - Sistema de Control Logístico y de Inventario

Prototipo operacional desarrollado bajo los lineamientos del Proceso Unificado de Desarrollo (PUD). Este sistema está diseñado para optimizar el control de inventario, la facturación de pedidos y la distribución en empresas mayoristas.

## 🚀 Tecnologías Utilizadas
* **Backend / UI:** Java (JDK 17+) - Arquitectura MVC.
* **Base de Datos:** MySQL 8.0+
* **Conectividad:** JDBC Driver

## 📦 Estructura de la Base de Datos
El esquema relacional (ubicado en `/database/schema.sql`) garantiza la integridad atómica de los datos e incluye las siguientes entidades principales:
* `usuarios`: Gestión de roles (Administrador, Depósito, Vendedor) y acceso.
* `proveedores` y `productos`: Catálogo general y control de stock mínimo.
* `clientes`: Directorio de facturación y despacho.
* `pedidos` y `detalle_pedidos`: Trazabilidad transaccional de ventas y reserva de inventario.

## ⚙️ Instalación y Configuración
1. Clonar este repositorio: `git clone https://github.com/tu-usuario/LogisStock-PUD-Prototype.git`
2. Importar el script `database/schema.sql` en tu servidor MySQL local o remoto.
3. Configurar las credenciales de la base de datos en la clase de conexión Java.
4. Compilar y ejecutar.
