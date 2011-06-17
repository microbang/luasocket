-----------------------------------------------------------------------------
-- Encoding conversion routines
-- LuaSocket 1.4 toolkit.
-- Author: Diego Nehab
-- Date: 26/12/2000
-- Conforming to: RFC 2045, LTN7
-- RCS ID: $Id: code.lua,v 1.3 2001/09/25 18:41:33 diego Exp $
-----------------------------------------------------------------------------

local Private, Public = {}, {}
Code = Public

-----------------------------------------------------------------------------
-- Direct and inverse convertion tables for base64
-----------------------------------------------------------------------------
Private.t64 = {
	[00] = 'A', [01] = 'B', [02] = 'C', [03] = 'D', [04] = 'E', [05] = 'F', 
	[06] = 'G', [07] = 'H', [08] = 'I', [09] = 'J', [10] = 'K', [11] = 'L', 
	[12] = 'M', [13] = 'N', [14] = 'O', [15] = 'P', [16] = 'Q', [17] = 'R', 
	[18] = 'S', [19] = 'T', [20] = 'U', [21] = 'V', [22] = 'W', [23] = 'X', 
	[24] = 'Y', [25] = 'Z', [26] = 'a', [27] = 'b', [28] = 'c', [29] = 'd', 
	[30] = 'e', [31] = 'f', [32] = 'g', [33] = 'h', [34] = 'i', [35] = 'j', 
	[36] = 'k', [37] = 'l', [38] = 'm', [39] = 'n', [40] = 'o', [41] = 'p', 
	[42] = 'q', [43] = 'r', [44] = 's', [45] = 't', [46] = 'u', [47] = 'v', 
	[48] = 'w', [49] = 'x', [50] = 'y', [51] = 'z', [52] = '0', [53] = '1', 
	[54] = '2', [55] = '3', [56] = '4', [57] = '5', [58] = '6', [59] = '7', 
	[60] = '8', [61] = '9', [62] = '+', [63] = '/', [64] = '='
}

Private.f64 = {
	['A'] = 00, ['B'] = 01, ['C'] = 02, ['D'] = 03, ['E'] = 04, ['F'] = 05, 
	['G'] = 06, ['H'] = 07, ['I'] = 08, ['J'] = 09, ['K'] = 10, ['L'] = 11, 
	['M'] = 12, ['N'] = 13, ['O'] = 14, ['P'] = 15, ['Q'] = 16, ['R'] = 17, 
	['S'] = 18, ['T'] = 19, ['U'] = 20, ['V'] = 21, ['W'] = 22, ['X'] = 23, 
	['Y'] = 24, ['Z'] = 25, ['a'] = 26, ['b'] = 27, ['c'] = 28, ['d'] = 29, 
	['e'] = 30, ['f'] = 31, ['g'] = 32, ['h'] = 33, ['i'] = 34, ['j'] = 35, 
	['k'] = 36, ['l'] = 37, ['m'] = 38, ['n'] = 39, ['o'] = 40, ['p'] = 41, 
	['q'] = 42, ['r'] = 43, ['s'] = 44, ['t'] = 45, ['u'] = 46, ['v'] = 47, 
	['w'] = 48, ['x'] = 49, ['y'] = 50, ['z'] = 51, ['0'] = 52, ['1'] = 53, 
	['2'] = 54, ['3'] = 55, ['4'] = 56, ['5'] = 57, ['6'] = 58, ['7'] = 59, 
	['8'] = 60, ['9'] = 61, ['+'] = 62, ['/'] = 63, ['='] = 64
}

-----------------------------------------------------------------------------
-- Converts a three byte sequence into its four character base64 
-- representation
-----------------------------------------------------------------------------
function Private.t2f(a,b,c)
	local s = strbyte(a)*65536 + strbyte(b)*256 + strbyte(c) 
	local ca, cb, cc, cd
	cd = mod(s, 64)
	s = (s - cd) / 64
	cc = mod(s, 64)
	s = (s - cc) / 64
	cb = mod(s, 64)
	ca = (s - cb) / 64
	return %Private.t64[ca] .. %Private.t64[cb] .. 
		%Private.t64[cc] .. %Private.t64[cd]
end

-----------------------------------------------------------------------------
-- Converts a four character base64 representation into its three byte
-- sequence
-----------------------------------------------------------------------------
function Private.f2t(a,b,c,d)
	local s = %Private.f64[a]*262144 + %Private.f64[b]*4096 + 
		%Private.f64[c]*64 + %Private.f64[d] 
	local ca, cb, cc
	cc = mod(s, 256)
	s = (s - cc) / 256
	cb = mod(s, 256)
	ca = (s - cb) / 256
	return strchar(ca, cb, cc)
end

