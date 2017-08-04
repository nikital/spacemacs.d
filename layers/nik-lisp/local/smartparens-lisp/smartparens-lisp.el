(require 'smartparens)

(defun sp-forward-slurp-from-behind ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (backward-sexp)
    (sp-down-sexp)
    (sp-forward-slurp-sexp)))

(defun sp-forward-barf-from-behind ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (sp-forward-barf-sexp)))

(define-minor-mode smartparens-lisp-mode
  "Add extra bindings when editing lisp"
  :keymap (let ((map (make-sparse-keymap)))
            (bind-key "<C-right>" 'sp-forward-slurp-sexp map)
            (bind-key "<C-left>" 'sp-forward-barf-sexp map)
            (bind-key "<C-S-right>" 'sp-backward-barf-sexp map)
            (bind-key "<C-S-left>" 'sp-backward-slurp-sexp map)
            (bind-key "M-u" 'sp-backward-up-sexp map)
            (bind-key "M-d" 'sp-kill-sexp map)
            (bind-key "M-y" 'sp-copy-sexp map)
            (bind-key "M-r" 'sp-raise-sexp map)
            (bind-key "M-k" 'sp-forward-slurp-from-behind map)
            (bind-key "M-h" 'sp-forward-barf-from-behind map)
            map))
