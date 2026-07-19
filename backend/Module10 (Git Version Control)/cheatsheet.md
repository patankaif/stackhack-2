# Git Cheatsheet

## Setup
```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --list
```

## Starting a repository
```bash
git init                     # new, empty repo here
git clone <url>               # copy an existing repo, full history included
```

## Everyday basics
```bash
git status                    # what's changed / staged / untracked
git add <file>                 # stage a file
git add .                      # stage everything in this directory
git add -A                     # stage everything in the whole repo
git commit -m "message"        # commit what's staged
git commit -am "message"       # stage all tracked changes + commit, in one step
git diff                       # unstaged changes
git diff --staged              # staged changes
git log                        # full history
git log --oneline              # condensed history
git log --oneline --graph --all  # visualize all branches at once
git log -p                     # history with full diffs
```

## Branching
```bash
git branch                     # list local branches
git branch <name>              # create (don't switch)
git checkout <name>            # switch
git checkout -b <name>         # create + switch
git checkout -b <name> <base>  # create from a specific starting point
git branch -d <name>           # delete (safe — only if merged)
git branch -D <name>           # force-delete
git branch -vv                 # show what each local branch tracks
```

## Merging
```bash
git merge <branch>             # merge <branch> into your current branch
git merge --no-ff <branch>     # always create a merge commit, even if fast-forward is possible
git merge --abort              # bail out of an in-progress conflicted merge
```
On conflict: edit the file(s), remove the `<<<<<<<`/`=======`/`>>>>>>>`
markers, then:
```bash
git add <file>
git commit
```

## Remotes
```bash
git remote -v                  # list remotes
git remote add <name> <url>    # add a remote
git fetch <remote>              # download, don't merge
git pull <remote> <branch>      # fetch + merge, in one step
git push <remote> <branch>      # upload your commits
git push -u origin <branch>     # push + set up tracking (future push/pull need no args)
```

## Tags
```bash
git tag -a v1.0.0 -m "Release 1.0.0"
git push origin v1.0.0
git tag                         # list tags
```

## Undoing things (safe → risky)
```bash
git restore <file>              # discard unstaged changes to a file
git restore --staged <file>     # unstage a file (keep the edits)
git commit --amend              # fix the message/content of the last commit (before pushing!)
git revert <commit>             # create a new commit that undoes an old one (safe on shared branches)
git reset --hard <commit>       # rewind the branch pointer, discarding changes (destructive — local only)
```

## Forking / PR workflow (no GitHub UI, same underlying commands)
```bash
# on the maintainer's clone:
git remote add <contributor-name> <path-or-url-to-their-fork>
git fetch <contributor-name>
git checkout -b <branch> <contributor-name>/<branch>
# ...review...
git checkout main
git merge --no-ff <branch> -m "Merge pull request: ..."
git push origin main

# on the contributor's fork, to stay in sync:
git remote add upstream <original-repo-url>
git fetch upstream
git merge upstream/main
git push origin main
```
