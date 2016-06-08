;; load prelude modules
(require 'prelude-ido)
(require 'prelude-company)
(require 'prelude-c)
(require 'prelude-emacs-lisp)
(require 'prelude-go)
(require 'prelude-org)
(require 'prelude-shell)

;; ido
(prelude-require-package 'ido-vertical-mode)
(ido-vertical-mode t)
(setq ido-vertical-define-keys 'C-n-and-C-p-only)

;; mac/gui
(when (memq window-system '(mac ns))
  (setenv "VAGRANT_DEFAULT_PROVIDER" "vmware_fusion")
  (set-face-font 'default "Monaco-11")
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'super)
  (scroll-bar-mode -1)
  (setq mouse-drag-copy-region t))

;; whitespace
(setq fill-column 120)
(setq whitespace-line-column fill-column)

;; keys
(defun backward-whitespace ()
  (interactive)
  (forward-whitespace -1))

(global-set-key (kbd "M-<right>") 'forward-whitespace)
(global-set-key (kbd "M-<left>") 'backward-whitespace)
(global-set-key (kbd "C-x C-o") 'ff-find-other-file)
(global-set-key (kbd "M-c") 'recompile)
(global-set-key (kbd "C--") 'negative-argument)

;; turn off the beep
(setq visible-bell t)

;; projectile
(prelude-require-packages '(ag))
(setq ag-highlight-search t)
(setq grep-highlight-matches 'auto)
(setq projectile-use-git-grep t)
(setq projectile-sort-order 'recentf)
(setq projectile-switch-project-action 'projectile-vc)

(let ((map prelude-mode-map))
  (define-key map (kbd "s-g") 'projectile-grep)
  (define-key map (kbd "s-f") 'projectile-find-file)
  (define-key map (kbd "s-s") 'projectile-ag)
  (define-key map (kbd "C-c W") 'browse-url-at-point)
  (define-key map (kbd "C-c w") (lambda ()
                                  (interactive)
                                  (eww (browse-url-url-at-point)))))

;; dir-locals based project config without the .dir-locals.el file
(dir-locals-set-class-variables
 'project-locals
 '((nil . ((eval . (olegshaldybin-projectile-project-locals))))))

(defun olegshaldybin-projectile-project-locals ()
  (let ((project (projectile-project-name)))
    (setq-local prelude-term-buffer-name project)
    (cond
     ((string= project "kubernetes")
      (progn
        (if (and buffer-file-name (equal "go" (file-name-extension buffer-file-name)))
            (setq-local compilation-read-command nil))
        (setq-local go-oracle-scope "k8s.io/kubernetes")))
     )))

(defun olegshaldybin-projectile-switch-project-hook ()
  (dir-locals-set-directory-class (projectile-project-root) 'project-locals))

(add-hook 'projectile-before-switch-project-hook 'olegshaldybin-projectile-switch-project-hook)

;; go
(setq go-projectile-tools-path (expand-file-name "~/gotools")
      go-test-verbose t)
(eval-after-load 'go-mode
  '(progn
     (go-projectile-install-tools)))

;; git
(prelude-require-packages '(magit-gerrit magit-gh-pulls git-link))
(eval-after-load 'magit
  '(progn
     (setq magit-revision-show-gravatars nil)
     (require 'magit-gerrit)))

;; vagrant
(prelude-require-packages '(vagrant vagrant-tramp))

;; .dir-locals.el
(setq enable-local-eval t
      enable-local-variables :all)

;; server
(require 'server)
(unless (server-running-p) (server-start))

;; misc
(prelude-require-packages '(list-environment))

;; old habits die hard
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\M-n" 'goto-line)
(global-set-key "\C-x\C-n" 'next-buffer)
(global-set-key "\C-x\C-p" 'previous-buffer)
(global-set-key "\M-=" 'align-regexp)

(setq frame-title-format "%b %+%+ %f")
(setq transient-mark-mode nil)

(setq recentf-max-menu-items 10)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)
