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
         workdir=~/exam3
#
###################################################
clear

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
echo Running  Nmap Scan  - Host $ip
tput setaf 7;
echo **TCP SCAN**
nmap $ip -A -T5 -oN nmap_$ip --stats-every 10s
echo **UDP SCAN**
nmap -sU $ip -T5 -oN nmap_udp_$ip --stats-every 10s

# RPC, NBT Scan
tput setaf 2;
echo ------------------------
echo Running RPC and NBT scan
tput setaf 7;
sleep 10
echo Checking For RPC and NBT Services . . . .
if grep "msrpc" nmap_$ip; then
        nmap --script msrpc-enum --script-args vulns.showall $ip -oN nmap_msrpc_$ip.txt
        echo MSRPC and NBT results stored in nmap_msrpc_$ip.txt
else
        echo No MSRPC Services Found on $ip
fi

# SMB Enum
tput setaf 2;
echo -----------------------------------------------------
echo Running enum4linux scan. Output to enum4linux_$ip.txt
tput setaf 7;
sleep 10
echo Checking For SMB Services . . . .
if grep "smb" nmap_$ip; then
	echo **SMB Scanning..**
	enum4linux $ip > enum4linux_$ip.txt
	echo SMB Enum stored in enum4linux_$ip
	nmap --script smb-* --script-args vulns.showall $ip -oN nmap_smb_$ip.txt
else
	echo No SMB Services Found on $ip
fi

# FTP Enum
tput setaf 2;
echo ------------------------------------------------
echo Running Nmap ftp scan. Output to nma_ftp_$ip.txt
tput setaf 7;
sleep 10
echo Checking For FTP Services . . . .
if grep "ftp" nmap_$ip; then
	echo **NMAP FTP Scan**
        nmap $ip --script ftp-* -oN nmap_ftp_$ip
        echo FTP Enum stored in nmap_ftp_$ip
else
        echo No FTP  Services Found on $ip
fi

# SSH Enum
tput setaf 2;
echo -------------------------------------------------
echo Running Nmap SSH scan. Output to nmap_ssh_$ip.txt
tput setaf 7;
sleep 10
echo Checking For SSH Services . . . .
if grep "ssh" nmap_$ip; then
	echo **NMAP SSH Scan**
        nmap $ip --script ssh-*,ssl-* -oN nmap_ssh_$ip
        echo SSH Enum stored in nmap_ssh_$ip
else
        echo No SSH  Services Found on $ip
fi

# SNMP Enum
tput setaf 2;
echo ----------------------------------------------
echo Running SNMP scan. Output to nmap_snmp_$ip.txt
sleep 10
tput setaf 7;
echo Checking For SNMP Services . . . .
if grep "snmp" nmap_$ip; then
	echo **NMAP SNMP Scan**
        nmap $ip --script snmp-* -oN nmap_snmp_$ip
        echo SSH Enum stored in nmap_snmp_$ip
else
        echo No SNMP  Services Found on $ip
fi

# DNS Enum
tput setaf 2;
echo --------------------------------------------
echo Running DNS scan. Output to nmap_dns_$ip.txt
sleep 10
tput setaf 7;
echo Checking For DNS Services . . . .
if grep "ssh" nmap_$ip; then
	echo **NMAP DNS Scan**
        nmap $ip --script dns-zone-transfer,dns-srv-enum -oN nmap_dns_$ip
        echo DNS Enum stored in nmap_dns_$ip
else
        echo No DNS Services Found on $ip
fi

# MSSQL Enum
tput setaf 2;
echo -------------------
echo Running MS SQL scan
sleep 10
tput setaf 7;
echo Checking For MS SQL Services . . . .
if grep ms-sql* nmap_$ip; then
	echo **NMAP MS-SQL Scan**
        nmap --script ms-sql-* --script-args vulns.showall $ip -oN nmap_mssql_$ip.txt
        echo MS-SQL Enum stored in nmap_mssql_$ip
else
        echo No MS-SQL Services Found on $ip
fi

tput setaf 2;
echo ---------------------------
echo Nmap Long Scan  - Host $ip
echo **This might take some time. Output to nmap_$ip**
nmap -sV $ip -p- -A -T5 -oN nmap_full_$ip --stats-every 10s
tput setaf 7;

tput setaf 2;
echo ###################################################################
echo # Last SCAN!!! Nikto, Feth robots.txt, NMAP HTTP and enum4linux
echo ###################################################################
sleep 10
echo Checking For HTTP Services . . . .
if grep "80/tcp" nmap_$ip; then
tput setaf 7;
	echo **Running nikto scan, press CTRL-C to Skip**
	nikto -h $ip > nikto_$ip.txt #-ask no
        echo Niko output stored in nikto_$ip.txt
	echo **Fething robots.txt file**
	wget http://$ip/robots.txt -O robots_$ip.txt
	echo **Running nmap http scan**
	nmap $ip -sV --script "http-sitemap-gen*,http-methods,http-mobile*, \
		http-open*,http-sql*,http-userdir*,http-vhosts,http-webdav*, \
		http-iis-webdav*,http-enum*,http-frontpage*, \
		http-useragent*" -oN nmap_http_$ip
	echo Nmap HTTP Enum stored in nmap_http_$ip 
	echo **Dir Busting**
	dirb http://$ip -o dirb_$ip -w
	echo **Scanned using common wordlist, you might want to do a thorough scan**
else
	echo No HTTP Services Found On $ip
fi

echo Scan completed for $ip
echo Happy Hunting!
echo ------------------------
echo
ls -lth $workdir/$ip
#end
