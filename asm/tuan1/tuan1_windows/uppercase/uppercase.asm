.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\kernel32.lib

include C:\masm32\include\masm32.inc
includelib C:\masm32\lib\masm32.lib


.data?
	input db 32 dup(?)

.code

main proc 
	call inp
	lea ebx, [input]
	call uppercase
	call outp
	push 0
	call ExitProcess
main endp
;-----------------------------------


inp proc
	push 32
	push offset input
	call StdIn					;input 32 byte
	ret
inp endp
;-----------------------------------


outp proc
	push offset input
	call StdOut					;output 32 byte after uppercase 
	ret
outp endp
;-----------------------------------


uppercase proc
L1:
	mov dl, BYTE ptr[ebx]
	cmp dl, 0
	jz done
	jmp check

up:
	sub dl, 20h
notup:
	mov [ebx], dl 
	add ebx, 1
	jmp L1

check:			; check ký tự in thường hay in hoa
	cmp dl, 61h		
	jl notup
	cmp dl, 7bh
	jg notup
	jmp up

done:
	ret
uppercase endp
;-----------------------------------
end main
