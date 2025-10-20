import { query } from "../db.js";

export async function listPersonas(_req, res, next) {
  try {
    const rows = await query({
      text: "SELECT * FROM agropets.personas ORDER BY pk_id_persona",
    });
    res.json(rows);
  } catch (e) { next(e); }
}
