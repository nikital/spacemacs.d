(defconst nik-packages
  '(
    evil
    company
    ))

(defun nik/post-init-evil ()
  (setq evil-want-C-u-scroll nil)

  (bind-key "C-u" 'evil-delete-to-bol evil-insert-state-map)
  (bind-key "RET" 'save-some-buffers-no-confirm evil-normal-state-map)
  (bind-key "C-j" 'nik/evil-scroll-down evil-motion-state-map)
  (bind-key "C-k" 'nik/evil-scroll-up evil-motion-state-map)
  (bind-key "C-p" 'projectile-find-file evil-normal-state-map))

(defun nik/pre-init-company ()
  (spacemacs|use-package-add-hook company
    :pre-config
    (unbind-key "C-w" company-active-map)))
