;;; leaf-manager.el --- Configure manager for leaf based init.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>
;; Version: 0.0.1
;; Keywords: convenience leaf
;; Package-Requires: ((emacs "25.1") (leaf "4.1") (ppp "2.1"))
;; URL: https://github.com/conao3/leaf-manager.el

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Interactive folding Elisp code using :tag leaf keyword.


;;; Code:

(require 'leaf)
(require 'ppp)

(defgroup leaf-manager nil
  "Configure manager for leaf based init.el"
  :prefix "leaf-manager-"
  :group 'tools
  :link '(url-link :tag "Github" "https://github.com/conao3/leaf-manager.el"))

(defcustom leaf-manager-file (locate-user-emacs-file "init.el")
  "Manage target user init.el file path."
  :group 'leaf-manager
  :type 'string)

(defvar leaf-manager-contents nil
  "`leaf-manager-file' contents cache.

Key is package name as symbol.
Value is alist
  - BODY is the leaf all value.")


;;; Function

(defun leaf-manager-contents-1 (table body)
  "Internal function for `leaf-manager-contents'.
Process leaf-manager BODY arguments into TABLE."
  (let (sexps)
    (cl-loop for (key val) on body by #'cddr
             do
             (if (not (eq key :config))
                 (progn
                   (push key sexps)
                   (dolist (v val)
                     (push v sexps)))
               (dolist (e val)
                 (pcase e
                   (`(leaf ,(and (pred symbolp) pkg) . ,body*)
                    (when (gethash pkg table)
                      (error "Duplicate leaf block.  package: %s" pkg))
                    (setf (alist-get 'body (gethash pkg table)) body*))
                   (_
                    (error "Leaf-manager :config includes unknown sexp.  sexp: %s" e))))))
    (setf (alist-get 'body (gethash 'leaf-manager table)) (nreverse sexps))))

(defun leaf-manager-contents (&optional reload)
  "Read `leaf-manager-file' and put values into `leaf-manager-contents'.
If RELOAD is non-nil, read file even if cache is avairable."
  (when (or reload (null leaf-manager-contents))
    (let ((table (make-hash-table :test 'eq))
          sexps elm)
      (with-temp-buffer
        (insert-file-contents leaf-manager-file)
        (goto-char (point-min))
        (while (ignore-errors (setq elm (read (current-buffer))))
          (pcase elm
            (`(leaf leaf-manager . ,body)
             (leaf-manager-contents-1 table (leaf-normalize-plist body)))
            (_
             (push elm sexps)))))
      (setf (alist-get 'body (gethash 'emacs table)) (nreverse sexps))
      (setq leaf-manager-contents table))))


;;; Main

(defun leaf-manager (spec)
  "Configure manager for leaf based init.el.
Pop configure edit window for SPEC."
  spec)

(provide 'leaf-manager)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; leaf-manager.el ends here
