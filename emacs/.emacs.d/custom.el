(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(auctex lsp-pyright company-box company lsp-mode poly-org polymode counsel swiper ivy-posframe ivy which-key undo-tree evil-collection evil zenburn-theme nord-theme rainbow-delimiters no-littering use-package))
 '(safe-local-variable-values
   '((eval add-hook 'after-save-hook
           (lambda nil
               (if
                       (y-or-n-p "Tangle?")
                       (org-babel-tangle)))
           nil t)
     (eval add-hook 'after-save-hook
           (lambda nil
               (if
                       (y-or-n-p "Reload?")
                       (load-file user-init-file)))
           nil t))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
