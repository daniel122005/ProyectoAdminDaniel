import { Router } from "express";
import { listRoles } from "../controllers/seguridad/roles.controller.js";

const router = Router();
router.get("/seguridad/roles", listRoles);

export default router;
