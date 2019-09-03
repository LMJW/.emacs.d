
;;; Code:


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(custom-enabled-themes (quote (adwaita)))
 '(package-archives
   (quote
    (("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa-stable" . "https://stable.melpa.org/packages/"))))
 '(package-selected-packages (quote (magit org)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "nil" :family "Menlo")))))

;; Wrap lines at 80 characters
(setq-default fill-column 80)

(require 'use-package)
(setq use-package-verbose t)

;; my own customization
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))


;; use exec-path-from-shell
;; 
;; this is to sync the emacs environment variable with the shell environment
;; variable so gopls can work
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; configure lsp-mode
(use-package lsp-mode
  :ensure t
  :config
  (add-hook 'go-mode-hook #'lsp)
  (add-hook 'c-mode-hook #'lsp))

;; use lsp-ui
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; use company-lsp for auto complete
(use-package company-lsp
  :ensure t
  :config
  (push 'company-lsp company-backends))

;; install yasnippet as company-lsp will need to
;; use it to make auto completion
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(provide 'init)
;;; init.el ends here
