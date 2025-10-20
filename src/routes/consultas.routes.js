import { Router } from "express";
import { registrarConsulta } from "../controllers/consultas.controller.js";

const router = Router();
router.post("/consultas", registrarConsulta);

export default router;
