import { Router } from "express";
import { iniciarProceso } from "../controllers/procesos.controller.js";

const router = Router();
router.post("/procesos", iniciarProceso);

export default router;
