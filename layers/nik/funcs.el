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
  (unless (string-prefix-p
           wiki-root
           (expand-file-name default-directory))
    (error "Not on a wiki buffer"))
  (save-some-buffers-no-confirm)
  (async-shell-command "git add -A && git commit -m . && git push && echo Finished"))

(defun wiki-find-file ()
  (interactive)
  (let ((default-directory wiki-root)
        projectile-cached-project-root
        projectile-cached-project-name)
    (projectile-find-file)))

(defun nik//file-to-sexp (filename)
  (with-temp-buffer
    (insert-file-contents filename)
    (beginning-of-buffer)
    (read (current-buffer))))

(defun quit-other-window (&optional kill)
  (interactive)
  (quit-window kill (next-window)))

(when (configuration-layer/package-used-p 'projectile)
  (defun magit-status-projectile ()
    (interactive)
    (magit-status
     (completing-read "git status: "
                      (projectile-relevant-known-projects)))))

(defun nik/ivy-projectile-require-match (args)
  (let ((optional (nthcdr 2 args)))
    (if (equal 'projectile-completing-read
               (plist-get optional :caller))
        (append args '(:require-match t))
      args)))

(defun eshell/ll (&rest args)
  (eshell/ls "-l" args))

(defun eshell/la (&rest args)
  (eshell/ls "-la" args))
