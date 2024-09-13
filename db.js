const { Pool } = require('pg');
require('dotenv').config();

// Crea una instancia del Pool de conexiones a la base de datos
const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT,
});

// Función para realizar consultas a la base de datos
const query = async (text, params) => {
  const client = await pool.connect();
  try {
    const res = await client.query(text, params);
    return res;
  } catch (err) {
    console.error('Database query error', err);
    throw err;
  } finally {
    client.release();
  }
};

module.exports = {
  query,
};
