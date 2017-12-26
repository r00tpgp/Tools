#!/bin/bash

###################################################
#              Recon Script
#
# Version: v2_08102016
# Created By: Seclyn
# Description: For initial recon of network/hosts.
#
###################################################
#             Set Variables
         workdir=~/lab
#
###################################################
clear

# Ping Scan
tput setaf 2; echo Current Hosts On the Network:
tput setaf 7;
echo ----------------------------------------------
nmap -sn 10.11.1.0/24 | grep "Nmap" | cut -d " " -f 5 > nmap-alive.txt
cat nmap-alive.txt
echo ----------------------------------------------------------

# Select IP to Target
tput setaf 4; echo Enter The IP Of The Target:
tput setaf 7;
echo --------------------------------------------
read ip
echo Making directory $workdir/$ip
mkdir $workdir/$ip
cd $workdir/$ip
echo

# Quick Nmap Scan To Get You Started
tput setaf 5;
echo --------------------------------------------
echo         Nmap Scan  - Host $ip
echo --------------------------------------------
tput setaf 7;
echo
nmap $ip -A -T5 -oN nmap_$ip
nmap -sU $ip -T5 -oN nmap_udp_$ip
echo

# Nikto
tput setaf 2;
echo ---------------------------------------------------------
echo Running Nikto scan. Output to nikto_$ip.txt
echo ---------------------------------------------------------
tput setaf 7;
sleep 10
echo Checking For HTTP Services . . . .
if grep "http" nmap_$ip; then
	nikto -h $ip > nikto_$ip.txt #-ask no
        echo Niko output stored in nikto_$ip.txt
	wget http://$ip/robots.txt -O robots_$ip.txt
else
	echo No HTTP Services Found On $ip
	echo No HTTP Services Found on $ip > nikto_NO_HTTP_$ip
fi
echo
echo

tput setaf 4;
echo
echo -----------------------------------------------
echo Running dirb scan.
echo ---------------------------------------------------
tput setaf 7;
dirb http://$ip -o dirb_$ip -w
echo Scanned using common wordlist, you might want to do a thorough scan
echo -------------------------------------------------------------------

tput setaf 4;
echo
echo --------------------------------------------
echo         Nmap Long Scan  - Host $ip
echo --------------------------------------------
tput setaf 7;
echo Scan will take some time. Output to nmap_$ip
echo
nmap -sV $ip -p- -A -T5 -oN nmap_full_$ip --stats-every 10s
echo --------------------------------------------

echo Scan completed for $ip
echo Happy Hunting!
echo --------------------------------------------
echo
ls -lth $workdir/$ip
#end



