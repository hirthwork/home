(require 'jabber)
(add-to-list 'jabber-account-list
  '("hirthwork@reinventedcode.com" (:connection-type . starttls)))
(setq jabber-invalid-certificate-servers '("reinventedcode.com"))
(setq jabber-history-enabled t)
(setq jabber-use-global-history nil)
(setq jabber-roster-show-bindings nil)
(setq jabber-backlog-number 20)
(setq jabber-backlog-days 7)
(setq jabber-chat-time-format "%F %T")
(setq jabber-chat-delayed-time-format "%F %T (offline)")

(add-to-list 'load-path "~/.emacs.d/emacs-point-el")
(require 'point-im)

(add-hook 'jabber-chat-mode-hook 'flyspell-mode)
(add-hook 'jabber-chat-mode-hook 'point-im-mode)

