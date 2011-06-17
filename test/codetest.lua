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

local test_base64 = function(a, z)
	local az = Code.base64(a)
	local za = Code.unbase64(z)
	if z ~= az or a ~= za then %fail(a .. " test failed") end
end


assert(dofile("../lua/code.lua"))

local t = _time()

test_base64("a", "YQ==")
test_base64("ab", "YWI=")
test_base64("abc", "YWJj")
test_base64("abcd", "YWJjZA==")
test_base64("abcde", "YWJjZGU=")
test_base64("abcdef", "YWJjZGVm")
test_base64("abcdefg", "YWJjZGVmZw==")
test_base64("abcdefgh", "YWJjZGVmZ2g=")
test_base64("abcdefghi", "YWJjZGVmZ2hp")
test_base64("abcdefghij", "YWJjZGVmZ2hpag==")
test_base64("life of brian", "bGlmZSBvZiBicmlhbg==")
test_base64("Ali-baba:open sesame", "QWxpLWJhYmE6b3BlbiBzZXNhbWU=")

print("passed all tests")

print(format("done in %.2fs", _time() - t))
