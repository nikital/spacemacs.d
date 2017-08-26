(defconst nik-packages
  '(
    evil
    ))

(defun nik/post-init-evil ()
  (setq evil-want-C-u-scroll nil)

  (bind-key "C-u" 'evil-delete-to-bol evil-insert-state-map)
  (bind-key "RET" 'save-some-buffers-no-confirm evil-normal-state-map)
  (bind-key "C-j" 'nik/evil-scroll-down evil-motion-state-map)
  (bind-key "C-k" 'nik/evil-scroll-up evil-motion-state-map)
  (bind-key "C-p" 'project-find-file evil-normal-state-map))
