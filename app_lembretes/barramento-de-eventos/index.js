const express = require("express");
const axios = require("axios");
const app = express();
app.use(express.json());

const eventos = [];

app.post("/eventos", (req, res) => {
  const evento = req.body;
  eventos.push(evento);
  //envia o evento para o microsserviço de lembretes
  axios.post("http://10.2.0.126:4000/eventos", evento).catch((err) => {
    console.log("Microsserviço de lembretes fora do ar.");
  });
  //envia o evento para o microsserviço de observações
  axios.post("http://10.2.0.126:5001/eventos", evento).catch((err) => {
    console.log("Microsserviço de observações fora do ar.");
  });
  //envia o evento para o microsserviço de consulta
  axios.post("http://10.2.0.126:6000/eventos", evento).catch((err) => {
    console.log("Microsserviço de consulta fora do ar.");
  });
  //envia o evento para o microsserviço de classificação
  axios.post("http://10.2.0.126:7001/eventos", evento).catch((err) => {
    console.log("Microsserviço de classificação fora do ar.");
  });
  res.status(200).send({ msg: "ok" });
});

app.get("/eventos", (req, res) => {
  res.send(eventos);
});

app.listen(10000, () => {
  console.log("Barramento de eventos. Porta 10000.");
});
