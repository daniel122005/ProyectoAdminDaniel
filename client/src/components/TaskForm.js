
import { Card, CardContent, Grid, Typography, TextField, Button, CircularProgress } from '@mui/material'
import { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';

export default function TaskForm() {
    const [task, setTask] = useState({
        title: '',
        description: '',
    });

    const [loading, setLoading] = useState(false);
    const [editing, setEditing] = useState(false);

    const navigate = useNavigate();
    const params = useParams();

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);

        if (editing) {
            await fetch('http://localhost:4000/tasks', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(task),
            });


        } else {
            await fetch('http://localhost:4000/tasks', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(task),
            });

        }

        setLoading(false);

        navigate('/')
    };

    const handleChange = (e) =>
        setTask({ ...task, [e.target.name]: e.target.value });


    const loadTask = async (id) => {
        const res = await fetch(`http://localhost:4000/tasks/${id}`);
        const data = await res.json();
        setTask({ title: data.title, description: data.description });
        setEditing(true);
    };

    useEffect(() => {
        if (params.id) {
            loadTask(params.id);
        }
    }, [params.id]);

    return (
        <Grid container direction="column" alignItems="center" justifyContent="center">
            <Grid item xs={12} sm={8} md={6}>
                <Card sx={{ mt: 5 }} style={{ backgroundColor: '#1e272e', padding: '1rem' }}>
                    <Typography variant='h5' textAlign="center" color='white'>
                        Create Task
                    </Typography>
                    <CardContent>
                        <form onSubmit={handleSubmit}>
                            <TextField
                                variant='filled'
                                label='write your title'
                                sx={{ display: 'block', margin: '.5rem 0' }}
                                name='title'
                                value={task.title}
                                onChange={handleChange}
                                inputProps={{ style: { color: 'white' } }}
                                InputLabelProps={{ style: { color: 'white' } }}
                                fullWidth
                            />
                            <TextField
                                variant='filled'
                                label='write your description'
                                multiline
                                rows={4}
                                sx={{ display: 'block', margin: '.5rem 0' }}
                                name='description'
                                value={task.description}
                                onChange={handleChange}
                                inputProps={{ style: { color: 'white' } }}
                                InputLabelProps={{ style: { color: 'white' } }}
                                fullWidth
                            />
                            <Button variant='contained' color='primary' type='submit' disabled={!task.title || !task.description}>
                                {loading ? <CircularProgress size={24} color='inherit' /> : 'Save'}
                            </Button>
                        </form>
                    </CardContent>
                </Card>
            </Grid>
        </Grid>
    )
}
