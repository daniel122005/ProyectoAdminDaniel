--BASE DE DATOS
CREATE DATABASE agropets;
\c agropets


-- SCHEMAS
CREATE SCHEMA agropets;     -- utilidades
CREATE SCHEMA personas;     -- persona, cliente, veterinario, recepcionista
CREATE SCHEMA clinica;      -- mascota, consulta, proceso_veterinario, tratamiento
CREATE SCHEMA inventario;   -- medicamento, dosis_aplicada
CREATE SCHEMA facturacion;  -- factura
CREATE SCHEMA seguridad;    -- roles/usuarios


--  ENUMS
CREATE TYPE clinica.sexo_mascota_enum        AS ENUM ('Macho','Hembra');
CREATE TYPE facturacion.estado_factura_enum  AS ENUM ('Pendiente','Pagada');
CREATE TYPE seguridad.estado_usuario         AS ENUM ('Activo','Inactivo','Bloqueado');


-- SECUENCIAS 
CREATE SEQUENCE personas.seq_persona;
CREATE SEQUENCE personas.seq_cliente;
CREATE SEQUENCE personas.seq_veterinario;
CREATE SEQUENCE personas.seq_recepcionista;

CREATE SEQUENCE seguridad.seq_rol;

CREATE SEQUENCE clinica.seq_mascota;
CREATE SEQUENCE clinica.seq_consulta;
CREATE SEQUENCE clinica.seq_proceso;
CREATE SEQUENCE clinica.seq_tratamiento;

CREATE SEQUENCE inventario.seq_medicamento;
CREATE SEQUENCE inventario.seq_dosis;

CREATE SEQUENCE facturacion.seq_factura;


-- TABLAS

-- PERSONAS
CREATE TABLE personas.persona (
  PK_id_persona    INT NOT NULL DEFAULT nextval('personas.seq_persona'),
  nombre_completo  VARCHAR(40) NOT NULL,
  documento        INT NOT NULL,
  telefono         INT NOT NULL
);

CREATE TABLE personas.cliente (
  PK_id_cliente INT NOT NULL DEFAULT nextval('personas.seq_cliente'),
  FK_id_persona INT NOT NULL,
  direccion     VARCHAR(50) NOT NULL,
  correo        VARCHAR(50) NOT NULL
);

CREATE TABLE personas.veterinario (
  PK_id_veterinario INT NOT NULL DEFAULT nextval('personas.seq_veterinario'),
  FK_id_persona     INT NOT NULL,
  especialidad      VARCHAR(80) NOT NULL
);

CREATE TABLE personas.recepcionista (
  PK_id_recepcionista INT NOT NULL DEFAULT nextval('personas.seq_recepcionista'),
  FK_id_persona       INT,
  horario_laboral     VARCHAR(60) NOT NULL
);

