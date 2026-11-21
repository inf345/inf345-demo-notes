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

## Week 8: Kubernetes
- `k8s/` runs three copies of the image of one commit, behind a Service called
  `notes`: `kubectl apply -f k8s/`.
- `demo-files/week8/` holds lecture-only files: a bare Pod, a Service with a
  broken selector, and the DNS debugging Pod from the Kubernetes documentation.

## Week 10: GitOps
- Argo CD deploys `k8s/` from this repository: `argocd/application.yaml`, applied once by
  hand. After that, a deploy is a commit to `main` - nobody runs `kubectl apply` on `k8s/`.
- `chart/` is the same service as a Helm chart, for the Helm demo. Argo CD does not deploy it:
  `helm template notes ./chart` shows what it would make.
- `demo-files/week10/` holds lecture-only files: an Application that deploys a Secret with a
  placeholder (the mistake the lecture shows - do not copy it), and a ConfigMap for the
  prune demo.

## Rollback
The cluster runs what `main` says. To go back, revert the commit that deployed the bad
version, and push:

    git revert --no-edit <commit>     # a merged pull request: git revert --no-edit -m 1 <merge commit>
    git push origin main

Argo CD syncs the previous version: at once after a refresh, otherwise within about three
minutes. Never fix the cluster by hand - self-heal puts Git's version back.

## Week 11: infrastructure as code
- `infra/` runs this service with Terraform and the Docker provider:
  `cd infra && terraform init && terraform plan && terraform apply`, then
  `curl "$(terraform output -raw healthz_url)"`. `.terraform.lock.hcl` is
  committed on purpose; state files never are.
- `ansible/` prepares a machine for the service. Run it twice - the second
  run changes nothing: `ansible-playbook -i ansible/inventory.ini ansible/site.yml`.
- `demo-files/week11/` holds lecture-only files: a version of `infra/` that
  passes a password (to find it in the state file), a plan for AWS that is
  never applied, and a playbook task that is not idempotent. Do not copy them.
