// app.js o el archivo de rutas correspondiente
const express = require('express');
const { query } = require('./db');  // Asegúrate de importar la conexión de la base de datos
const productRoutes = require('./product/src/routes')

const app = express();

// Endpoint de prueba para verificar la conexión con la base de datos
app.get('/test-db', async (req, res) => {
  try {
    // Realiza una consulta simple a la base de datos
    const result = await query('SELECT NOW()');
    
    // Si la consulta es exitosa, retorna la fecha y hora del servidor de la base de datos
    res.status(200).json({
      message: 'Conexión a la base de datos exitosa',
      time: result.rows[0]
    });
  } catch (error) {
    console.error('Error al conectar con la base de datos:', error);
    res.status(500).json({ message: 'Error al conectar con la base de datos', error });
  }
});

app.use('/products',productRoutes)

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
