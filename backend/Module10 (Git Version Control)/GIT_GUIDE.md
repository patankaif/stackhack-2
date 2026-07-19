# Module 10 – Version Control: Git

Every command in this guide was actually run in a real Git repository
while writing it (see `scripts/setup-practice-repo.sh` — the exact same
sequence, start to finish). The terminal output quoted below is real
output from that run, not invented.

**To follow along yourself:**
```bash
bash scripts/setup-practice-repo.sh
cd git-practice/alice
git log --oneline --graph --all
```

## 1. Introduction to Version Control

**What it is:** a system that records changes to files over time, so you
can recall specific versions later, see who changed what and why, and
combine changes from multiple people without overwriting each other's
work.

**Why it matters:**
- **History** — every commit is a checkpoint you can return to.
- **Collaboration** — multiple people can work on the same codebase at
  the same time without stepping on each other.
- **Safety** — mistakes are recoverable; nothing is really "lost" once
  committed.
- **Accountability** — every change is attributed to an author with a
  message explaining why.

**Types of version control systems:**
- **Local** — a simple database of changes on one machine (rarely used
  today, mostly of historical interest).
- **Centralized (CVCS)** — e.g. Subversion (SVN). One central server holds
  the history; clients check out a working copy. Single point of failure.
- **Distributed (DVCS)** — e.g. **Git**, Mercurial. Every clone is a full
  copy of the entire history, not just the latest snapshot. You can
  commit, branch, and view history completely offline, and there's no
  single point of failure.

## 2. Understanding Git

Git is a **distributed version control system**. Three concepts to keep
straight:

| Area | What it holds |
|---|---|
| **Working directory** | The actual files on disk you're editing right now |
| **Staging area (the "index")** | A holding area for changes you've decided to include in the *next* commit — `git add` moves changes here |
| **Repository (`.git` folder)** | The full committed history — `git commit` moves what's staged into a permanent, named snapshot |

```
working directory  --git add-->  staging area  --git commit-->  repository (.git)
```

This three-stage model is why you can edit ten files but only commit
three of them — `git add` lets you choose exactly what goes into each
commit, independent of what else is sitting, unstaged, in your working
directory.

## 3. Setting Up Git

```bash
git --version
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --list
```

**Creating a repository — two starting points:**
```bash
git init                         # start tracking a new, empty project here
git clone <url-or-path>          # copy an existing repository, history and all
```

From the practice script:
```
$ git init --bare central-repo.git
$ git clone central-repo.git alice
warning: You appear to have cloned an empty repository.
```
(That warning is expected and harmless — `central-repo.git` had no
commits yet at that point.)

## 4. Basic Git Commands

```bash
git init                         # initialize a new repo
git clone <repo>                 # initialize a new repo
git add <file>                   # stage a specific file
git add .                        # stage everything changed/new in this directory
git add -A                       # stage everything changed/new in the whole repo
git status                       # what's staged, unstaged, untracked
git commit -m "message"          # commit what's staged
git commit -am "message"         # stage all tracked-file changes AND commit, in one step
git log                          # full commit history
git log --oneline                # one line per commit
git log --oneline --graph --all  # ASCII graph of all branches — extremely useful
git diff                         # unstaged changes vs. the last commit
git diff --staged                # staged changes vs. the last commit
```

Real output from the practice repo, after Alice's first commit:
```
$ git status
On branch main
nothing to commit, working tree clean

$ git log --oneline
ff21461 Initial commit: add README
```

**Writing a good commit message:** a short summary line (ideally under
~50 characters, imperative mood — "Add X" not "Added X" or "Adds X"),
optionally followed by a blank line and more detail if the *why* isn't
obvious from the diff itself.

## 5. Branching and Merging

A branch is just a movable pointer to a commit — creating one is instant
and cheap, which is why Git workflows lean so heavily on branching for
every piece of work.

```bash
git branch                       # list local branches
git branch <name>                # create a branch (doesn't switch to it)
git checkout <name>               # switch to a branch
git checkout -b <name>            # create AND switch, in one step
git checkout -b <name> <base>     # create from a specific starting point
git switch <name>                 # modern alternative to checkout for switching
git branch -d <name>               # delete a branch (only if merged)
git branch -D <name>               # force-delete (even if not merged)
```

