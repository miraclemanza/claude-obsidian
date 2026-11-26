#!/usr/bin/env bash
# install-claude-tools.sh — install the 5-tool Claude Code stack, in the order listed (5 -> 1).
#
#   5. Find Skills   https://skills.sh                                   (npx skills)
#   4. Task Observer https://github.com/rebelytics/one-skill-to-rule-them-all (npx skills)
#   3. Impeccable    https://github.com/pbakaus/impeccable              (npx impeccable)
#   2. Claude Mem    https://github.com/thedotmack/claude-mem           (npx claude-mem)
#   1. Superpowers   https://github.com/obra/superpowers                (/plugin only)
#
# Every command below comes from the respective README / skills.sh page (fetched 2026-11-18).
# NOT verified: whether `claude plugin ...` CLI equivalents of the /plugin slash commands
# exist on your version, so plugin-only steps are PRINTED for you to paste into Claude Code.
#
# Safe by default: nothing runs unless you pass --run. Default is a dry run.
#
# Usage:
#   scripts/install-claude-tools.sh [--run] [--only a,b,c] [--skip a,b] [--scope project|global]
#   Tool names: find-skills, task-observer, impeccable, claude-mem, superpowers
#
# Privacy defaults (override with --allow-telemetry / --claude-mem-account):
#   * claude-mem: CLAUDE_MEM_ONLINE_OPTIN=false (skips sign-in/trial), telemetry disabled afterwards
#   * impeccable: telemetry turned off afterwards
# claude-mem records session observations in ~/.claude-mem — do not run it in sessions
# containing identifiable patient data.

set -uo pipefail

RUN=0
SCOPE="global"
ONLY=""
SKIP=""
TELEMETRY_OFF=1
CM_OPTIN="false"

usage() { sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'; }

while [ $# -gt 0 ]; do
  case "$1" in
    --run) RUN=1 ;;
    --dry-run) RUN=0 ;;
    --only) ONLY="${2:-}"; shift ;;
    --skip) SKIP="${2:-}"; shift ;;
    --scope) SCOPE="${2:-}"; shift ;;
    --allow-telemetry) TELEMETRY_OFF=0 ;;
    --claude-mem-account) CM_OPTIN="true" ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
  shift
done

case "$SCOPE" in project|global) ;; *) echo "--scope must be project or global" >&2; exit 2 ;; esac

selected() {
  local t="$1"
  if [ -n "$ONLY" ]; then case ",$ONLY," in *",$t,"*) ;; *) return 1 ;; esac; fi
  case ",$SKIP," in *",$t,"*) return 1 ;; esac
  return 0
}

FAILED=()
MANUAL=()

step() { printf '\n==> %s\n' "$1"; }

# run_cmd <tool> <cmd...>: print, and execute only with --run
run_cmd() {
  local tool="$1"; shift
  printf '    $ %s\n' "$*"
  if [ "$RUN" -eq 1 ]; then
    "$@" || { echo "    !! failed: $*" >&2; FAILED+=("$tool"); return 1; }
  fi
  return 0
}

need_node() {
  if ! command -v npx >/dev/null 2>&1; then
    echo "npx not found — install Node.js (claude-mem needs 20.19+ in 20.x or 22.12+) first." >&2
    exit 1
  fi
  if command -v node >/dev/null 2>&1; then
    echo "node $(node --version)"
  fi
}

[ "$RUN" -eq 1 ] && echo "MODE: executing" || echo "MODE: dry run (pass --run to execute)"
[ "$RUN" -eq 1 ] || true
need_node

GFLAG=()
[ "$SCOPE" = "global" ] && GFLAG=(-g)

# ---- 5. Find Skills -------------------------------------------------------
if selected find-skills; then
  step "5/5 Find Skills (vercel-labs/skills)"
  # Snyk audit on skills.sh showed 'Warn' on 2026-11-18 — review before running.
  run_cmd find-skills npx skills add https://github.com/vercel-labs/skills --skill find-skills "${GFLAG[@]}"
