# Exercise 4 — Forking and Collaboration Workflows

This exercise mirrors the full scenario in `scripts/setup-practice-repo.sh`
— you can run that script and read the result, but doing at least one
pass by hand first will make the automated version much more meaningful.

## Setup

```bash
mkdir git-exercise-4 && cd git-exercise-4
git init --bare upstream.git
git clone upstream.git maintainer
cd maintainer
git config user.name "Maintainer"
git config user.email "maintainer@example.com"
echo "# Shared Project" > README.md
git add README.md && git commit -m "Initial commit"
git branch -M main
git push -u origin main
cd ..
```

## Part A — fork, branch, and open a "pull request"

1. Simulate forking by making a **bare clone of the bare repo**:
   ```bash
   git clone --bare upstream.git contributor-fork.git
   git clone contributor-fork.git contributor
   cd contributor
   git config user.name "Contributor"
   git config user.email "contributor@example.com"
   ```
2. Create a feature branch, make a change, commit it, and push it to
   your fork (`origin`, which is `contributor-fork.git`):
   ```bash
   git checkout -b feature/my-change
   echo "Some new content" >> README.md
   git commit -am "Add a line to README"
   git push -u origin feature/my-change
   ```
3. Switch back to `maintainer/`. Add the contributor's fork as a second
   remote, fetch it, and review the branch:
   ```bash
   cd ../maintainer
   git remote add contributor ../contributor-fork.git
   git fetch contributor
   git checkout -b feature/my-change contributor/feature/my-change
   cat README.md   # review the change
   ```
4. "Merge the pull request":
   ```bash
   git checkout main
   git merge --no-ff feature/my-change -m "Merge pull request from contributor"
   git push origin main
   ```

## Part B — sync a stale fork

At this point, `contributor-fork.git` does **not** have the merge commit
you just pushed to `upstream.git` — forks don't auto-sync.

1. In `contributor/`, add `upstream.git` as a remote named `upstream`.
2. `git fetch upstream`, then merge `upstream/main` into your local
   `main`.
3. Push the sync back to your own fork: `git push origin main`.
4. Confirm with `git log --oneline --graph --all` that your fork now has
   the maintainer's merge commit.

## Check yourself

- Explain the difference between `origin` and `upstream` in your
  `contributor` clone — which one can you push to freely, and which one
  can you (realistically, on GitHub) usually only read from?
- Without looking at Part B again: what command sequence keeps a fork in
  sync with its upstream? (This trips up almost everyone the first time.)

## Part C — compare the workflows, in your own words

Given what you just did by hand, write 2–3 sentences each:

1. How would this have been *simpler* with a **Centralized** workflow
   (everyone commits straight to `main`)? What would you lose?
2. How is what you just did different from a plain **Feature Branch**
   workflow (no forking, everyone has push access to one shared repo)?
3. When would you reach for the **Forking** workflow specifically, instead
   of just giving every contributor push access?

There's no single correct answer here — the point is to connect the
commands you just typed to the reasons real teams choose one workflow
over another.
