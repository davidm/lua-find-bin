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

  https://github.com/davidm/lua-find-bin
  
DOWNLOAD/INSTALL

  To install using LuaRocks:
  
    luarocks install findbin

  Otherwise, download from https://github.com/davidm/lua-find-bin .

  You may just copy findbin.lua into your LUA_PATH.

  Optionally:
    
    make test
    make install  (or make install-local)  -- to install in LuaRocks
    make remove (or make remove-local) -- to remove from LuaRocks

DEPENDENCIES

  None (other than Lua 5.1 or 5.2).
    
RELATED WORK

  http://search.cpan.org/perldoc?FindBin
  https://github.com/davidm/lua-lib (Lua 'lib' module)

COPYRIGHT

(c) 2011-2012 David Manura.  Licensed under the same terms as Lua 5.1 (MIT license).

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
  
