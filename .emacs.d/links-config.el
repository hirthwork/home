(defun feh-browse (url &rest ignore)
  "Browse image using feh."
  (interactive (browse-url-interactive-arg "URL: "))
  (start-process (concat "feh " url) nil "feh" url))

(defun mpv-browse (url &rest ignore)
  "Browse image using mpv."
  (interactive (browse-url-interactive-arg "URL: "))
  (start-process (concat "mpv --loop-file=inf" url) nil "mpv" "--loop-file=inf" url))

(setq browse-url-browser-function
  '(("\\.\\(jpe?g\\|png\\)\\(:large\\|:orig\\)?\\(\\?.*\\)?$" . feh-browse)
    ("^https?://img-fotki\\.yandex\\.ru/get/" . feh-browse)
    ("^https?://pics\\.livejournal\\.com/.*/pic/" . feh-browse)
    ("^https?://l-userpic\\.livejournal\\.com/" . feh-browse)
    ("^https?://img\\.leprosorium\\.com/[0-9]+$" . feh-browse)
    ("\\.\\(gifv?\\|avi\\|AVI\\|mp[4g]\\|MP4\\|webm\\)$" . mpv-browse)
    ("^https?://\\(www\\.youtube\\.com\\|youtu\\.be\\|coub\\.com\\|vimeo\\.com\\|www\\.liveleak\\.com\\)/" . mpv-browse)
    ("^https?://www\\.facebook\\.com/.*/videos?/" . mpv-browse)
    ("." . browse-url-xdg-open)))
