--[[ FILE README.txt

LUA MODULE

  findbin v$(_VERSION) -  Locate directory of original Lua script
  
SYNOPSIS

  -- /qux/bar/baz.lua
  print(require 'findbin'.bin) --> prints directory of script (/qux/bar)
  require 'lib' (require 'findbin' '/../lib')
     -- adds a path relative to the directory of the current script to the
     -- package search paths (package.path & package.cpath).
  require 'foo'  -- loads from new search paths (/qux/lib/foo.lua)

DESCRIPTION

  The locates the directory of the currently executing script.

  One case where this is helpful is to set the packages search paths
  (`package.path` and `package.cpath`) to a directory relative to the
  directory of the currently executing script, as shown in the SYNOPSIS
  above.

API

  require 'findbin'.bin
  
    The directory of the currently executing script as a string (without
    trailing slash). Currently, this is derived from arg[0].  It will be '.'
    if the script is executing from 'lua -e'.
    
  require 'findbin' (relpath)
 
    Returns a path formed by appending the given relative path (`relpath`)
    to the directory containing the currently executing script.
 
    require 'findbin' '/bar/baz.lua'
       -- returns '/foo/bar/baz.lua' if current script is '/foo/qux.lua'

DESIGN NOTES

  This module may fail if the current working directory is changed after
  arg[0] is set and before findbin.lua is loaded.

HOME PAGE

  https://gist.github.com/1342365
  
DOWNLOAD/INSTALL

  If using LuaRocks:
    luarocks install lua-findbin

  Otherwise, download <https://raw.github.com/gist/1342365/findbin.lua>.
  Alternately, if using git:
    git clone git://gist.github.com/1342365.git lua-findbin
    cd lua-globtopattern
  Optionally unpack and install in LuaRocks:
    Download <https://raw.github.com/gist/1422205/sourceunpack.lua>.
    lua sourceunpack.lua findbin.lua
    cd out && luarocks make *.rockspec

DEPENDENCIES

  None (other than Lua 5.1 or 5.2).
    
RELATED WORK

  http://search.cpan.org/perldoc?FindBin
  https://gist.github.com/1342319 (Lua 'lib' module)

COPYRIGHT

(c) 2011 David Manura.  Licensed under the same terms as Lua 5.1 (MIT license).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
  
--]]---------------------------------------------------------------------

-- findbin.lua
-- (c) 2011 David Manura.  Licensed under the same terms as Lua 5.1 (MIT license).

local M = {_TYPE='module', _NAME='findbin', _VERSION='0.1.20111130'}

local script = arg and arg[0] or ''

local bin = script:gsub('[/\\]?[^/\\]+$', '') -- remove file name
if bin == '' then bin = '.' end

M.bin = bin

setmetatable(M, {__call = function(_, relpath) return bin .. relpath end})

return M

--[[ FILE lua-findbin-$(_VERSION)-1.rockspec

package = 'lua-findbin'
version = '$(_VERSION)-1'
source = {
  url = 'https://raw.github.com/gist/1342365/$(GITID)/findbin.lua',
  --url = 'https://raw.github.com/gist/1342365/findbin.lua', -- latest raw
  --url = 'https://gist.github.com/gists/1342365/download', -- latest archive
  md5 = '$(MD5)'
}
description = {
  summary = ' Locate directory of original Lua script',
  detailed =
    ' Locate directory of original Lua script.',
  license = 'MIT/X11',
  homepage = 'https://gist.github.com/1342365',
  maintainer = 'David Manura'
}
dependencies = {
  'lua >= 5.1' -- including 5.2
}
build = {
  type = 'builtin',
  modules = {
    ['findbin'] = 'findbin.lua'
  }
}

--]]---------------------------------------------------------------------


--[[ FILE test.lua


local function checkeq(a, b, e)
  if a ~= b then error(
    'not equal ['..tostring(a)..'] ['..tostring(b)..'] ['..tostring(e)..']', 2)
  end
end

checkeq(type(require 'findbin'.bin), 'string')

arg = nil; package.loaded.findbin = nil
checkeq(require 'findbin'.bin, '.')
arg = {[0] = 'foo.lua'}; package.loaded.findbin = nil
checkeq(require 'findbin'.bin, '.')
arg = {[0] = 'bar/foo.lua'}; package.loaded.findbin = nil
checkeq(require 'findbin'.bin, 'bar')
checkeq(require 'findbin' '/qux.lua', 'bar/qux.lua')

print 'OK'

--]]---------------------------------------------------------------------

