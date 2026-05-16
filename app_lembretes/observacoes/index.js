const express = require('express')
const { v4: uuidV4 } = require('uuid')
const axios = require('axios')
const app = express()
app.use(express.json())

const observacoesPorLembreteId = {}

const funcoes = {
    ObservacaoClassificada: (observacao) => {
        const observacoes =
        observacoesPorLembreteId[observacao.lembreteId]
        const obsParaAtualizar = 
            observacoes.find(o => o.id === observacao.id)
        obsParaAtualizar.status = observacao.status
        axios.post("http://localhost:10000/eventos", {
            tipo: "ObservacaoAtualizada",
            dados: {
                id: observacao.id,
                texto: observacao.texto,
                lembreteId: observacao.lembreteId,
                status: observacao.status
            }
        })
    }
}


//:id é um placeholder
//exemplo: /lembretes/12/observacoes
app.get('/lembretes/:id/observacoes', (req, res) => {
    res.send(observacoesPorLembreteId[req.params.id] || [])
})

app.post('/lembretes/:id/observacoes', async (req, res) => {
    const idObs = uuidV4()
    const { texto } = req.body
    const id = req.params.id

    const observacoesDoLembrete = observacoesPorLembreteId[id] || []
    observacoesDoLembrete.push({ id: idObs, texto, status: 'aguardando'})
    observacoesPorLembreteId[id] = observacoesDoLembrete
    await axios.post('http://localhost:10000/eventos', {
        tipo: 'ObservacaoCriada',
        dados: {
            id: idObs, 
            texto, 
            lembreteId: id,
            status: 'aguardando'
        }
    })
    res.status(201).send(observacoesDoLembrete)
})

app.post('/eventos', (req, res) => {
    try{
        funcoes[req.body.tipo](req.body.dados)
    } catch(err){}
    res.status(200).send({msg: 'ok'})
})

app.listen(5001, (() => {
    console.log('Observacoes. Porta 5001.')
}))