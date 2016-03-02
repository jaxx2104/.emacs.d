;;; load-pathを追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; タイトルバーにファイルのフルパス表示
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))


;; 括弧の範囲内を強調表示
(show-paren-mode t)
(setq show-paren-delay 0)

;; default to unified diffs
(setq diff-switches "-u")

;;バックアップファイルを作らない
(setq make-backup-files nil)
(setq auto-save-default nil)

;; メニューバーを非表示
(menu-bar-mode -1)

;; 起動画面非表示
(setq inhibit-startup-message t)

;; 起動画面非表示
(setq initial-scratch-message nil)

;; カーソルの位置が何文字目かを表示する
(column-number-mode t)


;; 行末の空白を強調表示
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "#b14770")

;; ミニバッファの履歴を保存する
(savehist-mode 1)

;; ミニバッファの履歴の保存数を増やす
(setq history-length 3000)

;; 行間
(setq-default line-spacing 0)

;; 1行ずつスクロール
(setq scroll-conservatively 35
      scroll-margin 0
      scroll-step 1)
(setq comint-scroll-show-maximum-output t) ;; shell-mode

;; オートインデントでスペースを使う
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; undo
(define-key global-map (kbd "C-z") 'undo)

;; 対応する括弧を光らせる
(show-paren-mode 1)
;; ウィンドウ内に収まらないときだけ括弧内も光らせる
(setq show-paren-style 'mixed)

;; 終了時にオートセーブファイルを消す
(setq delete-auto-save-files t)

;;折り返さない
(setq-default truncate-lines t)
;;ウィンドウを左右に分割したとき用の設定
(setq-default truncate-partial-width-windows t)

;; window間の移動
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(windmove-default-keybindings 'meta)

(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

;; PEAR規約のインデント設定にする
(setq php-mode-force-pear t)

;; 配列のインデントを4文字下げにする
(add-hook 'php-mode-hook
	  (lambda ()
	    (defun ywb-php-lineup-arglist-intro (langelem)
	      (save-excursion
		(goto-char (cdr langelem))
		(vector (+ (current-column) c-basic-offset))))
	    (defun ywb-php-lineup-arglist-close (langelem)
	      (save-excursion
		(goto-char (cdr langelem))
		(vector (current-column))))
	    (c-set-offset 'arglist-intro 'ywb-php-lineup-arglist-intro)
	    (c-set-offset 'arglist-close 'ywb-php-lineup-arglist-close)))

;; 24.3 テーマ::molokai
(load-theme 'monokai t)
;;(load-theme 'atom-dark t)

;; web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
;;;(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(setq web-mode-markup-indent-offset 4)
(setq web-mode-css-indent-offset 4)
(setq web-mode-code-indent-offset 4)
(setq web-mode-indent-style 4)
(add-hook 'web-mode-hook 'auto-complete-mode)

;; auto-complete
(add-to-list 'load-path "~/.emacs.d/elisp/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/ac-dict")
(ac-config-default)
;; 曖昧マッチ有効
(setq ac-use-fuzzy t)
;; 補完推測機能有効
(setq ac-use-comphist t)

;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'php-mode-hook 'flycheck-mode)


;; gotoした際にエラーメッセージをminibufferに表示する
(defun display-error-message ()
  (message (get-char-property (point) 'help-echo)))
(defadvice flymake-goto-prev-error (after flymake-goto-prev-error-display-message)
  (display-error-message))
(defadvice flymake-goto-next-error (after flymake-goto-next-error-display-message)
  (display-error-message))
(ad-activate 'flymake-goto-prev-error 'flymake-goto-prev-error-display-message)
(ad-activate 'flymake-goto-next-error 'flymake-goto-next-error-display-message)
(put 'dired-find-alternate-file 'disabled nil)

(require 'rainbow-delimiters)
(rainbow-delimiters-mode)
(add-hook 'web-mode-hook 'rainbow-delimiters-mode)
(add-hook 'php-mode-hook 'rainbow-delimiters-mode)
(add-hook 'html-mode-hook 'rainbow-delimiters-mode)

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(require 'magit)
