import { pool, query } from "../db.js";

// Vistas/Funciones (lecturas)
export async function listClientes(_req, res, next) {
  try {
    const rows = await query({
      text: "SELECT * FROM agropets.clientes ORDER BY pk_id_cliente",
    });
    res.json(rows);
  } catch (e) { next(e); }
}

export async function listMisMascotas(req, res, next) {
  try {
    const { idCliente } = req.params;
    const rows = await query({
      text: "SELECT * FROM api.fn_mis_mascotas($1)",
      params: [Number(idCliente)],
    });
    res.json(rows);
  } catch (e) { next(e); }
}

export async function listMisConsultas(req, res, next) {
  try {
    const { idCliente } = req.params;
    const rows = await query({
      text: "SELECT * FROM api.fn_mis_consultas($1)",
      params: [Number(idCliente)],
    });
    res.json(rows);
  } catch (e) { next(e); }
}

export async function listMisFacturas(req, res, next) {
  try {
    const { idCliente } = req.params;
    const rows = await query({
      text: "SELECT * FROM api.fn_mis_facturas($1)",
      params: [Number(idCliente)],
    });
    res.json(rows);
  } catch (e) { next(e); }
}

// Procedimiento (escritura)
export async function crearCliente(req, res, next) {
  try {
    const { nombre_completo, documento, telefono, direccion, correo } = req.body;
    const sql = `
      DO $$
      DECLARE o1 INT; o2 INT;
      BEGIN
        CALL personas.pr_crear_cliente($1,$2,$3,$4,$5, o1, o2);
        RAISE NOTICE 'id_persona=%, id_cliente=%', o1, o2;
      END$$;`;
    await pool.query(sql, [nombre_completo, documento, telefono, direccion, correo]);
    res.status(201).json({ ok: true });
  } catch (e) { next(e); }
}