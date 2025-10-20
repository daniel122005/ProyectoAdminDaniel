import { Router } from "express";
import { listMedicamentos } from "../controllers/medicamentos.controller.js";

const router = Router();
router.get("/medicamentos", listMedicamentos);

export default router;
