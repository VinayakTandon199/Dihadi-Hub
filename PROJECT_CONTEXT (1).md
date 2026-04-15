# 🏢 AGENCY MANAGEMENT SYSTEM — FULL PROJECT CONTEXT
> Paste this file at the start of any new chat to continue seamlessly

---

## 🎯 WHAT WE ARE BUILDING

A **cloud-based Agency Management System** that connects three types of users:
- **Clients** — need workers/staff for their work
- **Agencies** — provide staff to clients
- **Staff** — workers deployed by agencies to clients
- **Admin** — oversees everything (to be built later)

### Central Flow
```
Client Login → Browse Agencies → Filter by Type (Cook/Security etc)
→ Choose Agency → Choose Staff from that Agency
→ Send Request to Admin → Admin Reviews
→ Agency Gets Notified → Agency Deploys Staff
→ Client Gets Notification: Contract Accepted
→ Contract Goes Live → Attendance + Salary Tracking Begins
```

---

## 🛠️ TECH STACK

| Layer | Technology |
|---|---|
| Frontend | HTML, CSS, Vanilla JavaScript |
| Backend | Node.js + Express.js |
| Database | MySQL (database name: agency_db) |
| Auth | express-session (role-based) |
| DB Driver | mysql2 |

---

## 📁 PROJECT FOLDER STRUCTURE

```
agency-management-system/
├── index.js                  ✅ DONE — main server file
├── package.json
├── node_modules/
├── config/
│   └── db.js                 ✅ DONE — MySQL connection
├── routes/
│   ├── auth.js               ✅ DONE — login, register, logout
│   ├── dashboard.js          ✅ DONE — role based dashboard redirect
│   ├── client.js             ✅ DONE — client APIs, contract requests, notifications
│   └── agency.js             ✅ DONE — agency request review, accept/reject APIs
└── views/
    ├── login.html             ✅ DONE — particle background, glassmorphism
    ├── register.html          ✅ DONE — dynamic fields based on role
    ├── client-dashboard.html  ✅ DONE — contracts, attendance, salary, sidebar, new contract form
      ├── agency-dashboard.html  ✅ DONE — agency request review UI
    └── staff-dashboard.html   ❌ NOT BUILT YET
```

---

## 🗄️ DATABASE TABLES (MySQL — agency_db)

### 1. users
```sql
id | username | password | role (client/staff/agency) | created_at
```

### 2. client
```sql
id | user_id(FK) | name | age | gender | experience | type | address | contact | work_shift
```

### 3. agency
```sql
id | user_id(FK) | name | age | gender | experience | type | address | contact | work_shift
```

### 4. staff
```sql
id | user_id(FK) | name | age | gender | experience | type | address | contact | work_shift | expected_salary
```

### 5. contracts
```sql
id | client_id(FK→users) | agency_id(FK→users) | start_date | end_date | is_permanent(bool) | status(active/dismissed/pending) | created_at
```

### 6. contract_staff
```sql
id | contract_id(FK) | staff_id(FK→users) | working_hours | per_morning_salary
```

### 7. attendance
```sql
id | contract_id(FK) | staff_id(FK→users) | date | status(present/absent) | month | year
UNIQUE KEY on (contract_id, staff_id, date)
```

### 8. notifications
```sql
id | user_id(FK) | message | is_read(bool) | created_at
```

### 9. dismiss_requests
```sql
id | contract_id(FK) | requested_by(FK→users) | status(pending/accepted/rejected) | created_at
```

### 10. contract_requests ✅ NEW TABLE (just added)
```sql
id | client_id(FK→users) | agency_id(FK→users) | staff_type(varchar) | staff_count(int) | min_age(int) | max_salary(int) | work_shift(enum: morning/night) | address(text) | is_permanent(bool) | start_date(date) | end_date(date, nullable) | status(enum: pending/accepted/rejected, default pending) | created_at(timestamp)
```

---

## 👤 TEST USERS IN DATABASE

| username | password | role | user_id |
|---|---|---|---|
| agency1 | pass123 | agency | 1 |
| staff1 | pass123 | staff | 2 |
| client1 | pass123 | client | 3 |
| client2 | pass12345 | client | 7 |
| staff_test2 | pass123 | staff | 8 |
| staff_test1 | pass123 | staff | 9 |
| agency_test | pass123 | agency | 10 |

### Sample Data in DB
- **client** table: user_id=7, name=Vinayak Tandon
- **agency** table: user_id=10, name=QuickServe Agency, type=Cook, contact=9876543210
- **staff** table: user_id=8 Priya Sharma (₹350/morning), user_id=9 Rahul Kumar (₹300/morning)
- **contracts**: id=1, client_id=7, agency_id=10, start=2025-04-01, permanent=true, status=active
- **contract_staff**: contract_id=1, staff_id=9 (Rahul ₹300), staff_id=8 (Priya ₹350)

