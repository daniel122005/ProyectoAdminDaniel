import { callProc, pool } from "../db.js";

export async function aplicarDosis(req, res, next) {
  try {
    const { fk_tratamiento, fk_medicamento, dosis, precio_dosis } = req.body;
    const sql = `
      DO $$
      DECLARE o_id INT;
      BEGIN
        CALL inventario.pr_aplicar_dosis($1,$2,$3,$4, o_id);
        RAISE NOTICE 'id_dosis=%', o_id;
      END$$;`;
    await pool.query(sql, [
      Number(fk_tratamiento), Number(fk_medicamento), Number(dosis), Number(precio_dosis),
    ]);
    res.status(201).json({ ok: true });
  } catch (e) { next(e); }
}

export async function actualizarDosis(req, res, next) {
  try {
    const { id_dosis } = req.params;
    const { fk_medicamento, dosis, precio_dosis } = req.body;
    await callProc({
      schema: "inventario",
      name: "pr_actualizar_dosis",
      args: [Number(id_dosis), Number(fk_medicamento), Number(dosis), Number(precio_dosis)],
    });
    res.json({ ok: true });
  } catch (e) { next(e); }
}

export async function eliminarDosis(req, res, next) {
  try {
    const { id_dosis } = req.params;
    await callProc({
      schema: "inventario",
      name: "pr_eliminar_dosis",
      args: [Number(id_dosis)],
    });
    res.json({ ok: true });
  } catch (e) { next(e); }
}
