import { Router } from "express";
import {
  listClientes, crearCliente,
  listMisMascotas, listMisConsultas, listMisFacturas,
} from "../controllers/clientes.controller.js";

const router = Router();

router.get("/clientes", listClientes);
router.post("/clientes", crearCliente);

router.get("/clientes/:idCliente/mascotas", listMisMascotas);
router.get("/clientes/:idCliente/consultas", listMisConsultas);
router.get("/clientes/:idCliente/facturas", listMisFacturas);

export default router;
