# Exercise 1 — Basic Commands

Do this by typing each command yourself in an empty directory — don't
copy-paste the whole block at once.

## Setup

```bash
mkdir git-exercise-1 && cd git-exercise-1
git init
git config user.name "Your Name"
git config user.email "you@example.com"
```

## Tasks

1. Create a file called `notes.md` with any content, then check
   `git status`. What category does it show up under?
2. Stage it with `git add notes.md`, then run `git status` again. How did
   the output change?
3. Commit it with a message. Then run `git log` and `git log --oneline`.
   Compare the two.
4. Edit `notes.md`, adding a second line. Run `git diff` — notice it
   shows the change, but it's not staged yet.
5. Stage the change, then run `git diff` again (nothing shown) and
   `git diff --staged` (shows the change). Understand why they differ.
6. Commit the change with `git commit -am "..."` instead of a separate
   `add` + `commit` — this only works because the file is already
   *tracked* (it was committed once before). Confirm with `git log
   --oneline` that you now have 2 commits.
7. Create a second file, `todo.md`, but don't stage it. Run `git status`
   — it should show up as "Untracked". Now run `git add .` and confirm
   with `git status` that it's staged.

## Check yourself

- `git log --oneline` should show exactly 2 commits.
- `git status` should report a clean working tree only after your last
  commit — if `todo.md` is still staged, commit it too so you finish on
  a clean state.
- You should be able to explain, without looking it up: the difference
  between the working directory, the staging area, and the repository.

## Stretch goal

Run `git log -p` (with `-p`) on your 2-commit history — this shows the
actual diff introduced by each commit, not just the message. This is
often more useful than plain `git log` when you're trying to remember
*what* changed, not just *when*.
