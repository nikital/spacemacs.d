;; -*- mode: lisp-interaction; -*-

(defvar-local company-insert-selected--overlay nil)
(defvar-local company-insert-selected--keymap-overridden nil)

(defun company-insert-selected-frontend (command)
  "When the user changes the selection at least once, this
frontend will insert the candidate into the buffer as it it's
already there and any key outside of `company-active-map' will
confirm the selection and finish the completion."
  (cl-case command
    (show
     (setq company-insert-selected--overlay (make-overlay (point) (point))
           company-insert-selected--keymap-overridden nil)
     (overlay-put company-insert-selected--overlay 'priority 2)
     (advice-add 'company-fill-propertize :filter-args 'company-insert-selected//adjust-tooltip-highlight))
    (update
     (when company-selection-changed
       (let ((ov company-insert-selected--overlay)
             (selected (nth company-selection company-candidates))
             (prefix (length company-prefix)))
         (move-overlay ov (- (point) prefix) (point))
         (overlay-put ov 'display selected))
       (unless company-insert-selected--keymap-overridden
         ;; Any key that is not on the `company-active-map' should complete the
         ;; selection
         (company-enable-overriding-keymap
          (make-composed-keymap
           company-active-map
           '(keymap (t . company-complete-selection-and-redo-input))))
         (setq company-insert-selected--keymap-overridden t))))
    (hide
     (advice-remove 'company-fill-propertize 'company-insert-selected//adjust-tooltip-highlight)
     (when company-insert-selected--overlay
       (delete-overlay company-insert-selected--overlay)))))

(defun company-insert-selected//adjust-tooltip-highlight (args)
  "Don't allow the tooltip to highlight the current selection if
it wasn't made explicitly (e.g. `company-selection-changed' is
true)"
  (unless company-selection-changed
    ;; The 4th arg of `company-fill-propertize' is selected
    (setf (nth 3 args) nil))
  args)

(defun company-complete-selection-and-redo-input ()
  "Run `company-complete-selection' and put the input keys that
invoked this command back to the `unread-command-events'.

The intention of this is to apply the effect of the keys as if
there was no completion running when they were pressed."
  (interactive)
  (company-complete-selection)
  (setq unread-command-events (nconc
                               (listify-key-sequence (this-command-keys))
                               unread-command-events)))

(defun company-select-first-then-next ()
  (interactive)
    (if company-selection-changed
        (company-select-next)
      (company-set-selection 0 'force-update)))

(progn
  (setq company-frontends '(company-insert-selected-frontend
                            company-pseudo-tooltip-frontend
                            company-echo-metadata-frontend))
  (setq company-selection-wrap-around t)
  (unbind-key "RET" company-active-map)
  (unbind-key "<return>" company-active-map)
  (bind-key "TAB" 'company-select-first-then-next company-active-map)
  (bind-key "<tab>" 'company-select-first-then-next company-active-map))
