import { Router } from "express";
import { registrarMascota } from "../controllers/mascotas.controller.js";

const router = Router();
router.post("/mascotas", registrarMascota);

export default router;
