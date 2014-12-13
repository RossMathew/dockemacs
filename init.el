;; =========================== Interface  ==================================

;; ;;(set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>]))
;; (set-frame-parameter (selected-frame) 'alpha '(90 50))
;; (add-to-list 'default-frame-alist '(alpha 90 50))

(setq file-name-coding-system 'utf-8)
(fset 'yes-or-no-p 'y-or-n-p)
(setq display-time-interval 1)
(setq display-time-format "%H:%M")
(display-time-mode)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-delete-selection nil)
 '(custom-safe-themes
   (quote
    ("5b6a7f2a00275a5589b14fa23ff1699785d9f7c1722ee9f79ec1b7de92fa0935"
     "0c29db826418061b40564e3351194a3d4a125d182c6ee5178c237a7364f0ff12")))
 '(delete-selection-mode t)
 '(ergoemacs-ctl-c-or-ctl-x-delay 0.2)
 '(ergoemacs-handle-ctl-c-or-ctl-x (quote both))
 '(ergoemacs-keyboard-layout "us")
 '(ergoemacs-use-menus t)
 '(global-whitespace-mode t)
 '(initial-buffer-choice t)
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 '(initial-scratch-message
   ";; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with [Ctrl+O],
;; then enter the text in that file's own buffer.")
 '(org-CUA-compatible t)
 '(org-replace-disputed-keys nil)
 '(org-special-ctrl-a/e t)
 '(org-support-shift-select t)
 '(recentf-menu-before "Close")
 '(recentf-mode t)
 '(scroll-error-top-bottom t)
 '(set-mark-command-repeat-pop t)
 '(whitespace-style (quote (face lines-tail))))

