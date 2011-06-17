dofile("noglobals.lua")

local fail = function(s)
	print(s)
	exit()
end

local test_base64 = function(a, z)
	local az = socket.code.base64(a)
	local za = socket.code.unbase64(z)
	if z ~= az or a ~= za then fail(a .. " test failed") end
end

local test_unquote = function(u, q)
	local uq = socket.code.unquote(q)
	if u ~= uq then fail(a .. " test failed") end
end

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

test_unquote(
"Now's the time for all folk to come to the aid of their country.",
"Now's the time =\r\nfor all folk to come=\r\n to the aid of their country."
)
test_unquote("αινσϊ", "=E1=E9=ED=F3=FA")
test_unquote("αινoϊ", "=E1=E9=EDo=FA")


print("passed all tests")
