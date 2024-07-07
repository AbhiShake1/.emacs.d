;;; config.el -*- lexical-binding: t ; eval: (view-mode -1) -*-

;; environment
(defconst *is-windows* (eq system-type 'windows-nt))
(defconst *is-unix* (not *is-windows*))

;; fonts
(defconst *mono-font-family*
  (if *is-windows* "JetBrainsMono NF" "GoMono Nerd Font"))
(defconst *mono-font-height*
  (if *is-windows* 90 90))
(defconst *serif-font-family*
  (if *is-windows* "Georgia" "IBM Plex Serif"))
(defconst *serif-font-height*
  (if *is-windows* 110 110))
(defconst *project-dir* (expand-file-name "~/git"))

(use-package better-defaults
  :straight (better-defaults :type git :host nil :repo "https://git.sr.ht/~technomancy/better-defaults")
  :demand t)

(setq default-directory "~/"
      ;; always follow symlinks when opening files
      vc-follow-symlinks t
      ;; overwrite text when selected, like we expect.
      delete-seleciton-mode t
      ;; quiet startup
      inhibit-startup-message t
      initial-scratch-message nil
      ;; hopefully all themes we install are safe
      custom-safe-themes t
      ;; simple lock/backup file management
      create-lockfiles nil
      backup-by-copying t
      delete-old-versions t
      ;; when quiting emacs, just kill processes
      confirm-kill-processes nil
      ;; ask if local variables are safe once.
      enable-local-variables t
      ;; life is too short to type yes or no
      use-short-answers t

      ;; clean up dired buffers
      dired-kill-when-opening-new-dired-buffer t)

;; use human-readable sizes in dired
(setq-default dired-listing-switches "-alh")

;; always highlight code
(global-font-lock-mode 1)
;; refresh a buffer if changed on disk
(global-auto-revert-mode 1)

;; save window layout & buffers
;; (setq desktop-restore-eager 5)
;; (desktop-save-mode 1)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(if *is-windows*
  (set-w32-system-coding-system 'utf-8))
(set-buffer-file-coding-system 'utf-8)

(use-package no-littering
  :demand t
  :config
  (setq
   auto-save-file-name-transforms
   `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  (setq custom-file (no-littering-expand-etc-file-name "custom.el"))
  (when (file-exists-p custom-file)
    (load custom-file)))

(use-package which-key
  :demand t
  :after evil
  :custom
  (which-key-allow-evil-operators t)
  (which-key-show-remaining-keys t)
  (which-key-sort-order 'which-key-prefix-then-key-order)
  :config
  (which-key-mode 1)
  (which-key-setup-minibuffer)
  (set-face-attribute
    'which-key-local-map-description-face nil :weight 'bold))

(use-package undo-tree
  :demand t
  :config
  (global-undo-tree-mode))
(use-package evil
  :demand t
  :after undo-tree
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-Y-yank-to-eol t
        evil-split-window-below t
        evil-vsplit-window-right t
        evil-respect-visual-line-mode t
        evil-undo-system 'undo-tree)
  :config
  (evil-mode 1))
(use-package evil-collection
  :demand t
  :after evil
  :config
  (evil-collection-init))
(use-package evil-commentary
  :demand t
  :after evil
  :config
  (evil-commentary-mode 1))
(use-package evil-surround
  :demand t
  :after evil
  :config
  (global-evil-surround-mode 1))
(use-package evil-org
  :demand t
  :after evil org
  :hook (org-mode . evil-org-mode)
  :config
  (add-hook 'evil-org-mode-hook 'evil-org-set-key-theme)
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package general
  :demand t
  :config
  (general-evil-setup t)
  (general-create-definer leader-def
    :states '(normal motion emacs)
    :keymaps 'override
    :prefix "SPC"
    :non-normal-prefix "C-SPC")
  (leader-def
    "" '(:ignore t :wk "leader")
    "f" '(:ignore t :wk "file")
    "c" '(:ignore t :wk "checks")
    "t" '(:ignore t :wk "toggle")
    "bd" 'kill-this-buffer
    "bn" 'next-buffer
    "bp" 'previous-buffer
    "bx" 'kill-buffer-and-window
    "s" '(:ignore t :wk "straight")
    "sf" 'straight-x-fetch-all
    "sp" 'straight-x-pull-all
    "sr" 'straight-remove-unused-repos
    "ss" 'straight-get-recipe)

  (general-create-definer localleader-def
    :states '(normal motion emacs)
    :keymaps 'override
    :prefix "SPC m"
    :non-normal-prefix "C-SPC m")
  (localleader-def "" '(:ignore t :wk "mode")))

(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

(setq ring-bell-function 'ignore ; no bell
      ;; better scrolling
      scroll-conservatively 101
      scroll-preserve-screen-position 1
      mouse-wheel-follow-mouse t
      pixel-scroll-precision-use-momentum t)
(setq-default line-spacing 1)

;; highlight the current line
(global-hl-line-mode t)

;; Add padding inside buffer windows
(setq-default left-margin-width 2
              right-margin-width 2)
(set-window-buffer nil (current-buffer)) ; Use them now.

;; Add padding inside frames (windows)
(add-to-list 'default-frame-alist '(internal-border-width . 8))
(set-frame-parameter nil 'internal-border-width 8) ; Use them now

;; fix color display when loading emacs in terminal
(defun enable-256color-term ()
  (interactive)
  (load-library "term/xterm")
  (terminal-init-xterm))

(unless (display-graphic-p)
  (if (string-suffix-p "256color" (getenv "TERM"))
    (enable-256color-term)))

(use-package leuven-theme
  :defer t)

(use-package vivid-theme
  :straight (:host github :repo "websymphony/vivid-theme")
  :defer t)

(use-package doom-themes
  :defer t
  :config
  (doom-themes-visual-bell-config)
  (doom-themes-treemacs-config)
  (doom-themes-org-config)
  (doom-themes-set-faces nil
    ;; extending faces breaks orgmode collapsing for now
   '(org-block-begin-line :extend nil)
   '(org-block-end-line :extend nil)
    ;; different sized headings are nice.
   '(outline-1 :height 1.3)
   '(outline-2 :height 1.1)
   '(outline-3 :height 1.0)))

(use-package modus-themes
  :defer t
  :custom
  (modus-themes-italic-constructs t)
  (modus-themes-intense-markup t)
  (modus-themes-mode-line '(borderless moody))
  (modus-themes-tabs-accented t)
  (modus-themes-completions
   '((matches . (extrabold background intense))
     (selection . (semibold accented intense))
     (popup . (accented))
     (t . (extrabold intense))))
  (modus-themes-org-blocks 'tinted-background)
  (modus-themes-mixed-fonts t)
  (modus-themes-headings
      '((1 . (rainbow))
        (2 . (rainbow))
        (3 . (rainbow))
        (t . (monochrome)))))

(defun me/init-theme ()
  (load-theme 'modus-operandi t))

(add-hook 'emacs-startup-hook #'me/init-theme)

(use-package persistent-soft
  :demand t)
(use-package unicode-fonts
  :demand t
  :after persistent-soft
  :config
  (unicode-fonts-setup)
  (custom-set-faces
   `(default ((t (:family ,*mono-font-family*
                  :height ,*mono-font-height*))))
   `(variable-pitch ((t (:family ,*serif-font-family*
                         :height ,*serif-font-height*))))))

(use-package all-the-icons
  :demand t)
(use-package all-the-icons-dired
  :defer 1
  :after all-the-icons
  :hook (dired-mode . all-the-icons-dired-mode))
(use-package treemacs-all-the-icons
  :defer 1
  :after all-the-icons treemacs
  :config
  (treemacs-load-theme "all-the-icons"))
(use-package all-the-icons-completion
  :defer 1
  :after all-the-icons
  :config
  (add-hook 'marginalia-mode-hook
            #'all-the-icons-completion-marginalia-setup)
  (all-the-icons-completion-mode 1))

(use-package dashboard
  :demand t
  :after all-the-icons projectile
  :if (< (length command-line-args) 2)
  :custom
  ;; show in `emacsclient -c`
  (initial-buffer-choice #'(lambda () (get-buffer-create "*dashboard*")))
  (dashboard-startup-banner 'logo)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-center-content t)
  (dashboard-items '((recents  . 10)
                     (projects . 5)
                     (bookmarks . 5)))
  :config
  (dashboard-setup-startup-hook))

(use-package anzu
  :defer 1
  :after isearch
  :config
  (global-anzu-mode 1))

(use-package minions
  :defer 1
  :config
  (minions-mode 1))

(use-package doom-modeline
  :demand t
  :custom
  (inhibit-compacting-font-caches t)
  (doom-modeline-height 28)
  ;; 1 minor mode will be shown thanks to minions
  (doom-modeline-minor-modes t)
  (doom-modeline-hud t)
  :config
  (doom-modeline-mode 1))

(use-package centaur-tabs
  :disabled t
  :defer 1
  :after all-the-icons
  :general
  (:states 'normal
           "gt"  'centaur-tabs-forward
           "gT"  'centaur-tabs-backward)
  (leader-def
    "tg" 'centaur-tabs-toggle-groups)
  :hook
  (dashboard-mode . centaur-tabs-local-mode)
  (term-mode . centaur-tabs-local-mode)
  (calendar-mode . centaur-tabs-local-mode)
  (org-agenda-mode . centaur-tabs-local-mode)
  (helpful-mode . centaur-tabs-local-mode)
  :init
  (setq centaur-tabs-enable-key-bindings t)
  :custom
  (centaur-tabs-style "bar")
  (centaur-tabs-set-icons t)
  (centaur-tabs-set-modified-marker t)
  (centaur-tabs-height 28)
  (centaur-tabs-gray-out-icons 'buffer)
  (centaur-tabs-modified-marker "")
  (uniquify-separator "/")
  (uniquify-buffer-name-style 'forward)
  :config
  (centaur-tabs-headline-match)
  (centaur-tabs-enable-buffer-reordering)
  (centaur-tabs-mode t)
  (centaur-tabs-change-fonts *mono-font-family* *mono-font-height*)

  (defun me/after-theme (&rest _args)
      (centaur-tabs-init-tabsets-store)
      (centaur-tabs-display-update)
      (centaur-tabs-headline-match))
  (advice-add 'enable-theme :after #'me/after-theme)

  (defun centaur-tabs-buffer-groups ()
    "`centaur-tabs-buffer-groups' control buffers' group rules.

 Group centaur-tabs with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
 All buffer name start with * will group to \"Emacs\".
 Other buffer group by `centaur-tabs-get-group-name' with project name."
    (list
     (cond
      ;; ((not (eq (file-remote-p (buffer-file-name)) nil))
      ;; "Remote")
      ((or (string-equal "*" (substring (buffer-name) 0 1))
           (memq major-mode '(magit-process-mode
                              magit-status-mode
                              magit-diff-mode
                              magit-log-mode
                              magit-file-mode
                              magit-blob-mode
                              magit-blame-mode)))
       "Emacs")
      ((derived-mode-p 'dired-mode)
       "Dired")
      ((memq major-mode '(helpful-mode
                          help-mode))
       "Help")
      ((memq major-mode '(org-agenda-clockreport-mode
                          org-agenda-mode
                          org-beamer-mode
                          org-src-mode
                          org-indent-mode
                          org-bullets-mode
                          org-cdlatex-mode
                          org-agenda-log-mode
                          diary-mode))
       "OrgMode")
      (t
       (or (concat "Project: " (projectile-project-name))
           (centaur-tabs-get-group-name (current-buffer))))))))

(setq fast-but-imprecise-scrolling t
      jit-lock-defer-time 0)

(use-package fast-scroll
  :defer 1
  :hook
  (fast-scroll-start . (lambda () (flycheck-mode -1)))
  (fast-scroll-end . (lambda () (flycheck-mode 1)))
  :config
  (fast-scroll-config)
  (fast-scroll-mode 1))

(use-package visual-fill-column
  :defer 1
  :hook (org-src . visual-fill-column-mode)
  :custom
  (visual-line-fringe-indicators
   '(left-curly-arrow right-curly-arrow))
  (split-window-preferred-function
   'visual-fill-column-split-window-sensibly)
  :config
  (advice-add 'text-scale-adjust
              :after #'visual-fill-column-adjust)
  (global-visual-fill-column-mode 1)
  (global-visual-line-mode 1))

(use-package mixed-pitch
  :after all-the-icons
  :defer 1
  :commands mixed-pitch-mode
  :custom
  (mixed-pitch-set-height t))
  ;; :hook (text-mode . mixed-pitch-mode))

(use-package ligature
  :straight (:host github :repo "mickeynp/ligature.el")
  :defer 1
  :config
  (ligature-set-ligatures 't '("www"))
  (ligature-set-ligatures
   'prog-mode
   '("-->" "//" "/**" "/*" "*/" "<!--" ":=" "->>" "<<-" "->" "<-"
     "<=>" "==" "!=" "<=" ">=" "=:=" "!==" "&&" "||" "..." ".."
     "|||" "///" "&&&" "===" "++" "--" "=>" "|>" "<|" "||>" "<||"
     "|||>" "<|||" ">>" "<<" "::=" "|]" "[|" "{|" "|}"
     "[<" ">]" ":?>" ":?" "/=" "[||]" "!!" "?:" "?." "::"
     "+++" "??" "###" "##" ":::" "####" ".?" "?=" "=!=" "<|>"
     "<:" ":<" ":>" ">:" "<>" "***" ";;" "/==" ".=" ".-" "__"
     "=/=" "<-<" "<<<" ">>>" "<=<" "<<=" "<==" "<==>" "==>" "=>>"
     ">=>" ">>=" ">>-" ">-" "<~>" "-<" "-<<" "=<<" "---" "<-|"
     "<=|" "/\\" "\\/" "|=>" "|~>" "<~~" "<~" "~~" "~~>" "~>"
     "<$>" "<$" "$>" "<+>" "<+" "+>" "<*>" "<*" "*>" "</>" "</" "/>"
     "<->" "..<" "~=" "~-" "-~" "~@" "^=" "-|" "_|_" "|-" "||-"
     "|=" "||=" "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:" "#!" "#="
     "&="))
  (global-ligature-mode t))

;; A more complex, more lazy-loaded config
(use-package solaire-mode
  :defer 1
  :hook
  ;; Ensure solaire-mode is running in all solaire-mode buffers
  (change-major-mode . turn-on-solaire-mode)
  ;; ...if you use auto-revert-mode, this prevents solaire-mode from turning
  ;; itself off every time Emacs reverts the file
  (after-revert . turn-on-solaire-mode)
  ;; To enable solaire-mode unconditionally for certain modes:
  (ediff-prepare-buffer . solaire-mode)
  :custom
  (solaire-mode-auto-swap-bg t)
  :config
  (solaire-global-mode +1))

(use-package helpful
  :defer 1
  :general
  (leader-def
    "h" '(:ignore t :wk "help")
    "hh" 'helpful-symbol
    "hf" 'helpful-function
    "hv" 'helpful-variable
    "hk" 'helpful-key
    "ho" 'helpful-at-point)
  :config
  (add-to-list 'display-buffer-alist
               '("*[Hh]elp"
                 (display-buffer-reuse-mode-window
                  display-buffer-pop-up-window))))

(use-package info-colors
  :defer 1
  :config
  (add-hook 'Info-selection-hook 'info-colors-fontify-node))

(defun me/reload-init ()
  "Reload init.el."
  (interactive)
  (message "Reloading init.el...")
  (load user-init-file nil 'nomessage)
  (message "Reloading init.el... done."))

(use-package restart-emacs
  :commands restart-emacs
  :general
  (leader-def
    "q" '(:ignore t :wk "exit emacs")
    "qR" 'restart-emacs
    "qn" 'restart-emacs-start-new-emacs
    "qr" 'me/reload-init))

(use-package prescient
  :defer 1
  :config
  (prescient-persist-mode 1))

(use-package flycheck
  :defer 1
  :init
  (global-flycheck-mode t))
(use-package flycheck-posframe
  :defer 1
  :after flycheck
  :hook (flycheck-mode . flycheck-posframe-mode)
  :config
  (flycheck-posframe-configure-pretty-defaults)
  (add-hook 'flycheck-posframe-inhibit-functions #'company--active-p)
  (add-hook 'flycheck-posframe-inhibit-functions #'evil-insert-state-p)
  (add-hook 'flycheck-posframe-inhibit-functions #'evil-replace-state-p))

(use-package apheleia
  :straight (:host github :repo "raxod502/apheleia")
  :defer 1
  :config
  (apheleia-global-mode +1))

(use-package company
  :defer 1
  :config
  (global-company-mode 1))
(use-package company-prescient
  :defer 1
  :after company prescient
  :config
  (company-prescient-mode 1))
(use-package company-posframe
  :defer 1
  :after company
  :custom
  (company-posframe-quickhelp-delay nil)
  :config
  (company-posframe-mode 1))

(use-package magit
  :commands magit
  :general
  (leader-def
    "g"  '(:ignore t :wk "git")
    "gs" '(magit :wk "git status")
    "gg" '(magit :wk "git status"))
  :custom
  (magit-repository-directories `((,*project-dir* . 3)))
  :config
  ;; speed up magit for large repos
  (dir-locals-set-class-variables 'huge-git-repository
   '((magit-status-mode
      . ((eval . (magit-disable-section-inserter 'magit-insert-tags-header))))))

  ;; clasify by repo-name as detected by magit.
  ;; .dir-locals.el isn't portable across machines.
  (let ((large-dirs '("nixpkgs")))
    (dolist
        (dir large-dirs)
      (dir-locals-set-directory-class
       (cdr (assoc dir (magit-repos-alist)))
       'huge-git-repository))))

(use-package magit-todos
  :after magit
  :commands magit-todos-list magit-todos-mode
  :general
  (leader-def
    "gt" 'magit-todos-list)
  :init
  (if *is-windows* (setq magit-todos-nice nil)))

(use-package magit-delta
  :if *is-unix*
  :after magit
  :commands magit-delta-mode
  :hook (magit-mode . magit-delta-mode))

(defun me/expand-git-project-dirs (root)
  "Return a list of all project directories 2 levels deep in ROOT.

Given my git projects directory ROOT, with a layout like =git/{hub,lab}/<user>/project=, return a list of 'user' directories that are part of the ROOT."
  (mapcan #'(lambda (d) (cddr (directory-files d t)))
          (cddr (directory-files root t))))

(use-package projectile
  :demand t
  :general
  (leader-def
    "p" '(:ignore t :wk "project")
    "pP" 'projectile-switch-project
    "pd" 'projectile-dired
    "pb" 'projectile-switch-to-buffer
    "pf" 'projectile-find-file
    "p/" 'projectile-ripgrep)
  :custom
  (projectile-completion-system 'default)
  (projectile-enable-caching t)
  (projectile-sort-order 'recently-active)
  (projectile-indexing-method (if *is-unix* 'hybrid 'native))
  (projectile-project-search-path `((,*project-dir* . 3)))
  :config
  (projectile-save-known-projects)
  (projectile-mode +1))

(use-package diff-hl
  :defer 1
  :hook
  (dired-mode . diff-hl-dired-mode-unless-remote)
  :config
  (global-diff-hl-mode 1))

(use-package treemacs
  :defer 2
  :commands treemacs treemacs-find-file
  :general
  (leader-def
    "tt" 'treemacs
    "tf" 'treemacs-find-file))
(use-package treemacs-evil
  :defer 1
  :after treemacs evil)
(use-package treemacs-projectile
  :defer 1
  :after treemacs projectile)
(use-package treemacs-magit
  :defer 1
  :after treemacs-magit)

(use-package company-fish
  :defer 1
  :if (executable-find "fish")
  :straight (:host github :repo "CeleritasCelery/company-fish")
  :after company
  :hook
  (shell-mode . company-mode)
  (eshell-mode . company-mode)
  :config
  (add-to-list 'company-backends 'company-fish))

(use-package eshell-syntax-highlighting
  :defer 1
  :straight (:host github :repo "akreisher/eshell-syntax-highlighting")
  :after esh-mode
  :config
  (eshell-syntax-highlighting-global-mode 1))

(use-package em-smart
  :defer 1
  :straight (:type built-in)
  :custom
  (eshell-where-to-jump 'begin)
  (eshell-review-quick-commands nil)
  (eshell-smart-space-goes-to-end t))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(defun me/disable-global-hl-line-mode ()
  (global-hl-line-mode -1))

(use-package vterm
  :straight nil
  :commands vterm vterm-other-window
  :hook (vterm-mode . #'me/disable-global-hl-line-mode)
  :custom
  (vterm-term-environment-variable "eterm-color")
  :config
  (remove-hook 'vterm-mode-hook 'vterm))

(use-package multi-vterm
  :commands
  multi-vterm
  multi-vterm-next
  multi-vterm-prev
  multi-vterm-dedicated-toggle
  multi-vterm-project)
(leader-def "pt" 'multi-vterm-dedicated-toggle)

(use-package pcmpl-args)

(use-package lsp-mode
  :defer 1
  :commands lsp lsp-deferred
  :hook
  (prog-mode . lsp-deferred)
  (lsp-mode . lsp-enable-which-key-integration)
  :init
  (setq lsp-completion-provider :capf
        lsp-keymap-prefix nil)
  :general
  (local-leader-def
    :keymaps 'lsp-mode-map
    "l" '(lsp-command-map :wk "LSP")))

(use-package company-lsp
  :after company lsp-mode
  :config
  (add-to-list 'company-backends 'company-lsp))

(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  (setq read-extended-command-predicate
        #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

(use-package savehist
  :demand t
  :config
  (savehist-mode))

(use-package vertico
  :demand t
  :custom
  (vertico-resize t)
  (vertico-cycle t)
  :config
  (vertico-mode))

(use-package icomplete
  :custom
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (completion-ignore-case t)

  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles basic partial-completion))))

  (completion-group t)
  (completions-group-format
        (concat
         (propertize "    " 'face 'completions-group-separator)
         (propertize " %s " 'face 'completions-group-title)
         (propertize " " 'face 'completions-group-separator
                     'display '(space :align-to right)))))

(use-package orderless
  :demand t
  :custom
  (completion-styles '(orderless))
  :config
  (defun prefix-if-tilde (pattern _index _total)
    (when (string-suffix-p "~" pattern)
      `(orderless-prefixes . ,(substring pattern 0 -1))))

  (defun regexp-if-slash (pattern _index _total)
    (when (string-prefix-p "/" pattern)
      `(orderless-regexp . ,(substring pattern 1))))

  (defun literal-if-equal (pattern _index _total)
    (when (string-suffix-p "=" pattern)
      `(orderless-literal . ,(substring pattern 0 -1))))

  (defun without-if-bang (pattern _index _total)
    (cond
     ((equal "!" pattern)
      '(orderless-literal . ""))
     ((string-prefix-p "!" pattern)
      `(orderless-without-literal . ,(substring pattern 1)))))

  (setq orderless-matching-styles '(orderless-flex))
  (setq orderless-style-dispatchers
        '(prefix-if-tilde
          regexp-if-slash
          literal-if-equal
          without-if-bang)))

(use-package marginalia
  :defer 1
  :config
  (marginalia-mode 1))

(use-package consult
  :defer 1
  :general
  (leader-def
    "ff" 'find-file
    "fr" 'consult-recent-file
    "bb" 'consult-buffer
    "tc" 'consult-theme
    "/"  'consult-ripgrep
    "g/" 'consult-git-grep)
  :custom
  (consult-project-root-function #'projectile-project-root)
  (consult-narrow-key "<"))

(use-package consult-projectile
  :after consult projectile
  :demand t
  :straight (consult-projectile :type git :host gitlab :repo "OlMon/consult-projectile" :branch "master")
  :general
  (leader-def
    "pp" 'consult-projectile))

(use-package consult-flycheck
  :after (consult flycheck)
  :demand t
  :general
  (leader-def
    "ee" 'consult-flycheck))

;; (use-package consult-lsp
;;   :straight (consult-lsp :type git :host github :repo "gagbo/consult-lsp" :protocol ssh)
;;   :commands (consult-lsp-symbols consult-lsp-diagnostics consult-lsp-file-symbols)
;;   :config (define-key lsp-mode-map [remap xref-find-apropos] #'consult-lsp-symbols))

(use-package embark
  :after marginalia
  :demand t
  :custom
  (prefix-help-command #'embark-prefix-help-command)
  :general
  (leader-def
    "hm" 'embark-bindings-in-keymap
    "hM" 'embark-bindings)
  :config
  (defvar-keymap embark-straight-map
    :doc "Keymap actions for straight.el"
    :parent embark-general-map
    "u" #'straight-visit-package-website
    "r" #'straight-get-recipe
    "i" #'straight-use-package
    "c" #'straight-check-package
    "F" #'straight-pull-package
    "f" #'straight-fetch-package
    "p" #'straight-push-package
    "n" #'straight-normalize-package
    "m" #'straight-merge-package)
  (add-to-list 'embark-keymap-alist '(straight . embark-straight-map))
  (add-to-list 'marginalia-prompt-categories '("recipe\\|package" . straight)))

(use-package embark-consult
  :after (embark consult)
  :demand t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :straight (corfu :files (:defaults "extensions/*")) 
  :after prescient
  :custom
  (tab-always-indent 'complete)
  :init
  (global-corfu-mode)
  (defun corfu-enable-always-in-minibuffer ()
    "Enable Corfu in the minibuffer if Vertico/Mct are not active."
    (unless (or (bound-and-true-p mct--active)
                (bound-and-true-p vertico--input))
        (setq-local corfu-auto nil) ;; Disable auto completion
        (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
                    corfu-popupinfo-delay nil)
        (corfu-mode 1)))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer 1))

(use-package corfu-history
  :straight nil
  :after (corfu savehist)
  :commands corfu-history-mode
  :init
  (add-to-list 'savehist-additional-variables 'corfu-history)
  (corfu-history-mode 1))

(use-package corfu-echo
  :straight nil
  :after corfu
  :commands corfu-echo-mode
  :init
  (corfu-echo-mode 1))

(use-package corfu-popupinfo
  :straight nil
  :after corfu
  :commands corfu-popupinfo-mode
  :init
  (corfu-popupinfo-mode 1))

(use-package kind-all-the-icons
  :straight
  (kind-all-the-icons :type git :host github
                      :repo "Hirozy/kind-all-the-icons")
  :if (display-graphic-p)
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-all-the-icons-margin-formatter))

(use-package devdocs-browser)

;; treat camel-cased words as individual words.
(add-hook 'prog-mode-hook 'subword-mode)
;; don't assume sentences end with two spaces after a period.
(setq sentence-end-double-space nil)
;; show matching parens
(show-paren-mode t)
(setq show-paren-delay 0.0)
;; limit files to 80 columns. Controversial, I know.
(setq-default fill-column 80)
;; handle very long lines without hurting emacs
(global-so-long-mode)

(use-package editorconfig
  :defer 1
  :config
  (editorconfig-mode 1))

(defun me/hide-trailing-whitespace ()
  (setq show-trailing-whitespace nil))

(use-package whitespace-cleanup-mode
  :demand t
  :hook
  (special-mode     . me/hide-trailing-whitespace)
  (comint-mode      . me/hide-trailing-whitespace)
  (compilation-mode . me/hide-trailing-whitespace)
  (term-mode        . me/hide-trailing-whitespace)
  (vterm-mode       . me/hide-trailing-whitespace)
  (shell-mode       . me/hide-trailing-whitespace)
  (minibuffer-setup . me/hide-trailing-whitespace)
  :custom
  (show-trailing-whitespace t)
  :config
  (global-whitespace-cleanup-mode 1))

(use-package rainbow-delimiters
  :defer 1
  :hook (prog-mode . rainbow-delimiters-mode)
  :config
  (set-face-attribute 'rainbow-delimiters-unmatched-face nil
                      :foreground "red"
                      :inherit 'error
                      :box t))

(use-package evil-lion
  :commands evil-lion-left evil-lion-right
  :after evil
  :general
  (:states 'normal
           "ga"  'evil-lion-left
           "gA"  'evil-lion-right)
  (:states 'visual
           "ga"  'evil-lion-left
           "gA"  'evil-lion-right))

(use-package parinfer-rust-mode
  :defer 1
  :if *is-unix*
  :hook
  emacs-lisp-mode
  lisp-mode
  clojure-mode
  :custom
  (parinfer-rust-auto-download t))

(use-package parinfer
  :defer 1
  :if *is-windows*
  :hook
  (emacs-lisp-mode . parinfer-mode)
  (lisp-mode . parinfer-mode)
  (clojure-mode . parinfer-mode)
  :init
  (setq parinfer-extensions '(defaults pretty-parens evil)))

(use-package org
  :straight (:type built-in)
  :general
  (leader-def
    "o" '(:ignore t :wk "org")
    "oa" 'org-agenda)
  (localleader-def
    :keymaps 'org-mode-map
    :major-modes t
    "," '(org-insert-structure-template :wk "insert block")
    "e" '(:ignore t :wk "execute")
    "ee" '(org-babel-execute-maybe :wk "execute (dwim)")
    "es" '(org-babel-execute-src-block :wk "execute block")
    "eb" '(org-babel-execute-buffer :wk "execute buffer")
    "et" '(org-babel-execute-subtree :wk "execute subtree")
    "'"  '(org-edit-special :wk "edit block")
    "tv" 'org-change-tag-in-region
    "xt" 'org-table-iterate-buffer-tables
    "b" '(:ignore t :wk "babel")
    "bt" 'org-babel-tangle)
  (:keymaps 'org-src-mode
            :definer 'minor-mode
            :states 'normal
            "RET"  '(org-edit-src-exit :wk "save")
            "q"  '(org-edit-src-abort :wk "abort"))
  :custom
  (org-directory "~/Sync/org")
  ;; use syntax-highlighting for src blocks
  (org-src-fontify-natively t)
  ;; open another window when editing src blocks
  (org-src-window-setup 'other-window)
  ;; strip blank lines when closing src block editor
  (org-src-strip-leading-and-trailing-blank-lines t)
  ;; preserve indentation in src blocks, don't re-indent
  (org-src-preserve-indentation t)
  ;; respect the src block syntax for tabs
  (org-src-tab-acts-natively t)
  ;; wrap lines on startup
  (org-startup-truncated nil)
  ;; if editing in an invisible region, complain.
  (org-catch-invisible-edits 'show-and-error)
  ;; don't ask when evaluating every src block
  (org-confirm-babel-evaluate nil)
  ;; don't hide emphasis markers, because there are soo many
  (org-hide-emphasis-markers nil)
  ;; try to draw utf8 characters, don't just show their code
  (org-pretty-entities t)
  ;; add a background to begin_quote and begin_verse blocks.
  (org-fontify-quote-and-verse-blocks t)
  ;; use a pretty character to show a collapsed section
  (org-ellipsis " ▿")
  ;; don't collapse blank lines when collapsing a tree
  ;; as that messes with the ellipsis.
  (org-cycle-separator-lines -1)
  ;; don't align tags
  (org-tag-column 0)
  ;; allow #+BIND to be used for org-export
  (org-export-allow-bind-keywords t)
  (org-html-checkbox-type 'html)
  :hook (org-mode . org-indent-mode)
  :config
  (add-to-list 'org-structure-template-alist '("se" . "src elisp"))
  (add-to-list 'org-structure-template-alist '("ss" . "src sh"))
  (add-to-list 'org-structure-template-alist '("sp" . "src python"))
  (org-babel-do-load-languages 'org-babel-load-languages
                               '((emacs-lisp . t)
                                 (python . t)
                                 (shell . t))))
(use-package ox-gfm
  :after org)

(defun me/lightweight-superstar-mode ()
  "Start Org Superstar differently depending on the number of lists items."
  (let ((list-items
         (count-matches "^[ \t]*?\\([+-*]\\|[ \t]\\*\\)"
                        (point-min) (point-max))))
    (unless (< list-items 100))
    (org-superstar-toggle-lightweight-lists))
  (org-superstar-mode 1))

(use-package org-superstar
  :after all-the-icons org
  :commands
  org-superstar-mode
  org-superstar-toggle-lightweight-lists
  :hook (org-mode . me/lightweight-superstar-mode)
  :custom
  ;; draw pretty unicode heading bullets
  (org-superstar-headline-bullets-list '("⌾" "◈" "⚬" "▷"))
  ;; don't hide leading stars
  (org-hide-leading-stars nil)
  ;; replace them with spaces!
  (org-superstar-leading-bullet ?\s)
  ;; draw pretty todo items
  (org-superstar-special-todo-items t)
  ;; draw pretty unicode list bullets
  (org-superstar-prettify-item-bullets t))

(use-package org-clock
  :straight nil
  :after org
  :custom
  ;; resume clock when clocking into a task with an open clock
  (org-clock-in-resume t)
  ;; don't keep empty clock-times, usually made in error
  (org-clock-out-remove-zero-time-clocks t)
  ;; include the task in the clock report
  (org-clock-report-include-clocking-task t)
  ;; only auto-resolve clocks when theres no ongoing clock
  (org-clock-auto-clock-resolution 'when-no-clock-is-running)
  ;; save the running clock when emacs closes
  (org-clock-persist t)
  :general
  (localleader-def
    :keymap org-mode-map
    "c" '(:ignore t :wk "clock")
    "ci" 'org-clock-in
    "co" 'org-clock-out
    "cf" 'org-clock-goto
    "cq" 'org-clock-cancel
    "cc" 'org-clock-in-last)
  :commands
  org-clock-in
  org-clock-out
  org-clock-goto
  org-clock-cancel
  org-clock-in-last
  org-clock-load
  org-clock-save
  :hook
  ;; lazy-load org-clock-persistence-insinuate,
  ;; as it slows down init quite a bit.
  ;; source:
  (org-mode . org-clock-load)
  (kill-emacs-hook . (lambda ()
                         (when (featurep 'org-clock)
                           (org-clock-save))))
  :config
  (org-clock-load))

(use-package org-projectile
  :after projectile org
  :defer 1
  :general
  (leader-def
    "po" 'org-projectile-project-todo-completing-read
    "op" 'org-projectile-project-todo-completing-read)
  :custom
  (org-projectile-per-project-filepath "todo.org")
  ;; https://github.com/IvanMalison/org-projectile#project-headings-are-links
  (org-confirm-elisp-link-function nil)
  :config
  (org-projectile-per-project)
  (projectile-add-known-project org-directory)
  ;; avoid adding non-existing files.
  (setq org-agenda-files
        (append org-agenda-files
                (delq nil (mapcar (lambda (file) (if (file-exists-p file) file))
                                  (org-projectile-todo-files)))))
  (push (org-projectile-project-todo-entry) org-capture-templates))

(defun me/disable-flycheck-checkers-for-elisp ()
  (setq-local flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

(use-package elisp-mode
  :straight (:type built-in)
  :hook
  (org-src-mode . me/disable-flycheck-checkers-for-elisp)
  :general
  (localleader-def
    :keymaps 'emacs-lisp-mode-map
    :major-modes t
    "e" '(:ignore t :wk "eval")
    "ee" 'eval-defun
    "es" 'eval-last-sexp
    "eb" 'eval-buffer
    "er" 'eval-region))

(use-package git-modes)

(use-package nix-mode)
(use-package nixpkgs-fmt
  :hook (nix-mode . nixpkgs-fmt-on-save-mode))
(use-package pretty-sha-path
  :hook
  (shell-mode . pretty-sha-path-mode)
  (dired-mode . pretty-sha-path-mode))
(use-package direnv
  :config
  (add-hook 'prog-mode-hook #'direnv--maybe-update-environment)
  (direnv-mode 1))

(use-package markdown-mode
  :commands gfm-mode markdown-mode
  :mode
  ("README\\.md\\'" . gfm-mode)
  ("\\.md\\'" . markdown-mode)
  ("\\.markdown\\'" . markdown-mode)
  :custom
  (markdown-command '("pandoc" "--from=markdown" "--to=html5")))

(use-package clojure-mode)

(use-package cider
  :hook (clojure-mode . cider-mode))

(use-package clj-refactor
  :after cider
  :hook (clojure-mode . clj-refactor-mode))

(use-package pug-mode)

(use-package php-mode)
(use-package ac-php
  :after php-mode
  :hook
  (js2-mode . #'ac-php-mode)
  :config
  (add-to-list 'company-backends #'company-ac-php-backend))

(use-package web-mode)
(use-package emmet-mode
  :commands emmet-mode
  :hook
  (web-mode . emmet-mode))

(use-package js2-mode
  :interpreter (("node" . js2-mode))
  :config
  (add-hook 'js-mode-hook #'js2-minor-mode)
  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
  (add-to-list 'auto-mode-alist '("\\.json$" . js2-mode)))

(use-package add-node-modules-path)

(use-package terraform-mode)
(use-package hcl-mode)

(defun me/elixir-mode-save-hook ()
  (add-hook 'before-save-hook 'elixir-format nil t))
(use-package elixir-mode
  :commands elixir-mode
  :mode
  ("\\.exs?" . elixir-mode)
  ("\\.elixir" . elixir-mode)
  :hook
  (elixir-mode . me/elixir-mode-save-hook))

(use-package async
  :demand t)

(defvar *config-file* (expand-file-name "config.org" user-emacs-directory)
  "The configuration file.")

(defvar *config-last-change* (nth 5 (file-attributes *config-file*))
  "Last modification time of the configuration file.")

(defvar *show-async-tangle-results* nil
  "Keeps *emacs* async buffers around for later inspection.")

(defun me/config-updated ()
  "Checks if the configuration file has been updated since the last time."
  (time-less-p *config-last-change*
               (nth 5 (file-attributes *config-file*))))

(defun me/async-babel-tangle (org-file)
  "Tangles the org file asynchronously."
  (let ((init-tangle-start-time (current-time))
        (file (buffer-file-name))
        (async-quiet-switch "-q"))
    (async-start
     `(lambda ()
        (require 'ob-tangle)
        (org-babel-tangle-file ,org-file))
     (unless *show-async-tangle-results*
       `(lambda (result)
          (if result
              (message "SUCCESS: %s successfully tangled (%.2fs)."
                       ,org-file
                       (float-time
                        (time-subtract (current-time)
                                       ',init-tangle-start-time)))
            (message "ERROR: %s as tangle failed." ,org-file)))))))

(defun me/config-tangle ()
  "Tangles the org file asynchronously."
  (when (me/config-updated)
    (setq *config-last-change*
          (nth 5 (file-attributes *config-file*)))
    (me/async-babel-tangle *config-file*)))

(defun me/config-tangle-hook ()
  (when (and (not (null buffer-file-truename))
             (equal (expand-file-name buffer-file-truename)
                    *config-file*))
    (add-hook 'after-save-hook
              #'me/config-tangle
              nil 'make-it-local)))

(add-hook 'org-mode-hook #'me/config-tangle-hook)

;; Local Variables:
;; flycheck-disabled-checkers: (emacs-lisp-checkdoc)
;; byte-compile-warnings: (not free-vars)
;; End:
