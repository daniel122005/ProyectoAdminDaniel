import express from "express";
import cors from "cors";
import morgan from "morgan";
import "dotenv/config";
import personasRoutes from "./routes/personas.routes.js";
import clientesRoutes from "./routes/clientes.routes.js";
import mascotasRoutes from "./routes/mascotas.routes.js";
import consultasRoutes from "./routes/consultas.routes.js";
import procesosRoutes from "./routes/procesos.routes.js";
import tratamientosRoutes from "./routes/tratamientos.routes.js";
import dosisRoutes from "./routes/dosis.routes.js";
import facturasRoutes from "./routes/facturas.routes.js";
import medicamentosRoutes from "./routes/medicamentos.routes.js";
import segRolesRoutes from "./routes/seguridad.roles.routes.js";
import segUsuariosRoutes from "./routes/seguridad.usuarios.routes.js";

// …
app.use("/api", personasRoutes);
app.use("/api", clientesRoutes);
app.use("/api", mascotasRoutes);
app.use("/api", consultasRoutes);
app.use("/api", procesosRoutes);
app.use("/api", tratamientosRoutes);
app.use("/api", dosisRoutes);
app.use("/api", facturasRoutes);
app.use("/api", medicamentosRoutes);
app.use("/api", segRolesRoutes);
app.use("/api", segUsuariosRoutes);


import agropetsRoutes from "./routes/agropets.routes.js";
import seguridadRoutes from "./routes/seguridad.routes.js";

const app = express();

// Middlewares
app.use(cors());
app.use(express.json());
app.use(morgan("dev"));

// Health
app.get("/api/health", (_req, res) => res.json({ ok: true }));

// Rutas
app.use("/api", agropetsRoutes);
app.use("/api/seguridad", seguridadRoutes);

// Manejador de errores central
app.use((err, _req, res, _next) => {
  console.error(err);
  const msg =
    err?.detail ||
    err?.message ||
    "Error interno. Revisa consola/servidor para más detalles.";
  res.status(500).json({ error: msg });
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`Server on port ${PORT}`));


