;;; company-neo.el
;;
;; Heavily based on:
;; https://gist.github.com/aaronjensen/a46f88dbd1ab9bb3aa22
;; aaronjensen/company-complete-cycle.el
;; Modify company so that tab and S-tab cycle through completions without
;; needing to hit enter.
;; Similar to the way neocomplete package from Vim deals with autocompletion
;;

(defvar-local company-neo--prefix nil)
(defvar-local company-neo--start-point nil)

(defun company-neo-frontend (command)
  (cl-case command
    (show
     (advice-add 'company-tooltip--lines-update-offset
                 :filter-args 'company-neo//clamp-selection)
     (advice-add 'company-tooltip--simple-update-offset
                 :filter-args 'company-neo//clamp-selection)
     (advice-add 'company-set-selection
                 :override 'company-neo//set-selection)

     (company-neo//start))
    (update
     (when (not (equal company-prefix company-neo--prefix))
       ;; Restart completion because prefix has changed
       (company-neo//start)))
    (hide
     (advice-remove 'company-tooltip--lines-update-offset
                    'company-neo//clamp-selection)
     (advice-remove 'company-tooltip--simple-update-offset
                    'company-neo//clamp-selection)
     (advice-remove 'company-set-selection
                    'company-neo//set-selection)
     )
    ))

(defun company-neo/next (&optional arg)
  (interactive "p")
  (company-select-next arg)
  (company-neo//complete-selection-and-stay))

(defun company-neo/previous (&optional arg)
  (interactive "p")
  (company-select-previous arg)
  (company-neo//complete-selection-and-stay))

(put 'company-neo/next 'company-keep t)
(put 'company-neo/previous 'company-keep t)

(defun company-neo//start ()
  (setq company-selection -1
        company-neo--prefix company-prefix
        company-neo--start-point nil))

(defun company-neo//complete-selection-and-stay ()
  (if (cdr company-candidates)
      (when (company-manual-begin)
        (when company-neo--start-point
          (delete-region company-neo--start-point (point)))
        (setq company-neo--start-point (point))

        (unless (eq company-selection -1)
          (company--insert-candidate (nth company-selection company-candidates)))

        (company-call-frontends 'update)
        ;; post-command might redraw the tooltip, lie about the prefix to put
        ;; the tooltip on the correct alignment
        (let ((company-prefix (if (eq company-selection -1)
                                  company-prefix
                                (nth company-selection company-candidates))))
          (company-call-frontends 'post-command)))
    (company-complete-selection)))

(defun company-neo//set-selection (selection &optional force-update)
  "Reimplement company-set-selection and allow selection to be -1"
  (setq selection
        (if company-selection-wrap-around
            (mod selection company-candidates-length)
          (max -1 (min (1- company-candidates-length) selection))))
  (when (or force-update (not (equal selection company-selection)))
    (setq company-selection selection
          company-selection-changed t)
    (company-call-frontends 'update)))

(defun company-neo//clamp-selection (args)
  "Clamp selection for functions that don't expect a negative selection index"
  (cons (max 0 (car args))
        (cdr args)))

(provide 'company-neo)
