-- Build script for expkv
module="expkv"
pkgversion="0.3"
pkgdate="2020-01-21"

-- update package date and version
tagfiles={"expkv.dtx","README.md"}
function update_tag(file, content, tagname, tagdate)
  if tagname == nil then
    tagname=pkgversion
    tagdate=pkgdate
  end
  if string.match(file, "README.md") then
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

checkengines={"pdftex"}
checkformat="latex"

-- which files to build
sourcefiles={"expkv.dtx"}
unpackfiles=sourcefiles

-- which files to put in the tds
installfiles={"expkv.sty", "expkv.tex"}
textfiles   ={"README.md"}
docfiles    ={"expkv.pdf"}

-- how the documentation is build
typesetfiles={"*.dtx"}
typesetruns = 3

packtdszip  = true

-- make sure that expkv.tex ends up in the generic path
tdslocations={
  "tex/generic/expkv/expkv.tex",
}
