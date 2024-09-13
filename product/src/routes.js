const express =  require('express')
const {getProducts,createProduct,updateProduct,deleteProduct,getProductById} = require('./productService')
const router = express.Router()

router.get('/',async(req,res) =>{
    try {
        const products = await getProducts();
        res.status(200).json(products);
    } catch (error) {
        res.status(500).json({message:error.message})
    }
})

router.get('/:id', async (req, res) => {
    try {
      const product = await getProductById(req.params.id); 
      if (!product) return res.status(404).json({ message: 'Product not found' });
      res.status(200).json(product);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  });
  
  


router.post('/',async(req,res)=>{
    try {
        const {name,description,price,stock,categoryId} = req.body
        const newProduct = await createProduct(name,description,price,stock,categoryId)
        res.status(201).json(newProduct);
    } catch (error) {
        res.status(500).json({message:error.message})
    }
})

router.put('/:id', async (req, res) => {
    try {
      const { name, description, price, stock, categoryId } = req.body;
      const updatedProduct = await updateProduct(req.params.id, name, description, price, stock, categoryId);
      if (!updatedProduct) return res.status(404).json({ message: 'Product not found' });
      res.status(200).json(updatedProduct);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
});

router.delete('/:id',async(req,res)=>{
    try {
        const deleted = await deleteProduct(req.params.id);
        if (!deleted) return res.status(404).json({message:'Product not found'})
        res.status(200).json(deleted)
    } catch (error) {
        res.status(500).json({message:error.message})
    }
})



module.exports = router;