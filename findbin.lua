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

HOME PAGE / DOWNLOAD

  https://gist.github.com/1342365
  
INSTALLATION

  Copy findbin.lua into your LUA_PATH.  You may optionally run
  "lua findbin.lua unpack" to unpack the module into individual files in
  an "out" subdirectory.   file_slurp ( https://gist.github.com/1325400/ )
  is required to do this.  To subsequently install into LuaRocks, run
  "cd out && luarocks make findbin*.rockspec"
  
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

local M = {_TYPE='module', _NAME='findbin', _VERSION='000.001.001'}

local script = arg and arg[0] or ''

local bin = script:gsub('[/\\]?[^/\\]+$', '') -- remove file name
if bin == '' then bin = '.' end

M.bin = bin

setmetatable(M, {__call = function(_, relpath) return bin .. relpath end})

-- This ugly line will delete itself upon unpacking the module.
if...=='unpack'then assert(loadstring(io.open(arg[0]):read'*a':gsub('[^\n]*return M[^\n]*','')))()end

return M

--[[ FILE findbin-$(_VERSION)-1.rockspec

package = 'findbin'
version = '$(_VERSION)-1'
source = {
  -- IMPROVE?
  --url = 'https://raw.github.com/gist/1342365/findbin.lua',
  url = 'https://gist.github.com/gists/1342365/download',
  file = 'findbin-$(_VERSION).tar.gz'
  --url = 'https://raw.github.com/gist/1342365/FIX/dir.lua',
  --md5 = 'FIX'
}
description = {
  summary = ' Locate directory of original Lua script',
  detailed =
    ' Locate directory of original Lua script.',
  license = 'MIT/X11',
  homepage = 'https://gist.github.com/TODO',
  maintainer = 'David Manura'
}
dependencies = {}
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

--[[ FILE unpack.lua  -- return M

-- This optional code unpacks files into an "out" subdirectory for deployment.
local M = M
local FS = require 'file_slurp'
local name = arg[0]:match('[^/\\]+')
local code = FS.readfile(name, 'T')
code = code:gsub('%-*\n*%-%-%[%[%s*FILE%s+(%S+).-\n\n?(.-)%-%-%]%]%-*%s*',
 function(filename, text)
  filename = filename:gsub('%$%(_VERSION%)', M._VERSION)
  text = text:gsub('%$%(_VERSION%)', M._VERSION)
  if filename ~= 'unpack.lua' then
    if not FS.writefile('out/.test', '', 's') then os.execute'mkdir out' end
    os.remove'out/.test'
    print('writing out/' .. filename)
    FS.writefile('out/' .. filename, text)
  end
  return ''
end)
code = code:gsub('%-%- ?This ugly line[^\n]*\n[^\n]*\n', '')
print('writing out/' .. name)
FS.writefile('out/' .. name, code)
print('testing...')
assert(loadfile('out/test.lua'))()

--]]---------------------------------------------------------------------
