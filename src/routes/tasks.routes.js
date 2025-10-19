const {Router} = require('express');
const { getAllTasks, updateTask,createTask,deleteTask,getTask } = require('../controllers/tasks.controller');

const router = Router();

router.get('/tasks', getAllTasks);

router.get('/tasks/:id', getTask);

router.post('/tasks', createTask);

router.delete('/tasks/:id', deleteTask);

router.put('/tasks/:id', updateTask);

module.exports = router;