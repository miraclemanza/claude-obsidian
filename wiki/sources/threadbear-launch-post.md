---
type: source
title: "Threadbear Launch Post (Thai social post)"
source_type: social-post
author: "@GitHub (credited); project by mikecann"
date_published: 2026-11-16
url: "https://github.com/mikecann/threadbear"
confidence: medium
key_claims:
  - "Open-source macOS app that drives Claude Code / Codex with the user's existing CLI logins"
  - "UI is separated from a background runner; agents keep working when the app is closed or updated"
  - "Decision buttons, Inbox/Running/Archive, iPhone companion via self-hosted Convex, TypeScript patches"
  - "MIT licence; needs Apple silicon, macOS 26+, Xcode 26+, Node 24+, Convex account"
created: 2026-11-16
updated: 2026-11-16
tags:
  - source
  - agent-tooling
  - claude-code
  - macos
status: current
related:
  - "[[Threadbear]]"
  - "[[claude-obsidian-ecosystem]]"
sources:
  - "[[Threadbear]]"
raw_file: ".raw/articles/threadbear-thai-post-2026-11-16.md"
---

# Threadbear Launch Post (Thai social post)

## Summary

Thai-language social post promoting [[Threadbear]], an open-source macOS app for launching Claude Code or Codex jobs and then closing the app. A separate background runner owns the agents; anything needing the user's answer or approval collects in an Inbox. The post lists five headline features and the install requirements.

## Key Claims (post) vs. README check

Checked 2026-11-16 against the live `mikecann/threadbear` GitHub page (README, file list, commit messages) fetched this session.

| Claim in post | README check |
|---|---|
| Open source, MIT | Confirmed: LICENSE is MIT (commit "Ready for going public: an MIT licence…"). |
| Uses existing Claude Code / Codex CLI logins | Confirmed: drives official `claude` and `codex` CLIs "logged in as you", never reads or copies login tokens. **Post is incomplete**: README now also lists Grok, Cursor and OpenCode threads (titles and librarian need a Claude login). |
| Decision buttons | Confirmed ("Decisions": choices as buttons). |
| Inbox / Running / one-click Archive | Confirmed ("Inbox zero"). |
| Background runner survives quit/update | Confirmed ("A separate little process called the runner owns the agents"). |
| iPhone companion via self-hosted Convex | Confirmed: iPhone app on the App Store; backend deploys to the user's own Convex account. Post says "approve commands"; README shows approving a command from the iPhone. |
| TypeScript patches, agent can write them | Confirmed ("A patch is a little TypeScript file that adds panels and buttons, and your agent can write one for you"). |
| Requires Apple silicon, macOS 26+, Xcode 26+, Node 24+, Convex account | Confirmed ("Xcode 26 or newer, Node 24 or newer, free Convex account"). README also requires the GitHub CLI (`gh`) and a logged-in Claude Code or Codex. **Post omits `gh`.** |

## Not in the post (from the README)

- Install: `gh repo fork mikecann/threadbear --clone && ./threadbear setup`, or paste the README's agent prompt into Claude Code/Codex (it audits the code against `docs/on-your-mac.md` first, then follows `INSTALL.md`).
- Extras: Options window (agent shows designs side by side), a "librarian" that files threads into projects, schedules across Macs, per-thread web links, daily signed releases merged by a "Bring Them In" thread.
- Repo state at fetch: ~160 stars, 210 forks, 2,678 commits on `main`.

> [!contradiction] Native app is mid-migration
> Recent commit "Freeze the Swift app: refuse new code in app/ and dock/ in Mike's copy" says the author now uses a GPUI app daily and new code goes in `desktop/`; forks only get warned once a release ships the GPUI app. The post and README describe "the Mac app" without mentioning this. Re-check before relying on the Swift/Xcode requirement.

## Entities Mentioned

- [[Threadbear]], the project (new page)
- Convex (backend), Claude Code, Codex: no pages yet

## Concepts Introduced

None new. Relevant to the existing [[claude-obsidian-ecosystem]] only as adjacent agent-tooling, not an Obsidian integration.

## Notes

- Source-trace: all rows above come from the fetched README page (source type a). The post itself is secondary; it is a promotional summary.
- Not verified: star/fork counts beyond the snapshot, App Store listing, launch-video content.
