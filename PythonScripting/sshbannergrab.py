#! /usr/bin/python3

import socket

ip = input('give me the ip address: ')
ports = [22, 20, 21]

for port in ports:
	try:

		print('This is the banner for port ' + str(port) + ':' )
		sock = socket.socket()
		sock.connect((ip, port))
		answer = sock.recv(1024)
		print(answer)
		sock.close()	
	except:
		print('no answer')





#sock = socket.socket()

#sock.connect(('10.0.2.6', 22))

#answer = sock.recv(1024)

# print(answer)

# sock.close
