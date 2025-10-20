import { pool } from '../db.js';

// GET /api/inventario/medicamentos
export const listarMedicamentos = async (_req, res, next) => {
  try {
    const { rows } = await pool.query('SELECT * FROM agropets.medicamentos ORDER BY "PK_id_medicamento"');
    res.json(rows);
  } catch (e) { next(e); }
};

// POST /api/inventario/dosis
export const aplicarDosis = async (req, res, next) => {
  const { fk_tratamiento, fk_medicamento, dosis_aplicada, precio_dosis } = req.body;
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    await client.query(
      'CALL inventario.pr_aplicar_dosis($1,$2,$3,$4)',
      [fk_tratamiento, fk_medicamento, dosis_aplicada, precio_dosis]
    );
    const { rows } = await client.query(`SELECT currval('inventario.seq_dosis') AS id_dosis;`);
    await client.query('COMMIT');
    res.status(201).json({ message: 'Dosis aplicada', ...rows[0] });
  } catch (e) { await client.query('ROLLBACK'); next(e); }
  finally { client.release(); }
};

// PUT /api/inventario/dosis/:id
export const actualizarDosis = async (req, res, next) => {
  const { id } = req.params;
  const { fk_medicamento, dosis_aplicada, precio_dosis } = req.body;
  try {
    await pool.query(
      'CALL inventario.pr_actualizar_dosis($1,$2,$3,$4)',
      [id, fk_medicamento, dosis_aplicada, precio_dosis]
    );
    res.json({ message: 'Dosis actualizada' });
  } catch (e) { next(e); }
};

// DELETE /api/inventario/dosis/:id
export const eliminarDosis = async (req, res, next) => {
  const { id } = req.params;
  try {
    await pool.query('CALL inventario.pr_eliminar_dosis($1)', [id]);
    res.json({ message: 'Dosis eliminada' });
  } catch (e) { next(e); }
};
