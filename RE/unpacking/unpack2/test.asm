.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\kernel32.lib

include C:\masm32\include\masm32.inc
includelib C:\masm32\lib\masm32.lib

.code 

main proc
;0045C005
	push 0B728B903h
	rol dword ptr ss:[esp],3Dh

;0045C010
	push 3B728AA8h
	rol dword ptr ss:[esp],41h
	
;0045C01b
	push 0E83BC17Dh
	rol dword ptr ss:[esp],69h
	
;0045C026
	push 26F903B7h
	rol dword ptr ss:[esp],75h
 
;0045C031
	push 3B728570h
	rol dword ptr ss:[esp],81h

;0045C03c
	push 287183B7h
	rol dword ptr ss:[esp],95h
 
;0045C047
	push 726FC03Bh
	rol dword ptr ss:[esp],99h

;0045C052
	push 3B72A080h
	rol dword ptr ss:[esp],0A1h
	
;0045C05d
	push 3B728B2h
	rol dword ptr ss:[esp],0A5h

;0045C068
	push 297703B7h
	rol dword ptr ss:[esp],0B5h

;0045C073
	push 7298D03Bh
	rol dword ptr ss:[esp],0B9h

;0045C07e
	push 0B7298F83h
	rol dword ptr ss:[esp],0BDh
	
;0045C089
	push 0C83B7299h
	rol dword ptr ss:[esp],0E9h
	
;0045C094
	push 79C03B72h
	rol dword ptr ss:[esp],0F1h
	
;0045C09f
	push 3B729C58h
	rol dword ptr ss:[esp],1
	
;0040166d
main endp 


end



