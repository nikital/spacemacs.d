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

(defun wiki-commit ()
  (interactive)
  (if (string-prefix-p
       wiki-root
       (expand-file-name default-directory))
      (async-shell-command "git add -A && git commit -m . && git push")
    (error "Not on a wiki buffer")))

(defun wiki-find-file ()
  (interactive)
  (let ((default-directory wiki-root))
    (projectile-find-file)))

(defun quit-other-window (&optional kill)
  (interactive)
  (quit-window kill (next-window)))
