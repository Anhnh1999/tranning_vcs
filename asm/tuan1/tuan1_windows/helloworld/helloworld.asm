.386
.model flat, stdcall
option casemap :none

include C:\masm32\include\kernel32.inc
include C:\masm32\include\masm32.inc
includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\masm32.lib

.data
	msg db "Hello world!", 0

.code 

main:
	push offset msg		;offset msg làm tham số cho StdOut
	call StdOut
	push 0
	call ExitProcess	;0 làm tham số cho ExitProcess
end main 