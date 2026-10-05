# notes service — INF 345 demo repository

The lecturer's copy of the project students build all semester.

## What it does
A tiny HTTP service: `GET /` answers, `GET /notes` returns how many notes there
are, `GET /healthz` returns 200 for health checks.

## How to run
`./scripts/run.sh` — listens on `$PORT`, default 8080.

## How to test
`./scripts/test.sh` — prints `TESTS: n/n`.
