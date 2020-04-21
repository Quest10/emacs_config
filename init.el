;;Personal configuration for Emacs
;;Gerardo Diez García
;;2018-2020

(setq warning-minimum-level :error)

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
  :init
  (require 'spaceline-config)
  (spaceline-emacs-theme))


  (use-package spaceline-all-the-icons
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
  :init
  (cond
   ((string-equal system-type "gnu/linux")
    (if (not
      (file-exists-p (concat (getenv "HOME") "/.fonts/all-the-icons.ttf")))
      (all-the-icons-install-fonts "t")))
   ((string-equal system-type "darwin")
     (if (not
      (file-exists-p (concat (getenv "HOME") "/Library/Fonts/all-the-icons.ttf")))
      (all-the-icons-install-fonts "t")))))

(use-package all-the-icons-dired
  :hook
  (dired-mode . all-the-icons-dired-mode))

;; sobreescritura de la region seleccionada
(delete-selection-mode 1)

;; resaltar parentesis emparejados
(show-paren-mode 1)


;; guias de indentacion (macrae)
(use-package indent-guide
  :config
  (indent-guide-global-mode))

;; salvado del historial de comandos del minibuffer
(savehist-mode 1)


;; sidebar para dired
(use-package dired-sidebar
  :ensure t
  :commands (dired-sidebar-toggle-sidebar))

(global-set-key (kbd "<f3>") 'dired-sidebar-toggle-sidebar)

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

;; Set default bookmark file and auto-saving
(setq bookmark-default-file "~/.emacs.d/bookmarks")
(setq bookmark-save-flag 1)

(require 'bookmark)
(bookmark-bmenu-list)
(switch-to-buffer "*Bookmark List*")

;; ORG MODE
(eval-after-load 'org
'(progn
(add-to-list 'org-structure-template-alist
             '("P" "#+TITLE:\n#+OPTIONS: toc:nil\n#+TAGS:\n\n? "))))


;; ajustes estados TODO list
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

(use-package flycheck
  :defer 2
  :diminish
  :init (global-flycheck-mode)
  :custom
  (flycheck-display-errors-delay .3)
)

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package ido
  :config
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  (ido-mode 1))

;; DOCKER (macrae)
(use-package dockerfile-mode
  :mode "\\Dockerfile\\'")

(use-package docker-tramp)
(use-package docker
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
