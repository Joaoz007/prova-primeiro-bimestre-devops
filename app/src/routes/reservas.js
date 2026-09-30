'use strict';

const { Router } = require('express');
const pool = require('../db');

const router = Router();

// ─── Constantes de validação ──────────────────────────────────────────────────
const STATUS_VALIDOS = ['pendente', 'confirmada', 'cancelada'];
const REGEX_DATA = /^\d{4}-\d{2}-\d{2}$/;

/**
 * Valida se uma string de data está no formato YYYY-MM-DD e é uma data real.
 */
function dataValida(str) {
  if (!REGEX_DATA.test(str)) return false;

  const [ano, mes, dia] = str.split('-').map(Number);
  const data = new Date(Date.UTC(ano, mes - 1, dia));

  return (
    data.getUTCFullYear() === ano &&
    data.getUTCMonth() === mes - 1 &&
    data.getUTCDate() === dia
  );
}

/**
 * Valida os campos de uma reserva.
 * Retorna uma string de erro ou null se tudo for válido.
 * @param {object} body
 * @param {boolean} requireAll - true para POST (todos obrigatórios), false para PUT (ao menos um)
 */
function validar(body, requireAll) {
  const { cliente, data, status } = body;

  if (requireAll) {
    if (cliente === undefined) return "Campo 'cliente' é obrigatório.";
    if (data === undefined) return "Campo 'data' é obrigatório.";
    if (status === undefined) return "Campo 'status' é obrigatório.";
  } else {
    // PUT: ao menos um campo deve estar presente
    if (cliente === undefined && data === undefined && status === undefined) {
      return 'Informe ao menos um campo para atualizar: cliente, data ou status.';
    }
  }

  if (cliente !== undefined) {
    if (typeof cliente !== 'string' || cliente.trim().length < 1 || cliente.trim().length > 100) {
      return "Campo 'cliente' inválido: deve ser uma string de 1 a 100 caracteres.";
    }
  }

  if (data !== undefined) {
    if (typeof data !== 'string' || !dataValida(data)) {
      return "Campo 'data' inválido: deve estar no formato YYYY-MM-DD.";
    }
  }

  if (status !== undefined) {
    if (!STATUS_VALIDOS.includes(status)) {
      return `Campo 'status' inválido: deve ser um de ${STATUS_VALIDOS.map(s => `'${s}'`).join(', ')}.`;
    }
  }

  return null;
}

// ─── POST /reservas ───────────────────────────────────────────────────────────
router.post('/', async (req, res) => {
  const erro = validar(req.body, true);
  if (erro) return res.status(400).json({ error: erro });

  const { cliente, data, status } = req.body;

  try {
    const result = await pool.query(
      'INSERT INTO reservas (cliente, data, status) VALUES ($1, $2, $3) RETURNING id, cliente, data, status',
      [cliente.trim(), data, status]
    );
    return res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Erro ao criar reserva:', err.message);
    return res.status(500).json({ error: 'Erro interno do servidor. Tente novamente mais tarde.' });
  }
});

// ─── GET /reservas ────────────────────────────────────────────────────────────
router.get('/', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT id, cliente, data, status FROM reservas ORDER BY id'
    );
    return res.status(200).json(result.rows);
  } catch (err) {
    console.error('Erro ao listar reservas:', err.message);
    return res.status(500).json({ error: 'Erro interno do servidor. Tente novamente mais tarde.' });
  }
});

// ─── GET /reservas/:id ────────────────────────────────────────────────────────
router.get('/:id', async (req, res) => {
  const id = parseInt(req.params.id, 10);
  if (isNaN(id)) return res.status(404).json({ error: 'Reserva não encontrada.' });

  try {
    const result = await pool.query(
      'SELECT id, cliente, data, status FROM reservas WHERE id = $1',
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Reserva não encontrada.' });
    }
    return res.status(200).json(result.rows[0]);
  } catch (err) {
    console.error('Erro ao buscar reserva:', err.message);
    return res.status(500).json({ error: 'Erro interno do servidor. Tente novamente mais tarde.' });
  }
});

// ─── PUT /reservas/:id ────────────────────────────────────────────────────────
router.put('/:id', async (req, res) => {
  const id = parseInt(req.params.id, 10);
  if (isNaN(id)) return res.status(404).json({ error: 'Reserva não encontrada.' });

  const erro = validar(req.body, false);
  if (erro) return res.status(400).json({ error: erro });

  const { cliente, data, status } = req.body;

  // Constrói query dinâmica apenas com os campos fornecidos
  const campos = [];
  const valores = [];
  let idx = 1;

  if (cliente !== undefined) { campos.push(`cliente = $${idx++}`); valores.push(cliente.trim()); }
  if (data !== undefined)    { campos.push(`data = $${idx++}`);    valores.push(data); }
  if (status !== undefined)  { campos.push(`status = $${idx++}`);  valores.push(status); }

  valores.push(id); // último parâmetro é sempre o id

  try {
    const result = await pool.query(
      `UPDATE reservas SET ${campos.join(', ')} WHERE id = $${idx} RETURNING id, cliente, data, status`,
      valores
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Reserva não encontrada.' });
    }
    return res.status(200).json(result.rows[0]);
  } catch (err) {
    console.error('Erro ao atualizar reserva:', err.message);
    return res.status(500).json({ error: 'Erro interno do servidor. Tente novamente mais tarde.' });
  }
});

// ─── DELETE /reservas/:id ─────────────────────────────────────────────────────
router.delete('/:id', async (req, res) => {
  const id = parseInt(req.params.id, 10);
  if (isNaN(id)) return res.status(404).json({ error: 'Reserva não encontrada.' });

  try {
    const result = await pool.query(
      'DELETE FROM reservas WHERE id = $1',
      [id]
    );
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Reserva não encontrada.' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('Erro ao deletar reserva:', err.message);
    return res.status(500).json({ error: 'Erro interno do servidor. Tente novamente mais tarde.' });
  }
});

module.exports = router;