-----------------------------------------------------------------------------
-- Creates a base64 representation of an incomplete last block
-----------------------------------------------------------------------------
function Private.to64pad(s)
	local a, b, ca, cb, cc, _
	_, _, a, b = strfind(s, "(.?)(.?)")
	if b == "" then 
		s = strbyte(a)*16
		cb = mod(s, 64)
		ca = (s - cb)/64
		return %Private.t64[ca] .. %Private.t64[cb] .. "=="
	end
	s = strbyte(a)*1024 + strbyte(b)*4
	cc = mod(s, 64)
	s = (s - cc) / 64
	cb = mod(s, 64)
	ca = (s - cb)/64
	return %Private.t64[ca] .. %Private.t64[cb] .. %Private.t64[cc] .. "="
end

-----------------------------------------------------------------------------
-- Decodes the base64 representation of an incomplete last block
-----------------------------------------------------------------------------
function Private.from64pad(s)
	local a, b, c, d
	local ca, cb, _
	_, _, a, b, c, d = strfind(s, "(.)(.)(.)(.)")
	if d ~= "=" then return %Private.f2t(a,b,c,d) 
	elseif c ~= "=" then
		s = %Private.f64[a]*1024 + %Private.f64[b]*16 + %Private.f64[c]/4
		cb = mod(s, 256)
		ca = (s - cb)/256
		return strchar(ca, cb)
	else
		s = %Private.f64[a]*4 + %Private.f64[b]/16 
		ca = mod(s, 256)
		return strchar(ca)
	end
end

-----------------------------------------------------------------------------
-- Break a string in lines of equal size
-- Input 
--   s: string to be broken encoded
--   w: width of output string lines
-- Returns
--   string broken in lines
-----------------------------------------------------------------------------
function Private.split(s, w)
	-- this looks ugly,  but for lines with less  then 200 columns,
	-- it is more efficient then using strsub and the concat module
	local l = "(" .. strrep(".", w) .. ")"
	return gsub(s, l, "%1\r\n")
end

-----------------------------------------------------------------------------
-- Encodes a string into its base64 representation
-- Input 
--   s: binary string to be encoded
--   single: single line output?
-- Returns
--   string with corresponding base64 representation
-----------------------------------------------------------------------------
function Public.base64(s, single)
	local pad, whole
	local l = strlen(s)
	local m = mod(l, 3)
	l = l - m
	if l > 0 then whole = gsub(strsub(s, 1, l), "(.)(.)(.)", %Private.t2f)
	else whole = "" end
	if m > 0 then pad = %Private.to64pad(strsub(s, l+1))
	else pad = "" end
	if single then return whole .. pad
	else return %Private.split(whole .. pad, 76) end
end

-----------------------------------------------------------------------------
-- Decodes a string from its base64 representation
-- Input 
--   s: base64 string
-- Returns
--   decoded binary string
-----------------------------------------------------------------------------
function Public.unbase64(s)
    -- clean string
	local f64 = %Private.f64
	s = gsub(s, "(.)", function (c) 
		if %f64[c] then return c
		else return "" end
	end)
	local l = strlen(s)
	local whole, pad
	if l > 4 then whole = gsub(strsub(s, 1, -5), "(.)(.)(.)(.)", %Private.f2t)
	else whole = "" end
	pad = %Private.from64pad(strsub(s, -4))
	return whole .. pad
end

-----------------------------------------------------------------------------
-- Encodes a string into its hexadecimal representation
-- Input 
--   s: binary string to be encoded
-- Returns
--   string with corresponding hexadecimal representation
-----------------------------------------------------------------------------
function Public.hexa(s)
	return gsub(s, "(.)", function(c)
		return format("%02x", strbyte(c))
	end)
end

-----------------------------------------------------------------------------
-- Encodes a string into its hexadecimal representation
-- Input 
--   s: hexa string
-- Returns
--   decoded binary string
-----------------------------------------------------------------------------
function Public.unhexa(s)
	return gsub(s, "(.)(.)", function(d,u)
		return strchar(tonumber(d*16 + u))
	end)
end

-----------------------------------------------------------------------------
-- Encodes a string into its escaped hexadecimal representation
-- Input 
--   s: binary string to be encoded
-- Returns
--   escaped representation of string binary
-----------------------------------------------------------------------------
function Public.escape(s)
	return gsub(s, "(.)", function(c)
		return format("%%%02x", strbyte(c))
	end)
end

-----------------------------------------------------------------------------
-- Encodes a string into its escaped hexadecimal representation
-- Input 
--   s: binary string to be encoded
-- Returns
--   escaped representation of string binary
-----------------------------------------------------------------------------
function Public.unescape(s)
	return gsub(s, "%%(%x%x)", function(hex)
		return strchar(tonumber(hex, 16))
	end)
end
