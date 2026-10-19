# notes service — INF 345 demo repository

The lecturer's copy of the project students build all semester.

## What it does
A tiny HTTP service: `GET /` answers, `GET /notes` returns how many notes there
are, `GET /healthz` returns 200 for health checks.

## How to run
`./scripts/run.sh` — listens on `$PORT`, default 8080.

## How to test
`./scripts/test.sh` — prints `TESTS: n/n`.

## Week 5: Docker
- Build: `docker build -t notes:1 .`
- Run: `docker run -d --rm --name notes -p 8080:8080 notes:1`, then
  `curl localhost:8080/healthz`
- `requirements.txt` lists one heavy library on purpose, so the lecture can
  show a slow install. The service itself needs none.
- `demo-files/docker/` holds lecture-only Dockerfiles: shell-form CMD, slow
  layer order, a typo, the 127.0.0.1 bug, a CRLF start script, a leaked token,
  and a Go version built in one stage and in two. Do not copy them.

## Week 6: Compose and publishing
- `docker compose up --build --exit-code-from smoke` starts the service and a
  container that calls its `/healthz` by the service name `app`.
- The `publish` job in `.github/workflows/ci.yml` builds, smoke-tests, scans
  and pushes `ghcr.io/<owner>/inf345-demo-notes:<commit SHA>` and `:latest`.
- `demo-files/week6/` holds the lecture's workflow versions: before, the job
  to paste (one line missing on purpose), and after.
