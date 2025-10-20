import { Pool } from "pg";
import "dotenv/config";

export const pool = new Pool({
  host: process.env.PGHOST,
  port: Number(process.env.PGPORT || 5432),
  database: process.env.PGDATABASE,
  user: process.env.PGUSER,
  password: process.env.PGPASSWORD,
  allowExitOnIdle: true,
});

/** Utilidad: ejecutar procedimiento con parámetros seguros */
export async function callProc({ name, schema = "public", args = [] }) {
  const placeholders = args.map((_, i) => `$${i + 1}`).join(", ");
  const sql = `CALL ${schema}.${name}(${placeholders})`;
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    await client.query(sql, args);
    await client.query("COMMIT");
    return { ok: true };
  } catch (e) {
    await client.query("ROLLBACK");
    throw e;
  } finally {
    client.release();
  }
}

/** Utilidad: llamar funciones/SELECT con parámetros */
export async function query({ text, params = [] }) {
  const { rows } = await pool.query(text, params);
  return rows;
}

/** Utilidad: llamar función que retorna valor escalar */
export async function callFuncScalar({ name, schema = "public", args = [] }) {
  const placeholders = args.map((_, i) => `$${i + 1}`).join(", ");
  const sql = `SELECT ${schema}.${name}(${placeholders}) AS value`;
  const { rows } = await pool.query(sql, args);
  return rows?.[0]?.value;
}
