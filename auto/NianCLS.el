(TeX-add-style-hook
 "NianCLS"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("ltjsarticle" "twoside")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("hyperref" "hidelinks")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "href")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "d"
    "ltjsarticle"
    "ltjsarticle10"
    "hyperref"
    "doc"
    "luatexja-fontspec"
    "expl3")
   (TeX-add-symbols
    '("RequirePackage")
    "FORMAT"
    "MakePrivateLetters"
    "LuaTeX"
    "theCodelineNo"
    "regex"
    "noexpand"))
 :latex)

