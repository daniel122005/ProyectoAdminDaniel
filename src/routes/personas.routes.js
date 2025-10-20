import { Router } from "express";
import { listPersonas } from "../controllers/personas.controller.js";

const router = Router();
router.get("/personas", listPersonas);

export default router;
