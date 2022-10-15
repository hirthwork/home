(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq-default indent-tabs-mode nil)
(setq inhibit-startup-screen t)

(savehist-mode t)
(setq history-delete-duplicates t)

(global-set-key (kbd "C-x и") 'switch-to-buffer)

(mapc (lambda (f) (load-file (concat "~/.emacs.d/" f))) (directory-files "~/.emacs.d/" nil "\\.el$"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(warning-suppress-types '((comp) (comp) (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
