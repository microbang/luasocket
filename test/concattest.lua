function mysetglobal (varname, oldvalue, newvalue)
	print("changing " .. varname)
     %rawset(%globals(), varname, newvalue)
end
function mygetglobal (varname, newvalue)
	print("checking " .. varname)
     return %rawget(%globals(), varname)
end
settagmethod(tag(nil), "setglobal", mysetglobal)
settagmethod(tag(nil), "getglobal", mygetglobal)

local fail = function(s)
	print(s)
	exit()
end

-- load http
assert(dofile("../lua/concat.lua"))

local tt, t

t = _time()

local c = Concat.create()
local s

print("testing empty stack")
s = c:getresult()
if s ~= nil then fail("should be nil!") end
print("testing empty string")
c:addstring("")
s = c:getresult()
if s ~= "" then fail("should be empty!") end

c:reset()

print("testing empty stack")
s = c:getresult()
if s ~= nil then fail("should be nil!") end
print("testing empty string")
c:addstring("")
s = c:getresult()
if s ~= "" then fail("should be empty!") end

print("testing all ones")
tt = _time()
c:addstring("x")
for i = 1, 801*100 do c:addstring("a") end
c:addstring("y")
s = c:getresult()
if s ~= "x" .. strrep("a", 801*100) .. "y" then fail("strings differ!") end
print(format("done in %.2fs", _time() - tt))

c:reset()

print("testing growing strings")
tt = _time()
c:addstring("x")
for i = 1, 800 do c:addstring(strrep("a", i)) end
c:addstring("y")
s = c:getresult()
if s ~= "x" .. strrep("a", 801*400) .. "y" then fail("strings differ!") end
print(format("done in %.2fs", _time() - tt))

c:reset()

print("testing random sized strings")
tt = _time()
local total = 0
c:addstring("x")
for i = 1, 800 do 
	local this = random(1, 800)
	c:addstring(strrep("a", this))
	total = total + this
end
c:addstring("y")
s = c:getresult()
if s ~= "x" .. strrep("a", total) .. "y" then fail("strings differ!") end
print(format("done in %.2fs", _time() - tt))

print("passed all tests")

print(format("done in %.2fs", _time() - t))

