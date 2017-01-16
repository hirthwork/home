(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq-default indent-tabs-mode nil)
(setq inhibit-startup-screen t)

(savehist-mode t)
(setq history-delete-duplicates t)

(mapc (lambda (f) (load-file (concat "~/.emacs.d/" f))) (directory-files "~/.emacs.d/" nil "\\.el$"))