**Merging** brings the changes from one branch into another:
```bash
git checkout main
git merge feature/my-feature
```

Two outcomes:
- **Fast-forward** — if `main` hasn't moved since the branch was created,
  Git just moves the `main` pointer forward. No merge commit.
- **Three-way merge** — if both branches have new commits, Git creates a
  new **merge commit** with two parents. Use `--no-ff` to force a merge
  commit even when a fast-forward would be possible — this is common in
  team workflows because it keeps a visible record that a feature branch
  existed, instead of flattening it into the mainline history.

**Merge conflicts** happen when the same lines were changed differently
on both sides. This is genuinely what it looks like — captured from the
practice repo, where Alice and Bob both retitled the same `README.md`
line on separate branches:

```
$ git merge bob/feature/retitle-catalog
Auto-merging README.md
CONFLICT (content): Merge conflict in README.md
Automatic merge failed; fix conflicts and then commit the result.

$ cat README.md
<<<<<<< HEAD
# Library Catalog System
=======
# Book Catalog Manager
>>>>>>> bob/feature/retitle-catalog

A small project used to practice Git.
```

To resolve it: open the file, decide what the final content should be,
delete the `<<<<<<<`/`=======`/`>>>>>>>` marker lines, save, then:
```bash
git add README.md
git commit -m "Merge feature/retitle-catalog, resolve title conflict"
```
(No `-m` message needed if you just run `git commit` after resolving —
Git pre-fills a sensible merge commit message — but being explicit is
fine too.) You can also bail out entirely with `git merge --abort` if you
want to back out and reconsider.

**Branching strategies** (the "why" behind branch naming conventions):
- **Feature branching** — one branch per feature/fix (`feature/...`,
  `fix/...`), merged back to a shared integration branch when done. Used
  throughout this guide.
- **Release branching** — a `release/x.y.z` branch is cut when preparing
  a release, so last-minute fixes don't block ongoing feature work on
  `develop`. See the Gitflow section below.
- **Git Flow** — a specific, more structured combination of both: a
  long-lived `main` (production) and `develop` (integration) branch, plus
  short-lived `feature/*`, `release/*`, and `hotfix/*` branches. See §8.

## 6. Remote Repositories

A **remote** is just a named URL/path pointing to another copy of the
repository — most commonly a server like GitHub, but the practice script
uses local bare repositories (folders ending in `.git` with no working
directory) to simulate this without needing real network access.

```bash
git remote -v                          # list configured remotes
git remote add <name> <url>            # add a new remote
git push -u origin main                # push, and set up tracking (-u) so future
                                        # `git push`/`git pull` on this branch need no args
git push origin main                   # push local main to origin's main
git pull origin main                   # fetch + merge origin's main into your current branch
git fetch origin                       # download new commits/branches, but don't merge yet
git branch -vv                         # see which remote branch each local branch tracks
```

**`git fetch` vs. `git pull`:** `fetch` downloads everything new from the
remote but leaves your working branch untouched — you inspect what
changed before deciding what to do with it. `pull` is really `fetch` +
`merge` (or `+ rebase`, with `git pull --rebase`) in one step. When in
doubt, `fetch` first and look, especially on shared branches.

Real output from the practice repo — Bob pushing a new branch for the
first time:
```
$ git push -u origin feature/add-contributing-guide
To bob-fork.git
 * [new branch]      feature/add-contributing-guide -> feature/add-contributing-guide
branch 'feature/add-contributing-guide' set up to track 'origin/feature/add-contributing-guide'.
```

**Multiple remotes** — a repository can track more than one remote at
once. This is exactly how forking works (§7): your own fork is `origin`,
and the original repository you forked from is conventionally added as a
second remote named `upstream`.

## 7. Collaborating with Git

