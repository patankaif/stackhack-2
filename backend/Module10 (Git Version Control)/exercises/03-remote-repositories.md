# Exercise 3 — Remote Repositories

No GitHub account needed — a local **bare repository** (a repo with no
working directory, just the `.git` database) behaves exactly like a
remote server for every command in this exercise.

## Setup — build your own "remote"

```bash
mkdir git-exercise-3 && cd git-exercise-3
git init --bare project.git
git clone project.git workspace
cd workspace
git config user.name "Your Name"
git config user.email "you@example.com"
```

## Tasks

1. Create a file, commit it, then run `git remote -v`. You should already
   see `origin` pointing at `../project.git` — cloning sets this up for
   you automatically.
2. Push with `git push -u origin main` (the `-u` sets up tracking so
   future plain `git push`/`git pull` don't need arguments — confirm by
   running just `git push` after making another commit; it should work
   with no arguments).
3. Open a second terminal (or just `cd` back out and clone again into a
   second folder) to simulate a second developer:
   ```bash
   cd ..
   git clone project.git workspace2
   cd workspace2
   git config user.name "Second Developer"
   git config user.email "dev2@example.com"
   ```
4. In `workspace2`, make a commit and push it.
5. Back in `workspace` (the first clone), run `git fetch origin`, then
   `git log --oneline main..origin/main` — this shows commits that exist
   on the remote but not yet in your local `main`. This is exactly what
   `fetch` (without merging) is for: seeing what's new before you decide
   what to do with it.
6. Now run `git pull origin main` (or `git merge origin/main`) to bring
   those commits into your local branch.
7. Practice one conflict-free `git pull` where your local branch already
   has an unpushed commit of its own — confirm `pull` merges the two
   sets of commits together with a merge commit (assuming no conflicting
   lines).

## Check yourself

- `git branch -vv` in `workspace` should show `main` tracking
  `origin/main`, with no `ahead`/`behind` markers once you're fully
  synced.
- You should be able to explain, out loud, the difference between
  `git fetch` and `git pull` — and give one concrete reason you might
  prefer `fetch` first on a shared branch.

## Stretch goal

Try pushing from `workspace` *without* first pulling `workspace2`'s
commit (skip step 6, make a conflicting commit in `workspace`, then try
to push). Git should reject the push ("Updates were rejected because the
tip of your current branch is behind..."). This is Git protecting you
from silently overwriting someone else's pushed work — the fix is always
to `fetch`/`pull` (and resolve any conflict) *before* pushing again.
