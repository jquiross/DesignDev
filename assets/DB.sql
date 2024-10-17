-- Script para crear las tablas de la base de datos para el sistema de diseño gráfico y desarrollo 

Create database DesignDev;
Use DesignDev;

-- CREACION DE TABLAS

-- 1 Tabla de Roles
CREATE TABLE Roles (
    rol_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL
);

-- 2 Tabla de Usuarios
CREATE TABLE Usuarios (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    rol_id INT,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rol_id) REFERENCES Roles(rol_id)
);

-- 3 Tabla de Categorías de Servicios
CREATE TABLE Categorias_Servicios (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- 4 Tabla de Servicios
CREATE TABLE Servicios (
    servicio_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_servicio VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    categoria_id INT,
    FOREIGN KEY (categoria_id) REFERENCES Categorias_Servicios(categoria_id)
);

-- 5 Tabla de Proyectos
CREATE TABLE Proyectos (
    proyecto_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    servicio_id INT,
    estado ENUM('Pendiente', 'En Progreso', 'Completado') NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_finalizacion DATETIME,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id),
    FOREIGN KEY (servicio_id) REFERENCES Servicios(servicio_id)
);

-- 6 Tabla de Pagos
CREATE TABLE Pagos (
    pago_id INT AUTO_INCREMENT PRIMARY KEY,
    proyecto_id INT,
    monto DECIMAL(10, 2) NOT NULL,
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (proyecto_id) REFERENCES Proyectos(proyecto_id)
);

-- 7 Tabla de Pagos Fraccionados
CREATE TABLE Pagos_Fraccionados (
    pago_fraccionado_id INT AUTO_INCREMENT PRIMARY KEY,
    pago_id INT,
    monto DECIMAL(10, 2) NOT NULL,
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pago_id) REFERENCES Pagos(pago_id)
);

-- 8 Tabla de Mensajes de Contacto
CREATE TABLE Mensajes_Contacto (
    mensaje_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    mensaje TEXT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 9 Tabla de Testimonios
CREATE TABLE Testimonios (
    testimonio_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    contenido TEXT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    aprobado BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id)
);

-- 10 Tabla de Promociones o Descuentos
CREATE TABLE Promociones (
    promocion_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    descuento DECIMAL(5, 2) NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL
);

-- 11 Tabla de Historial de Cambios de Proyectos
CREATE TABLE Historial_Proyectos (
    historial_id INT AUTO_INCREMENT PRIMARY KEY,
    proyecto_id INT,
    cambio TEXT NOT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (proyecto_id) REFERENCES Proyectos(proyecto_id)
);

-- 12 Tabla de Notificaciones
CREATE TABLE Notificaciones (
    notificacion_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    contenido TEXT NOT NULL,
    leido BOOLEAN DEFAULT FALSE,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id)
);

-- 13 Tabla de Tickets de Soporte
CREATE TABLE Tickets_Soporte (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    asunto VARCHAR(100) NOT NULL,
    mensaje TEXT NOT NULL,
    estado ENUM('Abierto', 'En Proceso', 'Cerrado') NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id)
);

-- 14 Tabla de Auditoría de Cambios
CREATE TABLE Auditoria (
    auditoria_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    tabla_modificada VARCHAR(100) NOT NULL,
    cambio TEXT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id)
);

-- Trigger para auditoría de cambios en la base de datos

DELIMITER //

-- Trigger para INSERT en Usuarios
CREATE TRIGGER auditoria_insert_usuarios
AFTER INSERT ON Usuarios
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Usuarios', CONCAT('Se ha añadido un usuario: ', NEW.nombre), NOW());
END;
//

-- Trigger para UPDATE en Usuarios
CREATE TRIGGER auditoria_update_usuarios
AFTER UPDATE ON Usuarios
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Usuarios', CONCAT('Se ha actualizado un usuario: ', NEW.nombre), NOW());
END;
//

-- Trigger para DELETE en Usuarios
CREATE TRIGGER auditoria_delete_usuarios
AFTER DELETE ON Usuarios
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (OLD.usuario_id, 'Usuarios', CONCAT('Se ha eliminado un usuario: ', OLD.nombre), NOW());
END;
//

-- Trigger para INSERT en Roles
CREATE TRIGGER auditoria_insert_roles
AFTER INSERT ON Roles
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Roles', CONCAT('Se ha añadido un rol: ', NEW.nombre), NOW());
END;
//

-- Trigger para UPDATE en Roles
CREATE TRIGGER auditoria_update_roles
AFTER UPDATE ON Roles
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Roles', CONCAT('Se ha actualizado un rol: ', NEW.nombre), NOW());
END;
//

-- Trigger para DELETE en Roles
CREATE TRIGGER auditoria_delete_roles
AFTER DELETE ON Roles
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (OLD.usuario_id, 'Roles', CONCAT('Se ha eliminado un rol: ', OLD.nombre), NOW());
END;
//

-- Trigger para INSERT en Servicios
CREATE TRIGGER auditoria_insert_servicios
AFTER INSERT ON Servicios
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Servicios', CONCAT('Se ha añadido un servicio: ', NEW.nombre), NOW());
END;
//

-- Trigger para UPDATE en Servicios
CREATE TRIGGER auditoria_update_servicios
AFTER UPDATE ON Servicios
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Servicios', CONCAT('Se ha actualizado un servicio: ', NEW.nombre), NOW());
END;
//

-- Trigger para DELETE en Servicios
CREATE TRIGGER auditoria_delete_servicios
AFTER DELETE ON Servicios
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (OLD.usuario_id, 'Servicios', CONCAT('Se ha eliminado un servicio: ', OLD.nombre), NOW());
END;
//

