#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
# 🚀 MODERN ROFI LAUNCHER - r/unixporn Style
# ═══════════════════════════════════════════════════════════════════

# Launch rofi with our modern theme
rofi -show drun \
     -theme ~/.config/rofi/themes/modern.rasi \
     -show-icons \
     -drun-display-format "{name}" \
     -disable-history \
     -sort \
     -sorting-method fzf \
     -matching fuzzy