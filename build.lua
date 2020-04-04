-- Build script for expkv
module     = "expkv"
pkgversion = "0.5b"
pkgdate    = "2020-04-04"

-- update package date and version
tagfiles = {"expkv.dtx", "README.md", "CTAN.md"}
function update_tag(file, content, tagname, tagdate)
  if tagname == nil then
    tagname = pkgversion
    tagdate = pkgdate
  end
  if string.match(file, "%.md") then
    return string.gsub(content,
      "%d%d%d%d%-%d%d%-%d%d v%d%.%d%w?",
      tagdate .. " v" .. tagname)
  elseif string.match(file, "expkv.dtx") then
    content = string.gsub(content,
      "\\def\\ekvDate{%d%d%d%d%-%d%d%-%d%d}",
      "\\def\\ekvDate{" .. tagdate .. "}")
    return string.gsub(content,
      "\\def\\ekvVersion{%d%.%d%w?}",
      "\\def\\ekvVersion{" .. tagname .. "}")
  end
  return content
end

-- test with pdfTeX and the LaTeX format
checkengines = {"pdftex"}
checkformat  = "latex"

-- from which files to build
sourcefiles = {"expkv.dtx"}
unpackfiles = sourcefiles

-- which files to put in the tds
installfiles = {"expkv.sty", "expkv.tex"}
textfiles    = {"README.md", "CTAN.md"}
docfiles     = {"expkv.pdf"}

-- how the documentation is build
typesetfiles = {"expkv.dtx"}
typesetruns  = 4

-- make sure that expkv.tex ends up in the generic path
packtdszip   = true
tdslocations = {
  "tex/generic/expkv/expkv.tex",
}

-- CTAN upload
ctanreadme    = "CTAN.md"
uploadconfig  = {
  pkg         = module,
  author      = "Jonathan P. Spratte",
  version     = pkgversion .. " " .. pkgdate,
  license     = "lppl1.3c",
  summary     = "An expandable key=val implementation",
  topic       = "keyval",
  ctanPath    = "/macros/generic/expkv",
  repository  = "https://github.com/Skillmon/tex_expkv",
  bugtracker  = "https://github.com/Skillmon/tex_expkv/issues",
  update      = true,
  description = [[
`expkv` is a minimalistic but fast and expandable key=val implementation.
It provides two parsing macros:

* `\ekvset{<set>}{<key=val list>}` which is comparable to `keyval`'s `\setkeys`

* `\ekvparse<cs1><cs2>{<key=val list>}` which can be used inside `\expanded` and
expands to `<cs1>{key}` and `<cs2>{key}{val}` for the entries in the
`<key=val list>`.

`expkv` has predictable brace-stripping behaviour and handles commas and equal
signs with category codes 12 and 13 correctly.
  ]]
}
