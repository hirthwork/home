(defun dwm-status-update ()
  (let
    ((process-connection-type nil))
    (start-process-shell-command "dwm-update" nil "~/.dwm.update")))

(defun jabber-status-update ()
  "Updates dwm status with list of contacts with unread messages"
  (if
    jabber-activity-jids
    (progn
      (with-temp-file "~/.emacs.d/jabber-status"
        (insert
          (mapconcat
            (lambda (jid) (concat "⎁" (cdr jid)))
            (mapcar 'jabber-activity-lookup-name jabber-activity-jids)
            " ")))
      (dwm-status-update))
    (ignore-errors
      (progn
        (delete-file "~/.emacs.d/jabber-status")
        (dwm-status-update)))))

(require 'jabber-activity)
(add-hook 'jabber-activity-update-hook 'jabber-status-update)
