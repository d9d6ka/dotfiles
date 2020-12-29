(if (display-graphic-p)
		(progn
			(tool-bar-mode -1)
			(scroll-bar-mode -1)))
(menu-bar-mode -1)
(setq visible-bell 1)
(setq ring-bell-function 'ignore)
(setq custom-file "~/.emacs.d/custom.el")
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;; MELPA repository
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Create package archive
(unless package-archive-contents
	(package-refresh-contents))

;; Download use-package
(unless (package-installed-p 'use-package)
	(package-install 'use-package))
(require 'use-package)

;; Evil mode
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

;; Line numbers
(setq display-line-numbers-type 'relative)
(set-face-attribute 'line-number nil
                    :foreground "blue")
(global-display-line-numbers-mode)

;; Dired
(use-package dired)
(setq dired-recursive-deletes 'top)

;; Indents
(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq-default standart-indent 4)
(setq-default lisp-body-indent 4)
(global-set-key (kbd "RET") 'newline-and-indent)

;; Parentheses
(show-paren-mode t)
(electric-pair-mode 1)
(electric-indent-mode -1)
(use-package rainbow-delimiters
	:ensure t
	:hook (prog-mode . rainbow-delimiters-mode))

;; Which-key
(use-package which-key
    :ensure t
    :init (which-key-mode)
    :diminish which-key-mode
    :config
    (setq which-key-idle-delay 1))

;; Bufferlist
(use-package bs)
(use-package ibuffer)
(defalias 'list-buffers 'ibuffer)
(global-set-key (kbd "<f2>") 'bs-show)

;; Eyecandies
(use-package nord-theme
    :ensure t)
(use-package zenburn-theme
    :ensure t)
(load-theme 'zenburn t)

;; tex
(use-package auctex
    :defer t
    :ensure t)

;; LSP
(use-package lsp-mode
	:ensure t
	:commands (lsp lsp-deferred)
	:init
	(setq lsp-keymap-prefix "C-c l")
	:config
	(lsp-enable-which-key-integration t))

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
	(company-minimum-prefix-length 1)
	(company-idle-delay 0.0))

(use-package company-box
	:ensure t
	:hook (company-mode . company-box-mode))

;; Python
(use-package python-mode
	:hook (python-mode . lsp-deferred)
	:custom (python-shell-interpreter "python3"))

(use-package lsp-pyright
	:ensure t
	:hook (python-mode . (lambda ()
							 (require 'lsp-pyright)
							 (lsp-deferred))))
