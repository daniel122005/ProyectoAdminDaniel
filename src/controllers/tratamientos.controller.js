import { pool } from "../db.js";

export async function agregarTratamiento(req, res, next) {
  try {
    const { fk_proceso, fk_veterinario, nombre, tipo, precio } = req.body;
    const sql = `
      DO $$
      DECLARE o_id INT;
      BEGIN
        CALL clinica.pr_agregar_tratamiento($1,$2,$3,$4,$5, o_id);
        RAISE NOTICE 'id_tratamiento=%', o_id;
      END$$;`;
    await pool.query(sql, [
      Number(fk_proceso), Number(fk_veterinario), nombre, tipo || null, Number(precio),
    ]);
    res.status(201).json({ ok: true });
  } catch (e) { next(e); }
}
