const express = require('express');
const path = require('path');
const taskRoutes = require('./routes/tasks');

const app = express();

app.use(express.json());
app.use(express.static(path.join(__dirname, 'public'))); // frontend

app.get('/health', (req, res) => res.json({ status: 'ok' }));
app.use('/api/tasks', taskRoutes); // backend API

module.exports = app;
