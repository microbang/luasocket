dofile("noglobals.lua")

local fail = function(s)
	print(s)
	os.exit()
end

local tt, t

t = socket.time()

local c = socket.concat.create()
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
tt = socket.time()
c:addstring("x")
for i = 1, 801*500 do c:addstring("a") end
c:addstring("y")
s = c:getresult()
if s ~= "x" .. string.rep("a", 801*500) .. "y" then fail("strings differ!") end
print(string.format("done in %.2fs", socket.time() - tt))

c:reset()

print("testing growing strings")
tt = socket.time()
c:addstring("x")
for i = 1, 2000 do c:addstring(string.rep("a", i)) end
c:addstring("y")
s = c:getresult()
if s ~= "x" .. string.rep("a", 2001*1000) .. "y" then fail("strings differ!") end
print(string.format("done in %.2fs", socket.time() - tt))

c:reset()

print("testing random sized strings")
tt = socket.time()
local total = 0
c:addstring("x")
for i = 1, 4000 do 
	local this = math.random(1, 800)
	c:addstring(string.rep("a", this))
	total = total + this
end
c:addstring("y")
s = c:getresult()
if s ~= "x" .. string.rep("a", total) .. "y" then fail("strings differ!") end
print(string.format("done in %.2fs", socket.time() - tt))

print("passed all tests")

print(string.format("done in %.2fs", socket.time() - t))

