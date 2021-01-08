(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(unless package-archive-contents
    (package-refresh-contents))

(unless (package-installed-p 'use-package)
    (package-install 'use-package))
(require 'use-package)

(setq user-emacs-directory "~/.cache/emacs")

(use-package no-littering
    :ensure t)

(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(if (display-graphic-p)
        (progn
            (tool-bar-mode -1)
            (scroll-bar-mode -1)))
(menu-bar-mode -1)
(setq visible-bell 1)
(setq ring-bell-function 'ignore)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

(setq custom-file "~/.emacs.d/custom.el")

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq-default standart-indent 4)
(setq-default lisp-body-indent 4)
(global-set-key (kbd "RET") 'newline-and-indent)

(show-paren-mode t)
(electric-pair-mode 1)
(electric-indent-mode -1)

(use-package rainbow-delimiters
    :ensure t
    :hook (prog-mode . rainbow-delimiters-mode))

(use-package nord-theme
    :ensure t)
(use-package zenburn-theme
    :ensure t)
(load-theme 'zenburn t)

(global-visual-line-mode 1)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package evil
    :ensure t
    :init
    (setq evil-want-integration t)
    (setq evil-want-keybinding nil)
    :config
    (evil-mode t))

(use-package evil-collection
    :ensure t
    :after evil
    :config
    (evil-collection-init))

(use-package undo-tree
    :ensure t)
(global-undo-tree-mode)
(evil-set-undo-system 'undo-tree)

(use-package which-key
    :ensure t
    :init (which-key-mode)
    :diminish which-key-mode
    :config
    (setq which-key-idle-delay 1))

(use-package dired)
(setq dired-recursive-deletes 'top)

(use-package ivy
    :ensure t
    :diminish
    :bind (("<f2>" . ivy-switch-buffer)
           ("C-s" . swiper)
           :map ivy-minibuffer-map
           ("C-l" . ivy-alt-done)
           ("C-j" . ivy-next-line)
           ("C-k" . ivy-previous-line)
           ("TAB" . ivy-next-line)
           :map ivy-switch-buffer-map
           ("C-k" . ivy-previous-line)
           ("C-l" . ivy-done)
           ("C-d" . ivy-switch-buffer-kill)
           :map ivy-reverse-i-search-map
           ("C-k" . ivy-previous-line)
           ("C-d" . ivy-reverse-i-search-kill))
    :config
    (ivy-mode 1))

(use-package ivy-posframe
    :ensure t
    :config
    (setq ivy-posframe-display-functions-alist
          '((swiper                     . ivy-posframe-display-at-point)
            (complete-symbol            . ivy-posframe-display-at-point)
            (counsel-M-x                . ivy-display-function-fallback)
            (counsel-esh-history        . ivy-posframe-display-at-window-center)
            (counsel-describe-function  . ivy-display-function-fallback)
            (counsel-describe-variable  . ivy-display-function-fallback)
            (counsel-find-file          . ivy-display-function-fallback)
            (counsel-recentf            . ivy-display-function-fallback)
            (counsel-register           . ivy-posframe-display-at-frame-bottom-window-center)
            (ivy-switch-buffer          . ivy-posframe-display-at-window-center)
            (nil                        . ivy-posframe-display)))
    (ivy-posframe-mode 1))

(use-package swiper
    :ensure t
    :config
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (global-set-key "\C-s" 'swiper)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file))

(use-package counsel
    :ensure t
    :bind (("C-M-j" . 'counsel-switch-buffer)
           :map minibuffer-local-map
           ("C-r" . 'counsel-minibuffer-history))
    :custom
    (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
    :config
    (counsel-mode 1))

(use-package polymode
    :ensure t)
(use-package poly-org
    :ensure t)

(use-package lsp-mode
    :ensure t
    :commands (lsp lsp-deferred)
    :config
    (lsp-enable-which-key-integration t)
    (setq lsp-keymap-prefix "C-c l"))

(use-package company
    :ensure t
    :after lsp-mode
    :hook ((lsp-mode . company-mode)
           (after-init . global-company-mode))
    :bind ((:map company-active-map
                 ("<tab>" . company-complete-selection))
           (:map lsp-mode-map
               ("<tab>" . company-indent-or-complete-common)))
    :custom
    (company-selection-wrap-around t)
    (company-minimum-prefix-length 1)
    (company-idle-delay 0.0))

(use-package company-box
    :ensure t
    :hook (company-mode . company-box-mode))

(use-package python-mode
    :hook (python-mode . lsp-deferred)
    :custom (python-shell-interpreter "python3"))

(use-package lsp-pyright
    :ensure t
    :hook (python-mode . (lambda ()
                             (require 'lsp-pyright)
                             (lsp-deferred))))

(use-package auctex
    :defer t
    :ensure t)
