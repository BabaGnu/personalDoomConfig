;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! You do not need to run 'doom sync'
;; after modifying this file for most changes.

;; ============================================================================
;; Performance Optimizations
;; ============================================================================
;; Raise GC threshold and disable file-name handlers during init to speed up
;; startup; restore them shortly after Emacs starts.
(defvar my/gc-cons-threshold--saved gc-cons-threshold)
(setq gc-cons-threshold (* 256 1024 1024))  ;; 256MB for faster startup

(defvar my/file-name-handler-alist--saved file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Increase read buffer for subprocess output (useful for LSP backends)
(setq read-process-output-max (* 8 1024 1024))  ;; 8MB

;; Native compilation optimizations (guarded for older Emacsen)
(when (boundp 'comp-deferred-compilation)
      (setq comp-deferred-compilation t))  ;; Defer native compilation for faster startup
(when (boundp 'comp-async-jobs-number)
      (setq comp-async-jobs-number 8))     ;; Number of async compilation jobs

;; Frame performance optimizations (applies to all window systems)
(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t)

;; Focus and mouse settings (works for both X11 and Wayland)
(setq focus-follows-mouse nil)      ;; Prevent focus from following mouse
(setq mouse-autoselect-window nil)   ;; Don't auto-select window on mouse move

;; Version control optimization (limit to Git only for better performance)
(setq vc-handled-backends '(Git))

;; Garbage Collection Magic Hack (gcmh) - optimizes GC timing
(use-package! gcmh
  :config
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold (* 128 1024 1024))  ;; 128MB (safer default)
  (gcmh-mode 1))

;; Restore GC settings after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (run-with-timer
             1 nil
             (lambda ()
               (setq gc-cons-threshold (or my/gc-cons-threshold--saved (* 32 1024 1024)))
               (setq file-name-handler-alist my/file-name-handler-alist--saved)))))
;;
;; ============================================================================
;; Wayland & Emacs 30.2 Specific Optimizations
;; ============================================================================
;; Optimizations for CachyOS (Arch-based) with Wayland and Emacs 30.2
;;
;; PGTK (Pure GTK) backend optimizations for Wayland
(when (eq window-system 'pgtk)
  ;; Better event handling for Wayland
  (setq pgtk-wait-for-event-timeout nil)
  ;;
  ;; Disable input method context if not using IME (improves performance)
  (setq pgtk-use-im-context nil)
  ;;
  ;; Enable Wayland-native clipboard integration
  (setq select-enable-clipboard t
        select-enable-primary t
        save-interprogram-paste-before-kill t)

  ;; Better Wayland window management
  (setq frame-resize-pixelwise t
        frame-inhibit-implied-resize t))
;;
;; ;; Emacs 30.2 specific optimizations
(when (>= emacs-major-version 30)
  ;; Better font rendering on Wayland
  (setq font-lock-maximum-decoration t)
  ;;
  ;; Improved scrolling performance
  (setq scroll-margin 3
        scroll-step 1
        scroll-conservatively 10000
        scroll-preserve-screen-position t)

  ;; Native compilation improvements in Emacs 30+
  (when (boundp 'native-comp-speed)
    (setq native-comp-speed 3))  ;; Maximum optimization level
  ;;
  ;; CachyOS/Arch-specific: Better integration
  (when (file-exists-p "/etc/arch-release")
    ;; Use system's default font rendering if available
    ;; (setq font-use-system-font t)

    ;; Better integration with the desktop environment
    (setq desktop-save-mode t)))

;; ============================================================================
;; File Management Settings
;; ============================================================================
;; Send files to trash instead of fully deleting (safer)
(setq delete-by-moving-to-trash t)

;; Auto-save files automatically
(setq auto-save-default t)

;; ============================================================================
;; User Information
;; ============================================================================
;; (setq user-full-name "Baba Gnu"
;;       user-mail-address "babagnu@outlook.com")

;; Auth sources for GPG, email, and other authentication
(setq auth-sources '("~/.authinfo.gpg" "~/.authinfo")
      auth-source-cache-expiry nil)  ;; Default is 7200 (2h), nil = no expiry
;; ============================================================================
;; Fonts and Typography
;; ============================================================================
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 20 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 22))
;;
;; ============================================================================
;; Theme and Appearance
;; ============================================================================
(setq doom-theme 'poet)
;; (setq doom-theme 'doom-one)

;; Line numbers - use relative for better navigation (like vim)
(setq display-line-numbers-type 'relative)
;; Visual line wrapping (soft wrap, doesn't insert newlines)
(global-visual-line-mode t)

;; Cursor blink
(blink-cursor-mode 1)


;; Remove top frame bar (cleaner look, especially for keyboard-driven workflow)
;; (add-to-list 'default-frame-alist '(undecorated . t))

;; Transparency (optional - uncomment if you want transparent Emacs)
;; (set-frame-parameter (selected-frame) 'alpha '(96 . 97))
;; (add-to-list 'default-frame-alist '(alpha . (96 . 97)))
;;
;; ;; ============================================================================
;; ;; Modeline Configuration
;; ;; ============================================================================
(setq doom-modeline-height 18
      doom-modeline-icon t                    ;; Show icons
      doom-modeline-major-mode-icon t         ;; Show major mode icon
      doom-modeline-lsp-icon t                ;; Show LSP icon
      doom-modeline-major-mode-color-icon t   ;; Color code major mode icons
      doom-modeline-buffer-file-name-style 'truncate-with-project
      doom-modeline-enable-word-count nil
      doom-modeline-check-simple-format t
      doom-modeline-number-limit 3
      doom-modeline-vcs-max-length 12
      doom-modeline-workspace-name t
      doom-modeline-persp-name t
      doom-modeline-project-detection 'auto)

;; ============================================================================
;; Completion System Configuration
;; ============================================================================
;; Enhanced completion with Vertico, Consult, Marginalia, and Embark

;; Completion mechanisms
(setq completing-read-function #'completing-read-default)
(setq read-file-name-function #'read-file-name-default)

;; Case-insensitive completion (makes path completion more intuitive)
(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

;; Use the familiar C-x C-f interface for directory completion
(map! :map minibuffer-mode-map
      :when (featurep! :completion vertico)
      "C-x C-f" #'find-file)

;; Save minibuffer history - enables command history in M-x
(use-package! savehist
  :config
  (setq savehist-file (concat doom-cache-dir "savehist")
        savehist-save-minibuffer-history t
        history-length 1000
        history-delete-duplicates t
        savehist-additional-variables '(search-ring
                                        regexp-search-ring
                                        extended-command-history))
  (savehist-mode 1))

;; Vertico enhancements
(after! vertico
  ;; Add file preview and directory navigation
  (add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)
  (define-key vertico-map (kbd "DEL") #'vertico-directory-delete-char)
  (define-key vertico-map (kbd "M-DEL") #'vertico-directory-delete-word)

  ;; Make vertico use a more minimal display
  (setq vertico-count 17
        vertico-cycle t
        vertico-resize t)

  ;; Enable alternative filter methods
  (setq vertico-sort-function #'vertico-sort-history-alpha)

  ;; Quick actions keybindings
  (define-key vertico-map (kbd "C-j") #'vertico-next)
  (define-key vertico-map (kbd "C-k") #'vertico-previous)
  (define-key vertico-map (kbd "M-RET") #'vertico-exit-input)

  ;; History navigation
  (define-key vertico-map (kbd "M-p") #'vertico-previous-history)
  (define-key vertico-map (kbd "M-n") #'vertico-next-history)
  (define-key vertico-map (kbd "C-r") #'consult-history))

;; Configure orderless for better filtering
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((file (styles basic partial-completion orderless))))

;; Customize orderless behavior
(setq orderless-component-separator #'orderless-escapable-split-on-space
      orderless-matching-styles '(orderless-literal
                                  orderless-prefixes
                                  orderless-initialism
                                  orderless-flex
                                  orderless-regexp))

;; Quick command repetition - removed `vertico-repeat` (personal)
;; The following `use-package!` block was removed because it caused
;; `doom sync` to attempt cloning `vertico-repeat` and fail on this system.

;; Enhanced marginalia annotations
(after! marginalia
      (setq marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light))
      ;; Show more details in marginalia
      (setq marginalia-max-relative-age 0
                        marginalia-align 'right))

;; Embark configuration
(map! :leader
      (:prefix ("k" . "embark")  ;; Using 'k' prefix to avoid conflicts
       :desc "Embark act" "a" #'embark-act
       :desc "Embark dwim" "d" #'embark-dwim
       :desc "Embark collect" "c" #'embark-collect))

;; Configure consult for better previews
(after! consult
  (setq consult-preview-key "M-."
        consult-ripgrep-args "rg --null --line-buffered --color=never --max-columns=1000 --path-separator /   --smart-case --no-heading --with-filename --line-number --search-zip"
        consult-narrow-key "<"
        consult-line-numbers-widen t
        consult-async-min-input 2
        consult-async-refresh-delay 0.15
        consult-async-input-throttle 0.2
        consult-async-input-debounce 0.1)

  ;; More useful previews for different commands
  (consult-customize
   consult-theme consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   :preview-key '(:debounce 0.4 any)))

;; Enhanced directory navigation
(use-package! consult-dir
  :bind
  (("C-x C-d" . consult-dir)
   :map vertico-map
   ("C-x C-d" . consult-dir)
   ("C-x C-j" . consult-dir-jump-file)))

;; ============================================================================
;; Advanced Navigation & Search (All Possible Ways)
;; ============================================================================

;; 0. Consult-Projectile integration
(use-package! consult-projectile
  :after (consult projectile))

(defun consult-projectile-grep ()
  "Search with ripgrep in the current project using consult."
  (interactive)
  (consult-ripgrep (projectile-project-root)))

;; 1. Avy: The "God-speed" jump tool
(use-package! avy
  :config
  (setq avy-all-windows t
        avy-background t
        avy-style 'at-full))

;; 2. Dogears: Global back/forward button that works
(use-package! dogears
  :config
  (dogears-mode 1)
  (setq dogears-idle-interval 1.0))

;; 3. Deadgrep: Powerful search buffer
(use-package! deadgrep
  :commands (deadgrep))

;; 4. Symbol Overlay: Quick highlighting and jumping
(use-package! symbol-overlay
  :config
  (setq symbol-overlay-idle-time 0.1))

;; 5. Search & Jump Keybindings
(map! :leader
      (:prefix-map ("s" . "search")
       :desc "Search within buffer"       "b" #'consult-line
       :desc "Search all open buffers"    "B" #'consult-line-multi
       :desc "Search project (rg)"        "p" #'consult-ripgrep
       :desc "Search project (P-rg)"      "P" #'consult-projectile-grep
       :desc "Search project (deadgrep)"  "d" #'deadgrep
       :desc "Search project (fd)"        "f" #'consult-fd
       :desc "Search TODOs"               "t" #'consult-todo
       :desc "Search project TODOs"       "T" #'+vertico/project-todo
       :desc "Symbols (Imenu)"            "i" #'consult-imenu
       :desc "Global History"             "h" #'consult-history
       :desc "Recent directories"         "D" #'consult-dir)

      (:prefix-map ("j" . "jump")
       :desc "Jump to char"               "j" #'avy-goto-char-timer
       :desc "Jump to line"               "l" #'avy-goto-line
       :desc "Jump to word"               "w" #'avy-goto-word-1
       :desc "Jump to symbol"             "s" #'symbol-overlay-put
       :desc "Jump to last change"        "e" #'goto-last-change
       :desc "Jump back (dogears)"        "u" #'dogears-back
       :desc "Jump forward (dogears)"     "i" #'dogears-forward
       :desc "Jump to bookmark"           "b" #'consult-bookmark
       :desc "Jump in list"               "m" #'consult-mark))

;; M-i for quick symbol highlighting/navigation
(map! "M-i" #'symbol-overlay-put
      :map symbol-overlay-map
      "n" #'symbol-overlay-jump-next
      "p" #'symbol-overlay-jump-prev
      "d" #'symbol-overlay-remove-all)
;;
;; ;; ============================================================================
;; ;; Company Configuration
;; ;; ============================================================================
;; ;; Company and Corfu can work together, but here's the recommendation:
;; ;;
;; ;; **RECOMMENDATION: Use Corfu only** (it's faster, more modern, and less intrusive)
;; ;; - Corfu shows completion inline (like VS Code)
;; ;; - Company shows popup tooltips (more traditional)
;; ;; - Using both can cause conflicts and confusion
;; ;;
;; ;; **If you want to use both:**
;; ;; - Corfu for general code completion (default)
;; ;; - Company for specific backends (like company-files for path completion)
;; ;; - Requires careful configuration to avoid conflicts
;; ;;
;; ;; **If you want to use Company only:**
;; ;; - Disable corfu in init.el
;; ;; - Company will handle all completion
;; ;;
;; ;; Current setup: Both enabled - Corfu is primary, Company is available for specific use cases
;;
(after! company
  ;; Disable company-mode globally (we'll use corfu as primary)
  ;; Company will only activate for specific backends we configure
  (setq company-global-modes '(not org-mode text-mode))

  ;; Only enable company for specific use cases (like file paths)
  (setq company-idle-delay nil  ;; Don't auto-trigger (use corfu instead)
        company-tooltip-idle-delay nil)
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.1
        company-show-quick-access t
        company-tooltip-limit 20
        company-tooltip-align-annotations t)

  ;; Make company-files a higher priority backend
  (setq company-backends (cons 'company-files (delete 'company-files company-backends)))

  ;; Better file path completion settings
  (setq company-files-exclusions nil)
  (setq company-files-chop-trailing-slash t)

  ;; Enable completion at point for file paths
  (defun my/enable-path-completion ()
    "Enable file path completion using company."
    (setq-local company-backends
                (cons 'company-files company-backends)))

  ;; Enable for all major modes
  (add-hook 'after-change-major-mode-hook #'my/enable-path-completion)

  ;; Custom file path trigger
  (defun my/looks-like-path-p (input)
    "Check if INPUT looks like a file path."
    (or (string-match-p "^/" input)         ;; Absolute path
        (string-match-p "^~/" input)        ;; Home directory
        (string-match-p "^\\.\\{1,2\\}/" input))) ;; Relative path

  (defun my/company-path-trigger (command &optional arg &rest ignored)
    "Company backend that triggers file completion for path-like input."
    (interactive (list 'interactive))
    (cl-case command
      (interactive (company-begin-backend 'company-files))
      (prefix (when (my/looks-like-path-p (or (company-grab-line "\\([^ ]*\\)" 1) ""))
                (company-files 'prefix)))
      (t (apply 'company-files command arg ignored))))

  ;; Add the custom path trigger to backends
  (add-to-list 'company-backends 'my/company-path-trigger)

  ;; Configure company to work alongside corfu
  ;; Company will only activate when explicitly triggered (M-TAB) or for specific backends
  (global-company-mode -1))  ;; Disable global company-mode, use corfu instead

;; ============================================================================
;; Corfu Configuration (Primary Completion System)
;; ============================================================================
;; Corfu is the recommended completion system - faster and more modern
(after! corfu
  ;; Better corfu settings
  (setq corfu-auto t              ;; Enable auto completion
        corfu-auto-delay 0.2     ;; Delay before showing completions
        corfu-auto-prefix 2      ;; Minimum prefix length
        corfu-popupinfo-delay 0.5 ;; Delay for popup info
        corfu-preview-current nil  ;; Don't preview current candidate
        corfu-preselect-first nil ;; Don't preselect first candidate
        corfu-on-exact-match nil  ;; Don't complete on exact match
        corfu-scroll-margin 4     ;; Scroll margin
        corfu-cycle t)            ;; Enable cycling

  ;; Enable corfu globally (preferred) and ensure auto popup is enabled
  (when (fboundp 'global-corfu-mode)
    (global-corfu-mode 1))
  ;; Prevent Company from showing a second tooltip; make Corfu the only
  ;; completion popup in programming buffers.
  (setq company-idle-delay nil
        company-frontends '())
  (add-hook 'prog-mode-hook (lambda ()
                              (company-mode -1)
                              (corfu-mode 1)))
  ;; Enable Corfu automatic popup behavior
  (setq corfu-auto t
        corfu-auto-delay 0.15
        corfu-auto-prefix 1)
  (define-key corfu-map (kbd "M-d") #'corfu-show-documentation)
  (define-key corfu-map (kbd "C-g") #'corfu-quit)

  ;; Use company backends with corfu (via cape)
  (when (featurep 'cape)
    (add-to-list 'completion-at-point-functions #'cape-file)
    (add-to-list 'completion-at-point-functions #'cape-dabbrev)))
;;
;; ;; ============================================================================
;; ;; Evil Mode Configuration
;; ;; ============================================================================
;; ;; Enable Emacs key bindings in insert mode (C-a, C-e, C-k, etc.)
;; Enable Emacs key bindings in insert mode (C-a, C-e, C-k, etc.)
(after! evil
  ;; Enable standard Emacs key bindings in insert state
  (setq evil-disable-insert-state-bindings nil)

  ;; Standard Emacs editing key bindings for insert mode
  (define-key evil-insert-state-map (kbd "C-a") #'beginning-of-line)
  (define-key evil-insert-state-map (kbd "C-e") #'end-of-line)
  (define-key evil-insert-state-map (kbd "C-k") #'kill-line)
  (define-key evil-insert-state-map (kbd "C-w") #'backward-kill-word)
  (define-key evil-insert-state-map (kbd "C-y") #'yank)
  (define-key evil-insert-state-map (kbd "C-u") #'kill-whole-line)
  (define-key evil-insert-state-map (kbd "C-f") #'forward-char)
  (define-key evil-insert-state-map (kbd "C-b") #'backward-char)
  (define-key evil-insert-state-map (kbd "C-n") #'next-line)
  (define-key evil-insert-state-map (kbd "C-p") #'previous-line)
  (define-key evil-insert-state-map (kbd "C-d") #'delete-char)
  (define-key evil-insert-state-map (kbd "C-h") #'delete-backward-char)
  (define-key evil-insert-state-map (kbd "C-t") #'transpose-chars)
  (define-key evil-insert-state-map (kbd "M-f") #'forward-word)
  (define-key evil-insert-state-map (kbd "M-b") #'backward-word)
  (define-key evil-insert-state-map (kbd "M-d") #'kill-word)
  (define-key evil-insert-state-map (kbd "M-<backspace>") #'backward-kill-word))
;;
;; ;; ============================================================================
;; ;; Language-Specific Configuration
;; ============================================================================
(after! rustic
  (setq rustic-lsp-server 'rust-analyzer))
 
;;
;; ============================================================================
;; Org Mode Configuration
;; ============================================================================
;; Org directory and file locations
(setq org-directory (expand-file-name "~/org")
      org-agenda-files (list (expand-file-name "agenda" org-directory)
                             (expand-file-name "projects" org-directory)
                             (expand-file-name "journal" org-directory)
                             (expand-file-name "inbox" org-directory))
      org-default-notes-file (expand-file-name "inbox/inbox.org" org-directory))
;; denote config
;; Additional configurations can go here. For example, to enable completion
;; for keywords, you might use an external package like consult-denote.
;;     (info "(denote) Sample configuration")
(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :bind
  (("C-c d n" . denote)
   ("C-c d r" . denote-rename-file)
   ("C-c d l" . denote-link)
   ("C-c d b" . denote-backlinks)
   ("C-c d d" . denote-dired)
   ("C-c d g" . denote-grep))
  :config
  (setq denote-directory (expand-file-name "~/org/denotes/"))

  ;; Automatically rename Denote buffers when opening them so that
  ;; instead of their long file name they have, for example, a literal
  ;; "[D]" followed by the file's title.  Read the doc string of
  ;; `denote-rename-buffer-format' for how to modify this.
  (denote-rename-buffer-mode 1))


;; Org Roam configuration
(setq org-roam-directory (expand-file-name "roam" org-directory))

;; Org packages configuration
(use-package! org-superstar
  :defer t
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-headline-bullets-list '("◉" "○" "✸" "✿" "•")
        org-superstar-item-bullet-alist '((?* . ?•) (?+ . ?➤) (?- . ?–))))

(use-package! org-modern
  :defer t
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star '("◉" "○" "✸" "✿")
        org-modern-table t
        org-modern-todo t
        org-modern-block t))

(use-package! org-appear
  :defer t
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autosubmarkers t
        org-appear-autolinks t))

(use-package! valign
  :defer t
  :hook (org-mode . (lambda ()
                      (when (display-graphic-p)
                        (valign-mode 1)))))

(use-package! org-journal
  :defer t
  :init
  (setq org-journal-dir (expand-file-name "journal" org-directory)
        org-journal-date-prefix "* "
        org-journal-time-prefix "** "
        org-journal-file-format "%Y-%m-%d.org"
        org-journal-enable-agenda-integration t)
  :config
  (setq org-journal-carryover-items "TODO=\"TODO\"|TODO=\"NEXT\""))

(use-package! org-roam
  :defer t
  :custom
  (org-roam-completion-everywhere t)
  :config
  (add-hook 'org-roam-mode-hook #'org-roam-db-autosync-mode))

;; Org Roam capture templates
(setq org-roam-capture-templates
      '(("d" "default" plain "%?"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
         :unnarrowed t)))

;; Org mode settings
(after! org
  ;; Todo workflow
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "HOLD(h)" "|" "DONE(d)" "CANCELED(c)")))

  (setq org-todo-keyword-faces
        '(("TODO" . "tomato")
          ("NEXT" . "gold")
          ("WAIT" . "orange")
          ("HOLD" . "yellow")
          ("DONE" . "forest green")
          ("CANCELED" . "gray")))

  ;; Priorities: A > B > C
  (setq org-priority-faces
        '((?A . '(:foreground "red" :weight bold))
          (?B . '(:foreground "goldenrod"))
          (?C . '(:foreground "dark turquoise"))))

  ;; Org appearance settings
  (setq org-hide-leading-stars t)

  ;; Custom face setup for headings
  (defun my/org-setup ()
    (set-face-attribute 'org-level-1 nil :font "DejaVu Sans" :weight 'bold :height 1.35)
    (set-face-attribute 'org-level-2 nil :font "DejaVu Sans" :weight 'bold :height 1.3)
    (set-face-attribute 'org-document-title nil :font "FiraCode Nerd Font" :weight 'bold :height 1.8))
  (add-hook 'org-mode-hook #'my/org-setup)

  ;; Habits
  (setq org-habit-graph-column 50
        org-habit-show-habits-only-for-today nil
        org-habit-following-days 7
        org-habit-preceding-days 14)

  ;; Capture templates - enhanced with more practical options
  (setq org-capture-templates
        `(
          ;; t: Task (with better structure)
          ("t" "Task" entry
           (file+headline ,(expand-file-name "projects/tasks.org" org-directory) "Inbox")
           "* TODO %^{Title}\n:PROPERTIES:\n:Project: %^{Project|General}\n:Created: %U\n:END:\n%?%i\n%a"
           :empty-lines 1
           :prepend t)

          ;; T: Task with deadline
          ("T" "Task with Deadline" entry
           (file+headline ,(expand-file-name "projects/tasks.org" org-directory) "Inbox")
           "* TODO %^{Title}\n:PROPERTIES:\n:Project: %^{Project|General}\n:Created: %U\n:END:\nDEADLINE: %^t\n%?%i\n%a"
           :empty-lines 1
           :prepend t)

          ;; n: Note
          ("n" "Note" entry
           (file+headline ,(expand-file-name "agenda/notes.org" org-directory) "Inbox")
           "* %^{Title} :note:%^{Category|idea|meeting|reading|reference|misc}:\n:PROPERTIES:\n:Created: %U\n:END:\n%?%i\n%a"
           :empty-lines 1
           :prepend t)

          ;; m: Meeting note
          ("m" "Meeting" entry
           (file+headline ,(expand-file-name "agenda/notes.org" org-directory) "Meetings")
           "* %^{Meeting Title} :meeting:\n:PROPERTIES:\n:Date: %U\n:Attendees: %^{Attendees}\n:END:\n%?%i\n\n** Agenda\n\n** Notes\n\n** Action Items\n"
           :empty-lines 1
           :prepend t)

          ;; j: Journal
          ("j" "Journal" entry
           (file+datetree ,(expand-file-name "journal/journal.org" org-directory))
           "* %U\n:PROPERTIES:\n:Mood: %^{Mood|😀 Great|🙂 Good|😐 Okay|😕 Meh|😞 Low}\n:Energy: %^{Energy|High|Medium|Low}\n:Focus: %^{Focus|Deep|Shallow|Distracted}\n:END:\n\n** Gratitude\n%^{What are you grateful for today?}\n\n** Top Focus\n%^{Primary focus for today}\n\n** Notes\n%?"
           :empty-lines 1
           :tree-type week)

          ;; q: Quick capture
          ("q" "Quick" entry
           (file+headline ,(expand-file-name "inbox/inbox.org" org-directory) "Quick")
           "* %^{Title}\n%?%i\n%a"
           :empty-lines 1
           :prepend t)

          ;; p: Project
          ("p" "Project" entry
           (file+headline ,(expand-file-name "projects/tasks.org" org-directory) "Projects")
           "* %^{Project Name} :PROJECT:\n:PROPERTIES:\n:Created: %U\n:END:\n%?%i\n\n** Next Actions\n\n** Notes\n"
           :empty-lines 1
           :prepend t)

          ;; h: Habit
          ("h" "Habit" entry
           (file+headline ,(expand-file-name "projects/tasks.org" org-directory) "Habits")
           "* NEXT %^{Habit Name} :habit:\n:PROPERTIES:\n:STYLE: habit\n:Created: %U\n:END:\nSCHEDULED: %^t\n%?"
           :empty-lines 1
           :prepend t)))

  ;; Agenda settings
  (setq org-agenda-start-on-weekday 1
        org-agenda-span 'day
        org-log-done 'time
        org-log-into-drawer t
        org-enforce-todo-dependencies t
        org-agenda-prefix-format '((agenda . " %i %?-12t% s")
                                   (todo   . " %i ")
                                   (tags   . " %i ")
                                   (search . " %i "))
        ;; Better agenda sorting and filtering
        org-agenda-sorting-strategy '((agenda habit-down time-up priority-down category-keep)
                                      (todo priority-down category-keep)
                                      (tags priority-down category-keep)
                                      (search category-keep))
        org-agenda-todo-ignore-scheduled nil
        org-agenda-todo-ignore-deadlines nil
        org-agenda-todo-ignore-with-date nil
        org-agenda-window-setup 'current-window
        org-agenda-restore-windows-after-quit t
        org-agenda-sticky t
        org-agenda-include-diary nil
        org-agenda-include-deadlines t
        org-agenda-include-scheduled t
        org-agenda-deadline-leaders '("Deadline: " "In %d d.: " "%d d. ago: ")
        org-agenda-scheduled-leaders '("Scheduled: " "Sched.%2dx: ")
        org-agenda-time-grid '((daily today require-timed)
                               (800 1000 1200 1400 1600 1800 2000)
                               "......" "----------------")
        org-agenda-current-time-string "⏰ Now ─────────────────────────────────────────────────")

  (setq org-refile-targets '((org-agenda-files :maxlevel . 3)
                             (nil :maxlevel . 3))
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes 'confirm
        org-refile-target-verify-function nil)

  ;; Archive settings
  (setq org-archive-location (concat (expand-file-name "archive" org-directory) "::* From %s")
        org-archive-save-context-info '(time file category itags)
        org-archive-subtree-save-file-p t)

  ;; Clocking (time tracking)
  (setq org-clock-persist 'history
        org-clock-persist-file (expand-file-name ".org-clock-save.el" org-directory)
        org-clock-in-resume t
        org-clock-out-remove-zero-time-clocks t
        org-clock-out-when-done t
        org-clock-into-drawer t
        org-clock-history-length 23
        org-clock-report-include-clocking-task t)

  ;; Custom agenda commands - enhanced with more practical views
  (setq org-agenda-custom-commands
        '(("d" "Daily dashboard"
           ((agenda "" ((org-agenda-span 'day)
                        (org-deadline-warning-days 7)
                        (org-agenda-overriding-header "📅 Today's Schedule")
                        (org-agenda-time-grid t)
                        (org-agenda-skip-scheduled-if-done nil)
                        (org-agenda-skip-deadline-if-done nil)))
            (todo "NEXT"
                  ((org-agenda-overriding-header "⚡ Next Actions")
                   (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline))))
            (agenda "" ((org-agenda-span 'day)
                        (org-agenda-entry-types '(:deadline))
                        (org-agenda-overriding-header "⏰ Upcoming Deadlines")))
            (todo "WAIT"
                  ((org-agenda-overriding-header "⏳ Waiting For")))
            (tags-todo "+PRIORITY=\"A\""
                       ((org-agenda-overriding-header "🔥 High Priority Tasks")
                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))))))

          ("w" "Weekly review"
           ((agenda "" ((org-agenda-span 'week)
                        (org-agenda-overriding-header "📆 This Week")
                        (org-agenda-start-on-weekday 1)))
            (todo "DONE"
                  ((org-agenda-overriding-header "✅ Completed This Week")
                   (org-agenda-skip-function nil)))
            (todo "TODO"
                  ((org-agenda-overriding-header "🗂 Backlog")
                   (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline))))
            (tags-todo "+PROJECT"
                       ((org-agenda-overriding-header "📁 Active Projects")))))

          ("N" "Next Actions (All)"
           ((todo "NEXT"
                  ((org-agenda-overriding-header "⚡ All Next Actions")
                   (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("TODO" "WAIT" "HOLD" "DONE" "CANCELED"))))))
           ((org-agenda-span 7)
            (org-agenda-start-with-log-mode nil)))

          ("p" "Projects"
           ((tags-todo "+PROJECT"
                       ((org-agenda-overriding-header "📁 Active Projects")
                        (org-agenda-sorting-strategy '(priority-down category-up))))))

          ("r" "Review & Planning"
           ((tags "REFILE"
                  ((org-agenda-overriding-header "📥 Items to Refile")
                   (org-tags-match-list-sublevels nil)))
            (tags-todo "-CANCELLED/!"
                       ((org-agenda-overriding-header "📋 Tasks to Review")
                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline))))
            (tags "+PRIORITY=\"A\""
                  ((org-agenda-overriding-header "🔥 High Priority Items")))))

          ("s" "Stuck Projects"
           ((tags-todo "+PROJECT/-NEXT"
                       ((org-agenda-overriding-header "⚠️ Stuck Projects (No Next Actions)")
                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))))))

          ("h" "Habits"
           ((agenda ""
                    ((org-agenda-overriding-header "🔄 Habits")
                     (org-agenda-sorting-strategy '(habit-down time-up))
                     (org-agenda-prefix-format "  %i %-12:c%?-12t% s")))))))

  ;; Enable clock persistence
  (org-clock-persistence-insinuate))

;; Inline images on open
(setq org-startup-with-inline-images t
      org-image-actual-width nil)

;; Better checkboxes
(setq org-checkbox-hierarchical-statistics t)

;; Tags and properties
(setq org-tag-alist '((:startgroup)
                      ("@work" . ?w)
                      ("@home" . ?h)
                      ("@errand" . ?e)
                      (:endgroup)
                      ("PROJECT" . ?p)
                      ("habit" . ?h)
                      ("note" . ?n)
                      ("meeting" . ?m))
      org-tag-persistent-alist '((:startgroup)
                                 ("@work" . ?w)
                                 ("@home" . ?h)
                                 ("@errand" . ?e)
                                 (:endgroup)
                                 ("PROJECT" . ?p))
      org-use-fast-tag-selection t
      org-fast-tag-selection-single-key 'expert
      org-tags-column -80
      org-agenda-tags-column -80)

;; Better TODO state changes
(setq org-todo-state-tags-triggers
      '(("CANCELED" ("CANCELED" . t))
        ("WAIT" ("WAITING" . t))
        ("HOLD" ("HOLD" . t) ("@hold" . t))
        (done ("WAITING") ("HOLD"))
        ("TODO" ("WAITING") ("CANCELED") ("HOLD"))
        ("NEXT" ("WAITING"))
        ("DONE" ("WAITING") ("HOLD") ("CANCELED"))))

;; Refile completion
(setq org-completion-use-ido nil
      org-outline-path-complete-in-steps nil
      org-refile-use-outline-path t
      org-refile-allow-creating-parent-nodes 'confirm)

;; Olivetti settings for centered writing
(setq olivetti-body-width 90)

;; Org-mode hooks
(add-hook! 'org-mode
  (visual-line-mode 1)
  (variable-pitch-mode 1)
  (when (display-graphic-p)
    (olivetti-mode 1)))

;; Key bindings
(map! :leader
      :prefix "o"
      :desc "Capture" "c" #'org-capture
      :desc "Agenda" "a" #'org-agenda
      :desc "Goto" "g" #'org-goto
      :desc "Store link" "l" #'org-store-link
      :desc "Open at point" "f" #'org-open-at-point
      :desc "Export" "e" #'org-export-dispatch
      :desc "Zen mode" "z" #'zen-mode)

;; ============================================================================
;; Objed Fixes
;; ============================================================================
;; Prevent objed from crashing when it encounters keymaps during key rebinding checks.
;; This often happens in Evil setups where some keys are bound to keymaps (like text objects).
(after! objed
  (defun my/objed--insert-keys-rebound-p-safe (orig-fn &rest args)
    "Avoid crash in objed when checking for rebound keys."
    (condition-case nil
        (apply orig-fn args)
      (error nil)))
  (advice-add #'objed--insert-keys-rebound-p :around #'my/objed--insert-keys-rebound-p-safe))

(map! :map org-mode-map
      :leader
      :prefix "o"
      :desc "Insert link" "L" #'org-insert-link
      :desc "Toggle checkbox" "x" #'org-toggle-checkbox
      :desc "Toggle heading" "h" #'org-toggle-heading
      :desc "Insert timestamp" "t" #'org-time-stamp
      :desc "Priority up" "u" #'org-priority-up
      :desc "Priority down" "d" #'org-priority-down
      :desc "Archive subtree" "A" #'org-archive-subtree
      :desc "Refile" "r" #'org-refile
      :desc "Clock in" "I" #'org-clock-in
      :desc "Clock out" "O" #'org-clock-out
      :desc "Clock report" "R" #'org-clock-report)

;; Agenda keybindings
(map! :map org-agenda-mode-map
      :leader
      :prefix "o"
      :desc "Refile" "r" #'org-agenda-refile
      :desc "Archive" "A" #'org-agenda-archive
      :desc "Set priority" "p" #'org-agenda-priority
      :desc "Schedule" "s" #'org-agenda-schedule
      :desc "Set deadline" "d" #'org-agenda-deadline
      :desc "Toggle todo" "t" #'org-agenda-todo
      :desc "Clock in" "I" #'org-agenda-clock-in
      :desc "Show log" "l" #'org-agenda-log-mode)
;; config.el
(after! denote
  (setq denote-directory "~/Documents/Notes/")) ; Set your desired notes directory
;; Optional: add other custom configurations here


;; Global quick access bindings
(map! :leader
      :prefix "n"
      :desc "Quick capture" "c" #'org-capture
      :desc "Agenda" "a" #'org-agenda
      :desc "Switch to org" "o" (lambda () (interactive) (find-file org-directory)))
;;
;; ============================================================================
;; Agentic coding via gptel
;; ============================================================================
(after! gptel
  (setq gptel-model 'Qwen3-Coder:30B)
  (setq gptel-backend (gptel-make-ollama "Ollama"
                        :host "localhost:11434"
                        :stream t
                        :models '(llama3.2:latest Qwen3-Coder:30B)))
  (map! :leader
        :prefix ("g" . "gptel")
        :desc "Chat" "c" #'gptel-chat
        :desc "Send" "s" #'gptel-send
        :desc "Insert" "i" #'gptel-insert
        :desc "Commands" "a" #'gptel-commands))

;; ============================================================================
;; Reading (.epub support)
;; ============================================================================
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
(after! nov
  (setq nov-save-place-file (concat doom-cache-dir "nov-places"))
  (add-hook 'nov-mode-hook #'visual-line-mode)
  (add-hook 'nov-mode-hook #'variable-pitch-mode)
  (add-hook 'nov-mode-hook #'olivetti-mode)
  ;; Restrict width for better readability
  (setq nov-text-width t)
  (setq visual-fill-column-center-text t))

;; ============================================================================
;; Text-to-Speech (Read Aloud)
;; ============================================================================
(use-package! read-aloud
  :config
  (setq read-aloud-engine "speech-dispatcher") ; Default for Linux
  
  (defun my/read-aloud-pdf-page ()
    "Extract text from current PDF page and read it aloud using read-aloud-this."
    (interactive)
    (if (derived-mode-p 'pdf-view-mode)
        (let ((text (pdf-info-gettext (pdf-view-current-page))))
          (with-temp-buffer
            (insert text)
            (read-aloud-buf)))
      (message "Not in a PDF buffer"))))

(map! :leader
      :prefix ("o v" . "voice")
      :desc "Read word or region" "v" #'read-aloud-this
      :desc "Read buffer from point" "b" #'read-aloud-buf
      :desc "Stop reading"         "s" #'read-aloud-stop
      :desc "Change engine"        "e" #'read-aloud-change-engine
      :desc "Read current PDF page" "p" #'my/read-aloud-pdf-page)

;; ============================================================================
;; Treemacs Custom Bindings
;; ============================================================================
(map! :leader
      :desc "Toggle Treemacs" "e" #'+treemacs/toggle
      :desc "Find file in Treemacs" "E" #'treemacs-find-file)

;; ============================================================================
;; Make emacs start maximized
;; ============================================================================
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
