const request = require('supertest');

// Mock the database model so tests run without MongoDB (works in Jenkins too)
jest.mock('../models/Task', () => ({
  find: jest.fn(() => ({
    sort: jest.fn().mockResolvedValue([{ _id: '1', title: 'Learn DevSecOps', done: false }]),
  })),
  create: jest.fn(async (data) => ({ _id: '2', done: false, ...data })),
}));

const app = require('../app');

describe('App', () => {
  test('GET /health returns ok', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe('ok');
  });

  test('GET /api/tasks returns a list', async () => {
    const res = await request(app).get('/api/tasks');
    expect(res.statusCode).toBe(200);
    expect(res.body[0].title).toBe('Learn DevSecOps');
  });

  test('POST /api/tasks creates a task', async () => {
    const res = await request(app).post('/api/tasks').send({ title: 'New task' });
    expect(res.statusCode).toBe(201);
    expect(res.body.title).toBe('New task');
  });

  test('POST /api/tasks without title returns 400', async () => {
    const res = await request(app).post('/api/tasks').send({});
    expect(res.statusCode).toBe(400);
  });

  test('GET / serves the frontend', async () => {
    const res = await request(app).get('/');
    expect(res.statusCode).toBe(200);
    expect(res.text).toContain('<title>');
  });
});
