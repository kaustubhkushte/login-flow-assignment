# Backend workspace

This folder contains the local auth stack used by the SwiftUI app:

- `api/`: Express + MongoDB + JWT auth service
- `web/`: minimal React client for manual testing
- `docker-compose.yml`: starts Mongo, API, and React together

## Run locally

```bash
cd backend
cp .env.example .env
docker compose up --build
```

Services:

- API: `http://localhost:4000/api`
- Web demo: `http://localhost:5173`
- MongoDB: `mongodb://localhost:27017`

## Default seeded user

The API checks the values in `backend/.env` on startup:

- `DEFAULT_USER_NAME`
- `DEFAULT_USER_EMAIL`
- `DEFAULT_USER_PASSWORD`

If all three are present, the API creates that user the first time it starts against a fresh database. If a user with the same email already exists, seeding is skipped safely.

## API endpoints

- `POST /api/auth/signup`
- `POST /api/auth/login`
- `GET /api/auth/me`

## Sample payloads

Signup / login:

```json
{
  "email": "jacob@gmail.com",
  "password": "password123",
  "name": "Jacob Joseph"
}
```

Auth responses:

```json
{
  "token": "jwt-token",
  "user": {
    "_id": "user-id",
    "name": "Jacob Joseph",
    "email": "jacob@gmail.com"
  }
}
```
