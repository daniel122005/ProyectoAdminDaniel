import { pool } from "../db.js";

export async function registrarMascota(req, res, next) {
  try {
    const { fk_cliente, nombre, especie, raza, sexo, fecha_nacimiento, peso } = req.body;
    const sql = `
      DO $$
      DECLARE o_id INT;
      BEGIN
        CALL clinica.pr_registrar_mascota($1,$2,$3,$4,$5,$6,$7, o_id);
        RAISE NOTICE 'id_mascota=%', o_id;
      END$$;`;
    await pool.query(sql, [
      Number(fk_cliente), nombre, especie, raza || null, sexo, fecha_nacimiento, peso ?? null,
    ]);
    res.status(201).json({ ok: true });
  } catch (e) { next(e); }
}
