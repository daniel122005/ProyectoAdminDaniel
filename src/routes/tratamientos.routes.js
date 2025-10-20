import { Router } from "express";
import { agregarTratamiento } from "../controllers/tratamientos.controller.js";

const router = Router();
router.post("/tratamientos", agregarTratamiento);

export default router;
