;;;Personal configuration for Emacs
;;;Gerardo Diez García
;;;2018-2020

(setq warning-minimum-level :error)

(when (and (equal emacs-version "27.2")
           (eql system-type 'darwin))
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))

;; Init use of package
(require 'package)
(package-initialize)


;; Add another repos, so we can install use-package
(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Ensure always the use of "use-package"
(require 'use-package)
(setq use-package-always-ensure t)
(setq package-enable-at-startup nil)

;; inhibición de la pantalla de inicio
(setq inhibit-startup-screen t)
;; permite usar el alt - derecho de manera estandar
(setq mac-right-option-modifier nil)
;; deshabilita la barra de iconos
(tool-bar-mode -1)
;; abre todos los archivos en un mismo frame
(setq ns-pop-up-frames nil)
;; ajuste de línea
(global-visual-line-mode 1)


;; algo de estilo con colores por defecto
;;(load-theme 'misterioso)


;; carga de temas macrae
(use-package doom-themes
  :ensure t
  :after (spaceline)
  :init
  (setq
      doom-themes-enable-bold t
      doom-themes-enable-italic t
      doom-one-brighter-comments t
      doom-neotree-file-icons t)
  (load-theme 'doom-one t)
  :config
  (doom-themes-neotree-config))

;; spaceline macrae
(use-package spaceline
  :ensure t
  :init
  (require 'spaceline-config)
  (spaceline-emacs-theme))


(use-package spaceline-all-the-icons
  :ensure t
  :after spaceline
  :config
  (spaceline-all-the-icons-theme)
  (spaceline-all-the-icons--setup-git-ahead)
  (spaceline-toggle-all-the-icons-buffer-size-off)
  (spaceline-toggle-all-the-icons-hud-off)
  (spaceline-toggle-all-the-icons-vc-icon-off)
  (setq spaceline-all-the-icons-separator-type 'wave))



;; iconitos (macrae)
(use-package all-the-icons
  :ensure t
  :init
  (cond
  ((string-equal system-type "gnu/linux")
  (unless (file-exists-p (concat (getenv "HOME") "/.fonts/all-the-icons.ttf"))
      (let ((parent-directory (file-name-directory  (concat (getenv "HOME") "/.fonts/all-the-icons.ttf"))))
	(unless (file-exists-p parent-directory)
		 (make-directory parent-directory t)
		 (all-the-icons-install-fonts "t")))))
  ((string-equal system-type "darwin")
  (unless (file-exists-p (concat (getenv "HOME") "/Library/Fonts/all-the-icons.ttf"))
      (all-the-icons-install-fonts "t")))))

(use-package all-the-icons-dired
  :ensure t
  :hook
  (dired-mode . all-the-icons-dired-mode))

;; sobreescritura de la region seleccionada
(delete-selection-mode 1)

;; resaltar parentesis emparejados
(show-paren-mode 1)


;; guias de indentacion (macrae)
(use-package indent-guide
  :ensure t
  :config
  (indent-guide-global-mode))

;; salvado del historial de comandos del minibuffer
(savehist-mode 1)


;; recuperación entre arranques
(desktop-save-mode 1)


;; ajustes de backups (files~)
(setq
   backup-by-copying t
   backup-directory-alist
    '(("." . "~/.emacs.d/bck-files/"))
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)

;; ajustes de autoguardados (#files#)
(setq
   auto-save-file-name-transforms
   `((".*", "~/.emacs.d/bck-files/" t)))

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
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-forward-on-expand        nil
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-read-string-input             'from-child-frame
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-user-header-line-format       nil
          treemacs-width                         35
          treemacs-workspace-switch-cleanup      nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    (treemacs-resize-icons 15)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
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
  :after (treemacs dired)
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

;; Set default bookmark file and auto-saving
(setq bookmark-default-file "~/.emacs.d/bookmarks")
(setq bookmark-save-flag 1)

(require 'bookmark)
(bookmark-bmenu-list)
(switch-to-buffer "*Bookmark List*")

;; Necesario para habilitar las antiguas plantillas
;; Referencia: https://www.reddit.com/r/emacs/comments/ad68zk/get_easytemplates_back_in_orgmode_92/
(require 'org-tempo)

;; Posibles ajustes de estados TODO list
      (setq org-todo-keywords
	'(
      (sequence "TODO" "DOING" "|" "TRANSFERED" "POSTPONED" "DONE" "CANCELED")
      ;;(sequence "SENT" "APPROVED" "|" "PAID")
      ))

;; inherit shell variables correctly
;; now we can load node fine
(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns x))
  :config
  (exec-path-from-shell-initialize))

;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
 (awk . t)
 (C . t)
 (ditaa . t)
 (emacs-lisp . t)
 (dot . t)
 (js . t)
 (python . t)
 (shell . t)
 (sql . t)
 (sqlite . t)
 )
 )

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc"))

(use-package flycheck
  :ensure t
  :defer 2
  :diminish
  :init (global-flycheck-mode)
  :custom
  (flycheck-display-errors-delay .3)
)

(use-package yaml-mode
  :ensure t
)

(use-package hcl-mode
  :ensure t
  :mode ("\\.tf$" . hcl-mode)
)

(use-package ansible
  :ensure t
)

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package forge
  :ensure t
)

(use-package ido
  :ensure t
  :config
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  (ido-mode 1))

(use-package hydra
  :ensure t
)

;; DOCKER (macrae)
(use-package dockerfile-mode
  :ensure t
  :mode "\\Dockerfile\\'")

(use-package docker-tramp
  :ensure t)
(use-package docker
  :ensure t
  :bind ("C-c d" . hydra-docker/body)
  :config
  (defhydra hydra-docker (:columns 5 :color blue)
    "Docker"
    ("c" docker-containers "Containers")
    ("v" docker-volumes "Volumes")
    ("i" docker-images "Images")
    ("n" docker-networks "Networks")
    ("b" dockerfile-build-buffer "Build Buffer")
    ("q" nil "Quit")))

;; K8S (macrae)
(use-package kubernetes
  :ensure t
  :bind ("C-c k" . hydra-kube/body)
  :commands (kubernetes-overview)
  :config
  (defhydra hydra-kube (:columns 5 :color blue)
    "Kubernetes"
    ("o" kubernetes-overview "Overview")
    ("c" kubernetes-config-popup "Config")
    ("e" kubernetes-exec-popup "Exec")
    ("l" kubernetes-logs-popup "Logs")
    ("L" kubernetes-labels-popup "Labels")
    ("d" kubernetes-describe-popup "Describe")))

(global-set-key (kbd "<f3>") 'dired-sidebar-toggle-sidebar)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)
