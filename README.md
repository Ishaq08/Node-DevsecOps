# Node Full-Stack Task Board

- **Frontend:** `public/` (HTML, CSS, JavaScript)
- **Backend:** `app.js`, `routes/` (Node.js + Express REST API)
- **Database:** MongoDB (via Mongoose)

## Run everything with Docker (easiest)
    docker compose up --build
Open http://localhost:3000

## Run without Docker
Start MongoDB locally, then:
    npm install
    npm start

## Test
    npm test
(Tests mock the database, so they run without MongoDB. Good for Jenkins.)

## API
| Method | Path             | What it does        |
|--------|------------------|---------------------|
| GET    | /health          | Health check        |
| GET    | /api/tasks       | List tasks          |
| POST   | /api/tasks       | Create (`title`)    |
| PUT    | /api/tasks/:id   | Set `done` true/false |
| DELETE | /api/tasks/:id   | Delete a task       |
