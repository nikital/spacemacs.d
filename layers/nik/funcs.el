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

(defun magit-submodule-update-recursive (&optional init)
  "Clone missing submodules and checkout appropriate commits.
With a prefix argument also register submodules in \".git/config\"."
  (interactive "P")
  (magit-with-toplevel
    (magit-run-git-async "submodule" "update" "--recursive" (and init "--init"))))
