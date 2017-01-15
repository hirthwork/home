(require 'jabber-core)
(require 'jabber-xml)

(defun jabber-handle-incoming-xep-0184-request (jc xml-data)
  "Check for XEP-0184 request and send delivery confirmation if any"
  (let
    ((id (jabber-xml-get-attribute xml-data 'id)))
    (when
      (and
        id
        (string=
          (jabber-xml-get-attribute
            (car (jabber-xml-get-children xml-data 'request))
            'xmlns)
          "urn:xmpp:receipts"))
      (jabber-send-sexp
        jc
        `(message
           ((to . ,(jabber-xml-get-attribute xml-data 'from)))
           (received ((xmlns . "urn:xmpp:receipts") (id . ,id))))))))

;; Add function last in chain, so message will be stored in jabber history
(add-to-list 'jabber-message-chain 'jabber-handle-incoming-xep-0184-request t)
(add-to-list 'jabber-advertised-features "urn:xmpp:receipts")

