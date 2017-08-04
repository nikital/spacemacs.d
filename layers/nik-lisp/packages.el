(defconst nik-lisp-packages
  '(
    smartparens
    (smartparens-lisp :location local)
    ))

(defun nik-lisp/init-smartparens-lisp ()
  (use-package smartparens-lisp
    :commands smartparens-lisp-mode))

(defun nik-lisp/post-init-smartparens ()
  (when (configuration-layer/package-usedp 'smartparens-lisp)
    (add-hook 'lisp-mode-hook 'smartparens-lisp-mode)
    (add-hook 'emacs-lisp-mode-hook 'smartparens-lisp-mode)))

;;; packages.el ends here
