(defconst company-insert-selected-packages
  '((company-insert-selected :location local)))

(defun company-insert-selected/init-company-insert-selected ()
  (use-package company-insert-selected
    :after company
    :bind (:map company-active-map
                ("TAB" . company-select-first-then-next)
                ("<tab>" . company-select-first-then-next))
    :config
    (unbind-key "<return>" company-active-map)
    (unbind-key "RET" company-active-map)

    (setq company-frontends '(company-insert-selected-frontend
                              company-pseudo-tooltip-frontend
                              company-echo-metadata-frontend))
    (setq company-selection-wrap-around t)))

