(defun jabber-message-xosd (from buffer text proposed-alert)
  "Display incoming message event through the xosd"
  (let*
    ((process-connection-type nil)
    (process-name (start-process
      "jabber-xosd"
      nil
      "osd_cat"
      "-i800"
      "-f-misc-fixed-bold-r-normal--15-140-75-75-c-90-*-*"
      "-l100"
      "-o30"
      "-s1"
      "-clightgreen"
      "-")))
    (process-send-string process-name text)
    (process-send-eof process-name)))

(require 'jabber-alert)
(add-to-list 'jabber-alert-message-hooks 'jabber-message-xosd)

