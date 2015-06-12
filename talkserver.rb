#!/usr/bin/env ruby -w

require 'socket'

ip_addr = IPSocket.getaddress(Socket.gethostname)

server = TCPServer.new(ip_addr, 8000)

while (session = server.accept)
	request = session.gets
	session.print "HTTP/1.1 200/OK\rContent-type: text/html\r\n\r\n"
	session.print "<html><head><title>Response from Ruby Web server</title></head>\r\n"
	session.print "<body>request was:"
	session.print request
	session.print "</body></html>"

	if found = request.match(/%22(.*)%22/)
		output = found.captures[0].gsub(/%20/,' ')
		puts output
		`say -v Daniel \"#{output}\"`
	end

	session.close
end
