;;; company-insert-selected.el
;;
;; Similar to the way neocomplete package from Vim deals with autocompletion
;;

(defvar-local company-insert-selected--overlay nil)

(defun company--company-command-p (keys)
  "Checks if the keys are part of company's overriding keymap"
  (or (equal [company-dummy-event] keys)
      (lookup-key company-my-keymap keys)))

(defun company-insert-selected-frontend (command)
  "When the user changes the selection at least once, this
frontend will display the candidate in the buffer as if it's
already there and any key outside of `company-active-map' will
confirm the selection and finish the completion."
  (cl-case command
    (show
     (setq company-insert-selected--overlay (make-overlay (point) (point)))
     (overlay-put company-insert-selected--overlay 'priority 2)
     (advice-add 'company-fill-propertize :filter-args 'company-insert-selected//adjust-tooltip-highlight))
    (update
     (when company-selection-changed
       (let ((ov company-insert-selected--overlay)
             (selected (nth company-selection company-candidates))
             (prefix (length company-prefix)))
         (move-overlay ov (- (point) prefix) (point))
         (overlay-put ov 'display selected))))
    (hide
     (advice-remove 'company-fill-propertize 'company-insert-selected//adjust-tooltip-highlight)
     (when company-insert-selected--overlay
       (delete-overlay company-insert-selected--overlay)))
    (pre-command
     (when (and company-selection-changed
                (not (company--company-command-p (this-command-keys))))
       (evil-repeat-changes 'pre)
       (let ((this-command 'company-complete-selection))
         (company-complete-selection))
       (evil-repeat-changes 'post)))))

(defun company-insert-selected//adjust-tooltip-highlight (args)
  "Don't allow the tooltip to highlight the current selection if
it wasn't made explicitly (i.e. `company-selection-changed' is
true)"
  (unless company-selection-changed
    ;; The 4th arg of `company-fill-propertize' is selected
    (setf (nth 3 args) nil))
  args)

(defun company-select-first-then-next (&optional arg)
  (interactive "p")
    (if company-selection-changed
        (company-select-next arg)
      (company-set-selection (1- (or arg 1)) 'force-update)))

(provide 'company-insert-selected)
