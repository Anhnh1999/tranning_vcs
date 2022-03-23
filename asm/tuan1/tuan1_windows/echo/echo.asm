.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\kernel32.lib

include C:\masm32\include\masm32.inc
includelib C:\masm32\lib\masm32.lib

.data
	msg db "enter text to echo: ", 0	


.data?
	input db 32 dup(?)

.code 
main:

	push offset msg				
	call StdOut					;print enter text to echo to screen 
;----------------------------------

	push 32
	push offset input
	call StdIn					;enter text 
;----------------------------------

	push offset input 
	call StdOut					;print text to screen 
;----------------------------------
	
	push 0 
	call ExitProcess

end main	