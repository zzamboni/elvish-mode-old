# elvish-mode for Emacs

Very early work in progress of a major mode for editing Elvish code in Emacs.

Basic highlighting and indentation works, but many things could be broken - please let me know!

Installation is for now manual. To use it:

- Install go-mode, since this mode is based on it (https://github.com/dominikh/go-mode.el or use `package-install` in Emacs)
- Put [`elvish-mode.el`](elvish-mode.el) in `~/.emacs.d/lisp`, and add the following to your .emacs file:

  ```elisp
  (add-to-list 'load-path "~/.emacs.d/lisp")
  (require 'elvish-mode)
  (add-to-list 'auto-mode-alist '("\\.elv\\'" . elvish-mode))
  ```

This mode is based on `go-mode`, which seems to get most of the
indentation right. Please let me know if you find anything it doesn't
indent correctly.

This is my first Emacs mode, heavily based on the following resources:

- http://ergoemacs.org/emacs/elisp_syntax_coloring.html
- https://www.emacswiki.org/emacs/DerivedMode
- http://www.wilfred.me.uk/blog/2015/03/19/adding-a-new-language-to-emacs/
- https://stackoverflow.com/questions/4158216/emacs-custom-indentation

Feedback welcome!
