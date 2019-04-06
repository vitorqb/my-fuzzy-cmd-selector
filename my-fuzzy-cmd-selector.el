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
(require 'cl-lib)

;;; code
(defvar mfcs-commands '()
  "A list mfcs-command to fuzzy match and call.
   Each mfcs-command must be a plist like (:description ... :command ...)
   For example:
   '((:description \"Run compile\"
      :command (lambda () (interactively) (call-interactively compile))))")

(defun mfcs--get-desc (x) (plist-get x :description))
(defun mfcs--get-func (x) (plist-get x :command))

(cl-defun mfcs-add-command (&key description command)
  "Adds a command to mfcs-commands if no other command with the
  same description is there."
  (when (not (-some? (-compose (-partial #'string-equal description)
                               #'mfcs--get-desc)
                     mfcs-commands))
    (cl-pushnew `(:description ,description :command ,command) mfcs-commands)))

(defun mfcs-call ()
  "Prompts the user to select from mfcs-commands and runs the selected function"
  (interactive)
  (unless mfcs-commands (error "mfcs-commands is empty"))
  (-let* ((chosen-desc (ivy-read "Command: "
                                 (-map #'mfcs--get-desc mfcs-commands)
                                 :require-match t
                                 :caller :mfcs-call)))
    (->> mfcs-commands
         (-first (lambda (x) (string= (funcall #'mfcs--get-desc x) chosen-desc)))
         mfcs--get-func
         call-interactively)))

(provide 'my-fuzzy-cmd-selector)
;; my-fuzzy-cmd-selector.el ends here


