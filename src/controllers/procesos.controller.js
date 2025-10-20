import { pool } from "../db.js";

export async function iniciarProceso(req, res, next) {
  try {
    const { fk_consulta, descripcion, fecha_inicio, fecha_fin } = req.body;
    const sql = `
      DO $$
      DECLARE o_id INT;
      BEGIN
        CALL clinica.pr_iniciar_proceso($1,$2,$3,$4, o_id);
        RAISE NOTICE 'id_proceso=%', o_id;
      END$$;`;
    await pool.query(sql, [
      Number(fk_consulta), descripcion, fecha_inicio, fecha_fin || null,
    ]);
    res.status(201).json({ ok: true });
  } catch (e) { next(e); }
}
