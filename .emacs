(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq-default indent-tabs-mode nil)
(setq inhibit-startup-screen t)

(savehist-mode t)
(setq history-delete-duplicates t)

(global-set-key (kbd "C-x и") 'switch-to-buffer)

(mapc (lambda (f) (load-file (concat "~/.emacs.d/" f))) (directory-files "~/.emacs.d/" nil "\\.el$"))
