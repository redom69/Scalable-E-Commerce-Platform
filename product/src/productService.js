const { query } = require('../../db');

// Función para obtener todos los productos
const getProducts = async () => {
  try {
    const result = await query('SELECT * FROM Products');
    return result.rows;
  } catch (error) {
    throw new Error('Error al obtener productos');
  }
};

// Función para crear un producto
const createProduct = async (name, description, price, stock, categoryId) => {
  try {
    const result = await query(
      'INSERT INTO Products (name, description, price, stock, categoryId) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [name, description, price, stock, categoryId]
    );
    return result.rows[0];
  } catch (error) {
    throw new Error('Error al crear el producto');
  }
};

// Función para actualizar un producto
const updateProduct = async (id, name, description, price, stock, categoryId) => {
  try {
    const result = await query(
      'UPDATE Products SET name = $1, description = $2, price = $3, stock = $4, categoryId = $5 WHERE productId = $6 RETURNING *',
      [name, description, price, stock, categoryId, id]
    );
    return result.rows[0];
  } catch (error) {
    throw new Error('Error al actualizar el producto');
  }
};

// Función para eliminar un producto
const deleteProduct = async (id) => {
  try {
    const result = await query('DELETE FROM Products WHERE productId = $1 RETURNING *', [id]);
    return result.rows[0];
  } catch (error) {
    throw new Error('Error al eliminar el producto');
  }
};

const getProductById = async (id)=>{
    try {
        const result = await query('SELECT * FROM Products WHERE productId =$1',[id])
        return result.rows[0];

    } catch (error) {
        throw new Error('Error al encontrar el producto')
    }
}

module.exports = {
  getProducts,
  createProduct,
  updateProduct,
  deleteProduct,
  getProductById
};
