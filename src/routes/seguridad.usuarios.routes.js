import { Router } from "express";
import {
  listUsuarios, crearUsuario, actualizarUsuario, cambiarContrasena
} from "../controllers/seguridad/usuarios.controller.js";

const router = Router();

router.get("/seguridad/usuarios", listUsuarios);
router.post("/seguridad/usuarios", crearUsuario);
router.put("/seguridad/usuarios/:fk_idpersona", actualizarUsuario);
router.patch("/seguridad/usuarios/:fk_idpersona/password", cambiarContrasena);

export default router;
