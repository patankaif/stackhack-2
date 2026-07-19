# Module 10 – Version Control: Git

Covers every learning objective in **Module 10** of the DN 5.0 Deep
Skilling handbook: version control concepts, branch/clone/push/fork
operations, and branch workflows — all as real, runnable Git commands,
not just descriptions.

Everything in this module was verified by actually running it: I built
the full scenario (fork, feature branch, pull-request-style merge, a
genuine merge conflict and its resolution, tagging, and a Gitflow release)
command-by-command in a real Git repository in this sandbox, then wrote
`scripts/setup-practice-repo.sh` to reproduce that exact sequence, and
ran the finished script fresh in a clean directory to confirm it works
standalone. The terminal output quoted throughout `GIT_GUIDE.md` is real,
not invented.

## Start here

```bash
bash scripts/setup-practice-repo.sh
cd git-practice/alice
git log --oneline --graph --all
```

This builds a small but complete, realistic history — no GitHub account
or network access needed, since it uses local bare repositories as
stand-ins for remote servers. Then read `GIT_GUIDE.md`, which walks
through every command the script just ran, organized by handbook topic,
with real captured output.

## Contents

| File | What it covers |
|---|---|
| `GIT_GUIDE.md` | The main guide — version control concepts, Git internals (working directory/staging/repo), setup, basic commands, branching & merging (including a real conflict), remotes, forking & PR workflow, Git Flow |
| `scripts/setup-practice-repo.sh` | Builds the full practice scenario in one command — safe to re-run, rebuilds from scratch each time |
| `exercises/01-basic-commands.md` | init, add, commit, status, log, diff |
| `exercises/02-branching-and-merging.md` | branch, checkout, merge, and a guaranteed merge conflict to resolve by hand |
| `exercises/03-remote-repositories.md` | remote, push, pull, fetch, tracking branches, using a local bare repo as a stand-in "GitHub" |
| `exercises/04-forking-and-collaboration-workflows.md` | forking, syncing a stale fork with upstream, the pull-request merge sequence, comparing workflows |
| `cheatsheet.md` | Condensed, printable command reference |

## The scenario, in one picture

```
central-repo.git (bare)  ───clone───►  alice/     (maintainer)
        │
        └──────bare clone (= "Fork")────►  bob-fork.git (bare)  ───clone───►  bob/  (contributor)
```

Alice pushes an initial commit. Bob forks, branches, commits, and pushes
to *his own fork*. Alice adds Bob's fork as a remote, fetches his branch,
reviews it, and merges it into `main` — exactly what clicking "Merge pull
request" does on GitHub under the hood. Later, Bob and Alice each branch
from the same commit and edit the same line of `README.md`, producing a
real merge conflict that gets resolved by hand. Finally, the script tags
a release and builds a small Git Flow structure (`develop`,
`release/1.1.0`, merged into both `main` and `develop`).

## Notes

- The script is idempotent — it deletes and rebuilds its target directory
  (`./git-practice` by default) every time, so there's no harm in running
  it repeatedly while you're learning.
- Everything here uses **local bare repositories** (`git init --bare`) in
  place of GitHub. This is a completely faithful simulation for every
  command that matters (`clone`, `push`, `pull`, `fetch`, remotes) —
  the only things GitHub adds on top are the web UI, authentication, and
  the Pull Request review interface itself. The underlying Git mechanics
  — which is what this module is about — are identical.
