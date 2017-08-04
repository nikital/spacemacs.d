(defconst nik-lisp-packages
  '(smartparens))

(defun nik-lisp/post-init-smartparens ()
  (add-hook 'lisp-mode-hook 'nik-lisp/bind-smartparens-locally)
  (add-hook 'emacs-lisp-mode-hook 'nik-lisp/bind-smartparens-locally))

;;; packages.el ends here
