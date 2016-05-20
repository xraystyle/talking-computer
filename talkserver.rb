#!/usr/bin/env ruby -w

require 'socket'

interface = `route get 0.0.0.0 | awk '/interface:/ {print $2}'`.strip
mac_iface_name = `networksetup -listallhardwareports | grep -B 1 #{interface} | head -1 | cut -d " " -f 3-`.strip
ip_addr = `networksetup -getinfo "#{mac_iface_name}" | awk '/^IP address:/ {print $3}'`.strip

puts "Listening on: #{ip_addr}:8000"
server = TCPServer.new(ip_addr, 8000)

while (session = server.accept)
  request = session.gets
  session.print "HTTP/1.1 200/OK\rContent-type: text/html\r\n\r\n"
  session.print "<html><head><title>Response from Ruby Web server</title></head>\r\n"
  session.print "<body>request was:"
  session.print request
  session.print "</body></html>"
  begin
    if found = request.match(/%22(.*)%22/)
      output = found.captures[0].gsub(/%20/,' ')
      puts output
      `say -v Daniel \"#{output}\"`
    end
  rescue => e
    puts "Something broke. Debug info:"
    puts "exception: #{e}"
    puts "request: #{request}"
    puts "found: #{found}"
    puts "output: #{output}"
  end
  session.close
end
