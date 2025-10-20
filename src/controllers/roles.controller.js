import { query } from "../../db.js";

export async function listRoles(_req, res, next) {
  try {
    const rows = await query({
      text: "SELECT * FROM agropets.roles ORDER BY pk_id_rol",
    });
    res.json(rows);
  } catch (e) { next(e); }
}
