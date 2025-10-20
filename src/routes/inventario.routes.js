import { Router } from 'express';
import * as ctrl from '../controllers/inventario.controller.js';
const router = Router();

router.get('/medicamentos', ctrl.listarMedicamentos);      // vista
router.post('/dosis', ctrl.aplicarDosis);                  // CALL inventario.pr_aplicar_dosis
router.put('/dosis/:id', ctrl.actualizarDosis);            // CALL inventario.pr_actualizar_dosis
router.delete('/dosis/:id', ctrl.eliminarDosis);           // CALL inventario.pr_eliminar_dosis

export default router;
