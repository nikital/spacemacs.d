;;; packages.el --- company-neo layer packages file for Spacemacs.
;;
;; Author: Nikita Leshenko
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:
;;
;; Integrates company-neo for neocomplete like completions into Spacemacs
;;;

;;; Code:

(defconst company-neo-packages
  '(
    (company-neo :location local)
    ))

(defun company-neo/init-company-neo ()
  (use-package company-neo
    :after company
    :bind (:map company-active-map
           ("TAB" . company-neo/next)
           ("<tab>" . company-neo/next)
           ("S-TAB" . company-neo/previous)
           ("<S-tab>" . company-neo/previous)
           ("<backtab>" . company-neo/previous)
           )
    :config
    (unbind-key "<return>" company-active-map)
    (unbind-key "RET" company-active-map)
    (add-to-list 'company-frontends 'company-neo-frontend)

    (with-eval-after-load 'evil
      (evil-declare-change-repeat 'company-neo/next)
      (evil-declare-change-repeat 'company-neo/previous)
      )
    ))

;;; packages.el ends here
