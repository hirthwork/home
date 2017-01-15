;; Originally from https://github.com/4DA/emacs-stuff/blob/master/comment.el
;; but modified a bit for redeye interface of bnw.im jabber bot

(defvar last-comins-begin -1)
(defvar last-comins-end -1)
(defvar comment-search-count 1)

(defun is-ro-at-pt(where)
  (member 'read-only (text-properties-at where)))

(defun find-readonly-end ()
  (save-excursion
    (end-of-buffer)
    (let ((curpos (point)))
      (while (and (not (is-ro-at-pt curpos))
                  (> curpos 0))
        (setq curpos (previous-property-change curpos)))
      curpos)))

(defun do-reply-to-post-comment (prefix regexp command)
  (if (eq last-command command)
      (setq comment-search-count (+ 1 comment-search-count ))
    (setq comment-search-count 1))

  (let ((re (find-readonly-end)))
    (if (is-ro-at-pt (point))
        ;; we might be on comment. jump to the next space sym
        (progn (re-search-forward "\\ ")
               (goto-char (match-beginning 0)))
      ;; start searching from editable space (to avoid counting pasted commend)
      (goto-char re))

    (if
      (re-search-backward regexp nil t comment-search-count)
      (progn
        (message (concat "last comins begin " (number-to-string last-comins-begin) " end is " (number-to-string last-comins-end)))
        (message (concat "comment search count " (number-to-string comment-search-count)))
        (when
          (> comment-search-count 1)
          (delete-region last-comins-begin last-comins-end))
        (end-of-buffer)
        ;; in jabber-el editable space begins 4 symbols starting from regions
        ;; border (don't know why)
        (goto-char (+ 4 re))
        (setq last-comins-begin (point))
        (setq last-comins-end
            (+
              1
              (length prefix)
              (point)
              (- (match-end 0) (+ 4 (match-beginning 0)))))
        (insert prefix)
        (insert-buffer-substring-no-properties
          (current-buffer)
          (+ 4 (match-beginning 0))
          (match-end 0))
        (insert " "))
      (message "No comments found"))))

(defun bnw-reply-to-post-comment()
  "Iterates over comment ids and puts them among with `c -m ' in buffer"
  (interactive)
  (save-excursion
    (do-reply-to-post-comment
      "c -m "
      "^--- [0-9A-Z]\\{6\\}\\(?:/[0-9A-Z]\\{3\\}\\)?"
      'bnw-reply-to-post-comment))
  (end-of-buffer))

(defun bnw-show-post()
  "Iterates over post ids and puts them among with `s -r -m ' in buffer"
  (interactive)
  (save-excursion
    (do-reply-to-post-comment
      "s -r -m "
      "^--- [0-9A-Z]\\{6\\}"
      'bnw-show-post))
  (end-of-buffer))

(global-set-key (kbd "M-p") 'bnw-reply-to-post-comment)
(global-set-key (kbd "M-P") 'bnw-show-post)

