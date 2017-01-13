(require 'jabber)
(add-to-list 'jabber-account-list
  '("hirthwork@reinventedcode.com" (:connection-type . starttls)))
(setq jabber-invalid-certificate-servers '("reinventedcode.com"))
(setq jabber-history-enabled t)
(setq jabber-use-global-history nil)
(setq jabber-backlog-number 20)
(setq jabber-backlog-days 7)

(add-to-list 'load-path "~/.emacs.d/emacs-point-el")
(require 'point-im)

(add-hook 'jabber-chat-mode-hook 'flyspell-mode)
(add-hook 'jabber-chat-mode-hook 'point-im-mode)

(require 'jabber-core)
(require 'jabber-xml)

(defun jabber-handle-incoming-xep-0184-request (jc xml-data)
  "Check for XEP-0184 request and send delivery confirmation if any"
  (let
    ((id (jabber-xml-get-attribute xml-data 'id)))
    (when
      (string=
        (jabber-xml-get-attribute
          (car (jabber-xml-get-children xml-data 'request))
          'xmlns)
        "urn:xmpp:receipts"))
      (jabber-send-sexp
        jc
        `(message
           ((to . ,(jabber-xml-get-attribute xml-data 'from)))
           (received ((xmlns . "urn:xmpp:receipts") (id . ,id)))))))

; Add function last in chain, so message will be stored in jabber history
(add-to-list 'jabber-message-chain 'jabber-handle-incoming-xep-0184-request t)

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

