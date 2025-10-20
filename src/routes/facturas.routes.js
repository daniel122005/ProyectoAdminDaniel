import { Router } from "express";
import { listFacturas, facturarProceso, cambiarEstadoFactura } from "../controllers/facturas.controller.js";

const router = Router();

router.get("/facturas", listFacturas);
router.post("/facturas", facturarProceso);
router.patch("/facturas/:id_factura/estado", cambiarEstadoFactura);

export default router;
