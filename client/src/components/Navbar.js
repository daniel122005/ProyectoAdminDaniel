import { AppBar, Box, Container, Typography } from '@mui/material'
import { Link, useNavigate } from 'react-router-dom'

export default function Navbar() {
    const navigate = useNavigate();
    return (
        <Box>
            <AppBar position="static" color="transparent">
                <Container>
                    <Typography variant='h6' sx={{ flexGrow: 1 }}>
                        <Link to="/" style={{ textDecoration: 'none', color: 'inherit' }}>PERN STACK</Link>
                    </Typography>
                    <button variant="contained" color="primary" onClick={() => navigate('/tasks/new')}>
                        New Task
                    </button>
                </Container>
            </AppBar>
        </Box>
    )
}