(add-hook 'before-save-hook
          'delete-trailing-whitespace)

(setq make-backup-files nil)
(setq auto-save-list-file-name nil)
(setq auto-save-default nil)

(setq show-paren-style 'expression)
(show-paren-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'spolsky)

;; =========================== Org mode ==================================

(add-to-list 'load-path "~/.emacs.d/org-mode/contrib/lisp" t)
(setq org-log-done t
      org-todo-keywords '((sequence "TODO" "INPROGRESS" "DONE"))
      org-todo-keyword-faces '(("INPROGRESS" . (:foreground "DodgerBlue2" :weight bold))))
(add-hook 'org-mode-hook
          (lambda ()
            (flyspell-mode)))

(eval-after-load "org"
  '(progn
     (define-prefix-command 'org-todo-state-map)
     (define-key org-mode-map "\C-cx" 'org-todo-state-map)
     (define-key org-todo-state-map "d"
       '(lambda nil (interactive) (org-todo "DONE")))
     (define-key org-todo-state-map "i"
       '(lambda nil (interactive) (org-todo "INPROGRESS")))))

;; =========================== GPG ==================================

(require 'epa-file)
(epa-file-enable)
(setq epa-file-cache-passphrase-for-symmetric-encryption t)

;; =========================== Features ==================================.

(add-to-list 'load-path "~/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
(setq-default ac-sources (add-to-list 'ac-sources 'ac-source-dictionary))
(global-auto-complete-mode 1)
(setq ac-auto-start 2)
(setq ac-ignore-case nil)

(require 'linum+)
(setq linum-format "%d ")
(global-linum-mode 1)

(require 'ido-hacks)
(ido-mode t)
(setq ido-enable-flex-matching t)

(add-to-list 'load-path "~/.emacs.d/multiple-cursors")
(require 'multiple-cursors)
(global-set-key (kbd "C-x C-m") 'mc/edit-lines)
(global-set-key (kbd "C-.") 'mc/mark-next-like-this)
(global-set-key (kbd "C-,") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-,") 'mc/mark-all-like-this)

(require 'autopair)
(autopair-global-mode)

;; =========================== Keybinding  ==================================

(add-to-list 'load-path "~/.emacs.d/ergoemacs-mode")
(require 'ergoemacs-mode)

(setq ergoemacs-theme nil)
(setq ergoemacs-keyboard-layout "us")
(ergoemacs-mode 1)

(defun reverse-input-method (input-method)
  "Build the reverse mapping of single letters from INPUT-METHOD."
  (interactive
   (list (read-input-method-name "Use input method (default current): ")))
  (if (and input-method (symbolp input-method))
      (setq input-method (symbol-name input-method)))
  (let ((current current-input-method)
        (modifiers '(nil (control) (meta) (control meta))))
    (when input-method
      (activate-input-method input-method))
    (when (and current-input-method quail-keyboard-layout)
      (dolist (map (cdr (quail-map)))
        (let* ((to (car map))
               (from (quail-get-translation
                      (cadr map) (char-to-string to) 1)))
          (when (and (characterp from) (characterp to))
            (dolist (mod modifiers)
              (define-key (if mod input-decode-map local-function-key-map)
                (vector (append mod (list from)))
                (vector (append mod (list to)))))))))
    (when input-method
      (activate-input-method current))))

(defadvice read-passwd (around my-read-passwd act)
  (let ((local-function-key-map nil))
    ad-do-it))

(reverse-input-method 'russian-computer)

;; =========================== Bookmark  ==================================

(global-set-key (kbd "`")         'bookmark-jump)
(global-set-key (kbd "C-x v")         'bookmark-set)
(global-set-key (kbd "s-SPC")         'bookmark-save)

;; =========================== Snippets  ==================================

(add-to-list 'load-path
              "~/.emacs.d/yasnippet")

(require 'yasnippet)
(yas-global-mode 1)
(add-to-list 'ac-sources 'ac-source-yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"
        "~/.emacs.d/some/collection/"
        "~/.emacs.d/yasnippet/yasmate/snippets"
        "~/.emacs.d/yasnippet/snippets"))

;; =========================== Packages  ==================================

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

;; =========================== Ruby  ==================================

(require 'rvm)
(rvm-use-default)

(require 'flyspell)
(setq flyspell-issue-message-flg nil)
(add-hook 'ruby-mode-hook
          (lambda () (flyspell-prog-mode)))

(setq-default ispell-program-name "aspell")
(setq ispell-local-dictionary "russian")

(add-to-list 'load-path "~/.emacs.d/robe")
(require 'ruby-mode)
(require 'inf-ruby)
(require 'robe)
(add-hook 'ruby-mode-hook 'robe-mode)
(add-hook 'robe-mode-hook 'ac-robe-setup)

(defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
  (rvm-activate-corresponding-ruby))

;; =========================== Rsense ==================================

(setq rsense-home "$RSENSE_HOME")
(add-to-list 'load-path (concat rsense-home "/opt/rsense-0.3"))
(require 'rsense)
(add-hook 'ruby-mode-hook
          (lambda ()
            (add-to-list 'ac-sources 'ac-source-rsense-method)
            (add-to-list 'ac-sources 'ac-source-rsense-constant)))

;; =========================== Rinary  ==================================

(require 'ido)
(ido-mode t)

(add-to-list 'load-path "~/.emacs.d/rinari")
(require 'rinari)
(global-rinari-mode)

(setf
 my-rinari-jump-schema
 '((my-stylesheet "y" ((t . "app/assets/stylesheets/.*")) nil)
   (my-javascript "j" ((t . "app/assets/javascripts/.*")) nil)
   (my-spine-application "a" ((t . "app/assets/javascripts/app/.*\\.js\\.coffee")) nil)
   (my-spine-lib "l" ((t . "app/assets/javascripts/app/lib/.*")) nil)
   (my-spine-model "m" ((t . "app/assets/javascripts/app/models/.*")) nil)
   (my-spine-view "v" ((t . "app/assets/javascripts/app/views/.*")) nil)
   (my-soine-index "r" ((t . "app/assets/javascripts/app/.*")) nil)

(my-fabrication "f" ((t . "spec/fabricators/.*")) nil)
   (my-rspec
    "t"
    (("app/models/\\1.rb"                      . "spec/models/\\1_spec.rb")
     ("app/controllers/\\1.rb"                 . "spec/controllers/\\1_spec.rb")
     ("app/views/\\1\\..*"                     . "spec/views/\\1_spec.rb")
     ("lib/\\1.rb"                             . "spec/libs/\\1_spec.rb")
     ("db/migrate/.*_create_\\1.rb"            . "spec/models/\\1_spec.rb")
     ("config/routes.rb"                       . "spec/routing/.*\\.rb")
     (t                                        . "spec/.*\\.rb"))
    t)

(my-decorator
    "d"
    (("app/models/\\1.rb"                      . "app/decorators/\\1_decorator.rb")
     ("app/controllers/\\1.rb"                 . "app/decorators/\\1_decorator.rb")
     ("app/views/\\1\\..*"                     . "app/decorators/\\1_decorator.rb")
     ("db/migrate/.*_create_\\1.rb"            . "app/decorators/\\1_decorator.rb")
     (t                                        . "app/decorators/.*\\.rb"))
    t)

   (my-request-rspec "r" ((t . "spec/requests/.*")) nil)
))

(rinari-apply-jump-schema my-rinari-jump-schema)

(define-key rinari-minor-mode-map (kbd "C-c m") 'rinari-find-model)
(define-key rinari-minor-mode-map (kbd "C-c M") 'rinari-find-mailer)
(define-key rinari-minor-mode-map (kbd "C-c c") 'rinari-find-controller)
(define-key rinari-minor-mode-map (kbd "C-c o") 'rinari-find-configuration)
(define-key rinari-minor-mode-map (kbd "C-c a") 'rinari-find-application)
(define-key rinari-minor-mode-map (kbd "C-c e") 'rinari-find-environment)
(define-key rinari-minor-mode-map (kbd "C-c h") 'rinari-find-helper)
(define-key rinari-minor-mode-map (kbd "C-c v") 'rinari-find-view)
(define-key rinari-minor-mode-map (kbd "C-c i") 'rinari-find-migration)
(define-key rinari-minor-mode-map (kbd "C-c l") 'rinari-find-lib)
(define-key rinari-minor-mode-map (kbd "C-c r") 'rinari-find-my-request-rspec)
(define-key rinari-minor-mode-map (kbd "C-c t") 'rinari-find-my-rspec)
(define-key rinari-minor-mode-map (kbd "C-c f") 'rinari-find-my-fabrication)
(define-key rinari-minor-mode-map (kbd "C-c y") 'rinari-find-my-stylesheet)
(define-key rinari-minor-mode-map (kbd "C-c d") 'rinari-find-my-decorator)
(define-key rinari-minor-mode-map (kbd "C-c j") 'rinari-find-my-javascript)
(define-key rinari-minor-mode-map (kbd "C-c C-c a") 'rinari-find-my-spine-application)
(define-key rinari-minor-mode-map (kbd "C-c C-c m") 'rinari-find-my-spine-model)
(define-key rinari-minor-mode-map (kbd "C-c C-c r") 'rinari-find-my-spine-index)
(define-key rinari-minor-mode-map (kbd "C-c C-c v") 'rinari-find-my-spine-view)
(define-key rinari-minor-mode-map (kbd "C-c C-c l") 'rinari-find-my-spine-lib)
(define-key rinari-minor-mode-map (kbd "C-l x") 'rinari-extract-partial)
(define-key rinari-minor-mode-map (kbd "C-l c") 'rinari-console)
(define-key rinari-minor-mode-map (kbd "C-l s") 'rinari-web-server)
(define-key rinari-minor-mode-map (kbd "C-l r") 'rinari-web-server-restart)
(define-key rinari-minor-mode-map (kbd "C-l p") 'rinari-cap)

(defun my-find-gemfile ()
  (interactive)
  (find-file (concat (rinari-root) "Gemfile")))
(define-key rinari-minor-mode-map (kbd "C-c g") 'my-find-gemfile)

;; =========================== Templates...  ==================================

(require 'slim-mode)
(require 'coffee-mode)
(add-to-list 'auto-mode-alist
            '("\\.coffee$" . rinari-minor-mode)
            '("\\.coffee$" . coffee-mode))

(eval-after-load "coffee-mode"
 '(progn
    (define-key coffee-mode-map [(meta r)] 'coffee-compile-buffer)
    (define-key coffee-mode-map (kbd "C-j") 'coffee-newline-and-indent)))

(add-to-list 'load-path "~/.emacs.d/rhtml")
(require 'rhtml-mode)
(add-to-list 'auto-mode-alist '("\\.jst\\.eco$" . rhtml-mode))

;; ====================== To be continued... ==========================
