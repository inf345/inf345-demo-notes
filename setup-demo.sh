#!/usr/bin/env bash
# Run ONCE inside the unzipped demo folder. Creates the history and the
# demo/green-lie branch. Then create the repository on GitHub and push
# (the last two lines this script prints).
set -euo pipefail
cd "$(dirname "$0")"
if [ -d .git ]; then echo "already a git repository - nothing to do"; exit 0; fi
git init -q -b main
git add README.md .gitignore .gitattributes src tests scripts
git commit -qm "Notes service with run and test scripts"
git add demo-files setup-demo.sh
git commit -qm "Demo files for the Week 4 lecture"

# The branch for DEMO 3: a test that fails, and a workflow that pipes into tee.
git switch -qc demo/green-lie
mkdir -p .github/workflows
cp demo-files/ci-green-lie.yml .github/workflows/ci.yml
sed -i.bak 's/"3")$/"4")/' tests/test_server.py && rm -f tests/test_server.py.bak
git add -A
git commit -qm "Demo: save the test output with tee (and expect 4 notes)"
git switch -q main

echo "Done. Now create an EMPTY public repository on GitHub called inf345-demo-notes, then:"
echo "  git remote add origin https://github.com/<you>/inf345-demo-notes.git"
echo "  git push -u origin main demo/green-lie"
