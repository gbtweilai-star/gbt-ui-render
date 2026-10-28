#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_ui_render info
PYTHONPATH=src python -m gbt_ui_render check --payload '{}'
PYTHONPATH=src python -m gbt_ui_render run   --payload '{}'
