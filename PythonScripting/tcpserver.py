#! /usr/bin/python3

import socket

TCP_IP = ""
TCP_PORT = ""
BUFFER_SIZE = 100

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.bind((TCP_IP, TCP_PORT))
sock.listen(1)

conn, addr = s.accept()
 print ('Connection address: ', addr )

 	while 1:
 		
 		data=conn.recv(BUFFER_SIZE)
 		if not data:break
 		print('Received dataK ', data)
 		     conn.send(data)   #echo
 	conn.close
