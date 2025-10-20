import { callProc, query } from "../../db.js";

export async function listUsuarios(_req, res, next) {
  try {
    const rows = await query({
      text: "SELECT * FROM agropets.usuarios ORDER BY pfk_idpersona",
    });
    res.json(rows);
  } catch (e) { next(e); }
}

export async function crearUsuario(req, res, next) {
  try {
    const { fk_idpersona, correo, contrasena, estado, fk_idrol } = req.body;
    await callProc({
      schema: "seguridad",
      name: "pr_crear_usuario",
      args: [Number(fk_idpersona), correo, contrasena, estado, Number(fk_idrol)],
    });
    res.status(201).json({ ok: true });
  } catch (e) { next(e); }
}

export async function actualizarUsuario(req, res, next) {
  try {
    const { fk_idpersona } = req.params;
    const { correo, estado, fk_idrol } = req.body;
    await callProc({
      schema: "seguridad",
      name: "pr_actualizar_usuario",
      args: [Number(fk_idpersona), correo, estado, Number(fk_idrol)],
    });
    res.json({ ok: true });
  } catch (e) { next(e); }
}

export async function cambiarContrasena(req, res, next) {
  try {
    const { fk_idpersona } = req.params;
    const { contrasena } = req.body;
    await callProc({
      schema: "seguridad",
      name: "pr_cambiar_contrasena",
      args: [Number(fk_idpersona), contrasena],
    });
    res.json({ ok: true });
  } catch (e) { next(e); }
}
