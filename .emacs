(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq-default indent-tabs-mode nil)

(savehist-mode t)

(mapc (lambda (f) (load-file (concat "~/.emacs.d/" f))) (directory-files "~/.emacs.d/" nil "\\.el$"))
