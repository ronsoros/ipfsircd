math.randomseed(os.time())
socket = require("socket")
url = require("socket.url")
mime = require("mime")
http = require("socket.http")
mytok = tostring(os.time()) .. "--" .. tostring(math.random(1,65536))
ipfs_port = tonumber(arg[1]) or 5001
ircd_port = tonumber(arg[2]) or 6667
ngircd = socket.tcp()
ngircd:connect('127.0.0.1', ircd_port)
ngircd:settimeout(0)
function ircd_out(...)
	print("send", string.format(...))
	ngircd:send(string.format(...) .. "\r\n")
end
function ircd_in(data)
print("recv", data)
splitted = data:split(" ")
if ( splitted[2] == "PING" ) then
	ircd_out(":ipfs-relay.local PONG %s", splitted[3])
	return
end
if ( splitted[1] == "PING" ) then
	ircd_out(":ipfs-relay.local PONG %s", splitted[2])
	return
end
if ( splitted[2] == "PASS" ) then
	return
end
if ( splitted[2] == "SERVER" ) then
mename = splitted[3]
meinfo = data:match(".- :(.*)")
s2s_out("%s :ipfs-relay.local SERVER %s 2 %d :%s", mytok, splitted[3], os.time(), data:match(".- :(.*)"))
	print(627);s2s_out("%s REBURST", mytok)
ipfs:settimeout(5)
str = "TGT"
while str:find("TGT") do
str=ipfs:receive("*l");
ipfsin=str;abcd()
end
ipfs:settimeout(0)
	return
end
s2s_out("%s %s", mytok, data)
end
function s2s_out(...)
        http.request("http://127.0.0.1:" .. tostring(ipfs_port) .. "/api/v0/pubsub/pub?arg=ipfschat&arg=" .. url.escape(string.format(...)))
end
function s2s_in(data)
if data:find(" PING ") then return end
	spl = data:split(" ")
	if ( data:find(" PING ") ) then return end
	if ( #spl >= 1 and spl[1] == mytok ) then
		return
	end
	if ( #spl == 2 and spl[2] == "REBURST" ) then
		ngircd:settimeout(1)
		ircdin = ""
		s2s_out("TGT %s :ipfs-relay.local SERVER %s 2 %d :%s",spl[1],mename,math.random(1,6555),meinfo)
		ircd_out(":ipfs-relay.local 376 * :End of MOTD Reply (Fake Reburst)")
		while not ircdin:find(" PING ") do
		ircdin = ngircd:receive('*l')
		if ircdin and not ircdin:find("SERVER "..mename) and not ircdin:find("SERVER ipfs-relay.local") then
		s2s_out("TGT %s %s", spl[1], ircdin)
		end
		if not ircdin then ircdin = "" end
		end
		ngircd:settimeout(0)
		return
	end
	if ( #spl >= 3 and spl[1] == "TGT" ) then
		if ( spl[2] == mytok ) then
print("inc",data:match("TGT .- (.*)"))
			ircd_out("%s", data:match("TGT .- (.*)"))
		end
		return
	end
	if ( data:find(" ERROR ") and not data:find("Prefix") ) then
		ircd_out(":ipfs-relay.local SQUIT %s :The server tried to give me an ERROR.", spl[2]:gsub(":",""))
		return
	end
	ircd_out("%s", data:match(".- (.*)"));
end
	function string:split( inSplitPattern, outResults )
  if not outResults then
    outResults = { }
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  while theSplitStart do
    table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  end
  table.insert( outResults, string.sub( self, theStart ) )
  return outResults
	
end
ipfs = socket.tcp()
ipfs:connect('127.0.0.1', ipfs_port)
ipfs:send("GET /api/v0/pubsub/sub?arg=ipfschat&discover=true HTTP/1.1\r\nHost: localhost\r\nUser-Agent: ipfschat/ircd 1.0.0 Mozilla/0.0 (NotHTML, Unlike Gecko)\r\n\r\n")
str = "yes"
while str ~= "" do
        str = ipfs:receive('*l')
--      print(str)
end
ipfs:settimeout(0)
ircd_out("PASS pass 0210-IRC+ ngircd|24.0:Xo")
ircd_out("SERVER ipfs-relay.local 1 :IPFS Relay Server")
                        abcd = function() data = ipfsin:match(".*\"data\":(%b\"\").*")
                        if data then
                        data = mime.unb64(data:sub(2, -2))
                        print(data)
			s2s_in(data)
                        end end
while true do
        ipfsin = ipfs:receive('*l')
        if ipfsin then
                if ( ipfsin ~= "{}" and ipfsin ~= "3" ) then
--                      print(ipfsin)
	abcd(ipfsin)
                end
        end
	ircdin, misc = ngircd:receive('*l')
	if ircdin then
		print(ircdin)
		ircd_in(ircdin)
	end
	if not ircdin and misc:find("closed") then
		print("panic:", "connection closed")
		os.exit(1)
	end
        socket.sleep(0.01)
end
