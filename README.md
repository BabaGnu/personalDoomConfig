[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE) [![Doom Emacs](https://img.shields.io/badge/Doom%20Emacs-config-4c1)](https://doomemacs.org)

# personalDoomConfig

A powerful, high-performance Doom Emacs configuration for Baba Gnu — **Emacs v30+ (PGTK/Wayland optimized)**, featuring advanced navigation, agentic coding with **gptel**, and a rich **Org-mode** ecosystem.

⚡ Overview

This repository contains the Doom Emacs configuration files stored in `~/.config/doom`:

- `config.el` — Performance optimizations, advanced navigation, and package configurations.
- `init.el` — Enabled Doom modules (Vertico, Corfu, LSP, Rust, etc.).
- `packages.el` — Strategic additions: Avy, Dogears, Deadgrep, Gptel, and more.

🚀 Key Features & Upgrades

### 🔍 Search & Navigation (Omni-capable)
*   **Buffer Search**: `SPC s b` (Consult-line) with live previews.
*   **Project Search**: `SPC s p` (Ripgrep) and `SPC s d` (Deadgrep for long-running searches).
*   **File Discovery**: `SPC s f` (Consult-fd) for lightning-fast file finding.
*   **Jump anywhere**: `SPC j j` (Avy) for character jumping; `SPC j w` for word jumping.
*   **Contextual Jump**: `SPC j u/i` (Dogears) for persistent "back/forward" history across buffers.
*   **Symbol Mastery**: `M-i` (Symbol Overlay) to highlight and jump between instances; `SPC s i` (Imenu) to jump to code definitions.
*   **Mass Edit**: **Wgrep** integration allows editing search results directly, applying changes across the whole project simultaneously.

### 🤖 Agentic Coding & AI (Local First)
*   **Integrated LLM**: Powered by **gptel** (`SPC g c`).
*   **Model**: Configured for **Qwen3-Coder:30B** via local Ollama instance.
*   **Workflow**: Seamless chat and code insertion directly into your active buffer.

### 🍱 The "Ultimate" Org Ecosystem
*   **Zettelkasten**: Full `org-roam` and `denote` integration for structured note-taking.
*   **Aesthetics**: Premium look with `org-modern`, `org-superstar`, and `valign`.
*   **Organization**: Custom high-visibility TODO keywords, custom priorities (A-C), and detailed capture templates (Tasks, Meetings, Journaling, Habits).
*   **Project Management**: Custom Agenda views for daily dashboards and weekly reviews.

### 🛠️ Language & Development
*   **Rust**: Top-tier support with `rustic`, `rust-analyzer`, and `tree-sitter`.
*   **C/C++**: Full LSP support via Eglot/Clangd.
*   **Shell**: Optimised `vterm` and `eshell` support.
*   **UI Helpers**: Format-on-save, `smartparens`, and `multiple-cursors` (`SPC e`) for bulk edits.

### 📖 Reading & Accessibility
*   **EPUB Support**: Native `.epub` reading via `nov.el` with reader-optimized typography (Olivetti mode).
*   **Voice**: `read-aloud` integration (`SPC o v`) for Text-to-Speech support, including a custom engine to read PDF pages.

### 🏎️ Performance & System (PGTK/Wayland)
*   **Emacs 30.2 Hardware Accel**: Optimized for PGTK/Wayland (no resizing flicker, native clipboard, pixel-wise scrolling).
*   **Native Comp**: Optimized for 8-core compilation (`comp-async-jobs-number 8`).
*   **Garbage Collection**: Uses `gcmh` (Garbage Collection Magic Hack) for stutter-free editing.
*   **UI**: **Poet** theme with **FiraCode Nerd Font** (Size 20) and relative line numbers for efficient Vim movement.

> Fully updated to align with `config.el` as of February 2026.

🎯 Goals

- **Performance**: Sub-second responsiveness through aggressive GC and buffer management.
- **Portability**: A single, self-documenting Doom setup for any modern Linux environment.
- **Velocity**: Minimizing keystrokes via Avy, Consult, and advanced Evil-mode integration.

Prerequisites

- **GNU Emacs**: v29+ required (v30.2 PGTK recommended for Wayland).
- **Core Tools**: `ripgrep` (rg), `fd-find` (fd), `git`.
- **Language Servers**: `rust-analyzer`, `clangd`.
- **Fonts**: `FiraCode Nerd Font`, `Fira Sans`, `DejaVu Sans`.

Installation

1. Install Doom Emacs:
   ```bash
   git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
   ~/.emacs.d/bin/doom install
   ```

2. Clone this repo to `~/.config/doom`:
   ```bash
   git clone https://github.com/BabaGnu/personalDoomConfig ~/.config/doom
   ```

3. Sync Doom:
   ```bash
   doom sync
   ```

License

Distributed under the MIT License. See `LICENSE` for more information.

---

*Configured and refined by Antigravity (Advanced Agentic Coding).*
