import { pool } from '../db.js';

export const listarRoles = async (_req, res, next) => {
  try {
    const { rows } = await pool.query('SELECT * FROM agropets.roles ORDER BY "PK_id_rol"');
    res.json(rows);
  } catch (e) { next(e); }
};

export const listarUsuarios = async (_req, res, next) => {
  try {
    const { rows } = await pool.query('SELECT * FROM agropets.usuarios ORDER BY pfk_idpersona');
    res.json(rows);
  } catch (e) { next(e); }
};

export const crearUsuario = async (req, res, next) => {
  const { fk_idpersona, correo, contrasena, estado_usuario, fk_idrol } = req.body;
  try {
    await pool.query(
      'CALL seguridad.pr_crear_usuario($1,$2,$3,$4,$5)',
      [fk_idpersona, correo, contrasena, estado_usuario, fk_idrol]
    );
    res.status(201).json({ message: 'Usuario creado' });
  } catch (e) { next(e); }
};

export const actualizarUsuario = async (req, res, next) => {
  const { persona } = req.params;
  const { correo, estado_usuario, fk_idrol } = req.body;
  try {
    await pool.query(
      'CALL seguridad.pr_actualizar_usuario($1,$2,$3,$4)',
      [persona, correo, estado_usuario, fk_idrol]
    );
    res.json({ message: 'Usuario actualizado' });
  } catch (e) { next(e); }
};
