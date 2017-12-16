(defconst nik-packages
  '(
    evil
    company
    default-org-config
    org-agenda
    ))

(defun nik/post-init-evil ()
  (setq evil-want-C-u-scroll nil)

  (bind-key "C-u" 'evil-delete-to-bol evil-insert-state-map)
  (bind-key "C-e" 'end-of-line evil-insert-state-map)
  (bind-key "RET" 'save-some-buffers-no-confirm evil-normal-state-map)
  (bind-key "C-j" 'nik/evil-scroll-down evil-motion-state-map)
  (bind-key "C-k" 'nik/evil-scroll-up evil-motion-state-map)
  (bind-key "C-e" 'switch-to-buffer evil-normal-state-map)
  (bind-key "M-e" 'switch-to-buffer-other-window evil-normal-state-map)
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

(defun nik/pre-init-org-agenda ()
  (spacemacs|use-package-add-hook org-agenda
    :pre-config
    (when (file-exists-p (concat wiki-root "agenda.el"))
      (dolist (agenda-file (nik//file-to-sexp (concat wiki-root "agenda.el")))
        (when (string-match-p "\\.\\." agenda-file)
          (error "Agenda file outside of wiki-root"))
        (add-to-list 'org-agenda-files (concat wiki-root agenda-file))))))
