-----------------------------------------------------------------------------
-- Select implementation
-- LuaSocket toolkit.
-- Author: Diego Nehab
-- RCS ID: $Id: select.lua,v 1.5 2003/06/26 18:47:47 diego Exp $
-----------------------------------------------------------------------------

----------------------------------------------------------------------
-- Copy fds from tab to set, creating fd_tab association table.
----------------------------------------------------------------------
local function collect_fd(obj_tab, fd_set, fd_tab)
    for i, obj in ipairs(obj_tab) do 
        local fd = obj:fd()
        fd_set:set(fd)
        fd_tab[fd] = obj
    end
    return fd_set
end

----------------------------------------------------------------------
-- Copy socks from set to tab, using fd_tab association table.
----------------------------------------------------------------------
local function collect_obj(fd_set, max_fd, obj_tab, fd_tab)
    for fd = 0, max_fd do
        if fd_set:isset(fd) then 
            table.insert(obj_tab, fd_tab[fd]) 
        end
    end
end

----------------------------------------------------------------------
-- Treat objects with unread buffered data
----------------------------------------------------------------------
local function check_dirty(obj_tab, dirty, fd_tab)
    local any = false
    for i, obj in ipairs(obj_tab) do
        if obj:dirty() then 
            table.insert(dirty, obj)
            fd_tab[obj:fd()] = nil
            any = true
        end
    end
    return any
end

----------------------------------------------------------------------
-- Lua select helper
----------------------------------------------------------------------
return function(read_obj_tab, write_obj_tab, timeout, 
    read_fd_set, write_fd_set, c_select)
    local fd_tab = {}
    local readable, writable = {}, {}
    read_obj_tab = read_obj_tab or {}
    write_obj_tab = write_obj_tab or {}
    -- build read_fd_set from from read_obj_tab and build write_fd_set 
    -- from write_obj_tab. create fd_tab mapping fd values to their
    -- corresponding objects. 
    collect_fd(read_obj_tab, read_fd_set, fd_tab)
    collect_fd(write_obj_tab, write_fd_set, fd_tab)
    -- if there are any sockets being tested for readability that 
    -- have buffered data unread, move them to readable table and
    -- set timeout to 0
    local dirty = check_dirty(read_obj_tab, readable, fd_tab)
    if dirty then timeout = 0 end
    -- compute the maximum fd value
    local max_fd = -1
    for fd, obj in fd_tab do 
        if fd > max_fd then 
            max_fd = fd 
        end 
    end
    -- call C select
    local ret = c_select(max_fd+1, read_fd_set, write_fd_set, timeout)
    if ret > 0 then 
        -- collect readable and writable sockets from fd sets to 
        -- readable and writable object tables
        collect_obj(read_fd_set, max_fd, readable, fd_tab) 
        collect_obj(write_fd_set, max_fd, writable, fd_tab)
        ret = nil
    elseif dirty then ret = nil 
    else ret = "timeout" end
    return readable, writable, ret
end
