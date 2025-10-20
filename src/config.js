import 'dotenv/config';

export const config = {
  port: process.env.PORT || 4000,
  db: {
    host: process.env.PGHOST,
    port: Number(process.env.PGPORT || 5432),
    database: process.env.PGDATABASE,
    user: process.env.PGUSER,
    password: process.env.PGPASSWORD,
    ssl: false,
  },
};