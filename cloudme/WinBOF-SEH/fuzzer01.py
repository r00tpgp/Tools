# Simple Fuzzer for CloudMe Sync 1.9.2
# Written by r00tpgp
 
import sys, socket, time
 
# Use in the form "python fuzzer.py  "
 
host = sys.argv[1] # Recieve IP from user
port = int(sys.argv[2]) # Recieve Port from user
 
length = 100 # Initial length of 100 A's
 
while (length <= 3000): # Stop once we've tried up to 3000 length
	client=socket.socket(socket.AF_INET, socket.SOCK_STREAM) # Declare a TCP socket
	client.connect((host, port)) # Connect to user supplied port and IP address
	client.send("A" * length) # Send the user command with a variable length name
	client.close() # Close the Connection
	time.sleep(2) # Sleep to prevent DoS crashes
	print "Length Sent: " + str(length) # Output the length username sent to the server
	length += 100 # Try again with an increased length
