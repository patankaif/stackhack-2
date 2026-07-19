# Exercise 2 — Branching and Merging

Continue in the repository from Exercise 1, or start a fresh one.

## Part A — a clean feature branch merge

1. Create and switch to a branch called `feature/add-greeting` in one
   command (`git checkout -b ...`).
2. Add a line to `notes.md`, commit it on this branch.
3. Switch back to `main` (or `master`) — confirm with `cat notes.md`
   that your change is *not* here (branches are isolated until merged).
4. Merge `feature/add-greeting` into `main`. Was it a fast-forward or a
   three-way merge? (Check the output — a fast-forward says "Fast-forward"
   explicitly.)
5. Delete the feature branch with `git branch -d feature/add-greeting` —
   Git will refuse if it thinks the branch has unmerged work, which
   confirms your merge actually succeeded.

## Part B — force a merge conflict on purpose

1. From `main`, create two branches: `feature/a` and `feature/b`, both
   starting from the same commit.
2. On `feature/a`, change the **first line** of `notes.md` to something,
   commit.
3. On `feature/b`, change the **same first line** to something different,
   commit.
4. Merge `feature/a` into `main` — should be clean.
5. Merge `feature/b` into `main` — this **will** conflict, because both
   branches changed the same line relative to the same starting commit.
6. Run `git status` and `cat notes.md` to see the conflict markers
   (`<<<<<<<`, `=======`, `>>>>>>>`).
7. Edit the file by hand to the content you actually want, removing the
   markers. Then `git add notes.md` and `git commit` (no `-m` needed —
   Git already knows this is a merge commit and pre-fills a message,
   though you can still pass `-m` if you'd rather write your own).
8. Run `git log --oneline --graph` — you should see the merge commit with
   two parent lines converging into it.

## Check yourself

- You should be able to explain *why* step 4 didn't conflict but step 5
  did, even though both merges touched the same file.
- Try `git merge --abort` once, on purpose, mid-conflict (before
  resolving) — confirm it puts you back to a clean state with no trace
  of the attempted merge. This is your "undo" button if a conflict looks
  too messy to resolve and you'd rather back out and rethink.

## Stretch goal

Try `git rebase` instead of `git merge` for a clean (non-conflicting)
feature branch: `git checkout feature/x`, `git rebase main`. Compare the
resulting `git log --oneline --graph` to what a merge would have produced
— rebase rewrites your branch's commits on top of main instead of
creating a merge commit, giving a linear history. (Never rebase a branch
that others have already pulled from you — it rewrites commit hashes,
which breaks anyone else's copy of that branch.)