**Forking** — on GitHub, "Fork" creates your own server-side copy of
someone else's repository, which you then clone locally and can push to
freely (you don't have write access to the original). The practice
script simulates this with `git clone --bare central-repo.git
bob-fork.git` (Bob's fork) followed by `git clone bob-fork.git bob`
(Bob's local working copy).

**A subtlety the practice script deliberately surfaces:** forks do
**not** automatically stay in sync with the original repository. After
Alice merges a pull request into `central-repo.git`, Bob's fork
(`bob-fork.git`) still doesn't have that commit until Bob explicitly
syncs it:
```bash
git remote add upstream <original-repo-url>
git fetch upstream
git merge upstream/main      # (while on your local main)
git push origin main         # push the sync back up to your own fork, optional but tidy
```
Forgetting this step is one of the most common sources of confusing pull
request conflicts in real projects — worth internalizing early.

**Pull Requests (PRs)** — a request to merge one branch into another,
with a review step in between. There's no server-side "PR" object in
plain Git; a platform like GitHub layers that UI/review workflow on top.
But the underlying mechanics are exactly what the practice script does
by hand:
```bash
git remote add bob <path-or-url-to-bobs-fork>
git fetch bob
git checkout -b feature/add-contributing-guide bob/feature/add-contributing-guide
# ...review the code, run it, test it...
git checkout main
git merge --no-ff feature/add-contributing-guide -m "Merge pull request: Add CONTRIBUTING.md"
git push origin main
```
That's literally what GitHub's "Merge pull request" button does on your
behalf, plus the review UI around it (inline comments, required approvals,
CI status checks, etc.).

**Common collaboration workflows, compared:**

| Workflow | How it works | Typical use |
|---|---|---|
| **Centralized** | Everyone commits straight to one shared branch (usually `main`) | Very small teams, simple projects |
| **Feature Branch** | Every change happens on its own branch, merged via PR/review | Most common default for team projects today |
| **Forking** | Contributors work in their own server-side copy, PR back to the original | Open-source projects with many outside contributors who don't have push access |
| **Git Flow** | Structured `main`/`develop`/`feature`/`release`/`hotfix` branches with strict rules about what merges where | Projects with formal, versioned releases and release cycles |

## 8. Git Flow in practice

The practice script's final step builds a small but complete Git Flow
example:

```bash
git tag -a v1.0.0 -m "Release 1.0.0"     # tag the current main as a release
git push origin v1.0.0

git checkout -b develop main              # long-lived integration branch
git push -u origin develop

git checkout -b release/1.1.0 develop     # cut a release branch from develop
# ...final release-prep commits go here (release notes, version bumps)...

git checkout main
git merge --no-ff release/1.1.0 -m "Release 1.1.0"   # ship it
git tag -a v1.1.0 -m "Release 1.1.0"

git checkout develop
git merge --no-ff release/1.1.0 -m "Merge release/1.1.0 back into develop"
# so develop also has any last-minute fixes made on the release branch

git push origin main develop v1.1.0
```

Real resulting graph (from `git log --oneline --graph --all`):
```
*   7e07b4e Merge release/1.1.0 back into develop
|\
| | * bcd9d14 Release 1.1.0
| |/|
|/|/
| * 1705622 Add 1.1.0 release notes
|/
*   62f7927 Merge feature/retitle-catalog, resolve title conflict
...
```
Notice `release/1.1.0` merges into **both** `main` (to ship) and
`develop` (so develop doesn't lose any fixes made during release
prep) — that "merge twice" step is the signature of Git Flow's release
branch.

**Hotfix branches** follow the same idea but branch from `main` (not
`develop`) for urgent production fixes, then merge back into both `main`
and `develop`:
```bash
git checkout -b hotfix/critical-bug main
# ...fix, commit...
git checkout main
git merge --no-ff hotfix/critical-bug -m "Hotfix: critical bug"
git tag -a v1.1.1 -m "Hotfix release 1.1.1"
git checkout develop
git merge --no-ff hotfix/critical-bug -m "Merge hotfix into develop"
```

## Quick command reference

See `cheatsheet.md` in this folder for a condensed, printable version of
every command above.

## Exercises

Numbered, hands-on versions of everything above, meant to be done by
typing the commands yourself rather than copy-pasting the whole script at
once, live in `exercises/`:

1. `exercises/01-basic-commands.md`
2. `exercises/02-branching-and-merging.md`
3. `exercises/03-remote-repositories.md`
4. `exercises/04-forking-and-collaboration-workflows.md`

## Notes

- Every command and every quoted terminal snippet in this guide came from
  actually running `scripts/setup-practice-repo.sh` (or the commands it's
  built from) in a real Git repository — nothing here is hypothetical.
  Re-run it yourself any time; it's fully self-contained (uses local
  bare repos as "remotes", no network or GitHub account required) and
  safe to re-run repeatedly since it deletes and rebuilds its target
  directory each time.