---

## ✅ WHAT IS FULLY BUILT

### Authentication System
- Login page with particle network background, glassmorphism card
- Register page with dynamic fields based on role selection
- Role-based redirect after login
- Session management with express-session
- Logout route

### Register Page Features
- Fields for all roles: username, password, confirm password, role, name, age, gender, contact, address
- Agency specific: type, experience, work_shift
- Staff specific: type, experience, work_shift, expected_salary
- Client specific: type, work_shift
- Password match validation, 10 digit contact validation
- Data saved in users + role specific table simultaneously

### Client Dashboard (views/client-dashboard.html)
**Theme:** Light theme, blue gradient background (#f0f4ff → #e8f0fe)

**Layout:**
- Navbar (full width, gradient #1e3a5f → #2563eb)
- Below navbar: sidebar (left 240px) + main content (right, remaining width)

**Sidebar (✅ DONE):**
- Menu item 1: 📋 "Current Contract" — shows existing dashboard
- Menu item 2: ➕ "New Contract" — shows new contract form
- Active state: blue bg #2563eb, white text
- Smooth fade-in transition on view switch
- Sticky, height = 100vh minus navbar

**Current Contract View (✅ DONE):**
1. Navbar with username + logout
2. Notifications bar (unread from DB)
3. My Contracts section with contract cards:
   - Agency Details, Contract Info, Deployed Staff cards
   - Each staff: avatar, name, age, contact, working hours, salary badge
4. Attendance & Salary System:
   - Live calendar, month/year navigation
   - Click past date → Present/Absent popup
   - Green = present, Red = absent
   - Salary: base = present × per_morning_salary
   - Deduction: every 2 absents = minus 1 morning salary; >8 absents = extra ₹1000 off
   - Monthly reset
5. Request Contract Dismissal button with confirmation dialog

**New Contract View (✅ DONE — HTML form built, JS submission complete):**
- Staff Type dropdown (Cook, Security Guard, House Help, Driver, Gardener, Electrician, Plumber, Gunman, Sweeper, Carpenter, Painter, House Labour)
- Agency dropdown (filtered by staff type — JS done)
- Min Staff Age + Number of Staff (side by side)
- Max Budget per Staff (₹/morning) + Work Shift (side by side)
- Deployment Address (textarea)
- Contract Start Date
- Contract Duration (Permanent / Fixed End Date dropdown)
- End Date (shown only if Fixed End Date selected)
- Submit button (id="submit-contract-btn") with POST to /client/contract/request and success/error feedback

### Agency Dashboard (views/agency-dashboard.html)
**Theme:** Light dashboard theme with blue gradients and card layout

**Built:**
1. Request list from GET /agency/requests
2. Accept request button
3. Reject request button
4. Client notification after accept/reject
5. Refresh button for live reloading

### API Routes Built (routes/client.js)
- GET /client/dashboard → returns all client data as JSON
- POST /client/attendance/mark → marks attendance in DB
- GET /client/attendance/:contract_id/:staff_id/:month/:year → fetches attendance + calculates salary
- POST /client/contract/dismiss → sends dismiss request + notifies agency
- POST /client/notifications/read → marks notification as read
- GET /client/agencies?type=Cook → ✅ NEW — returns agencies filtered by type
- POST /client/contract/request → ✅ NEW — submits new contract request + notifies agency
- GET /client/contract/requests → ✅ NEW — fetches all contract requests for logged-in client

### API Routes Built (routes/agency.js)
- GET /agency/requests → lists pending contract requests for logged-in agency
- POST /agency/requests/:id/accept → marks request accepted, creates active contract, notifies client
- POST /agency/requests/:id/reject → marks request rejected, notifies client

---

## 🔄 CURRENT SESSION — WHAT WE ARE BUILDING NOW

### New Contract Flow (Client Dashboard)
We are adding the ability for clients to submit new contract requests from inside the client dashboard.

**Steps completed so far:**
- [x] Step 1 — DB: Created `contract_requests` table
- [x] Step 2 — Backend: GET /client/agencies?type= route
- [x] Step 3 — Backend: POST /client/contract/request route
- [x] Step 4 — Backend: GET /client/contract/requests route
- [x] Step 5 — Frontend: Sidebar HTML structure added to client-dashboard.html
- [x] Step 6 — Frontend: Sidebar navigation JS (toggle between views)
- [x] Step 7 — Frontend: New Contract form HTML built inside #new-contract-view
- [x] Step 8 — Frontend JS: Agency dropdown auto-populate based on staff type selection
- [x] Step 9 — Frontend JS: Form submission posts to backend and shows success/error message
- [x] Step 10 — Agency-side request review UI created
- [x] Step 11 — Agency-side accept/reject APIs created

**Steps remaining in this session:**
- [ ] Step 12 — Agency acceptance flow should also deploy staff into `contract_staff` when staff selection logic is added
- [ ] Step 13 — Client Current Contract view should reflect newly accepted contracts after agency action
- [ ] Step 14 — Build staff dashboard
- [ ] Step 15 — Build admin dashboard
- [ ] Step 16 — Verify/fix server startup, because the last recorded `node index.js` exited with code 1

---

## ❌ WHAT IS NOT BUILT YET

### Agency Dashboard Remaining Work
- Auto-deploy staff into `contract_staff` after request acceptance, once staff selection logic is added
- View agency profile info and notifications
- View all active contracts and deployed staff under the agency
- Handle dismiss contract requests from clients

### Staff Dashboard (staff-dashboard.html + routes/staff.js)
Planned features:
- View personal profile
- See which contract they are currently deployed in
- View their own attendance record
- View their own salary for current month

### Admin Dashboard (admin-dashboard.html + routes/admin.js)
Planned features:
- View all users
- View all contracts
- Overall system statistics

### Client Dashboard — Remaining
- Sync Current Contract view after agency accepts a request
- Optional: show newly created request history in a dedicated section

---

## 🔄 FULL PLANNED USER FLOW

```
1. Client logs in → sees existing contracts OR no contract message
2. Client clicks "New Contract" in sidebar → form opens
3. Client selects Staff Type → Agency dropdown auto-filters
4. Client fills all fields → submits form
5. contract_requests row created with status=pending
6. Notification sent to selected agency
7. Agency logs in → sees notification → reviews request
8. Agency accepts → contracts row created (status=active) → client notified
9. Contract appears in client's "Current Contract" view
10. Staff assignment/deployment will be added when agency-side selection is implemented
11. Client marks attendance daily
12. Monthly salary auto-calculated
13. Either party requests dismissal → both agree → contract dismissed
```

---

## 🎨 DESIGN SYSTEM

### Login/Register Pages
- Background: dark navy #0d1b2a
- Particle network animation (canvas, mouse interactive)
- Glassmorphism card: rgba(255,255,255,0.12), backdrop-filter blur(30px)
- Accent: cyan #00d4ff / #00e5ff
- Button: gradient cyan to blue

### Client Dashboard
- Background: gradient #f0f4ff → #e8f0fe → #f0f7ff
- Navbar: gradient #1e3a5f → #2563eb
- Sidebar: white, subtle blue shadow, sticky
- Cards: white, border-radius 16px, subtle blue shadow
- Accent: #2563eb (blue)
- Staff cards: white with blue top border accent
- Salary summary: dark blue gradient #1e3a5f → #2563eb
- Inputs: border 1.5px solid #e2e8f0, border-radius 10px, focus glow blue
- Labels: font-weight 600, color #1e3a5f

### Agency Dashboard (planned)
- Theme: to be decided

### Staff Dashboard (planned)
- Theme: to be decided

---

## ⚙️ HOW TO RUN THE PROJECT

```bash
cd agency-management-system
npm install express mysql2 express-session body-parser path
node index.js
# Visit: http://localhost:3000
```

**Server should show:**
```
✅ MySQL Connected Successfully
🚀 Server running at http://localhost:3000
```

---

## 🔑 KEY RULES OF THIS PROJECT

1. Every user has unique username + password
2. Each user's data is separate — dashboards show only their own data
3. Salary system is daily-based (per_morning_salary × present mornings)
4. Attendance resets every month
5. Contract can only be dismissed if agency accepts the dismiss request
6. Staff is linked to agency (agency deploys staff, not client directly)
7. Admin is the middleman between client requests and agency
8. All prompts are given to VS Code GitHub Copilot for code generation
9. Step by step micro-step approach — one component at a time

---

## 📝 DEVELOPMENT APPROACH

- One micro-step at a time
- Each step has: file to create/edit + exact Copilot prompt
- Confirm after each step before moving forward
- Backend routes built first, then frontend HTML
- MySQL queries verified before using in code
- Debugging by checking terminal errors + browser console + direct API URL testing

---
*Last updated: Step 11 complete. Client new contract flow works end-to-end, agency review UI/APIs are built, and remaining work is staff deployment + dashboard completion + startup verification.*
