(defun jabber-status-update ()
  "Updates dwm status with list of contacts with unread messages"
  (if
    jabber-activity-jids
    (with-temp-file "~/.emacs.d/jabber-status"
      (insert
        (mapconcat
          (lambda (jid) (concat "⎁" (cdr jid)))
          (mapcar 'jabber-activity-lookup-name jabber-activity-jids)
          " ")))
    (ignore-errors (delete-file "~/.emacs.d/jabber-status")))
  (start-process-shell-command "dwm-update" nil "~/.dwm.update"))

(require 'jabber-activity)
(add-hook 'jabber-activity-update-hook 'jabber-status-update)
