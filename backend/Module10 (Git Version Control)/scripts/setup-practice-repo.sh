#!/usr/bin/env bash
set -e

TARGET_DIR="${1:-./git-practice}"

echo "Setting up Git practice environment in $TARGET_DIR ..."
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

git config --global init.defaultBranch main >/dev/null 2>&1 || true

echo
echo "=== Step 1: Create the 'central' repository (simulates a GitHub remote) ==="
git init --bare central-repo.git -q

echo
echo "=== Step 2: Alice clones it and pushes an initial commit ==="
git clone central-repo.git alice -q
cd alice
git config user.email "alice@example.com"
git config user.name "Alice Maintainer"
cat > README.md << 'EOF'
# Library Catalog

A small project used to practice Git.
EOF
git add README.md
git commit -m "Initial commit: add README" -q
git branch -M main
git push -u origin main
cd ..

echo
echo "=== Step 3: Bob 'forks' the repo (bare clone) and clones his fork ==="
git clone --bare central-repo.git bob-fork.git -q
git clone bob-fork.git bob -q
cd bob
git config user.email "bob@example.com"
git config user.name "Bob Contributor"
git checkout -b feature/add-contributing-guide -q
cat > CONTRIBUTING.md << 'EOF'
# Contributing

1. Fork the repository.
2. Create a feature branch.
3. Open a pull request.
EOF
git add CONTRIBUTING.md
git commit -m "Add CONTRIBUTING.md" -q
git push -u origin feature/add-contributing-guide
cd ..

echo
echo "=== Step 4: Alice reviews Bob's branch from his fork and merges it (a Pull Request) ==="
cd alice
git remote add bob ../bob-fork.git
git fetch bob
git checkout -b feature/add-contributing-guide bob/feature/add-contributing-guide -q
git checkout main -q
git merge --no-ff feature/add-contributing-guide -m "Merge pull request: Add CONTRIBUTING.md" -q
git push origin main
cd ..

echo
echo "=== Step 5: Bob syncs his now-stale fork with upstream ==="
cd bob
git checkout main -q
git remote add upstream ../central-repo.git
git fetch upstream
git merge upstream/main -q
git push origin main
cd ..

echo
echo "=== Step 6: A real merge conflict, created on purpose, then resolved ==="
cd alice
git checkout main -q
git checkout -b feature/rename-title main -q
sed -i '1s/.*/# Library Catalog System/' README.md
git commit -am "Rename project title (Alice)" -q
cd ..

cd bob
git checkout -b feature/retitle-catalog main -q
sed -i '1s/.*/# Book Catalog Manager/' README.md
git commit -am "Retitle project (Bob)" -q
git push -u origin feature/retitle-catalog
cd ..

cd alice
git checkout main -q
git merge feature/rename-title -m "Merge: rename project title" -q
git push origin main
git fetch bob
set +e
git merge bob/feature/retitle-catalog
set -e
echo
echo "--- CONFLICT! git status: ---"
git status
echo
echo "--- Resolving by hand and completing the merge ---"
cat > README.md << 'EOF'
# Library Catalog System

A comprehensive Git practice project for the DN 5.0 program.
EOF
git add README.md
git commit -m "Merge feature/retitle-catalog, resolve title conflict" -q
git push origin main
cd ..

echo
echo "=== Step 7: Tagging a release and a Gitflow-style release branch ==="
cd alice
git tag -a v1.0.0 -m "Release 1.0.0"
git push origin v1.0.0

git checkout -b develop main -q
git push -u origin develop

git checkout -b release/1.1.0 develop -q
echo "Preparing 1.1.0 release notes" > RELEASE_NOTES.md
git add RELEASE_NOTES.md
git commit -m "Add 1.1.0 release notes" -q

git checkout main -q
git merge --no-ff release/1.1.0 -m "Release 1.1.0" -q
git tag -a v1.1.0 -m "Release 1.1.0"
git checkout develop -q
git merge --no-ff release/1.1.0 -m "Merge release/1.1.0 back into develop" -q
git push origin main develop v1.1.0
cd ..

echo
echo "=== Done. Explore the result: ==="
echo "  cd $TARGET_DIR/alice"
echo "  git log --oneline --graph --all"
echo "  git tag"
echo "  git branch -a"
