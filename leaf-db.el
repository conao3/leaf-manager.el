;;; leaf-db.el --- Configure manager for leaf based init.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>
;; Version: 0.0.1
;; Keywords: convenience leaf
;; Package-Requires: ((emacs "25.1") (ppp "2.1"))
;; URL: https://github.com/conao3/leaf-db.el

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

(require 'ppp)

(defgroup leaf-db nil
  "Configure manager for leaf based init.el"
  :prefix "leaf-db-"
  :group 'tools
  :link '(url-link :tag "Github" "https://github.com/conao3/leaf-db.el"))


;;; Function


;;; Main

(defun leaf-db (spec)
  "Configure manager for leaf based init.el.
Pop configure edit window for SPEC."
  spec)

(provide 'leaf-db)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; leaf-db.el ends here
