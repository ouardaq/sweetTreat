# Sweet Treat 🍩

A bakery storefront in a pixel-art style: browse and search a donut catalogue, register, and log in. Flask API over MySQL, with a static frontend served by the same app.

This was the first version of an idea I later rebuilt properly as [Sweet Nothing](https://github.com/ouardaq/sweet-nothing) — same premise, TypeScript and PostgreSQL instead, with a cart, checkout, and tests.

## Features

- Donut catalogue served from MySQL, with case-insensitive name search
- `POST /api/donuts` to add a donut
- Registration and login, with passwords hashed by bcrypt
- Pixel-art styling across four pages: home, shop, login, register

## API

| Method | Route | Purpose |
| ------ | ----- | ------- |
| `GET` | `/api/donuts` | List donuts; `?search=` filters by name |
| `POST` | `/api/donuts` | Add a donut — `name` and `price` required |
| `POST` | `/api/login` | Verify a username and password |
| `POST` | `/api/register` | Create an account |

Static pages are served at `/`, `/shop`, `/login`, and `/register`.

## Tech

| Layer | Choice |
| ----- | ------ |
| Backend | Python, Flask, Flask-Cors |
| Password hashing | Flask-Bcrypt |
| Database | MySQL (`mysql-connector-python`) |
| Frontend | Vanilla JavaScript, HTML, CSS |

Every query is parameterized, so the search box is not an SQL injection vector.

## Running locally

**Prerequisites:** Python 3, MySQL.

```bash
git clone https://github.com/ouardaq/sweetTreat.git
cd sweetTreat
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Create the database and tables:

```bash
mysql -u root -p < schema.sql
```

Then set `DB_CONFIG` in `app.py` to match your MySQL user and password, and run:

```bash
python app.py
```

Open http://127.0.0.1:5000.

## Known rough edges

Honest notes, since this is an early project kept for the record rather than maintained:

- **Login establishes nothing.** `session` and `SECRET_KEY` are both set up, but `session` is never assigned to — so `/api/login` verifies the password, returns `200`, and leaves the user no more authenticated than before. The frontend never calls it either. Real auth needs the session written on login and read on the routes that should be protected.
- **`POST /api/donuts` is unauthenticated.** Anyone who can reach the API can add products.
- **Credentials are hardcoded.** `SECRET_KEY` and `DB_CONFIG` sit in `app.py` as placeholder literals. They belong in environment variables loaded from a git-ignored `.env`.
- **`schema.sql` is reconstructed, not original.** The repository shipped without one, so the tables here were derived from the `SELECT` and `INSERT` statements in `app.py`. Column types are a best reading of intent — `price` is `DECIMAL(10,2)` because money should never be a float.
- **`redirect` and `url_for` are imported and unused.**
