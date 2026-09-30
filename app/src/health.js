'use strict';

const { Router } = require('express');
const pool = require('./db');

const router = Router();

// Qualquer método diferente de GET → 405
router.all('/', async (req, res, next) => {
  if (req.method !== 'GET') {
    return res.status(405).end();
  }
  next();
});

// GET /health
router.get('/', async (req, res) => {
  // Timeout de 5 segundos para o check do banco
  const timeoutPromise = new Promise((_, reject) =>
    setTimeout(() => reject(new Error('timeout')), 5000)
  );

  try {
    await Promise.race([pool.query('SELECT 1'), timeoutPromise]);
    return res.status(200).json({ status: 'ok' });
  } catch (err) {
    return res.status(503).json({
      status: 'error',
      message: 'Banco de dados indisponível.',
    });
  }
});

module.exports = router;
