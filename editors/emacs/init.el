;; ==================================================
;; Definition of my minor mode
;; ==================================================

(defvar my-keys-minor-mode-map (make-keymap) "my keys")
(define-minor-mode my-keys-minor-mode
     "A minor mode for my custom keys"
     t " my-keys" 'my-keys-minor-mode-map)
(my-keys-minor-mode t)


;; ==================================================
;; Basic settings
;; ==================================================

; Line numbers.
(global-linum-mode t)

; Autoindent.
(electric-indent-mode t)

; ido mode.
(ido-mode 1)
(ido-everywhere 1)

; Replace selection when type.
(delete-selection-mode t)

; Don't break line in the middle of the word.
(global-visual-line-mode t)

; Highlight pair parens.
(show-paren-mode t)

; Blink cursor
(blink-cursor-mode t)

; Don't make backup.
(setq make-backup-file nil)

; Don't auto save.
(setq auto-save-default nil)

; Save backup in ~/.saves.
(setq backup-directory-alist `(("." . "~/.saves")))

; Don't display welcome message.
(setq inhibit-startup-message t)

; Don't use tabs.
(setq-default indent-tabs-mode nil)

; y/n instead of yes/no.
(defalias 'yes-or-no-p 'y-or-n-p)

; Save position before exit.
(require 'saveplace)
(setq save-place-file (concat user-emacs-directory "saveplace.el"))
(setq-default save-place t)

; Hide menu, toolbar and scrollbar in gui.
(when (window-system)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

; Toggle menu bar.
(define-key my-keys-minor-mode-map [f12] 'toggle-menu-bar-mode-from-frame)

; Dired                                        ;
; Ask once when dired delete not empty folder.
(setq dired-recursive-deletes (quote top))
; For one buffer in dired mode.
(require 'dired)
(define-key dired-mode-map (kbd "f") 'dired-find-alternate-file)
(define-key dired-mode-map (kbd "^") (lambda()
                                       (interactive)
                                       (find-alternate-file "..")))

; Org-mode
; Don't indent in org mode.
(add-hook 'org-mode-hook (lambda()
                           (set (make-local-variable 'electric-indent-functions)
                                (list (lambda(arg) 'no-indent)))))
; Highlight languages natively in org mod.
(setq org-src-fontify-natively t)

; Recently opened files.
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 100)
(setq recentf-auto-cleanup 'never)


;; ==================================================
;; Custom functions
;; ==================================================

; Duplicate current line or region.
(define-key my-keys-minor-mode-map (kbd "C-S-y") 'duplicate-current-line-or-region)
(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (beginning-of-visual-line)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

; Select current line.
(define-key my-keys-minor-mode-map (kbd "M-l") 'select-current-line)
(defun select-current-line()
  "Selects the current line"
  (interactive)
  (end-of-line)
  (push-mark (line-beginning-position) nil t))

; Paste line above.
(define-key my-keys-minor-mode-map (kbd "M-RET") 'line-above)
(defun line-above()
  "Pastes line abobe"
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

; Cut line or region.
(define-key my-keys-minor-mode-map [remap kill-region] 'cut-line-or-region)
(defun cut-line-or-region()
  "Cuts line or region"
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (kill-region (line-beginning-position) (line-beginning-position 2))))

; Copy line or region.
(define-key my-keys-minor-mode-map [remap kill-ring-save] 'copy-line-or-region)
(defun copy-line-or-region()
  "Copys line or region"
  (interactive)
  (if (region-active-p)
      (kill-ring-save (region-beginning) (region-end))
    (kill-ring-save (line-beginning-position) (line-beginning-position 2))))

; Run editor.
(defun runeditor (editor args)
  (let (filename (file-truename buffer-file-name))
    (setq cmd (format "%s %s %s" editor (file-truename buffer-file-name) args))
    (save-window-excursion (async-shell-command cmd))))

; Run gvim.
(defun rungvim ()
  (interactive)
  (runeditor "gvim" (format "-c \"call cursor(%s,%s)\"" (line-number-at-pos) (+ (current-column) 1))))


;; ==================================================
;; Plugins
;; ==================================================

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)


; Use-package.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


; Theme.
(use-package color-theme-sanityinc-tomorrow
  :ensure t)


; Org-mode.
(use-package org
  :ensure org-plus-contrib)


; Autocompletion.
(use-package auto-complete
  :ensure t
  :config (ac-config-default))


; Yasnippet.
(use-package yasnippet
  :ensure t
  :init (yas-global-mode t)
  :config
  (progn
      ; Create snippet.
      (defun create-snippet (filename)
         (interactive "s")
         (let ((mode (symbol-name major-mode)))
              (find-file (format "~/.emacs.d/snippets/%s/%s" mode filename))
              (snippet-mode))))
  :bind (:map my-keys-minor-mode-map
              ("M-'" . create-snippet)))


; Projectile.
(use-package projectile
  :ensure t
  :init (projectile-global-mode)
  :bind (:map my-keys-minor-mode-map
              ("M-/" . projectile-find-file)))


; Helm.
(use-package helm
  :ensure t
  :init (require 'helm-config)
  :config
  (progn
      (helm-mode 1)
      (helm-autoresize-mode 1)
      ; Move to end or beginning of source when reaching top or bottom of
      ; source.
      (setq helm-move-to-line-cycle-in-source t
            helm-M-x-fuzzy-match t
            helm-buffers-fuzzy-matching t
            helm-recentf-fuzzy-match t
            helm-apropos-fuzzy-match t
            helm-semantic-fuzzy-match t
            helm-imenu-fuzzy-match t)
      ; To enable man page at point.
      (add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages))
  :bind (:map my-keys-minor-mode-map
              ("C-x C-r" . helm-recentf)
              ("M-x" . helm-M-x)
              ("C-x C-f" . helm-find-files)
              ("M-y" . helm-show-kill-ring)
              ("C-x b" . helm-mini)
              ("C-<tab>" . helm-dabbrev)))


; Helm-descbinds.
(use-package helm-descbinds
  :ensure t
  :config (helm-descbinds-mode))


; Helm-projectile.
(use-package helm-projectile
  :ensure t
  :bind (:map my-keys-minor-mode-map
              ("M-/" . projectile-find-file)))


; Expand selection.
(use-package expand-region
  :ensure t
  :bind (:map my-keys-minor-mode-map
              ("C-=" . er/expand-region)))


; Ace jump.
(use-package ace-jump-mode
  :ensure t
  :bind (:map my-keys-minor-mode-map
              ("C-c SPC" . ace-jump-mode)))


; Neotree.
(use-package neotree
  :ensure t
  :config
  (progn
      ; Show hidden files.
      (setq-default neo-show-hidden-files t)
      ; Change root automatically when project is switched.
      (setq projectile-switch-project-action 'neotree-projectile-action))
  :bind (:map my-keys-minor-mode-map
              ("C-\\" . neotree-toggle)))


; Flx-ido.
(use-package flx-ido
  :ensure t
  :config
  (progn
      (flx-ido-mode 1)
      ; Disable ido faces to see flx highlights.
      (setq ido-enable-flex-matching t)
      (setq ido-use-faces nil)))


; Powerline.
(use-package powerline
  :ensure t
  :config (powerline-default-theme))


; Magit.
(use-package magit
  :ensure t
  :config
  (progn
      (global-magit-file-mode t)
      (define-key my-keys-minor-mode-map (kbd "C-x g") 'magit-status)))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (sanityinc-tomorrow-eighties)))
 '(custom-safe-themes
   (quote
    ("628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" default)))
 '(initial-frame-alist (quote ((fullscreen . maximized)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

