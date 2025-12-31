[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE) [![Doom Emacs](https://img.shields.io/badge/Doom%20Emacs-config-4c1)](https://doomemacs.org)

# personalDoomConfig

A compact, portable Doom Emacs configuration for Baba Gnu — **Emacs v28+**, notable support: **Org**, **Rust**, **LSP**, **treemacs**, **vterm**.

⚡ Overview

This repository contains the Doom Emacs configuration files stored in `~/.config/doom`:

- `config.el` — Personal configuration: keybindings, settings, UI tweaks.
- `init.el` — Enabled Doom modules and core module configuration.
- `packages.el` — Additional packages to install with Doom.
- `custom.el` — Machine-specific or Emacs-managed customizations.
- `snippets/` — Yasnippet snippets used by the config.

Quick summary (at-a-glance)

- **Core features:** Doom UI (theme, modeline, dashboard), workspace support, `treemacs` project drawer, `vterm`, persistent undo and `magit` for Git.
- **Completion & navigation:** `company`, `corfu` (with orderless/icons/dabbrev), and `vertico` (with icons/childframe) for fast completion and searching.
- **Editing:** `evil` mode, snippets, format-on-save, multiple cursors, whitespace trimming, and smartparens-enabled defaults.
- **Tools & LSP:** `lsp` (eglot + peek), `tree-sitter`, `llm` (LLM integrations), eval overlays, and PDF support.
- **Languages with extra support:** `org` (roam/brain/contacts/noter/pretty/pandoc), `rust` (lsp + tree-sitter), `emacs-lisp`, `json`, `markdown`, `sh`, and `cc` (C/C++ with LSP).
- **Quality checks:** Syntax checking and spell checking (flyspell).

> Summary generated from `init.el` (modules enabled as of 2025-12-30).

🎯 Goals

- Provide a reproducible, portable Doom configuration.
- Keep customizations concise and documented.
- Allow easy onboarding on a new machine.

Prerequisites

- GNU Emacs (v28+ recommended)
- Git
- Doom Emacs: the core repository at `~/.emacs.d` (see install step)

Installation

1. Install Doom Emacs (if you haven't already):

   ```bash
   git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
   ~/.emacs.d/bin/doom install
   ```

2. Place these config files in `~/.config/doom` (this repo is already laid out for that):

   ```bash
   # Option A: clone directly to ~/.config/doom
   git clone https://github.com/BabaGnu/personalDoomConfig ~/.config/doom

   # Option B: if you copy files, ensure they live in ~/.config/doom
   rsync -av . ~/.config/doom/
   ```

3. Sync Doom to install packages and apply changes:

   ```bash
   ~/.emacs.d/bin/doom sync
   # or, if `doom` is on PATH
   doom sync
   ```

4. Restart Emacs (or run `doom sync` and `doom build` as needed).

Configuration files

- `init.el`: Select modules here — uncomment or configure the modules you want.
- `packages.el`: Add package declarations using `package!`.
- `config.el`: Your personal configuration lives here (hooks, settings, keybinds).
- `custom.el`: Emacs writes machine-specific `customize` settings here; do not commit secrets.
- `snippets/`: Yasnippet snippets, organized per mode.

Tips & Maintenance

- After adding a package, run `doom sync` to install it.
- Keep `custom.el` out of version control if you want machine-specific settings not tracked here.
- Use `doom doctor` to check for common issues.

Contributing

If you want to contribute or suggest improvements:

- Open an issue or PR on https://github.com/BabaGnu/personalDoomConfig
- Keep changes small and documented in the commit message

Acknowledgements

- Portions of this configuration were adapted from Josh Blais's "Literate Doom Emacs config": https://joshblais.com/blog/literate-doom-emacs-config/
- An AI assistant (GitHub Copilot, Raptor mini (Preview)) was used to review, correct, and enhance parts of this configuration.

License

This repository does not include an explicit license. Add one if you want to permit reuse.

Contact

Repository: https://github.com/BabaGnu/personalDoomConfig

Status: Pushed to GitHub (2025-12-30)

---

*Generated README for Doom Emacs config.*
