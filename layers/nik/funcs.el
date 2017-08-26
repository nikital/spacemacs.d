(defun evil-delete-to-bol ()
  (interactive)
  (evil-delete (point-at-bol) (point)))

(defun save-some-buffers-no-confirm ()
  (interactive)
  (save-some-buffers 'no-confirm))

(defun nik/evil-scroll-up ()
  (interactive)
  (evil-scroll-line-up 5))
(defun nik/evil-scroll-down ()
  (interactive)
  (evil-scroll-line-down 5))
