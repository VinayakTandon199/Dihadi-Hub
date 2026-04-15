# Dihadi-Hub: The Daily Wage Empire

Dihadi-Hub is a workforce management platform built to simplify how agencies coordinate daily wage staff, handle client requests, and track attendance. It gives teams a central system to manage deployment, monitor work progress, and keep daily operations organized without the usual paperwork chaos.

## Tech Stack

- Node.js
- Express
- MySQL
- EJS

## Key Features

- Staff Deployment: Assign workers to contracts and manage workforce distribution efficiently.
- Client Requests: Handle client-side requests and contract-related workflows in one place.
- Attendance Tracking: Mark and review daily attendance with month-wise visibility.
- Role-Based Dashboards: Separate views for agency, client, and staff users.
- Database-Driven Workflow: Store and manage application data reliably with MySQL.

## How to Run Locally

1. Clone the repository.
2. Install dependencies:

   ```bash
   npm install
   ```

3. Set up your MySQL database using the provided schema file:

   ```bash
   database.sql
   ```

4. Update your database connection details in `config/db.js` if needed.
5. Start the application:

   ```bash
   npm start
   ```

6. Open the app in your browser at:

   ```
   http://localhost:3000
   ```

## Project Structure

- `index.js` - Application entry point
- `config/` - Database configuration
- `routes/` - Application routes
- `views/` - HTML dashboard and auth pages
- `public/` - Static assets

## What Dihadi-Hub Delivers

Dihadi-Hub helps agencies move faster, stay organized, and maintain accountability across daily wage operations. It is designed to make workforce management more transparent, more efficient, and easier to scale.
