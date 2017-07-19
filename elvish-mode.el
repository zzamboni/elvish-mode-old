;;; elvish-mode.el --- sample major mode for editing Elvish.

;; Author: Diego Zamboni <diego@zzamboni.org>
;; Version: 0.0.2
;; Created: 18-Jul-17
;; Keywords: languages
;; Homepage: https://github.com/zzamboni/elvish-mode

;; This file is not part of GNU Emacs.

;;; License:

;; You can redistribute this program and/or modify it under the terms of the MIT Open Source license (https://opensource.org/licenses/MIT)

;;; ChangeLog:

;; - 2017-07-19: modified to base on go-mode instead of javascript-mode, which improves indentation.

;;; Commentary:

;; Major mode for editing code written in Elvish (http://elvish.io)

;; VERY EARLY VERSION
;; Basic highlighting and indentation works, but many things could be broken.
;; To use:
;;
;; - Install go-mode, since this mode is based on it (https://github.com/dominikh/go-mode.el or use package-install in Emacs)
;; - Put this file in ~/.emacs.d/lisp, and add the following to your .emacs file:
;;
;;       (add-to-list 'load-path "~/.emacs.d/lisp")
;;       (require 'elvish-mode)
;;       (add-to-list 'auto-mode-alist '("\\.elv\\'" . elvish-mode))

;;; Code:

;; define several category of keywords
(setq elvish-keywords '(
                        "del"
                        "fn"
                        "use"
                        "and"
                        "or"
                        "if"
                        "while"
                        "for"
                        "try"
                        ) )
(setq elvish-types '())
(setq elvish-constants '(
                         "$_"
                         "$pid"
                         "$ok"
                         "$true"
                         "$false"
                         "$paths"
                         "$pwd"
                         ))
(setq elvish-events '())
(setq elvish-functions '(
                         ;; Trivial builtin
                         "nop"

                         ;; Introspection
                         "ind-of"
                         "is"
                         "eq"

                         ;; Value output
                         "put"

                         ;; Bytes output
                         "print"
                         "echo"
                         "pprint"
                         "repr"

                         ;; Bytes to value
                         "slurp"
                         "from-lines"
                         "from-json"

                         ;; Value to bytes
                         "to-lines"
                         "to-json"

                         ;; Exception and control
                         "fail"
                         "multi-error"
                         "return"
                         "break"
                         "continue"

                         ;; Misc functional
                         "constantly"

                         ;; Misc shell basic
                         "-source"

                         ;; Iterations.
                         "each"
                         "peach"
                         "repeat"

                         ;; Container primitives.
                         "assoc"

                         ;; Sequence primitives
                         "explode"
                         "take"
                         "range"
                         "count"
                         "has-key"
                         "has-value"

                         ;; String
                         "joins"
                         "splits"

                         ;; String operations
                         "ord"
                         "base"
                         "wcswidth"
                         "-override-wcwidth"

                         ;; Map operations
                         "keys"

                         ;; String predicates
                         "has-prefix"
                         "has-suffix"

                         ;; String comparison
                         "<s" 
                         "<=s"
                         "==s" 
                         "!=s"
                         ">s" 
                         ">=s" 

                         ;; eawk
                         "eawk"

                         ;; Directory
                         "cd"
                         "dir-history"

                         ;; Path
                         "path-abs"
                         "path-base"
                         "path-clean"
                         "path-dir"
                         "path-ext"
                         "eval-symlinks"
                         "tilde-abbr"

                         ;; Boolean operations
                         "bool"
                         "not"

                         ;; Arithmetics
                         "+"
                         "-"
                         "*"
                         "/"
                         "^"
                         "%"

                         ;; Random
                         "rand"
                         "randint"

                         ;; Numerical comparison
                         "<" 
                         "<=" 
                         "==" 
                         "!="
                         ">" 
                         ">=" 

                         ;; Command resolution
                         "resolve"
                         "has-external"
                         "search-external"

                         ;; File and pipe
                         "fopen"
                         "fclose"
                         "pipe"
                         "prclose"
                         "pwclose"

                         ;; Process control
                         "fg"
                         "exec"
                         "exit"

                         ;; Time
                         "esleep"
                         "-time"

                         ;; Debugging
                         "-gc"
                         "-stack"
                         "-log"

                         "-ifaddrs"
                         ))

;; generate regex string for each category of keywords
(setq elvish-keywords-regexp (regexp-opt elvish-keywords 'words))
(setq elvish-type-regexp (regexp-opt elvish-types 'words))
(setq elvish-constant-regexp (regexp-opt elvish-constants 'words))
(setq elvish-event-regexp (regexp-opt elvish-events 'words))
(setq elvish-functions-regexp (regexp-opt elvish-functions 'words))

;; create the list for font-lock.
;; each category of keyword is given a particular face
(setq elvish-font-lock-keywords
      `(
        (,elvish-constant-regexp . font-lock-constant-face)
        (,elvish-functions-regexp . font-lock-function-name-face)
        (,elvish-keywords-regexp . font-lock-keyword-face)
        ;; note: order above matters, because once colored, that part won't change.
        ;; in general, longer words first
        ))

(defvar elvish-mode-syntax-table nil "Syntax table for `elvish-mode'.")

(setq elvish-mode-syntax-table
      (let ( (synTable (make-syntax-table)))
        ;; python style comment: “# …”
        (modify-syntax-entry ?# "<" synTable)
        (modify-syntax-entry ?\n ">" synTable)
        synTable))

(defvar elvish-indent-offset 2
  "*Indentation offset for `elvish-mode'.")

(defun elvish-indent-line ()
  "Indent current line for `elvish-mode'."
  (interactive)
  (let ((indent-col 0))
    (save-excursion
      (beginning-of-line)
      (condition-case nil
          (while t
            (backward-up-list 1)
            (when (looking-at "[[{]")
              (setq indent-col (+ indent-col elvish-indent-offset))))
        (error nil)))
    (save-excursion
      (back-to-indentation)
      (when (and (looking-at "[]}]") (>= indent-col elvish-indent-offset))
        (setq indent-col (- indent-col elvish-indent-offset))))
    (indent-line-to indent-col)))

;;;###autoload
(define-derived-mode elvish-mode go-mode "Elvish"
  "Major mode for editing Elvish shell code (http://elvish.io)"

  ;; code for syntax highlighting
  (setq font-lock-defaults '((elvish-font-lock-keywords)))
  (set-syntax-table elvish-mode-syntax-table)

  ;;(make-local-variable 'elvish-indent-offset)
  ;;(set (make-local-variable 'indent-line-function) 'elvish-indent-line)
  )

;; clear memory. no longer needed
(setq elvish-keywords nil)
(setq elvish-types nil)
(setq elvish-constants nil)
(setq elvish-events nil)
(setq elvish-functions nil)

;; clear memory. no longer needed
(setq elvish-keywords-regexp nil)
(setq elvish-types-regexp nil)
(setq elvish-constants-regexp nil)
(setq elvish-events-regexp nil)
(setq elvish-functions-regexp nil)

;; add the mode to the `features' list
(provide 'elvish-mode)

;;; elvish-mode.el ends here
