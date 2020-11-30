(setq visible-bell 1)
(setq custom-file "~/.emacs.d/custom.el")
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)

;; MELPA repository
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Download use-package
(unless (package-installed-p 'use-package) (package-install `use-package))
(require 'use-package)

(use-package evil
  :ensure t)
(evil-mode 1)

(use-package nord-theme
  :ensure t)

(use-package auctex
  :defer t
  :ensure t)

(load custom-file :noerror)
