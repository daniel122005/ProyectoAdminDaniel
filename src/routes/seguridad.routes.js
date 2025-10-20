import { Router } from 'express';
import * as ctrl from '../controllers/seguridad.controller.js';
const router = Router();

router.get('/roles', ctrl.listarRoles);               // vista
router.get('/usuarios', ctrl.listarUsuarios);         // vista
router.post('/usuarios', ctrl.crearUsuario);          // CALL seguridad.pr_crear_usuario
router.put('/usuarios/:persona', ctrl.actualizarUsuario); // CALL seguridad.pr_actualizar_usuario

export default router;
