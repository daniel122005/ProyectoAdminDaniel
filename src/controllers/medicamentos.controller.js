import { query } from "../db.js";

export async function listMedicamentos(_req, res, next) {
  try {
    const rows = await query({
      text: "SELECT * FROM agropets.medicamentos ORDER BY pk_id_medicamento",
    });
    res.json(rows);
  } catch (e) { next(e); }
}
