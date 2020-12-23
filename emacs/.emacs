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
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Create package archive
(when (not package-archive-contents)
	(package-refresh-contents))

;; Download use-package
(unless (package-installed-p 'use-package) (package-install 'use-package))
(require 'use-package)

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

;; company-mode
(use-package company
	:ensure t
	:config
	(setq company-idle-delay 0)
	(setq company-minimum-prefix-length 1)
	(setq company-show-numbers t)
	(global-company-mode t))

(company-tng-configure-default)

(use-package company-box
	:ensure t
	:after company
	:hook (company-mode . company-box-mode))

(use-package company-jedi
	:ensure t)
(defun my/python-mode-hook ()
	(add-to-list 'company-backends 'company-jedi))
(add-hook 'python-mode-hook 'my/python-mode-hook)

;; Custom file
(load custom-file :noerror)
