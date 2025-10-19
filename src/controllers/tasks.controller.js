const pool = require('../db');

const getAllTasks = async (req, res, next) => {
    try {
        throw new Error("Algo fue mal");
        const allTasks = await pool.query('SELECT * FROM tasks');
        res.json(allTasks.rows);
    } catch (error) {
        next(error);
    }
};

const getTask = async (req, res, next) => {
    try {
        const { id } = req.params
        const result = await pool.query('SELECT * FROM tasks WHERE id = $1', [id])
        if (result.rows.length === 0) return res.status(404).json({ message: "Task not found" });

        res.json(result.rows[0]);
    } catch (error) {
        next(error);
    }
};

const createTask = async (req, res, next) => {
    const { tittle, description } = req.body;
    try {
        const result = await pool.query("INSERT INTO tasks (title, description) VALUES ($1, $2) RETURNING *", [tittle, description]);
        console.log(result);

        res.json(result.rows[0]);
    } catch (error) {
        next(error);
    }
};

const deleteTask = async (req, res, next) => {
    try {
        const { id } = req.params;
        const result = await pool.query('DELETE FROM tasks WHERE id = $1', [id]);
        if (result.rowCount === 0) return res.status(404).json({ message: "Task not found" });
    } catch (error) {
        next(error);
    }


};

const updateTask = async (req, res, next) => {

    try {
        const { id } = req.params;
        const { title, description } = req.body;
        const result = await pool.query('UPDATE tasks SET title = $1, description = $2 WHERE id = $3', [title, description, id]);
        if (result.rowCount === 0) return res.status(404).json({ message: "Task not found" });
    } catch (error) {
        next(error);
    }
};

module.exports = {
    getAllTasks,
    getTask,
    createTask,
    deleteTask,
    updateTask
};
