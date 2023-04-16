;;; ess-test-r-edit.el --- ESS tests for R editing  -*- lexical-binding: t; -*-
;;
;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; A copy of the GNU General Public License is available at
;; https://www.r-project.org/Licenses/
;;
;;; Commentary:
;;

(etest-deftest test-ess-r-edit-keybindings-smart-assign ()
  (define-key ess-mode-map "_" #'ess-insert-assign)
  :case "foo¶"
  "_" :result "foo <- ¶"
  "_" :result "foo_¶"
  "_" :result "foo_ <- ¶"

  (define-key ess-mode-map ";" #'ess-insert-assign)
  :case "foo¶"
  ";" :result "foo <- ¶"
  ";" :result "foo;¶"
  ";" :result "foo; <- ¶"

  ;; With `nil` smart key
  (setq ess-smart-S-assign-key nil)
  :case "foo¶"
  ";" :result "foo <- ¶"
  ";" :result "foo;¶"

  (define-key ess-mode-map ";" nil)     ; Reset
  (setq ess-smart-S-assign-key "_")     ; Reset
  ";" :result "foo;;¶"

  ;; With complex key
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M--") #'ess-insert-assign)
    (use-local-map map))
  :case "foo¶"
  "M--" :result "foo <- ¶"
  "M--" :result "foo-¶")

(etest-deftest test-ess-r-edit-keybindings-assign-list ()
  "`ess-insert-assign` uses `ess-assign-list`."
  (local-set-key "_" #'ess-insert-assign)
  (setq-local ess-assign-list '(" <~ "))

  :case "foo¶"
  "_" :result "foo <~ ¶"
  "_" :result "foo_¶"
  "_" :result "foo_ <~ ¶")

;; Local Variables:
;; etest-local-config: etest-r-config
;; End:
