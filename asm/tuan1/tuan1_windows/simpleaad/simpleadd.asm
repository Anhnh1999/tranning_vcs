.386
.model flat, stdcall
option casemap:none


include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\kernel32.lib

include C:\masm32\include\masm32.inc
includelib C:\masm32\lib\masm32.lib

.data?
	a db 20 dup(?)
	b db 20 dup(?)
	value db 100 dup(?)
	trueValue db 100 dup(?)

.data
	pa db "input first number: ", 0
	pb db "input second number: ", 0
	s  db "sum is: "
	inval db "invalid number!!", 0
		

.code
main proc
	call inpa
	lea ecx, [a] 
	call atoi
	mov  DWORD ptr[esp + 8],edx			;nhập a và chuyển sang dạng số rồi push vào stack
;--------------------------------------------------------
	
	call inpb
	lea ecx, [b]
	call atoi
	mov  DWORD ptr[esp + 12],edx			;nhập b và chuyển sang dạng số rồi push vào stack
;--------------------------------------------------------
	
	mov eax, DWORD ptr[esp + 8]
	mov ebx, DWORD ptr[esp + 12]

;--------------------------------------------------------
	cmp eax, 7fffffffh							;so sánh 2 số nhập với 31 bit 
	ja invalid
	cmp ebx, 7fffffffh
	ja invalid
;--------------------------------------------------------

	add eax, ebx

	push eax 
	call hex2chr
	
main endp
;----------------------------------------------------------------------


inpa proc
	push offset pa
	call StdOut						;print input first number to screen 
	push 20
	push offset a
	call StdIn						;input a 
	ret 
inpa endp
;----------------------------------------------------------------------


inpb proc
	push offset pb 
	call StdOut						;input second number to screen
	push 20
	push offset b
	call StdIn						;input b 
	ret
inpb endp 	
;----------------------------------------------------------------------


atoi proc								;convert char to int  vd: 1234 = ((10 + 2)*10 + 3) * 10 + 4
	xor eax, eax
	xor ebx, ebx 
	xor edx, edx 
	mov DWORD ptr[esp + 4] , 10
nextchr:
	mov bl, BYTE ptr[ecx]
	cmp bl, 0
	jz done
	cmp bl, 30h 
	jl invalid	
	cmp bl, 39h
	jg invalid
	
	sub ebx, 30h
	mul DWORD ptr[esp + 4]    ;eax = eax * 10  
	pushf 							 ;make a copy of flags on to stack 

	add eax, ebx

	popf  							 ;get flags
	jo invalid						 ;check overflow  
	
	mov edx, eax
	add ecx, 1
	jmp nextchr
done:
	ret	
atoi endp
;----------------------------------------------------------------------


hex2chr proc
	mov eax, DWORD ptr[esp + 4] 	; mov sum of two number to eax
	
	lea ebx, [value]						; mov offset of value to ebx
	mov DWORD ptr[esp +8], 0		; DWORD[esp + 4] is index
	
hex2chr1:
	mov ecx, 10
	mov edx, 0
	div ecx
	
	add dl, 30h
	mov BYTE ptr[ebx], dl		;each character mov to ebx
	add ebx, 1
	add DWORD ptr[esp +8], 1
	cmp eax, 0
	jnz hex2chr1

hex2chr endp	
;----------------------------------------------------------------------
	
reverse:
	mov eax, DWORD ptr[esp +8] 		;number of character in sum of two number 
	lea ecx, [trueValue]

reverse1:
	mov dl, BYTE ptr[value + eax - 1]	 ;last char of sum two number string
	mov BYTE ptr[ecx], dl
	
	sub eax, 1
	add ecx, 1
	cmp eax, 0
	jnz reverse1
	mov BYTE ptr[ecx], 0Ah
	
	
outp:
	push offset trueValue
	call StdOut
	
	push 0
	call ExitProcess
;----------------------------------------------------------------------end reverse


invalid proc
	push offset inval
	call StdOut
	
	push 0
	call ExitProcess
invalid endp

end main





