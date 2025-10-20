import { Router } from "express";
import { aplicarDosis, actualizarDosis, eliminarDosis } from "../controllers/dosis.controller.js";

const router = Router();

router.post("/dosis", aplicarDosis);
router.put("/dosis/:id_dosis", actualizarDosis);
router.delete("/dosis/:id_dosis", eliminarDosis);

export default router;
