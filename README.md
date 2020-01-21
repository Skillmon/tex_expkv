-------------------------------------------------------------------------------
# expkv -- an expandable key=val implementation

Version 2020-01-21 v0.3

Released under the LaTeX Project Public License v1.3c or later
See http://www.latex-project.org/lppl.txt

Hosted at https://github.com/Skillmon/tex_expkv

-------------------------------------------------------------------------------

Copyright (C) 2020 Jonathan P. Spratte

This  work may be  distributed and/or  modified under  the conditions  of the
LaTeX Project Public License (LPPL),  either version 1.3c  of this license or
(at your option) any later version.  The latest version of this license is in
the file:

  http://www.latex-project.org/lppl.txt

This work is "maintained" (as per LPPL maintenance status) by
  Jonathan P. Spratte.

-------------------------------------------------------------------------------

This provides an expandable key=val implementation that is somewhat fast, but
not the fastest key=val implementation available. It is generic code and
completely self-contained. There is a LaTeX package `expkv.sty` included to play
nice on LaTeX's package loading system, but that package is not needed and does
not provide more functionality than the generic code in `expkv.tex`.

# Building expkv

`expkv` is written as docstrip-file, you can get `expkv.sty` and `expkv.tex` by
running `pdftex expkv.dtx`. You can create both the documentation and the code
files by running `pdflatex expkv.dtx`. However the dates and version in
`expkv.dtx` aren't guaranteed to be correct, if you want these to be correct run
`l3build tag` and afterwards generate the `.sty`- and `.tex`-files. Also you
don't get the final documentation by running `pdflatex` once.

Of course you can use the other facilities of `l3build` as well, e.g., you could
do `l3build unpack` to generate the code files in the directory
`build/unpacked/`, and `l3build doc` to generate the documentation.
