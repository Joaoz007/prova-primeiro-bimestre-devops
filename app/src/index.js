'use strict';

// ─── 1. Validar variáveis de ambiente obrigatórias ───────────────────────────
const REQUIRED_ENV = ['DB_HOST', 'DB_PORT', 'DB_NAME', 'DB_USER', 'DB_PASS'];
for (const varName of REQUIRED_ENV) {
  if (!process.env[varName]) {
    console.error(`Variável de ambiente obrigatória ausente: ${varName}`);
    process.exit(1);
  }
}

const express = require('express');
const pool = require('./db');
const reservasRouter = require('./routes/reservas');
const healthRouter = require('./health');

const app = express();
const PORT = process.env.PORT || 3000;

// ─── 2. DDL — criação da tabela se não existir ────────────────────────────────
const DDL = `
  CREATE TABLE IF NOT EXISTS reservas (
    id      SERIAL PRIMARY KEY,
    cliente VARCHAR(255) NOT NULL,
    data    VARCHAR(10)  NOT NULL,
    status  VARCHAR(20)  NOT NULL
      CHECK (status IN ('pendente', 'confirmada', 'cancelada'))
  )
`;

async function bootstrap() {
  // Verifica conectividade e cria tabela
  try {
    await pool.query(DDL);
  } catch (err) {
    console.error('Falha ao conectar ou inicializar o banco de dados:', err.message);
    process.exit(1);
  }

  // ─── 3. Middlewares e rotas ─────────────────────────────────────────────────
  app.use(express.json());
  app.use('/reservas', reservasRouter);
  app.use('/health', healthRouter);

  // ─── 4. Iniciar servidor ────────────────────────────────────────────────────
  app.listen(PORT, () => {
    console.log(`API TechNova Reservas rodando na porta ${PORT}`);
  });
}

bootstrap();

module.exports = app; // exportado para testes
