---
type: entity
title: "Threadbear"
entity_type: product
created: 2026-11-16
updated: 2026-11-16
tags:
  - github-repo
  - macos
  - claude-code
  - codex
  - agent-tooling
status: current
related:
  - "[[claude-obsidian-ecosystem]]"
sources:
  - "[[threadbear-launch-post]]"
---

# Threadbear

**Type**: Open-source macOS app (MIT) for running coding-agent threads
**URL**: https://github.com/mikecann/threadbear · site https://threadbear.mikecann.app/
**Author**: mikecann

## What it is

A Mac app that runs Claude Code, Codex (and per README: Grok, Cursor, OpenCode) threads on the user's existing subscriptions by driving the official CLIs under the user's own login. A separate runner process owns the agents, so quitting or updating the app never stops a turn.

## Features

- **Decisions**: agent questions become buttons.
- **Inbox / Running / Archive**: only threads needing the user sit in the inbox.
- **Options**: agent shows design alternatives side by side.
- **Librarian**: files new threads into projects, no project picker.
- **Phone + web**: iPhone app and per-thread web page via the user's own Convex deployment; approve commands from the phone.
- **Patches**: TypeScript files adding panels/buttons; an agent can write them.
- **Fork model**: users fork; daily signed releases merge in via a "Bring Them In" thread.
- **Schedules** across multiple Macs.

## Requirements

Apple silicon Mac, macOS 26+, Xcode 26+, Node 24+, logged-in Claude Code or Codex, free Convex account, GitHub CLI (`gh`). Install: `gh repo fork mikecann/threadbear --clone && ./threadbear setup`.

## Caveats

- The Swift app is being frozen in favour of a GPUI app under `desktop/` (see [[threadbear-launch-post]]).
- Privacy: messages go to the user's own Convex deployment; tool output stays local until a phone or second machine is paired, then offered (scrubbed, "not a guarantee").
- Relevance to this vault: none directly; adjacent agent tooling.