-- SEGURIDAD
CREATE TABLE seguridad.rol (
  PK_id_rol INT NOT NULL DEFAULT nextval('seguridad.seq_rol'),
  nombre    VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE seguridad.usuario (
  pfk_idpersona   INT NOT NULL,
  correo          VARCHAR(70) UNIQUE NOT NULL,
  contrasena      VARCHAR(50) NOT NULL,
  estado_usuario  seguridad.estado_usuario NOT NULL,
  fk_idrol        INT NOT NULL
);

-- CLÍNICA
CREATE TABLE clinica.mascota (
  PK_id_mascota      INT NOT NULL DEFAULT nextval('clinica.seq_mascota'),
  FK_id_cliente      INT NOT NULL,
  nombre             VARCHAR(60) NOT NULL,
  especie            VARCHAR(30) NOT NULL,
  raza               VARCHAR(60),
  sexo               clinica.sexo_mascota_enum NOT NULL,
  fecha_nacimiento   DATE NOT NULL,
  peso               NUMERIC(10,2)
);

CREATE TABLE clinica.consulta (
  PK_id_consulta      INT NOT NULL DEFAULT nextval('clinica.seq_consulta'),
  FK_id_mascota       INT NOT NULL,
  FK_id_veterinario   INT NOT NULL,
  FK_id_recepcionista INT NOT NULL,
  motivo              VARCHAR(150) NOT NULL,
  fecha               DATE NOT NULL,
  hora                TIME NOT NULL,
  costo               NUMERIC(10,2) NOT NULL,
  diagnostico         VARCHAR(100)
);

CREATE TABLE clinica.proceso_veterinario (
  PK_id_proceso  INT NOT NULL DEFAULT nextval('clinica.seq_proceso'),
  FK_id_consulta INT NOT NULL,
  descripcion    VARCHAR(100) NOT NULL,
  fecha_inicio   DATE NOT NULL,
  fecha_fin      DATE
);

CREATE TABLE clinica.tratamiento (
  PK_id_tratamiento INT NOT NULL DEFAULT nextval('clinica.seq_tratamiento'),
  FK_id_proceso     INT NOT NULL,
  FK_id_veterinario INT NOT NULL,
  nombre            VARCHAR(80) NOT NULL,
  tipo              VARCHAR(40),
  precio            NUMERIC(10,2) NOT NULL
);

-- INVENTARIO
CREATE TABLE inventario.medicamento (
  PK_id_medicamento INT NOT NULL DEFAULT nextval('inventario.seq_medicamento'),
  nombre            VARCHAR(100) NOT NULL,
  cantidad          INT NOT NULL,
  precio            NUMERIC(10,2) NOT NULL
);

CREATE TABLE inventario.dosis_aplicada (
  PK_id_dosis       INT NOT NULL DEFAULT nextval('inventario.seq_dosis'),
  FK_id_tratamiento INT NOT NULL,
  FK_id_medicamento INT NOT NULL,
  dosis_aplicada    INT NOT NULL,
  precio_dosis      NUMERIC(10,2) NOT NULL
);

-- FACTURACIÓN
CREATE TABLE facturacion.factura (
  PK_id_factura INT NOT NULL DEFAULT nextval('facturacion.seq_factura'),
  FK_id_proceso INT NOT NULL,
  fecha         DATE NOT NULL,
  subtotal      NUMERIC(10,2) NOT NULL,
  descuento     NUMERIC(10,2),
  metodo_pago   VARCHAR(20) NOT NULL,
  monto_total   NUMERIC(10,2) NOT NULL,
  estado        facturacion.estado_factura_enum NOT NULL
);


-- LLAVES PRIMARIAS
ALTER TABLE personas.persona               ADD PRIMARY KEY (PK_id_persona);
ALTER TABLE personas.cliente               ADD PRIMARY KEY (PK_id_cliente);
ALTER TABLE personas.veterinario           ADD PRIMARY KEY (PK_id_veterinario);
ALTER TABLE personas.recepcionista         ADD PRIMARY KEY (PK_id_recepcionista);
ALTER TABLE seguridad.rol                  ADD PRIMARY KEY (PK_id_rol);
ALTER TABLE seguridad.usuario              ADD PRIMARY KEY (pfk_idpersona);
ALTER TABLE clinica.mascota                ADD PRIMARY KEY (PK_id_mascota);
ALTER TABLE clinica.consulta               ADD PRIMARY KEY (PK_id_consulta);
ALTER TABLE clinica.proceso_veterinario    ADD PRIMARY KEY (PK_id_proceso);
ALTER TABLE clinica.tratamiento            ADD PRIMARY KEY (PK_id_tratamiento);
ALTER TABLE inventario.medicamento         ADD PRIMARY KEY (PK_id_medicamento);
ALTER TABLE inventario.dosis_aplicada      ADD PRIMARY KEY (PK_id_dosis);
ALTER TABLE facturacion.factura            ADD PRIMARY KEY (PK_id_factura);


-- LLAVES FORÁNEAS
-- Personas
ALTER TABLE personas.cliente
  ADD FOREIGN KEY (FK_id_persona)     REFERENCES personas.persona(PK_id_persona);
ALTER TABLE personas.veterinario
  ADD FOREIGN KEY (FK_id_persona)     REFERENCES personas.persona(PK_id_persona);
ALTER TABLE personas.recepcionista
  ADD FOREIGN KEY (FK_id_persona)     REFERENCES personas.persona(PK_id_persona);

-- Seguridad
ALTER TABLE seguridad.usuario
  ADD FOREIGN KEY (pfk_idpersona) REFERENCES personas.persona(PK_id_persona),
  ADD FOREIGN KEY (fk_idrol)      REFERENCES seguridad.rol(PK_id_rol);

-- Clínica
ALTER TABLE clinica.mascota
  ADD FOREIGN KEY (FK_id_cliente)     REFERENCES personas.cliente(PK_id_cliente);

ALTER TABLE clinica.consulta
  ADD FOREIGN KEY (FK_id_mascota)       REFERENCES clinica.mascota(PK_id_mascota);
ALTER TABLE clinica.consulta
  ADD FOREIGN KEY (FK_id_veterinario)   REFERENCES personas.veterinario(PK_id_veterinario);
ALTER TABLE clinica.consulta
  ADD FOREIGN KEY (FK_id_recepcionista) REFERENCES personas.recepcionista(PK_id_recepcionista);

ALTER TABLE clinica.proceso_veterinario
  ADD FOREIGN KEY (FK_id_consulta)    REFERENCES clinica.consulta(PK_id_consulta);

ALTER TABLE clinica.tratamiento
  ADD FOREIGN KEY (FK_id_proceso)     REFERENCES clinica.proceso_veterinario(PK_id_proceso);
ALTER TABLE clinica.tratamiento
  ADD FOREIGN KEY (FK_id_veterinario) REFERENCES personas.veterinario(PK_id_veterinario);

-- Inventario
ALTER TABLE inventario.dosis_aplicada
  ADD FOREIGN KEY (FK_id_tratamiento) REFERENCES clinica.tratamiento(PK_id_tratamiento);
ALTER TABLE inventario.dosis_aplicada
  ADD FOREIGN KEY (FK_id_medicamento) REFERENCES inventario.medicamento(PK_id_medicamento);

-- Facturación
ALTER TABLE facturacion.factura
  ADD FOREIGN KEY (FK_id_proceso)     REFERENCES clinica.proceso_veterinario(PK_id_proceso);

-- Únicos
ALTER TABLE personas.cliente       ADD UNIQUE (FK_id_persona);
ALTER TABLE personas.veterinario   ADD UNIQUE (FK_id_persona);
ALTER TABLE personas.recepcionista ADD UNIQUE (FK_id_persona);
ALTER TABLE facturacion.factura    ADD UNIQUE (FK_id_proceso);
ALTER TABLE personas.persona       ADD CONSTRAINT uq_persona_documento UNIQUE (documento);


-- INSERTS 
-- PERSONAS
INSERT INTO personas.persona (nombre_completo, documento, telefono) VALUES
('Carlos Dueno',1000000001,3001111),
('Maria Lopez',1000000002,3002222),
('Juan Perez',1000000003,3003333),
('Luisa Gomez',1000000004,3004444),
('Santiago Ruiz',1000000005,3005555),
('Ana Torres',1000000006,3006666),
('Pedro Rojas',1000000007,3007777),
('Camila Diaz',1000000008,3008888),
('Miguel Ramos',1000000009,3009999),
('Sofia Herrera',1000000010,3010001),
('Ricardo Avila',1000000011,3010002),
('Daniel Vargas',1000000012,3010003),
('Valentina Cruz',1000000013,3010004),
('Dra. Valeria Gomez',2000000001,3201111),
('Dr. Martin Rivera',2000000002,3202222),
('Dra. Daniela Suarez',2000000003,3203333),
('Dr. Andres Vega',2000000004,3204444),
('Laura Fernandez',2100000001,3101111),   -- <== corregido: antes 3000000001
('Carolina Mejia',2100000002,3102222),    -- <== corregido: antes 3000000002
('Ricardo Molina',2100000003,3103333);    -- <== corregido: antes 3000000003

-- CLIENTES
INSERT INTO personas.cliente (FK_id_persona, direccion, correo) VALUES
(1,'Calle 10 #5-20, Florencia','carlos@gmail.com'),
(2,'Cra 12 #8-40, Florencia','maria@gmail.com'),
(3,'Av. Centenario #15-45','juan@gmail.com'),
(4,'Calle 2 #9-10','luisa@gmail.com'),
(5,'Calle 18 #10-30','santiago@gmail.com'),
(6,'Cra 5 #3-50','ana@gmail.com'),
(7,'Cra 25 #7-15','pedro@gmail.com'),
(8,'Calle 14 #8-55','camila@gmail.com'),
(9,'Calle 21 #6-22','miguel@gmail.com'),
(10,'Calle 19 #4-50','sofia@gmail.com'),
(11,'Av. Principal #22-40','ricardoavila@gmail.com'),
(12,'Cra 1 #3-55','daniel@gmail.com'),
(13,'Calle 8 #9-40','valentina@gmail.com');

-- VETERINARIOS (personas 14..17)
INSERT INTO personas.veterinario (FK_id_persona, especialidad) VALUES
(14,'Medicina Interna'),
(15,'Cirugia'),
(16,'Cardiologia'),
(17,'Dermatologia');

-- RECEPCIONISTAS (personas 18..20)
INSERT INTO personas.recepcionista (FK_id_persona, horario_laboral) VALUES
(18,'Lunes a Sabado 8:00-18:00'),
(19,'Lunes a Viernes 9:00-17:00'),
(20,'Lunes a Sabado 7:00-15:00');

-- MASCOTAS
INSERT INTO clinica.mascota (FK_id_cliente, nombre, especie, raza, sexo, fecha_nacimiento, peso) VALUES
(1,'Luna','Canino','Labrador','Hembra','2021-05-12',24.50),
(1,'Max','Felino','Persa','Macho','2020-08-20',5.80),
(2,'Rocky','Canino','Pitbull','Macho','2019-06-10',28.30),
(2,'Mia','Felino','Siames','Hembra','2020-09-25',4.20),
(3,'Toby','Canino','Beagle','Macho','2021-01-15',10.50),
(3,'Nina','Canino','Poodle','Hembra','2022-03-22',8.10),
(4,'Simba','Felino','Angora','Macho','2021-04-12',6.00),
(4,'Kira','Canino','Bulldog','Hembra','2020-10-30',20.00),
(5,'Zeus','Canino','Rottweiler','Macho','2019-12-10',40.20),
(5,'Luna','Felino','Mestizo','Hembra','2022-02-28',3.90),
(6,'Coco','Ave','Loro','Macho','2018-07-10',1.50),
(7,'Bobby','Canino','Golden Retriever','Macho','2019-05-15',32.50),
(8,'Luna','Canino','Dalmata','Hembra','2021-11-18',22.00),
(9,'Tomas','Felino','Maine Coon','Macho','2020-01-05',6.80),
(10,'Milo','Canino','Pastor Aleman','Macho','2019-09-10',34.00),
(11,'Kiara','Felino','Siames','Hembra','2020-07-22',4.50),
(12,'Thor','Canino','Boxer','Macho','2021-08-09',25.50),
(13,'Bella','Felino','Persa','Hembra','2020-02-11',5.00),
(1,'Loki','Canino','Bulldog Frances','Macho','2019-03-30',12.30),
(2,'Chispa','Felino','Mestizo','Hembra','2022-01-15',3.70);

-- CONSULTAS
INSERT INTO clinica.consulta (FK_id_mascota, FK_id_veterinario, FK_id_recepcionista, motivo, fecha, hora, costo, diagnostico) VALUES
(1,1,1,'Cojera pata trasera','2025-10-10','09:00',60000.00,'Esguince leve'),
(2,2,2,'Revision general','2025-10-10','10:00',50000.00,'Saludable'),
(3,3,3,'Vomito ocasional','2025-10-11','11:30',55000.00,'Gastritis leve'),
(4,4,1,'Vacunacion anual','2025-10-11','15:00',45000.00,'Aplicada vacuna triple'),
(5,1,2,'Tos persistente','2025-10-12','09:45',65000.00,'Traqueitis'),
(6,2,3,'Dermatitis en oreja','2025-10-12','14:20',52000.00,'Dermatitis leve'),
(7,3,1,'Revision dental','2025-10-13','08:40',48000.00,'Sarro moderado'),
(8,4,2,'Control postquirurgico','2025-10-13','10:10',50000.00,'Evolucion favorable'),
(9,1,3,'Letargo','2025-10-14','13:00',58000.00,'Anemia leve'),
(10,2,1,'Perdida de apetito','2025-10-14','16:30',57000.00,'Estres'),
(11,3,2,'Otitis','2025-10-15','09:15',56000.00,'Otitis externa'),
(12,4,3,'Caida de pelo','2025-10-15','11:50',52000.00,'Alopecia estacional'),
(13,1,1,'Diarrea aguda','2025-10-16','12:10',59000.00,'Enteritis'),
(14,2,2,'Revision cachorro','2025-10-16','15:20',50000.00,'Desarrollo normal'),
(15,3,3,'Herida en pata','2025-10-17','09:40',61000.00,'Laceracion leve'),
(16,4,1,'Control de peso','2025-10-17','10:30',48000.00,'Sobrepeso leve'),
(17,1,2,'Revision geriatrica','2025-10-18','08:50',60000.00,'Artritis leve'),
(18,2,3,'Vacuna antirrabica','2025-10-18','11:00',45000.00,'Aplicada'),
(19,3,1,'Conjuntivitis','2025-10-19','14:00',53000.00,'Conjuntivitis bacteriana'),
(20,4,2,'Chequeo prequirurgico','2025-10-19','15:30',62000.00,'Apto para cirugia');

-- PROCESOS
INSERT INTO clinica.proceso_veterinario (FK_id_consulta, descripcion, fecha_inicio, fecha_fin) VALUES
(1,'Tratamiento antiinflamatorio y reposo','2025-10-10','2025-10-14'),
(2,'Plan preventivo anual','2025-10-10','2025-10-10'),
(3,'Manejo de gastritis','2025-10-11','2025-10-15'),
(4,'Esquema de vacunacion','2025-10-11','2025-10-11'),
(5,'Manejo de tos','2025-10-12','2025-10-16'),
(6,'Cuidado dermatologico','2025-10-12','2025-10-15'),
(7,'Limpieza dental programada','2025-10-13','2025-10-13'),
(8,'Seguimiento postquirurgico','2025-10-13','2025-10-18'),
(9,'Plan de suplementacion','2025-10-14','2025-10-17'),
(10,'Manejo de estres','2025-10-14','2025-10-16'),
(11,'Tratamiento de otitis','2025-10-15','2025-10-18'),
(12,'Cuidado de piel y pelo','2025-10-15','2025-10-19'),
(13,'Hidratacion y dieta blanda','2025-10-16','2025-10-17'),
(14,'Control de desarrollo','2025-10-16','2025-10-16'),
(15,'Curacion de herida y vendaje','2025-10-17','2025-10-20'),
(16,'Plan nutricional','2025-10-17','2025-10-19'),
(17,'Manejo de artritis','2025-10-18','2025-10-22'),
(18,'Vacunacion antirrabica','2025-10-18','2025-10-18'),
(19,'Tratamiento oftalmico','2025-10-19','2025-10-23'),
(20,'Preparacion prequirurgica','2025-10-19','2025-10-20');

-- TRATAMIENTOS
INSERT INTO clinica.tratamiento (FK_id_proceso, FK_id_veterinario, nombre, tipo, precio) VALUES
(1,1,'Meloxicam 7.5mg','Farmacologico',25000.00),
(2,2,'Desparasitacion','Preventivo',20000.00),
(3,3,'Omeprazol','Farmacologico',22000.00),
(4,4,'Vacuna triple canina','Vacuna',45000.00),
(5,1,'Antitusivo','Farmacologico',18000.00),
(6,2,'Unguento otico','Topico',15000.00),
(7,3,'Limpieza dental','Procedimiento',40000.00),
(8,4,'Analgesico posoperatorio','Farmacologico',23000.00),
(9,1,'Hierro y vitaminas','Suplemento',20000.00),
(10,2,'Feromonas ambientales','Ambiental',30000.00),
(11,3,'Gotas oticas','Topico',16000.00),
(12,4,'Champu medicado','Topico',25000.00),
(13,1,'Probiotico','Farmacologico',17000.00),
(14,2,'Vitaminas cachorro','Suplemento',14000.00),
(15,3,'Curacion y vendaje','Procedimiento',35000.00),
(16,4,'Plan nutricional','Consulta',28000.00),
(17,1,'Condroprotector','Suplemento',32000.00),
(18,2,'Vacuna antirrabica','Vacuna',30000.00),
(19,3,'Colirio antibiotico','Topico',19000.00),
(20,4,'Sedacion ligera','Procedimiento',50000.00);

-- MEDICAMENTOS
INSERT INTO inventario.medicamento (nombre, cantidad, precio) VALUES
('Meloxicam 7.5mg',80,4000.00),
('Desparasitante tabletas',120,2500.00),
('Omeprazol 20mg',60,3000.00),
('Vacuna triple canina',40,15000.00),
('Jarabe antitusivo',50,3500.00),
('Unguento otico',70,4200.00),
('Kit limpieza dental',30,12000.00),
('Analgesico posoperatorio',90,3200.00),
('Complejo B + Hierro',100,2800.00),
('Difusor de feromonas',20,16000.00),
('Gotas oticas antibioticas',60,4000.00),
('Champu medicado',45,7000.00),
('Probiotico sobres',80,2200.00),
('Vitaminas cachorro',100,1800.00),
('Vendaje elastico',200,1000.00),
('Plan nutricional (pack)',25,20000.00),
('Condroprotector 500mg',50,6000.00),
('Vacuna antirrabica',35,12000.00),
('Colirio antibiotico',55,3500.00),
('Sedacion ligera (ampolla)',25,8000.00);

-- DOSIS
INSERT INTO inventario.dosis_aplicada (FK_id_tratamiento, FK_id_medicamento, dosis_aplicada, precio_dosis) VALUES
(1,1,5,20000.00),
(2,2,1,2500.00),
(3,3,7,21000.00),
(4,4,1,15000.00),
(5,5,3,10500.00),
(6,6,1,4200.00),
(7,7,1,12000.00),
(8,8,3,9600.00),
(9,9,10,28000.00),
(10,10,1,16000.00),
(11,11,3,12000.00),
(12,12,2,14000.00),
(13,13,5,11000.00),
(14,14,10,18000.00),
(15,15,2,2000.00),
(16,16,1,20000.00),
(17,17,6,36000.00),
(18,18,1,12000.00),
(19,19,4,14000.00),
(20,20,1,8000.00);

-- FACTURAS
INSERT INTO facturacion.factura (FK_id_proceso, fecha, subtotal, descuento, metodo_pago, monto_total, estado) VALUES
(1,'2025-10-10',(60000+25000+20000),0,'Efectivo',(60000+25000+20000),'Pagada'),
(2,'2025-10-10',(50000+20000+2500),0,'Tarjeta',(50000+20000+2500),'Pagada'),
(3,'2025-10-11',(55000+22000+21000),0,'Efectivo',(55000+22000+21000),'Pagada'),
(4,'2025-10-11',(45000+45000+15000),5000,'Efectivo',(45000+45000+15000-5000),'Pagada'),
(5,'2025-10-12',(65000+18000+10500),0,'Tarjeta',(65000+18000+10500),'Pagada'),
(6,'2025-10-12',(52000+15000+4200),0,'Efectivo',(52000+15000+4200),'Pagada'),
(7,'2025-10-13',(48000+40000+12000),0,'Efectivo',(48000+40000+12000),'Pagada'),
(8,'2025-10-13',(50000+23000+9600),0,'Tarjeta',(50000+23000+9600),'Pagada'),
(9,'2025-10-14',(58000+20000+28000),0,'Efectivo',(58000+20000+28000),'Pagada'),
(10,'2025-10-14',(57000+30000+16000),0,'Efectivo',(57000+30000+16000),'Pagada'),
(11,'2025-10-15',(56000+16000+12000),0,'Tarjeta',(56000+16000+12000),'Pagada'),
(12,'2025-10-15',(52000+25000+14000),0,'Efectivo',(52000+25000+14000),'Pagada'),
(13,'2025-10-16',(59000+17000+11000),0,'Efectivo',(59000+17000+11000),'Pagada'),
(14,'2025-10-16',(50000+14000+18000),0,'Tarjeta',(50000+14000+18000),'Pagada'),
(15,'2025-10-17',(61000+35000+2000),0,'Efectivo',(61000+35000+2000),'Pagada'),
(16,'2025-10-17',(48000+28000+20000),0,'Tarjeta',(48000+28000+20000),'Pagada'),
(17,'2025-10-18',(60000+32000+36000),0,'Efectivo',(60000+32000+36000),'Pagada'),
(18,'2025-10-18',(45000+30000+12000),0,'Efectivo',(45000+30000+12000),'Pagada'),
(19,'2025-10-19',(53000+19000+14000),0,'Tarjeta',(53000+19000+14000),'Pagada'),
(20,'2025-10-19',(62000+50000+8000),8000,'Efectivo',(62000+50000+8000-8000),'Pagada');




-- ÍNDICES
-- Agenda: aceleran validaciones de choques
CREATE INDEX idx_consulta_vet_fecha_hora    ON clinica.consulta(FK_id_veterinario, fecha, hora);
CREATE INDEX idx_consulta_masc_fecha_hora   ON clinica.consulta(FK_id_mascota,     fecha, hora);
CREATE INDEX idx_consulta_recep_fecha_hora  ON clinica.consulta(FK_id_recepcionista, fecha, hora);

CREATE INDEX idx_mascota_cliente            ON clinica.mascota(FK_id_cliente);
CREATE INDEX idx_consulta_mascota           ON clinica.consulta(FK_id_mascota);
CREATE INDEX idx_consulta_veterinario       ON clinica.consulta(FK_id_veterinario);
CREATE INDEX idx_consulta_recepcionista     ON clinica.consulta(FK_id_recepcionista);
CREATE INDEX idx_proceso_consulta           ON clinica.proceso_veterinario(FK_id_consulta);
CREATE INDEX idx_tratamiento_proceso        ON clinica.tratamiento(FK_id_proceso);
CREATE INDEX idx_tratamiento_veterinario    ON clinica.tratamiento(FK_id_veterinario);
CREATE INDEX idx_dosis_tratamiento          ON inventario.dosis_aplicada(FK_id_tratamiento);
CREATE INDEX idx_dosis_medicamento          ON inventario.dosis_aplicada(FK_id_medicamento);
CREATE INDEX idx_factura_proceso            ON facturacion.factura(FK_id_proceso);
CREATE INDEX idx_usuario_rol                ON seguridad.usuario(fk_idrol);


--  TRIGGERS

-- FACTURACIÓN: calcular monto_total
CREATE OR REPLACE FUNCTION facturacion.fn_factura_calcular_total()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.monto_total := NEW.subtotal - COALESCE(NEW.descuento, 0);
  RETURN NEW;
END$$;

CREATE TRIGGER tr_factura_calcular_total_ins
BEFORE INSERT ON facturacion.factura
FOR EACH ROW EXECUTE FUNCTION facturacion.fn_factura_calcular_total();

CREATE TRIGGER tr_factura_calcular_total_upd
BEFORE UPDATE ON facturacion.factura
FOR EACH ROW EXECUTE FUNCTION facturacion.fn_factura_calcular_total();

-- FACTURACIÓN: validar descuento lógico
CREATE OR REPLACE FUNCTION facturacion.fn_factura_validar_descuento()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF COALESCE(NEW.descuento,0) < 0 THEN RAISE EXCEPTION 'Descuento negativo'; END IF;
  IF COALESCE(NEW.descuento,0) > NEW.subtotal THEN RAISE EXCEPTION 'Descuento mayor al subtotal'; END IF;
  RETURN NEW;
END$$;

CREATE TRIGGER tr_factura_validar_descuento_bu
BEFORE INSERT OR UPDATE ON facturacion.factura
FOR EACH ROW EXECUTE FUNCTION facturacion.fn_factura_validar_descuento();

-- INVENTARIO: INSERT descuenta stock con validación
CREATE OR REPLACE FUNCTION inventario.fn_dosis_descuenta_stock()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE v_stock INT;
BEGIN
  SELECT cantidad INTO v_stock
  FROM inventario.medicamento
  WHERE PK_id_medicamento = NEW.FK_id_medicamento;

  IF v_stock IS NULL THEN
    RAISE EXCEPTION 'Medicamento % no existe', NEW.FK_id_medicamento;
  END IF;

  IF v_stock < NEW.dosis_aplicada THEN
    RAISE EXCEPTION 'Stock insuficiente en %: disp %, req %', NEW.FK_id_medicamento, v_stock, NEW.dosis_aplicada;
  END IF;

  UPDATE inventario.medicamento
     SET cantidad = cantidad - NEW.dosis_aplicada
   WHERE PK_id_medicamento = NEW.FK_id_medicamento;

  RETURN NEW;
END$$;

CREATE TRIGGER tr_dosis_descuenta_stock
AFTER INSERT ON inventario.dosis_aplicada
FOR EACH ROW EXECUTE FUNCTION inventario.fn_dosis_descuenta_stock();

-- INVENTARIO: BEFORE UPDATE validar incremento/cambio
CREATE OR REPLACE FUNCTION inventario.fn_dosis_validar_stock_bu()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE v_delta INT; v_disp INT;
BEGIN
  IF NEW.FK_id_medicamento = OLD.FK_id_medicamento AND NEW.dosis_aplicada <= OLD.dosis_aplicada THEN
    RETURN NEW;
  END IF;

  v_delta := CASE
               WHEN NEW.FK_id_medicamento = OLD.FK_id_medicamento
                 THEN NEW.dosis_aplicada - OLD.dosis_aplicada
               ELSE NEW.dosis_aplicada
             END;

  IF v_delta <= 0 THEN RETURN NEW; END IF;

  SELECT cantidad INTO v_disp
  FROM inventario.medicamento
  WHERE PK_id_medicamento = NEW.FK_id_medicamento;

  IF v_disp IS NULL THEN
    RAISE EXCEPTION 'Medicamento % no existe', NEW.FK_id_medicamento;
  END IF;

  IF v_disp < v_delta THEN
    RAISE EXCEPTION 'Stock insuficiente en %: disp %, req %', NEW.FK_id_medicamento, v_disp, v_delta;
  END IF;

  RETURN NEW;
END$$;

CREATE TRIGGER tr_dosis_validar_stock_bu
BEFORE UPDATE ON inventario.dosis_aplicada
FOR EACH ROW EXECUTE FUNCTION inventario.fn_dosis_validar_stock_bu();

-- INVENTARIO: AFTER UPDATE ajustar stock (devuelve viejo / descuenta nuevo)
CREATE OR REPLACE FUNCTION inventario.fn_dosis_ajustar_stock_au()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.FK_id_medicamento = OLD.FK_id_medicamento THEN
    UPDATE inventario.medicamento
       SET cantidad = cantidad + OLD.dosis_aplicada - NEW.dosis_aplicada
     WHERE PK_id_medicamento = NEW.FK_id_medicamento;
  ELSE
    UPDATE inventario.medicamento
       SET cantidad = cantidad + OLD.dosis_aplicada
     WHERE PK_id_medicamento = OLD.FK_id_medicamento;

    UPDATE inventario.medicamento
       SET cantidad = cantidad - NEW.dosis_aplicada
     WHERE PK_id_medicamento = NEW.FK_id_medicamento;
  END IF;

  RETURN NEW;
END$$;

CREATE TRIGGER tr_dosis_ajustar_stock_au
AFTER UPDATE ON inventario.dosis_aplicada
FOR EACH ROW EXECUTE FUNCTION inventario.fn_dosis_ajustar_stock_au();

-- INVENTARIO: AFTER DELETE reponer stock
CREATE OR REPLACE FUNCTION inventario.fn_dosis_reponer_stock_ad()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  UPDATE inventario.medicamento
     SET cantidad = cantidad + OLD.dosis_aplicada
   WHERE PK_id_medicamento = OLD.FK_id_medicamento;
  RETURN OLD;
END$$;

CREATE TRIGGER tr_dosis_reponer_stock_ad
AFTER DELETE ON inventario.dosis_aplicada
FOR EACH ROW EXECUTE FUNCTION inventario.fn_dosis_reponer_stock_ad();

-- DOSIS: autoprecio si falta (precio_medicamento * dosis) + no negativo
CREATE OR REPLACE FUNCTION inventario.fn_dosis_autoprecio()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE p NUMERIC(10,2);
BEGIN
  IF NEW.precio_dosis IS NULL THEN
    SELECT precio INTO p
    FROM inventario.medicamento
    WHERE PK_id_medicamento = NEW.FK_id_medicamento;

    IF p IS NULL THEN
      RAISE EXCEPTION 'Medicamento % no existe', NEW.FK_id_medicamento;
    END IF;

    NEW.precio_dosis := p * NEW.dosis_aplicada;
  END IF;

  IF NEW.precio_dosis < 0 THEN
    RAISE EXCEPTION 'precio_dosis negativo';
  END IF;

  RETURN NEW;
END$$;

CREATE TRIGGER tr_dosis_autoprecio_bi
BEFORE INSERT ON inventario.dosis_aplicada
FOR EACH ROW EXECUTE FUNCTION inventario.fn_dosis_autoprecio();

CREATE TRIGGER tr_dosis_autoprecio_bu
BEFORE UPDATE ON inventario.dosis_aplicada
FOR EACH ROW EXECUTE FUNCTION inventario.fn_dosis_autoprecio();

-- CLÍNICA: evitar choques de agenda
CREATE OR REPLACE FUNCTION clinica.fn_validar_consulta_agenda()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE v INT;
BEGIN
  SELECT COUNT(*) INTO v
  FROM clinica.consulta c
  WHERE c.FK_id_veterinario=NEW.FK_id_veterinario
    AND c.fecha=NEW.fecha
    AND c.hora=NEW.hora
    AND (TG_OP='INSERT' OR c.PK_id_consulta<>NEW.PK_id_consulta);
  IF v>0 THEN
    RAISE EXCEPTION 'Veterinario % ya tiene consulta en % %', NEW.FK_id_veterinario, NEW.fecha, NEW.hora;
  END IF;

  SELECT COUNT(*) INTO v
  FROM clinica.consulta c
  WHERE c.FK_id_mascota=NEW.FK_id_mascota
    AND c.fecha=NEW.fecha
    AND c.hora=NEW.hora
    AND (TG_OP='INSERT' OR c.PK_id_consulta<>NEW.PK_id_consulta);
  IF v>0 THEN
    RAISE EXCEPTION 'Mascota % ya tiene consulta en % %', NEW.FK_id_mascota, NEW.fecha, NEW.hora;
  END IF;

  SELECT COUNT(*) INTO v
  FROM clinica.consulta c
  WHERE c.FK_id_recepcionista=NEW.FK_id_recepcionista
    AND c.fecha=NEW.fecha
    AND c.hora=NEW.hora
    AND (TG_OP='INSERT' OR c.PK_id_consulta<>NEW.PK_id_consulta);
  IF v>0 THEN
    RAISE EXCEPTION 'Recepcionista % ya tiene consulta en % %', NEW.FK_id_recepcionista, NEW.fecha, NEW.hora;
  END IF;

  RETURN NEW;
END$$;

CREATE TRIGGER tr_consulta_validar_agenda_bi
BEFORE INSERT OR UPDATE ON clinica.consulta
FOR EACH ROW EXECUTE FUNCTION clinica.fn_validar_consulta_agenda();

-- CLÍNICA: coherencia de fechas en proceso_veterinario
CREATE OR REPLACE FUNCTION clinica.fn_proceso_validar_fechas()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.fecha_fin IS NOT NULL AND NEW.fecha_fin < NEW.fecha_inicio THEN
    RAISE EXCEPTION 'fecha_fin < fecha_inicio';
  END IF;
  RETURN NEW;
END$$;

CREATE TRIGGER tr_proceso_validar_fechas_bu
BEFORE INSERT OR UPDATE ON clinica.proceso_veterinario
FOR EACH ROW EXECUTE FUNCTION clinica.fn_proceso_validar_fechas();

-- PROCESO: inicio no anterior a la fecha de la consulta
CREATE OR REPLACE FUNCTION clinica.fn_proceso_validar_inicio_con_consulta()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE f DATE;
BEGIN
  SELECT fecha INTO f FROM clinica.consulta WHERE PK_id_consulta = NEW.FK_id_consulta;
  IF f IS NULL THEN RAISE EXCEPTION 'Consulta % no existe', NEW.FK_id_consulta; END IF;
  IF NEW.fecha_inicio < f THEN RAISE EXCEPTION 'fecha_inicio < fecha de consulta'; END IF;
  RETURN NEW;
END$$;

CREATE TRIGGER tr_proceso_validar_inicio_bu
BEFORE INSERT OR UPDATE ON clinica.proceso_veterinario
FOR EACH ROW EXECUTE FUNCTION clinica.fn_proceso_validar_inicio_con_consulta();

-- FACTURACIÓN: descuento fidelidad (≥4 consultas del cliente)
CREATE OR REPLACE FUNCTION facturacion.fn_factura_desc_fidelidad()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE
  v_cliente  INT;
  v_visitas  INT;
BEGIN
  SELECT m.FK_id_cliente INTO v_cliente
  FROM clinica.proceso_veterinario p
  JOIN clinica.consulta c  ON c.PK_id_consulta = p.FK_id_consulta
  JOIN clinica.mascota  m  ON m.PK_id_mascota  = c.FK_id_mascota
  WHERE p.PK_id_proceso = NEW.FK_id_proceso;

  IF v_cliente IS NULL THEN
    RAISE EXCEPTION 'Proceso % no existe', NEW.FK_id_proceso;
  END IF;

  SELECT COUNT(*) INTO v_visitas
  FROM clinica.consulta c
  JOIN clinica.mascota  m ON m.PK_id_mascota = c.FK_id_mascota
  WHERE m.FK_id_cliente = v_cliente
    AND c.fecha <= NEW.fecha;

  IF v_visitas > 3 AND COALESCE(NEW.descuento,0) = 0 THEN
    NEW.descuento := ROUND(NEW.subtotal * 0.10, 2);
  END IF;

  RETURN NEW;
END$$;

CREATE TRIGGER tr_factura_00_desc_fidelidad_bu
BEFORE INSERT OR UPDATE ON facturacion.factura
FOR EACH ROW EXECUTE FUNCTION facturacion.fn_factura_desc_fidelidad();


-- PROCEDIMIENTOS ALMACENADOS

-- PROCEDIMIENTO: crear cliente (persona + cliente)
CREATE OR REPLACE PROCEDURE personas.pr_crear_cliente(
  IN p_nombre_completo VARCHAR(40),
  IN p_documento INT,
  IN p_telefono INT,
  IN p_direccion VARCHAR(50),
  IN p_correo VARCHAR(50),
  OUT o_id_persona INT,
  OUT o_id_cliente INT
)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO personas.persona(nombre_completo,documento,telefono)
  VALUES(p_nombre_completo,p_documento,p_telefono)
  RETURNING PK_id_persona INTO o_id_persona;

  INSERT INTO personas.cliente(FK_id_persona,direccion,correo)
  VALUES(o_id_persona,p_direccion,p_correo)
  RETURNING PK_id_cliente INTO o_id_cliente;
END$$;

-- PROCEDIMIENTO: crear veterinario (persona + veterinario)
CREATE OR REPLACE PROCEDURE personas.pr_crear_veterinario(
  IN p_nombre_completo VARCHAR(40),
  IN p_documento INT,
  IN p_telefono INT,
  IN p_especialidad VARCHAR(80),
  OUT o_id_persona INT,
  OUT o_id_veterinario INT
)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO personas.persona(nombre_completo,documento,telefono)
  VALUES(p_nombre_completo,p_documento,p_telefono)
  RETURNING PK_id_persona INTO o_id_persona;

  INSERT INTO personas.veterinario(FK_id_persona,especialidad)
  VALUES(o_id_persona,p_especialidad)
  RETURNING PK_id_veterinario INTO o_id_veterinario;
END$$;

-- PROCEDIMIENTO: crear recepcionista (persona + recepcionista)
CREATE OR REPLACE PROCEDURE personas.pr_crear_recepcionista(
  IN p_nombre_completo VARCHAR(40),
  IN p_documento INT,
  IN p_telefono INT,
  IN p_horario_laboral VARCHAR(60),
  OUT o_id_persona INT,
  OUT o_id_recepcionista INT
)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO personas.persona(nombre_completo,documento,telefono)
  VALUES(p_nombre_completo,p_documento,p_telefono)
  RETURNING PK_id_persona INTO o_id_persona;

  INSERT INTO personas.recepcionista(FK_id_persona,horario_laboral)
  VALUES(o_id_persona,p_horario_laboral)
  RETURNING PK_id_recepcionista INTO o_id_recepcionista;
END$$;

-- PROCEDIMIENTO: actualizar datos de contacto de persona
CREATE OR REPLACE PROCEDURE personas.pr_actualizar_contacto_persona(
  IN p_id_persona INT,
  IN p_nombre_completo VARCHAR(40),
  IN p_telefono INT
)
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE personas.persona
  SET nombre_completo = p_nombre_completo,
      telefono = p_telefono
  WHERE PK_id_persona = p_id_persona;
END$$;

-- PROCEDIMIENTO: registrar mascota
CREATE OR REPLACE PROCEDURE clinica.pr_registrar_mascota(
  IN p_fk_cliente INT,
  IN p_nombre VARCHAR(60),
  IN p_especie VARCHAR(30),
  IN p_raza VARCHAR(60),
  IN p_sexo clinica.sexo_mascota_enum,
  IN p_fecha_nacimiento DATE,
  IN p_peso NUMERIC(10,2),
  OUT o_id_mascota INT
)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO clinica.mascota(FK_id_cliente,nombre,especie,raza,sexo,fecha_nacimiento,peso)
  VALUES(p_fk_cliente,p_nombre,p_especie,p_raza,p_sexo,p_fecha_nacimiento,p_peso)
  RETURNING PK_id_mascota INTO o_id_mascota;
END$$;

-- PROCEDIMIENTO: registrar consulta
CREATE OR REPLACE PROCEDURE clinica.pr_registrar_consulta(
  IN p_fk_mascota INT,
  IN p_fk_veterinario INT,
  IN p_fk_recepcionista INT,
  IN p_motivo VARCHAR(150),
  IN p_fecha DATE,
  IN p_hora TIME,
  IN p_costo NUMERIC(10,2),
  IN p_diagnostico VARCHAR(100),
  OUT o_id_consulta INT
)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO clinica.consulta(FK_id_mascota,FK_id_veterinario,FK_id_recepcionista,motivo,fecha,hora,costo,diagnostico)
  VALUES(p_fk_mascota,p_fk_veterinario,p_fk_recepcionista,p_motivo,p_fecha,p_hora,p_costo,p_diagnostico)
  RETURNING PK_id_consulta INTO o_id_consulta;
END$$;

-- PROCEDIMIENTO: iniciar proceso veterinario
CREATE OR REPLACE PROCEDURE clinica.pr_iniciar_proceso(
  IN p_fk_consulta INT,
  IN p_descripcion VARCHAR(100),
  IN p_fecha_inicio DATE,
  IN p_fecha_fin DATE,
  OUT o_id_proceso INT
)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO clinica.proceso_veterinario(FK_id_consulta,descripcion,fecha_inicio,fecha_fin)
  VALUES(p_fk_consulta,p_descripcion,p_fecha_inicio,p_fecha_fin)
  RETURNING PK_id_proceso INTO o_id_proceso;
END$$;

-- PROCEDIMIENTO: agregar tratamiento a un proceso
CREATE OR REPLACE PROCEDURE clinica.pr_agregar_tratamiento(
  IN p_fk_proceso INT,
  IN p_fk_veterinario INT,
  IN p_nombre VARCHAR(80),
  IN p_tipo VARCHAR(40),
  IN p_precio NUMERIC(10,2),
  OUT o_id_tratamiento INT
)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO clinica.tratamiento(FK_id_proceso,FK_id_veterinario,nombre,tipo,precio)
  VALUES(p_fk_proceso,p_fk_veterinario,p_nombre,p_tipo,p_precio)
  RETURNING PK_id_tratamiento INTO o_id_tratamiento;
END$$;

-- PROCEDIMIENTO: aplicar dosis
CREATE OR REPLACE PROCEDURE inventario.pr_aplicar_dosis(
  IN p_fk_tratamiento INT,
  IN p_fk_medicamento INT,
  IN p_dosis INT,
  IN p_precio_dosis NUMERIC(10,2),
  OUT o_id_dosis INT
)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO inventario.dosis_aplicada(FK_id_tratamiento,FK_id_medicamento,dosis_aplicada,precio_dosis)
  VALUES(p_fk_tratamiento,p_fk_medicamento,p_dosis,p_precio_dosis)
  RETURNING PK_id_dosis INTO o_id_dosis;
END$$;

-- PROCEDIMIENTO: actualizar dosis
CREATE OR REPLACE PROCEDURE inventario.pr_actualizar_dosis(
  IN p_id_dosis INT,
  IN p_fk_medicamento INT,
  IN p_dosis INT,
  IN p_precio_dosis NUMERIC(10,2)
)
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE inventario.dosis_aplicada
  SET FK_id_medicamento = p_fk_medicamento,
      dosis_aplicada   = p_dosis,
      precio_dosis     = p_precio_dosis
  WHERE PK_id_dosis = p_id_dosis;
END$$;

-- PROCEDIMIENTO: eliminar dosis 
CREATE OR REPLACE PROCEDURE inventario.pr_eliminar_dosis(
  IN p_id_dosis INT
)
LANGUAGE plpgsql AS $$
BEGIN
  DELETE FROM inventario.dosis_aplicada
  WHERE PK_id_dosis = p_id_dosis;
END$$;

-- FUNCIÓN: calcular subtotal total de un proceso
CREATE OR REPLACE FUNCTION facturacion.fn_calcular_subtotal_proceso(p_fk_proceso INT)
RETURNS NUMERIC(10,2)
LANGUAGE plpgsql AS $$
DECLARE
  v_sub_consulta NUMERIC(10,2) := 0;
  v_sub_trat     NUMERIC(10,2) := 0;
  v_sub_dosis    NUMERIC(10,2) := 0;
BEGIN
  SELECT COALESCE(c.costo,0) INTO v_sub_consulta
  FROM clinica.proceso_veterinario p
  JOIN clinica.consulta c ON c.PK_id_consulta = p.FK_id_consulta
  WHERE p.PK_id_proceso = p_fk_proceso;

  SELECT COALESCE(SUM(t.precio),0) INTO v_sub_trat
  FROM clinica.tratamiento t
  WHERE t.FK_id_proceso = p_fk_proceso;

  SELECT COALESCE(SUM(d.precio_dosis),0) INTO v_sub_dosis
  FROM inventario.dosis_aplicada d
  JOIN clinica.tratamiento t ON t.PK_id_tratamiento = d.FK_id_tratamiento
  WHERE t.FK_id_proceso = p_fk_proceso;

  RETURN v_sub_consulta + v_sub_trat + v_sub_dosis;
END$$;

-- PROCEDIMIENTO: crear/actualizar factura de un proceso
CREATE OR REPLACE PROCEDURE facturacion.pr_facturar_proceso(
  IN p_fk_proceso INT,
  IN p_fecha DATE,
  IN p_metodo_pago VARCHAR(20),
  IN p_descuento NUMERIC(10,2),
  IN p_estado facturacion.estado_factura_enum,
  OUT o_id_factura INT
)
LANGUAGE plpgsql AS $$
DECLARE v_subtotal NUMERIC(10,2);
BEGIN
  v_subtotal := facturacion.fn_calcular_subtotal_proceso(p_fk_proceso);

  INSERT INTO facturacion.factura(FK_id_proceso,fecha,subtotal,descuento,metodo_pago,monto_total,estado)
  VALUES(p_fk_proceso,p_fecha,v_subtotal,p_descuento,p_metodo_pago,v_subtotal - COALESCE(p_descuento,0),p_estado)
  ON CONFLICT (FK_id_proceso) DO UPDATE
    SET fecha = EXCLUDED.fecha,
        subtotal = EXCLUDED.subtotal,
        descuento = EXCLUDED.descuento,
        metodo_pago = EXCLUDED.metodo_pago,
        estado = EXCLUDED.estado
  RETURNING PK_id_factura INTO o_id_factura;
END$$;

-- PROCEDIMIENTO: cambiar estado de una factura
CREATE OR REPLACE PROCEDURE facturacion.pr_cambiar_estado_factura(
  IN p_id_factura INT,
  IN p_estado facturacion.estado_factura_enum
)
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE facturacion.factura
  SET estado = p_estado
  WHERE PK_id_factura = p_id_factura;
END$$;

-- PROCEDIMIENTO: crear usuario (seguridad)
CREATE OR REPLACE PROCEDURE seguridad.pr_crear_usuario(
  IN p_fk_idpersona INT,
  IN p_correo VARCHAR(70),
  IN p_contrasena VARCHAR(50),
  IN p_estado seguridad.estado_usuario,
  IN p_fk_idrol INT
)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO seguridad.usuario(pfk_idpersona,correo,contrasena,estado_usuario,fk_idrol)
  VALUES(p_fk_idpersona,p_correo,p_contrasena,p_estado,p_fk_idrol);
END$$;

-- PROCEDIMIENTO: actualizar usuario (correo/estado/rol)
CREATE OR REPLACE PROCEDURE seguridad.pr_actualizar_usuario(
  IN p_fk_idpersona INT,
  IN p_correo VARCHAR(70),
  IN p_estado seguridad.estado_usuario,
  IN p_fk_idrol INT
)
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE seguridad.usuario
  SET correo = p_correo,
      estado_usuario = p_estado,
      fk_idrol = p_fk_idrol
  WHERE pfk_idpersona = p_fk_idpersona;
END$$;

-- PROCEDIMIENTO: cambiar contraseña de usuario
CREATE OR REPLACE PROCEDURE seguridad.pr_cambiar_contrasena(
  IN p_fk_idpersona INT,
  IN p_contrasena VARCHAR(50)
)
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE seguridad.usuario
  SET contrasena = p_contrasena
  WHERE pfk_idpersona = p_fk_idpersona;
END$$;

-- SINÓNIMOS (vistas 1:1 en esquema agropets)
CREATE OR REPLACE VIEW agropets.personas         AS SELECT * FROM personas.persona;
CREATE OR REPLACE VIEW agropets.clientes         AS SELECT * FROM personas.cliente;
CREATE OR REPLACE VIEW agropets.veterinarios     AS SELECT * FROM personas.veterinario;
CREATE OR REPLACE VIEW agropets.recepcionistas   AS SELECT * FROM personas.recepcionista;

CREATE OR REPLACE VIEW agropets.mascotas         AS SELECT * FROM clinica.mascota;
CREATE OR REPLACE VIEW agropets.consultas        AS SELECT * FROM clinica.consulta;
CREATE OR REPLACE VIEW agropets.procesos         AS SELECT * FROM clinica.proceso_veterinario;
CREATE OR REPLACE VIEW agropets.tratamientos     AS SELECT * FROM clinica.tratamiento;

CREATE OR REPLACE VIEW agropets.medicamentos     AS SELECT * FROM inventario.medicamento;
CREATE OR REPLACE VIEW agropets.dosis            AS SELECT * FROM inventario.dosis_aplicada;

CREATE OR REPLACE VIEW agropets.facturas         AS SELECT * FROM facturacion.factura;

CREATE OR REPLACE VIEW agropets.roles            AS SELECT * FROM seguridad.rol;
CREATE OR REPLACE VIEW agropets.usuarios         AS SELECT * FROM seguridad.usuario;

-- DATOS CALCULADOS
-- Calcular monto total a pagar de la factura
CREATE OR REPLACE VIEW agropets.vw_facturas_calculadas AS
SELECT
  f.PK_id_factura,
  f.FK_id_proceso,
  f.fecha,
  f.subtotal,
  COALESCE(f.descuento,0)                          AS descuento,
  (f.subtotal - COALESCE(f.descuento,0))::NUMERIC(10,2) AS monto_total_calc
FROM facturacion.factura f;


-- AUDITORÍA
CREATE SCHEMA auditoria;

CREATE OR REPLACE FUNCTION auditoria.log_auditoria()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    EXECUTE format(
      'INSERT INTO auditoria.%I (operacion, usuario, fecha, txid, datos_anteriores, datos_nuevos)
       VALUES ($1, $2, statement_timestamp(), txid_current(), to_jsonb($3), NULL)',
      TG_TABLE_NAME
    )
    USING TG_OP, current_user, OLD;
    RETURN OLD;

  ELSIF TG_OP = 'INSERT' THEN
    EXECUTE format(
      'INSERT INTO auditoria.%I (operacion, usuario, fecha, txid, datos_anteriores, datos_nuevos)
       VALUES ($1, $2, statement_timestamp(), txid_current(), NULL, to_jsonb($3))',
      TG_TABLE_NAME
    )
    USING TG_OP, current_user, NEW;
    RETURN NEW;

  ELSE
    EXECUTE format(
      'INSERT INTO auditoria.%I (operacion, usuario, fecha, txid, datos_anteriores, datos_nuevos)
       VALUES ($1, $2, statement_timestamp(), txid_current(), to_jsonb($3), to_jsonb($4))',
      TG_TABLE_NAME
    )
    USING TG_OP, current_user, OLD, NEW;
    RETURN NEW;
  END IF;
END;
$$;

-- Tablas de auditoría 
CREATE TABLE auditoria.persona (
  id BIGSERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario   TEXT NOT NULL,
  fecha     TIMESTAMPTZ NOT NULL DEFAULT statement_timestamp(),
  txid      BIGINT NOT NULL DEFAULT txid_current(),
  datos_anteriores JSONB,
  datos_nuevos     JSONB
);

CREATE TABLE auditoria.cliente (
  id BIGSERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario   TEXT NOT NULL,
  fecha     TIMESTAMPTZ NOT NULL DEFAULT statement_timestamp(),
  txid      BIGINT NOT NULL DEFAULT txid_current(),
  datos_anteriores JSONB,
  datos_nuevos     JSONB
);

CREATE TABLE auditoria.veterinario (
  id BIGSERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario   TEXT NOT NULL,
  fecha     TIMESTAMPTZ NOT NULL DEFAULT statement_timestamp(),
  txid      BIGINT NOT NULL DEFAULT txid_current(),
  datos_anteriores JSONB,
  datos_nuevos     JSONB
);

CREATE TABLE auditoria.recepcionista (
  id BIGSERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario   TEXT NOT NULL,
  fecha     TIMESTAMPTZ NOT NULL DEFAULT statement_timestamp(),
  txid      BIGINT NOT NULL DEFAULT txid_current(),
  datos_anteriores JSONB,
  datos_nuevos     JSONB
);

CREATE TABLE auditoria.rol (
  id BIGSERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario   TEXT NOT NULL,
  fecha     TIMESTAMPTZ NOT NULL DEFAULT statement_timestamp(),
  txid      BIGINT NOT NULL DEFAULT txid_current(),
  datos_anteriores JSONB,
  datos_nuevos     JSONB
);

CREATE TABLE auditoria.usuario (
  id BIGSERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario   TEXT NOT NULL,
  fecha     TIMESTAMPTZ NOT NULL DEFAULT statement_timestamp(),
  txid      BIGINT NOT NULL DEFAULT txid_current(),
  datos_anteriores JSONB,
  datos_nuevos     JSONB
);

CREATE TABLE auditoria.mascota (
  id BIGSERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario   TEXT NOT NULL,
  fecha     TIMESTAMPTZ NOT NULL DEFAULT statement_timestamp(),
  txid      BIGINT NOT NULL DEFAULT txid_current(),
  datos_anteriores JSONB,
  datos_nuevos     JSONB
);

CREATE TABLE auditoria.consulta (
  id BIGSERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario   TEXT NOT NULL,
  fecha     TIMESTAMPTZ NOT NULL DEFAULT statement_timestamp(),
  txid      BIGINT NOT NULL DEFAULT txid_current(),
  datos_anteriores JSONB,
  datos_nuevos     JSONB
);

CREATE TABLE auditoria.proceso_veterinario (
  id BIGSERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario   TEXT NOT NULL,
  fecha     TIMESTAMPTZ NOT NULL DEFAULT statement_timestamp(),
  txid      BIGINT NOT NULL DEFAULT txid_current(),
  datos_anteriores JSONB,
  datos_nuevos     JSONB
);

CREATE TABLE auditoria.tratamiento (
  id BIGSERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario   TEXT NOT NULL,
  fecha     TIMESTAMPTZ NOT NULL DEFAULT statement_timestamp(),
  txid      BIGINT NOT NULL DEFAULT txid_current(),
  datos_anteriores JSONB,
  datos_nuevos     JSONB
);

CREATE TABLE auditoria.medicamento (
  id BIGSERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario   TEXT NOT NULL,
  fecha     TIMESTAMPTZ NOT NULL DEFAULT statement_timestamp(),
  txid      BIGINT NOT NULL DEFAULT txid_current(),
  datos_anteriores JSONB,
  datos_nuevos     JSONB
);

CREATE TABLE auditoria.dosis_aplicada (
  id BIGSERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario   TEXT NOT NULL,
  fecha     TIMESTAMPTZ NOT NULL DEFAULT statement_timestamp(),
  txid      BIGINT NOT NULL DEFAULT txid_current(),
  datos_anteriores JSONB,
  datos_nuevos     JSONB
);

CREATE TABLE auditoria.factura (
  id BIGSERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  usuario   TEXT NOT NULL,
  fecha     TIMESTAMPTZ NOT NULL DEFAULT statement_timestamp(),
  txid      BIGINT NOT NULL DEFAULT txid_current(),
  datos_anteriores JSONB,
  datos_nuevos     JSONB
);

-- Triggers de auditoría
CREATE TRIGGER tr_audit_persona
AFTER INSERT OR UPDATE OR DELETE ON personas.persona
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria();

CREATE TRIGGER tr_audit_cliente
AFTER INSERT OR UPDATE OR DELETE ON personas.cliente
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria();

CREATE TRIGGER tr_audit_veterinario
AFTER INSERT OR UPDATE OR DELETE ON personas.veterinario
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria();

CREATE TRIGGER tr_audit_recepcionista
AFTER INSERT OR UPDATE OR DELETE ON personas.recepcionista
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria();

CREATE TRIGGER tr_audit_rol
AFTER INSERT OR UPDATE OR DELETE ON seguridad.rol
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria();

CREATE TRIGGER tr_audit_usuario
AFTER INSERT OR UPDATE OR DELETE ON seguridad.usuario
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria();

CREATE TRIGGER tr_audit_mascota
AFTER INSERT OR UPDATE OR DELETE ON clinica.mascota
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria();

CREATE TRIGGER tr_audit_consulta
AFTER INSERT OR UPDATE OR DELETE ON clinica.consulta
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria();

CREATE TRIGGER tr_audit_proceso
AFTER INSERT OR UPDATE OR DELETE ON clinica.proceso_veterinario
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria();

CREATE TRIGGER tr_audit_tratamiento
AFTER INSERT OR UPDATE OR DELETE ON clinica.tratamiento
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria();

CREATE TRIGGER tr_audit_medicamento
AFTER INSERT OR UPDATE OR DELETE ON inventario.medicamento
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria();

CREATE TRIGGER tr_audit_dosis
AFTER INSERT OR UPDATE OR DELETE ON inventario.dosis_aplicada
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria();

CREATE TRIGGER tr_audit_factura
AFTER INSERT OR UPDATE OR DELETE ON facturacion.factura
FOR EACH ROW EXECUTE FUNCTION auditoria.log_auditoria();


-- Roles de aplicación (sin LOGIN)
CREATE ROLE r_admin;
CREATE ROLE r_veterinario;
CREATE ROLE r_recepcionista;
CREATE ROLE r_cliente;
CREATE ROLE r_visor;

-- Cerrar PUBLIC
REVOKE ALL ON SCHEMA agropets, personas, clinica, inventario, facturacion, seguridad, auditoria FROM PUBLIC;

-- Acceso a schemas
GRANT USAGE ON SCHEMA agropets, personas, clinica, inventario, facturacion, seguridad TO r_admin, r_veterinario, r_recepcionista, r_visor;
GRANT USAGE ON SCHEMA auditoria TO r_admin;

-- Admin full
GRANT ALL PRIVILEGES ON ALL TABLES    IN SCHEMA personas,clinica,inventario,facturacion,seguridad,auditoria TO r_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA personas,clinica,inventario,facturacion,seguridad,auditoria TO r_admin;
GRANT ALL PRIVILEGES ON ALL ROUTINES  IN SCHEMA personas,clinica,inventario,facturacion,seguridad TO r_admin;

-- Veterinario (lectura + gestiona tratamientos y diagnósticos)
GRANT SELECT ON personas.persona, personas.cliente TO r_veterinario;
GRANT SELECT ON clinica.mascota, clinica.proceso_veterinario TO r_veterinario;
GRANT SELECT ON inventario.medicamento, inventario.dosis_aplicada TO r_veterinario;
GRANT SELECT ON facturacion.factura TO r_veterinario;

GRANT INSERT, SELECT, UPDATE ON clinica.tratamiento TO r_veterinario;
GRANT UPDATE (diagnostico) ON clinica.consulta TO r_veterinario;

-- Recepcionista (registra clientes, mascotas, consultas y facturas)
GRANT SELECT ON personas.persona, personas.cliente, clinica.mascota, clinica.consulta, facturacion.factura TO r_recepcionista;
GRANT INSERT ON personas.persona, personas.cliente, clinica.mascota, clinica.consulta, facturacion.factura TO r_recepcionista;
GRANT UPDATE (nombre_completo, telefono) ON personas.persona TO r_recepcionista;
GRANT UPDATE (direccion, correo)         ON personas.cliente TO r_recepcionista;
-- Actualizaciones que suele hacer sobre la factura:
GRANT UPDATE (metodo_pago, estado, descuento) ON facturacion.factura TO r_recepcionista;

-- Secuencias/identidades para inserts
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA personas,clinica,inventario,facturacion TO r_veterinario, r_recepcionista;

-- API para clientes (solo lectura de lo propio)
CREATE SCHEMA api;

CREATE OR REPLACE FUNCTION api.fn_mis_mascotas(p_id_cliente INT)
RETURNS SETOF clinica.mascota
LANGUAGE sql
AS $$
  SELECT * FROM clinica.mascota WHERE FK_id_cliente = p_id_cliente;
$$;

CREATE OR REPLACE FUNCTION api.fn_mis_consultas(p_id_cliente INT)
RETURNS TABLE (
  PK_id_consulta INT,
  FK_id_mascota INT,
  FK_id_veterinario INT,
  FK_id_recepcionista INT,
  motivo VARCHAR,
  fecha DATE,
  hora TIME,
  costo NUMERIC(10,2),
  diagnostico VARCHAR
)
LANGUAGE sql
AS $$
  SELECT c.PK_id_consulta, c.FK_id_mascota, c.FK_id_veterinario, c.FK_id_recepcionista,
         c.motivo, c.fecha, c.hora, c.costo, c.diagnostico
  FROM clinica.consulta c
  JOIN clinica.mascota m ON m.PK_id_mascota = c.FK_id_mascota
  WHERE m.FK_id_cliente = p_id_cliente;
$$;

CREATE OR REPLACE FUNCTION api.fn_mis_facturas(p_id_cliente INT)
RETURNS TABLE (
  PK_id_factura INT,
  FK_id_proceso INT,
  fecha DATE,
  subtotal NUMERIC(10,2),
  descuento NUMERIC(10,2),
  monto_total NUMERIC(10,2),
  estado facturacion.estado_factura_enum
)
LANGUAGE sql
AS $$
  SELECT f.PK_id_factura, f.FK_id_proceso, f.fecha, f.subtotal, f.descuento, f.monto_total, f.estado
  FROM facturacion.factura f
  JOIN clinica.proceso_veterinario p ON p.PK_id_proceso = f.FK_id_proceso
  JOIN clinica.consulta c ON c.PK_id_consulta = p.FK_id_consulta
  JOIN clinica.mascota m ON m.PK_id_mascota = c.FK_id_mascota
  WHERE m.FK_id_cliente = p_id_cliente;
$$;

GRANT USAGE ON SCHEMA api TO r_cliente;
GRANT EXECUTE ON FUNCTION api.fn_mis_mascotas(INT)  TO r_cliente;
GRANT EXECUTE ON FUNCTION api.fn_mis_consultas(INT) TO r_cliente;
GRANT EXECUTE ON FUNCTION api.fn_mis_facturas(INT)  TO r_cliente;

-- Vistas públicas de solo lectura (rol visor)
GRANT SELECT ON agropets.personas, agropets.clientes, agropets.veterinarios, agropets.recepcionistas,
               agropets.mascotas, agropets.consultas, agropets.procesos, agropets.tratamientos,
               agropets.medicamentos, agropets.dosis, agropets.facturas,
               agropets.roles, agropets.usuarios
TO r_visor;