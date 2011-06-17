byte = strchar

OP_RRQ = 1
OP_WRQ = 2
OP_DATA = 3
OP_ACK = 4
OP_ERROR = 5

function RRQ(file, mode)
	return byte(0, OP_RRQ) .. file .. byte(0) .. mode .. byte(0)
end

function ACK(block)
	local low, high
	low = mod(block, 256)
	high = (block - low)/256
	return byte(0, OP_ACK, high, low) 
end

function get_OP(dgram)
	return strbyte(dgram, 1)*256 + strbyte(dgram, 2)
end

function split_DATA(dgram)
	local block = strbyte(dgram, 3)*256 + strbyte(dgram, 4)
	local data = strsub(dgram, 5)
	return block, data
end

function readable_ERROR(dgram)
	local code = strbyte(dgram, 3)*256 + strbyte(dgram, 4)
	local msg
	_,_, msg = strfind(dgram, "(.*)\000", 5)
	return format("error code %d: %s", code, msg)
end

function tftp_get(host, port, file, name)
	name = name or gsub(file, ".*/", "")
	writeto(name)
	err = tftp_getwrite(host, port, file)
	writeto()
	if err then remove(name) end
	return err
end

function tftp_getwrite(host, port, file)
	local dgram
	local code = OP_DATA
	local udp, err = udpsocket()
	local datahost, dataport
	host = toip(host)
	if not udp then return err end
	udp:timeout(1)
	repeat 
		err = udp:sendto(RRQ(file, "octet"), host, port)
		if err then return err end
		dgram, datahost, dataport = udp:receivefrom()
	until dgram or host ~= "timeout"
	if not dgram then return datahost end
	udp:setpeername(datahost, dataport)
	while 1 do
		code = get_OP(dgram)
		if code == OP_ERROR then return readable_ERROR(dgram) end
		if code ~= OP_DATA then return "unhandled opcode " .. code end
		local block, data = split_DATA(dgram)
		write(data)
		if strlen(data) < 512 then udp:send(ACK(block)) return nil end
		repeat 
			err = udp:send(ACK(block))
			if err then return err end
			dgram, err = udp:receive()
		until dgram or err ~= "timeout"
		if not dgram then return err end
	end
end
