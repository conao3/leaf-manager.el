;;; leaf-manager-tests.el --- Test definitions for leaf-manager  -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>
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

;; Test definitions for `leaf-manager'.


;;; Code:

(require 'cort)
(require 'leaf-manager)

(defmacro cort-deftest-with-equal (name form)
  "Return `cort-deftest' compare by `equal' for NAME, FORM.

Example:
  (p (cort-deftest-with-equal leaf/disabled
       '((asdf asdf-fn)
         (uiop uiop-fn))))
   => (cort-deftest leaf/disabled
        '((:equal 'asdf asdf-fn)
          (:equal 'uiop uiop-fn)))"
  (declare (indent 1))
  `(cort-deftest ,name
     ',(mapcar (lambda (elm)
                 `(:equal ,(cadr elm) ,(car elm)))
               (cadr form))))


;;; test definitions

(cort-deftest leaf-manager/read-contents
  '((:equal
     (let ((leaf-manager-file (make-temp-file "leaf-manager"))
           (leaf-manager--contents nil))
       (unwind-protect
           (progn
             (with-temp-file leaf-manager-file
               (insert "nil\n(setq example t)\n; trailing comment"))
             (alist-get 'body (gethash 'emacs (leaf-manager--contents))))
         (delete-file leaf-manager-file)))
     '(nil (setq example t)))))

(cort-deftest leaf-manager/reject-incomplete-edit
  '((:eq
     (let ((leaf-manager--contents (make-hash-table :test 'eq))
           (write-called nil))
       (with-temp-buffer
         (leaf-manager-edit-mode)
         (insert "(leaf leaf-manager)\n(")
         (cl-letf (((symbol-function 'leaf-manager-write-contents)
                    (lambda () (setq write-called t) nil)))
           (condition-case nil
               (leaf-manager-edit-commit)
             (end-of-file
              (and (not write-called)
                   (hash-table-p leaf-manager--contents)))))))
     t)))


;; (provide 'leaf-manager-test)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; leaf-manager-tests.el ends here
