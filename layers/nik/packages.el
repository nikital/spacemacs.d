(defconst nik-packages
  '(
    evil
    company
    default-org-config
    org
    org-agenda
    cc-mode
    magit
    imenu
    ggtags
    ivy
    js2-mode
    terminal-here
    ))

(defun nik/post-init-evil ()
  (setq evil-want-C-u-scroll nil)

  (bind-key "C-u" 'evil-delete-to-bol evil-insert-state-map)
  (bind-key "C-e" 'end-of-line evil-insert-state-map)
  (bind-key "RET" 'save-some-buffers-no-confirm evil-normal-state-map)
  (bind-key "C-j" 'nik/evil-scroll-down evil-motion-state-map)
  (bind-key "C-k" 'nik/evil-scroll-up evil-motion-state-map)
  (bind-key "C-e" 'switch-to-buffer evil-motion-state-map)
  (bind-key "M-e" 'switch-to-buffer-other-window evil-motion-state-map)
  (bind-key "C-p" 'projectile-find-file evil-normal-state-map)
  (bind-key "M-p" 'projectile-find-file-other-window evil-normal-state-map)

  (evil-declare-not-repeat 'save-some-buffers-no-confirm)
  (evil-declare-not-repeat 'nik/evil-scroll-down)
  (evil-declare-not-repeat 'nik/evil-scroll-up))

(defun nik/pre-init-company ()
  (spacemacs|use-package-add-hook company
    :pre-config
    (unbind-key "C-w" company-active-map)
    :post-config
    (company-tng-configure-default)
    (when (configuration-layer/package-used-p 'evil)
      (add-hook 'evil-insert-state-exit-hook 'company-cancel))))

(defun nik/pre-init-default-org-config ()
  (spacemacs|use-package-add-hook org
    :post-config
    (evil-define-key 'normal org-mode-map (kbd "RET") nil)))

(defun nik/post-init-org ()
  (setq org-startup-with-inline-images nil
        org-cycle-separator-lines 1
        org-directory wiki-root)
  (let ((wiki-journal (concat wiki-root "Journal.org")))
    (setq org-capture-templates
          `(("j" "Journaling")
            ("ji" "Intersting things I learned" entry (file+olp+datetree ,wiki-journal)
             "* %? :interesting:")
            ("jl" "Log things I've done" entry (file+olp+datetree ,wiki-journal)
             "* Log :log:\n%?")))))

(defun nik/pre-init-org-agenda ()
  (spacemacs|use-package-add-hook org-agenda
    :pre-config
    (setq org-agenda-start-on-weekday nil)
    (setq org-agenda-weekend-days '(5 6))
    (when (file-exists-p (concat wiki-root "agenda.el"))
      (dolist (agenda-file (nik//file-to-sexp (concat wiki-root "agenda.el")))
        (when (string-match-p "\\.\\." agenda-file)
          (error "Agenda file outside of wiki-root"))
        (add-to-list 'org-agenda-files (concat wiki-root agenda-file))))))

(defun nik/pre-init-cc-mode ()
  (spacemacs|use-package-add-hook cc-mode
    :pre-init
    (advice-add
     'c-populate-syntax-table :after
     (lambda (table)
       (modify-syntax-entry ?_ "w" table)))))

(defun nik/pre-init-magit ()
  (when (configuration-layer/package-used-p 'projectile)
    (spacemacs|use-package-add-hook magit
      :post-init
      (spacemacs/set-leader-keys "gp" 'magit-status-projectile)))
  (spacemacs|use-package-add-hook magit
    :pre-config
    (setq magit-bury-buffer-function 'magit-mode-quit-window)))

(defun nik/pre-init-imenu ()
  (when (configuration-layer/package-used-p 'evil)
    (spacemacs|use-package-add-hook imenu
      :post-init
      (evil-set-command-property 'imenu :jump t))))

(defun nik/pre-init-ggtags ()
  (when (configuration-layer/package-used-p 'evil)
    (spacemacs|use-package-add-hook ggtags
      :post-init
      (bind-key "C-]" 'ggtags-find-tag-dwim evil-normal-state-map)
      :post-config
      (evil-define-minor-mode-key 'normal 'ggtags-navigation-mode
        "\r" 'ggtags-navigation-mode-done
        [return] 'ggtags-navigation-mode-done))))

(defun nik/pre-init-ivy ()
  (setq confirm-nonexistent-file-or-buffer t)
  (advice-add 'ivy-read :filter-args 'nik/ivy-projectile-require-match))

(defun nik/pre-init-js2-mode ()
  (spacemacs|use-package-add-hook js2-mode
    :post-config
    (setq js2-strict-missing-semi-warning nil)))

(defun nik/init-terminal-here ()
  (use-package terminal-here
    :defer t
    :commands (terminal-here-launch
               terminal-here-project-launch)
    :init
    (spacemacs/set-leader-keys "at" 'terminal-here-launch)
    :config
    (setq terminal-here-terminal-command '("gnome-terminal"))))
