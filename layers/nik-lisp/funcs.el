(defun nik-lisp/bind-smartparens-locally ()
  (bind-key "<C-right>" 'sp-forward-slurp-sexp (current-local-map))
  (bind-key "<C-left>" 'sp-forward-barf-sexp (current-local-map))
  (bind-key "<C-S-right>" 'sp-backward-barf-sexp (current-local-map))
  (bind-key "<C-S-left>" 'sp-backward-slurp-sexp (current-local-map))
  (bind-key "M-u" 'sp-backward-up-sexp (current-local-map))
  (bind-key "M-d" 'sp-kill-sexp (current-local-map))
  (bind-key "M-r" 'sp-raise-sexp (current-local-map))
  (bind-key "M-k" 'nik-lisp/slurp-from-behind (current-local-map))
  (bind-key "M-h" 'nik-lisp/barf-from-behind (current-local-map)))

(defun nik-lisp/slurp-from-behind ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (backward-sexp)
    (sp-down-sexp)))

(defun nik-lisp/barf-from-behind ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (sp-forward-barf-sexp)))