-- Trigger para INSERT en Categorías de Servicios
CREATE TRIGGER auditoria_insert_categoria_servicios
AFTER INSERT ON `Categorías de Servicios`
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Categorías de Servicios', CONCAT('Se ha añadido una categoría: ', NEW.nombre), NOW());
END;
//

-- Trigger para UPDATE en Categorías de Servicios
CREATE TRIGGER auditoria_update_categoria_servicios
AFTER UPDATE ON `Categorías de Servicios`
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Categorías de Servicios', CONCAT('Se ha actualizado una categoría: ', NEW.nombre), NOW());
END;
//

-- Trigger para DELETE en Categorías de Servicios
CREATE TRIGGER auditoria_delete_categoria_servicios
AFTER DELETE ON `Categorías de Servicios`
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (OLD.usuario_id, 'Categorías de Servicios', CONCAT('Se ha eliminado una categoría: ', OLD.nombre), NOW());
END;
//

-- Trigger para INSERT en Proyectos
CREATE TRIGGER auditoria_insert_proyectos
AFTER INSERT ON Proyectos
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Proyectos', CONCAT('Se ha añadido un proyecto: ', NEW.nombre), NOW());
END;
//

-- Trigger para UPDATE en Proyectos
CREATE TRIGGER auditoria_update_proyectos
AFTER UPDATE ON Proyectos
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Proyectos', CONCAT('Se ha actualizado un proyecto: ', NEW.nombre), NOW());
END;
//

-- Trigger para DELETE en Proyectos
CREATE TRIGGER auditoria_delete_proyectos
AFTER DELETE ON Proyectos
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (OLD.usuario_id, 'Proyectos', CONCAT('Se ha eliminado un proyecto: ', OLD.nombre), NOW());
END;
//

-- Trigger para INSERT en Pagos
CREATE TRIGGER auditoria_insert_pagos
AFTER INSERT ON Pagos
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Pagos', CONCAT('Se ha registrado un pago: ', NEW.monto), NOW());
END;
//

-- Trigger para UPDATE en Pagos
CREATE TRIGGER auditoria_update_pagos
AFTER UPDATE ON Pagos
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Pagos', CONCAT('Se ha actualizado un pago: ', NEW.monto), NOW());
END;
//

-- Trigger para DELETE en Pagos
CREATE TRIGGER auditoria_delete_pagos
AFTER DELETE ON Pagos
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (OLD.usuario_id, 'Pagos', CONCAT('Se ha eliminado un pago: ', OLD.monto), NOW());
END;
//

-- Trigger para INSERT en Mensajes de Contacto
CREATE TRIGGER auditoria_insert_mensajes_contacto
AFTER INSERT ON `Mensajes de Contacto`
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Mensajes de Contacto', CONCAT('Se ha recibido un mensaje de contacto: ', NEW.asunto), NOW());
END;
//

-- Trigger para UPDATE en Mensajes de Contacto
CREATE TRIGGER auditoria_update_mensajes_contacto
AFTER UPDATE ON `Mensajes de Contacto`
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Mensajes de Contacto', CONCAT('Se ha actualizado un mensaje de contacto: ', NEW.asunto), NOW());
END;
//

-- Trigger para DELETE en Mensajes de Contacto
CREATE TRIGGER auditoria_delete_mensajes_contacto
AFTER DELETE ON `Mensajes de Contacto`
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (OLD.usuario_id, 'Mensajes de Contacto', CONCAT('Se ha eliminado un mensaje de contacto: ', OLD.asunto), NOW());
END;
//

-- Trigger para INSERT en Testimonios/Comentarios
CREATE TRIGGER auditoria_insert_testimonios
AFTER INSERT ON `Testimonios/Comentarios`
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Testimonios/Comentarios', CONCAT('Se ha añadido un testimonio: ', NEW.nombre), NOW());
END;
//

-- Trigger para UPDATE en Testimonios/Comentarios
CREATE TRIGGER auditoria_update_testimonios
AFTER UPDATE ON `Testimonios/Comentarios`
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Testimonios/Comentarios', CONCAT('Se ha actualizado un testimonio: ', NEW.nombre), NOW());
END;
//

-- Trigger para DELETE en Testimonios/Comentarios
CREATE TRIGGER auditoria_delete_testimonios
AFTER DELETE ON `Testimonios/Comentarios`
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (OLD.usuario_id, 'Testimonios/Comentarios', CONCAT('Se ha eliminado un testimonio: ', OLD.nombre), NOW());
END;
//

-- Trigger para INSERT en Promociones o Descuentos
CREATE TRIGGER auditoria_insert_promociones
AFTER INSERT ON `Promociones o Descuentos`
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Promociones o Descuentos', CONCAT('Se ha añadido una promoción: ', NEW.nombre), NOW());
END;
//

-- Trigger para UPDATE en Promociones o Descuentos
CREATE TRIGGER auditoria_update_promociones
AFTER UPDATE ON `Promociones o Descuentos`
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (NEW.usuario_id, 'Promociones o Descuentos', CONCAT('Se ha actualizado una promoción: ', NEW.nombre), NOW());
END;
//

-- Trigger para DELETE en Promociones o Descuentos
CREATE TRIGGER auditoria_delete_promociones
AFTER DELETE ON `Promociones o Descuentos`
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (usuario_id, tabla_modificada, cambio, fecha)
    VALUES (OLD.usuario_id, 'Promociones o Descuentos', CONCAT('Se ha eliminado una promoción: ', OLD.nombre), NOW());
END;
//

DELIMITER ;


SHOW TRIGGERS;



