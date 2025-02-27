;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "syryuauros"
      user-mail-address "sy.ryu@aurostech.com")

(setq default-input-method "korean-hangul3f")

(setq-default backup-directory-alist '(("" . "~/.backup"))
              make-backup-files t
              vc-make-backup-files t
              backup-by-copying t
              version-control t
              delete-old-versions t
              kept-new-versions 99
              kept-old-versions 0
)

(defun force-backup-of-buffer ()
  (setq buffer-backed-up nil)
  (backup-buffer))
(add-hook 'before-save-hook  'force-backup-of-buffer)

(setq doom-theme 'doom-oceanic-next)

;; (use-package 'doom-oceanic-next
;;   :ensure t
;;   :config
;;   ;; Global settings (defaults)
;;   (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
;;         doom-themes-enable-italic t) ; if nil, italics is universally disabled
;;   (load-theme 'doom-oceanic-next t)

;;   ;; Enable flashing mode-line on errors
;;   (doom-themes-visual-bell-config)
;;   ;; Enable custom neotree theme (all-the-icons must be installed!)
;;   (doom-themes-neotree-config)
;;   ;; or for treemacs users
;;   (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
;;   (doom-themes-treemacs-config)
;;   ;; Corrects (and improves) org-mode's native fontification.
;;   (doom-themes-org-config))

(use-package! face-remap
  :custom-face
  (default ((t (:family "Mononoki Nerd Font Mono"))))
  (fixed-pitch ((t (:family "Mononoki Nerd Font Mono"))))
  ;; (variable-pitch ((t (:family "SeoulHangang CB"))))
  (variable-pitch ((t (:family "Noto Sans CJK KR"))))
)

;; M-x counsel-fonts for other font options
;; (use-package! face-remap
;;   :custom-face
;;   (default ((t (:family "SauceCodePro Nerd Font Mono"))))
;;   (fixed-pitch ((t (:family "SauceCodePro Nerd Font Mono"))))
;;   (variable-pitch ((t (:family "SauceCodePro Nerd Font"))))
;; )

(use-package! mixed-pitch
  :hook
  (org-mode . mixed-pitch-mode)
)

(setq display-line-numbers-type t)

(use-package! windsize
  :custom
  (windsize-cols 1)
  (windsize-rows 1)
  :commands windsize-left windsize-right
            windsize-up windsize-down
)

(map!
  "C-S-h" #'windsize-left
  "C-S-l" #'windsize-right
  "C-S-k" #'windsize-up
  "C-S-j" #'windsize-down
)

(use-package! winum
  :config
  (winum-mode 1)
)

(use-package! envrc
  :hook (after-init . envrc-global-mode))

(use-package! lsp-mode
  :custom
  (lsp-completion-enable-additional-text-edit nil)
  (lsp-lens-enable nil)
  :hook (lsp-mode . (lambda ()
     (lsp-ui-mode)
     (lsp-ui-doc-mode)
   ))
)

(use-package! lsp-ui)

(after! lsp-ui
  (setq lsp-ui-doc-position 'top)
  (setq lsp-ui-doc-show-with-cursor t)
  (setq lsp-ui-sideline-show-code-actions t))

(defun my/cycle-lsp-ui-doc-position ()
  (interactive)
  (setq lsp-ui-doc-position
     (let ((x lsp-ui-doc-position))
        (cond ((eq x 'top) 'bottom)
              ((eq x 'bottom) 'at-point)
              ((eq x 'at-point) 'top))))
)

(defun set-lsp-ui-doc-size()
  (interactive)
  (setq lsp-ui-doc-text-scale-level 2)
  (setq lsp-ui-doc-max-width 300)
  (setq lsp-ui-doc-max-height 50))

(use-package! lsp-haskell
  :hook ((haskell-mode . lsp-deferred)
         (haskell-mode . (lambda ()
                           (set-tab-width)
                           (set-lsp-ui-doc-size)
                           (lsp-ui-mode)
                           (lsp-ui-doc-mode)))))

;; add to $DOOMDIR/config.el
(after! lsp-mode
  (advice-remove #'lsp #'+lsp-dont-prompt-to-install-servers-maybe-a))

  (defun my/org-archive()
    (setq
      org-archive-mark-done nil
      org-archive-location "%s_arxiv::"
    )
  )

  (defun my/org-capture()
     (setq org-capture-templates `(
            ("h" "Haedosa" entry
              (file+olp+datetree ,(concat org-directory "/haedosa/README.org"))
              "* %? %U\n%a\n%i"
            )
            ("m" "Memo" entry
              (file+olp+datetree ,(concat org-directory "/memo/memo.org"))
              "* %? %U\n%a\n%i"
            )
          ))
  )

  (defun my/org-agenda()
    (setq org-agenda-files
       (list
          (concat org-directory "/haedosa/README.org")
          (concat org-directory "/memo/memo.org")
       )
    )

    (setq org-agenda-ndays 7
          org-agenda-show-all-dates t)
  )

  (defun my/org-babel()

    (org-babel-do-load-languages
      'org-babel-load-languages
      '((haskell . t)
        (emacs-lisp . t)
        (shell . t)
        (sql . t)
        (ruby . t)
        (python . t)
        (maxima . t)
        (C . t)
        (R . t)
        (latex . t)
        (ditaa . t)
        (java . t))
    )

    (setq org-catch-invisible-edits           'show
          org-src-preserve-indentation        t
          org-src-tab-acts-natively           t
          org-fontify-quote-and-verse-blocks  t
          org-return-follows-link             t
          org-edit-src-content-indentation    0
          org-src-fontify-natively            t
          org-confirm-babel-evaluate          nil
    )
  )

  (defun my/org-id()
    (advice-add 'org-id-new :filter-return #'upcase)
  )

  (defun my/org-header-size()
  (dolist (face '((org-level-1 . 1.3)
                  (org-level-2 . 1.2)
                  (org-level-3 . 1.1)
                  (org-level-4 . 1.1)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.0)
                  (org-level-7 . 1.0)
                  (org-level-8 . 1.0)))
  (set-face-attribute (car face) nil :height (cdr face)))
  )

(use-package! org-roam
  :ensure t
  :custom
  ;; (org-roam-directory (file-truename "https://github.com/syryuauros/Memo/tree/main/RoamNotes"))
  (org-roam-directory (file-truename "~/gits/Memo/RoamNotes/"))
  (org-roam-completion-everywhere t)
  :bind (("C-c n b" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n a" . org-roam-alias-add)
         ("C-c n u" . org-roam-ui-open)
         :map org-mode-map
         ("C-M-i"   . completion-at-point)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today)
         ("C-c i" . org-id-get-create))

  :config
;;   ;; If you're using a vertical completion framework, you might want a more informative completion interface
;;   (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode))
;;   ;; If using org-roam-protocol
;;   (require 'org-roam-protocol))

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

;; (use-package! org-roam
;; ;; ;;    :after org-roam ;; or :after org
;; ;; ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;; ;; ;;         a hookable mode anymore, you're advised to pick something yourself
;; ;; ;;         if you don't care about startup time, use
;; ;; ;;  :hook (after-init . org-roam-ui-mode)
;;     :ensure t
;;     :init
;;     (setq org-roam-v2-ack t)
;;     :custom
;;     (org-roam-directory "~/RoamNotes")
;;     :bind (("C-c n l" . org-roam-buffer-toggle)
;;            ("C-c n f" . org-roam-node-find)
;;            ("C-c n i" . org-roam-node-insert))
;;     :config
;;     (setq org-roam-setup)
;;     (setq org-roam-database-connector 'sqlite3))
;; ;;https://github.com/org-roam/org-roam-ui#package.el - end

;; (use-package! websocket
;;     :after org-roam)

;; (use-package! simple-httpd
;;     :after org-roam)

;; (use-package! f
;;     :after org-roam)

;; (use-package! org-roam-ui
;;     :after org-roam ;; or :after org
;; ;; ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;; ;; ;;         a hookable mode anymore, you're advised to pick something yourself
;; ;; ;;         if you don't care about startup time, use
;; ;; ;;  :hook (after-init . org-roam-ui-mode)
;;     :config
;;     (setq org-roam-ui-sync-theme t
;;           org-roam-ui-follow nil
;;           org-roam-ui-update-on-save t
;;           org-roam-ui-open-on-start t))
;; ;;https://github.com/org-roam/org-roam-ui#package.el - end

;; (use-package! sqlite3
;;     :after org-roam)

(use-package! org
  :custom
  (org-directory                       "~/Org")
  (org-ellipsis                        " ▾")
  (org-src-fontify-natively            t)
  (org-src-tab-acts-natively           t)
  (org-hide-block-startup              nil)
  (org-src-preserve-indentation        t)
  (org-startup-folded                  'content)
  (org-startup-indented                t)
  (org-startup-with-inline-images      nil)
  (org-hide-leading-stars              t)
  (org-attach-id-dir                   "data/")
  (org-export-with-sub-superscripts (quote {}))
  :config
  (my/org-archive)
  (my/org-capture)
  (my/org-agenda)
  (my/org-babel)
  (my/org-id)
  (my/org-header-size)
)

(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)
(setq-default indent-tabs-mode nil)

(defun set-tab-width()
  (interactive)
  (setq tab-width 2)
  (setq evil-shift-width tab-width)
  (setq indent-tabs-mode nil))

(setq-default evil-snipe-scope 'buffer)

(map! :map company-active-map
      "TAB"        #'company-select-common-or-cycle
      "<tab>"      #'company-select-common-or-cycle
      "RET"        nil
      "<return>"   nil
      "S-RET"      #'company-complete
      "<S-return>" #'company-complete
)

(use-package! whitespace
  :custom (whitespace-style '(face tabs trailing
                              space-before-tab
                              newline empty
                              space-after-tab))
  :hook (((prog-mode org-mode) . whitespace-mode)
         (before-save . delete-trailing-whitespace))
)

(use-package! string-inflection)

(mapc (lambda (x) (add-to-list '+lookup-provider-url-alist x))
      (list
        '("Hackage"           "http://hackage.haskell.org/package/%s")
        '("Hoogle"            "http://www.haskell.org/hoogle/?q=%s")
        '("Haedosa Gitlab"    "https://gitlab.com/search?group_id=12624055&search=%s")
        '("Dictionary"        "http://dictionary.reference.com/browse/%s")
        '("Thesaurus"         "http://thesaurus.reference.com/search?q=%s")
        '("Google Scholar"    "https://scholar.google.com/scholar?q=%s")
        '("Nix Packages"      "https://search.nixos.org/packages?channel=unstable&query=%s")
        '("Nix Options"       "https://search.nixos.org/options?channel=unstable&query=%s")
        '("Libgen"            "http://libgen.rs/search.php?req=%s")))

(use-package! rg
  :commands (rg rg-menu)
  :bind ("C-c s" . rg-menu)
  :config
  (message "rg loaded")
)

(map! :leader
      (:prefix-map ("a" . "avy")
        :desc "avy-goto-char-2" "2" #'avy-goto-char-2
        :desc "avy-goto-char-timer" "a" #'avy-goto-char-timer
        :desc "avy-goto-line" "l" #'avy-goto-line
        :desc "avy-goto-word-0" "w" #'avy-goto-word-0
        :desc "avy-goto-subword-0" "s" #'avy-goto-subword-0
        :desc "avy-resume" "r" #'avy-resume
        :desc "avy-transpose-lines-in-region" "t" #'avy-transpose-lines-in-region
        (:prefix ("c" . "copy")
           :desc "avy-copy-region" "r" #'avy-copy-region
           :desc "avy-copy-line" "l" #'avy-copy-line)
        (:prefix ("m" . "move")
           :desc "avy-move-region" "r" #'avy-move-region
           :desc "avy-move-line" "l" #'avy-move-line)
      ))

(map! :leader
      (:prefix-map ("z" . "fzf")
        :desc "fzf-directory"     "d" #'fzf-directory
        :desc "fzf-git-files"     "f" #'fzf-directory
        :desc "fzf-git-grep"      "z" #'fzf-git-grep
        :desc "fzf-grep"          "g" #'fzf-grep
        :desc "fzf-switch-buffer" "b" #'fzf-switch-buffer
      ))

(use-package! dired-hide-dotfiles
  :after dired
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
    (map! (:map dired-mode-map
           :n "H" #'dired-hide-dotfiles-mode)))

(use-package! dired-ranger
  :after dired
  :bind (:map dired-mode-map
          ("C-c C-b" . dired-ranger-bookmark)
          ("C-c C-v" . dired-ranger-bookmark-visit)
          ("C-c C-p" . dired-ranger-paste)
          ("C-c C-y" . dired-ranger-copy)
          ("C-c C-x" . dired-ranger-move))
)

(use-package! all-the-icons-dired
  :after all-the-icons dired
  :hook (dired-mode . all-the-icons-dired-mode))

(setq which-key-idle-delay 0.1)

(map! :leader
      "r" #'counsel-rg
      ">" #'counsel-fzf
      "d" #'dired-jump
      )
