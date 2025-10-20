import { pool, query, callProc } from "../db.js";

export async function listFacturas(_req, res, next) {
  try {
    const rows = await query({
      text: "SELECT * FROM agropets.vw_facturas_calculadas ORDER BY pk_id_factura DESC",
    });
    res.json(rows);
  } catch (e) { next(e); }
}

export async function facturarProceso(req, res, next) {
  try {
    const { fk_proceso, fecha, metodo_pago, descuento, estado } = req.body;
    const sql = `
      DO $$
      DECLARE o_id INT;
      BEGIN
        CALL facturacion.pr_facturar_proceso($1,$2,$3,$4,$5, o_id);
        RAISE NOTICE 'id_factura=%', o_id;
      END$$;`;
    await pool.query(sql, [
      Number(fk_proceso), fecha, metodo_pago, descuento ?? 0, estado,
    ]);
    res.status(201).json({ ok: true });
  } catch (e) { next(e); }
}

export async function cambiarEstadoFactura(req, res, next) {
  try {
    const { id_factura } = req.params;
    const { estado } = req.body;
    await callProc({
      schema: "facturacion",
      name: "pr_cambiar_estado_factura",
      args: [Number(id_factura), estado],
    });
    res.json({ ok: true });
  } catch (e) { next(e); }
}
