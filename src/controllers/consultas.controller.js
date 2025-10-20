import { pool } from "../db.js";

export async function registrarConsulta(req, res, next) {
  try {
    const {
      fk_mascota, fk_veterinario, fk_recepcionista,
      motivo, fecha, hora, costo, diagnostico
    } = req.body;

    const sql = `
      DO $$
      DECLARE o_id INT;
      BEGIN
        CALL clinica.pr_registrar_consulta($1,$2,$3,$4,$5,$6,$7,$8, o_id);
        RAISE NOTICE 'id_consulta=%', o_id;
      END$$;`;

    await pool.query(sql, [
      Number(fk_mascota), Number(fk_veterinario), Number(fk_recepcionista),
      motivo, fecha, hora, Number(costo), diagnostico || null,
    ]);

    res.status(201).json({ ok: true });
  } catch (e) { next(e); }
}
