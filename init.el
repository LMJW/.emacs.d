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
 '(package-selected-packages
   (quote
    (realgud-ipdb realgud-lldb realgud commenter python-mode diff-hl yaml-mode dockerfile-mode use-package treemacs treemacs-icons-dired go-mode treemacs-magit yasnippet company-lsp lsp-ui lsp-mode exec-path-from-shell magit org)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "nil" :family "Menlo")))))

;; Wrap lines at 80 characters
(setq-default fill-column 80)

;; Add display line number mode
;; For the mode that does not want this line number to turn on
;; we will disable this mode in that particular mode, for example the treemacs
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

;; Add global hightlight line mode
(global-hl-line-mode 1)
;; copied the highlight face and replaced the :inverse-video to nil. To get the
;; high-light info, use 'C-u C-x = ' will get the current information of buffer,
;; including what face is being used at the moment. Not sure why the highlight
;; line is green, but it seems ok to use.
(defface my-highlight
  '((((class color) (min-colors 88) (background light))
     :background "darkseagreen2")
    (((class color) (min-colors 88) (background dark))
     :background "darkolivegreen")
    (((class color) (min-colors 16) (background light))
     :background "darkseagreen2")
    (((class color) (min-colors 16) (background dark))
     :background "darkolivegreen")
    (((class color) (min-colors 8))
     :background "green" :foreground "black")
    (t :inverse-video nil))
  "Basic face for highlighting."
  :group 'basic-faces)
;; inherit set the high-light color theme. Because the default theme inversed
;; the colore, which replaced the syntex highlight. So I disabled the
;; inverse-video.
(set-face-attribute 'hl-line nil :inherit 'my-highlight)


;; install use-package if it is not installed
(when (not (require 'use-package nil t))
  (package-refresh-contents)
  (package-install 'use-package))

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
  (add-hook 'c-mode-hook #'lsp)
  (add-hook 'before-save-hook #'lsp-format-buffer)
  (setq lsp-prefer-flymake nil))

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

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-follow-delay             0.2
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-desc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-width                         35)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit
  :ensure t)

;; add golang support
;; go-mode
(use-package go-mode
  :ensure t)

;; add language support: dockerfile
;; dockerfile-mode
(use-package dockerfile-mode
  :ensure t
  :config
  (add-hook 'dockerfile-mode-hook #'dockerfile-mode))

;; add language support for yaml
;; yaml-mode
(use-package yaml-mode
  :ensure t
  :config
  (add-hook 'yml-mode-hook #'yaml-mode)
  (add-hook 'yaml-mode-hook #'yaml-mode))

;; add package diff-hl for diff the change compare to last commit
(use-package diff-hl
  :ensure t)

;; add package realgud && realgud-lldb debug tools
;; to use the debuggers within realgud, do:
;;   "M-x load-library RET realgud"
(use-package realgud
  :ensure t)

;; to use the realgud-lldb, we need to load library seperately:
;;   "M-x load-library RET realgud-lldb"
(use-package realgud-lldb
  :ensure t)

;; enable code execute in org mode
(org-babel-do-load-languages
 'org-babel-load-languages '((C . t)
			     (python . t)))


;;;
;; custom funtions to help quickly navigate the document
(defun insert-a-newline-below ()
  "insert a newline below current line, indent the new line and move cursor to the begining of the line"
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

;; custom function
(defun insert-a-newline-above ()
  "Insert a newline above the current line and put point at beginning."
  (interactive)
  (unless (bolp)
    (beginning-of-line))
  (newline)
  (forward-line -1)
  (indent-according-to-mode))





;; add key binding to editor
(global-set-key (kbd "<C-return>") 'insert-a-newline-below)
(global-set-key (kbd "C-o") 'insert-a-newline-above)
(global-set-key (kbd "M-`") 'compile)
;;;

(provide 'init)
;;; init.el ends here
