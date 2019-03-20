;;; my-fuzzy-cmd-selector.el --- A fuzzy command selector -*- lexical-binding: t -*-

;; Copyright (C) 2010-2018 Vitor Quintanilha Barbosa

;; Author: Vitor <vitorqb@gmail.com>
;; Version: 0.0.1
;; Maintainer: Vitor <vitorqb@gmail.com>
;; Created: 2019-03-20
;; Keywords: elisp
;; Homepage: https://github.com/vitorqb/my-fuzzy-command-selector

;; This file is not part of GNU Emacs.
     
;; Do whatever you want. No warranties.
(require 'ivy)
(require 'dash)
(require 'dash-functional)

;;; code
(defvar mfcs-commands '()
  "A list mfcs-command to fuzzy match and call.
   Each mfcs-command must be a plist like (:description ... :command ...)
   For example:
   '((:description \"Run compile\"
      :command (lambda () (interactively) (call-interactively compile))))")

(defun mfcs-call ()
  "Prompts the user to select from mfcs-commands and runs the selected function"
  (interactive)
  (unless mfcs-commands (error "mfcs-commands is empty"))
  (-let* ((get-desc (-rpartial 'plist-get :description))
          (get-func (-rpartial 'plist-get :command))
          (chosen-desc
           (ivy-read "Command: " (-map get-desc mfcs-commands) :require-match t)))
    (->> mfcs-commands
         (-first (lambda (x) (string= (funcall get-desc x) chosen-desc)))
         (funcall get-func)
         funcall-interactively)))

(provide 'my-fuzzy-cmd-selector)
;; my-fuzzy-cmd-selector.el ends here


