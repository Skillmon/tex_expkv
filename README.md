-------------------------------------------------------------------------------
# expkv -- an expandable key=val implementation

Version 2020-02-26 v0.5

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

The only place where version numbers and dates are guaranteed to be correct in
the repository is in the `l3build` configuration file `build.lua`. If it is
important to you that the files created have the correct version and date, you
should run `l3build tag` before any other build-related task.

`expkv` utilizes the `l3build` system. You can run `l3build unpack` to extract
the code files `expkv.tex` and `expkv.sty` into the directory `build/unpacked/`.
If you want to build the documentation run `l3build doc`, the resulting PDF will
be in the main directory. Running `l3build install` will put `expkv.tex` and
`expkv.sty` in your `TEXMFHOME`, `l3build uninstall` will remove them. `l3build`
should be contained in any recent LaTeX installation.

You can run the checks from the folder `testfiles/` by running `l3build check`
to test whether the version you got has any regressions.

Of course you can also build everything manually. `pdftex expkv.dtx` will
generate the code files, `pdflatex expkv.dtx` will create the documentation, but
you'll have to run that at least twice, and if you want an index you'll also
have to run `makeindex -s gind.ist -o expkv.ind expkv.idx` and then rerun
`pdflatex`. Building the files manually will create quite a few auxiliary files
in the main directory.
