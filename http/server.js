const express = require('express')
const app = express()

app.get("/hello", (req, res) => {
    res.send("Olá!!!")
})

app.listen(3000, () => {
    console.log('Estou ouvindo na porta 3000.')
})