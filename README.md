# Lilly's UPSC Companion — Backend (v1)

A minimal Rails JSON API for the goal-tracking core: monthly goals, weekly
milestones, and daily check-ins. No AI, no WhatsApp yet — that comes later.
This is deliberately small so it's easy to verify end-to-end before adding
anything else.

## What's in here

```
app/
  controllers/   monthly_goals, weekly_milestones, daily_logs, health
  models/        MonthlyGoal, WeeklyMilestone, DailyLog  (Mongoid, not ActiveRecord)
config/
  routes.rb
  mongoid.yml    reads MONGODB_URI from the environment
  puma.rb
Procfile         tells Render how to start the app
```

## API endpoints (v1)

| Method | Path | Purpose |
|---|---|---|
| GET | `/health` | Confirms the app is up and can reach MongoDB |
| GET | `/monthly_goals` | List all goals |
| POST | `/monthly_goals` | Create a goal |
| GET | `/monthly_goals/:id` | One goal |
| PATCH | `/monthly_goals/:id` | Update a goal |
| DELETE | `/monthly_goals/:id` | Delete a goal |
| GET | `/monthly_goals/:monthly_goal_id/weekly_milestones` | List milestones for a goal |
| POST | `/monthly_goals/:monthly_goal_id/weekly_milestones` | Add a milestone |
| PATCH | `/monthly_goals/:monthly_goal_id/weekly_milestones/:id` | Update a milestone |
| DELETE | `/monthly_goals/:monthly_goal_id/weekly_milestones/:id` | Delete a milestone |
| GET | `/daily_logs` | List check-ins (optional `?date=2026-08-19` filter) |
| POST | `/daily_logs` | Create a check-in |
| PATCH | `/daily_logs/:id` | Update a check-in |

All POST/PATCH bodies are wrapped in their resource name, e.g.:

```json
{ "monthly_goal": { "month": "2026-09", "title": "Finish Polity Ch 1-10" } }
```

## Option A — Test it locally first (optional but recommended)

You'll need Ruby 3.2+, Rails 7.1, and a local MongoDB (or just point
`MONGODB_URI` at a free MongoDB Atlas cluster even for local testing —
that's fine too, and saves installing MongoDB locally).

```bash
bundle install
export MONGODB_URI="mongodb://localhost:27017/upsc_companion_development"
bin/rails server
```

Then in another terminal:

```bash
curl http://localhost:3000/health

curl -X POST http://localhost:3000/monthly_goals \
  -H "Content-Type: application/json" \
  -d '{"monthly_goal": {"month": "2026-09", "title": "Finish Polity Ch 1-10"}}'
```

If that returns JSON back, it works. Skip straight to Option B if you'd
rather just deploy first and test on the live URL.

## Option B — Push to GitHub, then deploy on Render

### 1. Push this to GitHub

```bash
cd backend
git init
git add .
git commit -m "v1: goals, milestones, daily logs"
git branch -M main
git remote add origin <your-empty-github-repo-url>
git push -u origin main
```

### 2. Create a free MongoDB Atlas cluster

1. Sign up at mongodb.com/cloud/atlas (free, no card needed for the M0 tier).
2. Create an M0 (free) cluster.
3. Under **Database Access**, create a database user + password.
4. Under **Network Access**, allow access from anywhere (`0.0.0.0/0`) —
   simplest for a personal project; Render's IPs aren't static.
5. Click **Connect → Drivers**, copy the connection string. It looks like:
   `mongodb+srv://<user>:<password>@cluster0.xxxxx.mongodb.net/upsc_companion?retryWrites=true&w=majority`

### 3. Deploy on Render

1. Sign up at render.com (free, no card required for a web service).
2. **New → Web Service**, connect your GitHub repo.
3. Render should auto-detect Ruby. Set:
   - **Build Command:** `bundle install`
   - **Start Command:** `bundle exec puma -C config/puma.rb`
4. Under **Environment**, add:
   - `MONGODB_URI` → the Atlas connection string from step 2
   - `RAILS_ENV` → `production`
   - `SECRET_KEY_BASE` → any long random string (generate one with
     `ruby -rsecurerandom -e "puts SecureRandom.hex(64)"` on your machine)
5. Click **Create Web Service**. First deploy takes a few minutes.

### 4. Confirm it's live

```bash
curl https://<your-app-name>.onrender.com/health
```

You should get back `{"status":"ok","database":"connected", ...}`. That URL
is what goes into the frontend/APK config next.

## A note on the free tier

Render's free web service spins down after ~15 minutes of no traffic and
takes 30-60 seconds to wake back up on the next request. For a personal
tracker this is a non-issue — it just means the very first request after
opening the app on a given day might feel slow. Nothing to fix, just
expected behavior.

## What's deliberately not here yet

- No authentication (single-user personal project for now)
- No AI question generation / WhatsApp — the whole point of this pass was
  a clean, verified backend first. Those get layered on afterward without
  touching what's already working.
