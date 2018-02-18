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
  (bind-key "M-p" 'projectile-find-file-other-window evil-normal-state-map))

(defun nik/pre-init-company ()
  (spacemacs|use-package-add-hook company
    :pre-config
    (unbind-key "C-w" company-active-map)
    :post-config
    (company-tng-configure-default)))

(defun nik/pre-init-default-org-config ()
  (spacemacs|use-package-add-hook org
    :post-config
    (evil-define-key 'normal org-mode-map (kbd "RET") nil)))

(defun nik/post-init-org ()
  (setq org-startup-with-inline-images nil))

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
    (advice-add 'magit-submodule-update :override 'magit-submodule-update-recursive)))

(defun nik/pre-init-imenu ()
  (when (configuration-layer/package-used-p 'evil)
    (spacemacs|use-package-add-hook imenu
      :post-init
      (evil-set-command-property 'imenu :jump t))))