fi

# ---- 4. Task Observer -----------------------------------------------------
if selected task-observer; then
  step "4/5 Task Observer (rebelytics/one-skill-to-rule-them-all)"
  run_cmd task-observer npx skills@1.8.1 add rebelytics/one-skill-to-rule-them-all --skill task-observer "${GFLAG[@]}"
  MANUAL+=("Task Observer ACTIVATION (installing alone is not enough):
    - add the session-start hook and the 31-line activation block from
      skills/task-observer/references/environments.md (in the skill folder) to your CLAUDE.md
    - verify in a NEW session with ordinary work that does not name the skill; then check that
      skill-observations/observation-log/ exists
    - keep skill-observations/ and skill-updates/ out of this vault's wiki/ (or .gitignore them)
    - plugin alternative (inside Claude Code):
        /plugin marketplace add rebelytics/one-skill-to-rule-them-all
        /plugin install task-observer@one-skill-to-rule-them-all
        /reload-plugins")
fi

# ---- 3. Impeccable --------------------------------------------------------
if selected impeccable; then
  step "3/5 Impeccable (pbakaus/impeccable)"
  echo "    (run from the project root; the installer asks about the design hook — accept it, but review"
  echo "     it: hooks run even when the model's own commands are denied)"
  run_cmd impeccable npx impeccable install --providers=claude --scope="$SCOPE"
  [ "$TELEMETRY_OFF" -eq 1 ] && run_cmd impeccable npx impeccable telemetry off
  MANUAL+=("Impeccable: reload Claude Code, then run  /impeccable init
    (alt: /plugin marketplace add pbakaus/impeccable, then install from /plugin)")
fi

# ---- 2. Claude Mem --------------------------------------------------------
if selected claude-mem; then
  step "2/5 Claude Mem (thedotmack/claude-mem)"
  echo "    NOTE: do NOT 'npm install -g claude-mem' — that installs the SDK only (no hooks/worker)."
  printf '    $ CLAUDE_MEM_ONLINE_OPTIN=%s npx claude-mem install\n' "$CM_OPTIN"
  if [ "$RUN" -eq 1 ]; then
    CLAUDE_MEM_ONLINE_OPTIN="$CM_OPTIN" npx claude-mem install \
      || { echo "    !! failed: claude-mem install" >&2; FAILED+=("claude-mem"); }
  fi
  [ "$TELEMETRY_OFF" -eq 1 ] && run_cmd claude-mem npx claude-mem telemetry disable
  MANUAL+=("Claude Mem: restart Claude Code. Memory lives in ~/.claude-mem.
    (alt: /plugin marketplace add thedotmack/claude-mem, then /plugin install claude-mem)")
fi

# ---- 1. Superpowers (plugin-only; no verified shell install) ---------------
if selected superpowers; then
  step "1/5 Superpowers (obra/superpowers)"
  echo "    Plugin-only — paste inside Claude Code (not run by this script)."
  MANUAL+=("Superpowers (official marketplace):
        /plugin install superpowers@claude-plugins-official
    or (author's marketplace):
        /plugin marketplace add obra/superpowers-marketplace
        /plugin install superpowers@superpowers-marketplace")
fi

# ---- Summary ----------------------------------------------------------------
echo
echo "================ MANUAL STEPS (inside Claude Code / editor) ================"
for m in "${MANUAL[@]:-}"; do [ -n "$m" ] && printf '\n- %s\n' "$m"; done

echo
if [ "$RUN" -eq 0 ]; then
  echo "Dry run complete — nothing was executed. Re-run with --run to install."
elif [ "${#FAILED[@]}" -gt 0 ]; then
  echo "Finished with failures: ${FAILED[*]}" >&2
  exit 1
else
  echo "Finished. Restart Claude Code, then complete the manual steps above."
fi
