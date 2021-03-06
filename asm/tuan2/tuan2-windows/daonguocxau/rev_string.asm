option casemap:none
include C:\masm32\include64\win64.inc
include C:\masm32\include64\kernel32.inc
includelib C:\masm32\lib64\kernel32.lib
include C:\masm32\include64\user32.inc
includelib C:\masm32\lib64\user32.lib

.data
	inps db "input string: ", 0
	rev_s db "rev string is: ", 0
	outps db "string is: ", 0
	outp_rev db "string after reverse: ", 0

.data?
	s db 256 dup(?)
	s_len db 256 dup(?)

.code

main proc
	
	call ioS_proc
	
	
	lea rcx, [s]
	call lstrlen
	sub rax, 2						; trừ đi 2 ký tự \r\n
	mov QWORD ptr[s_len], rax		; độ dài xâu nhập
	
	
	push QWORD ptr[s_len]
	lea rdi, [s]
	push rdi						;push s
	call rev_string
	
	xor rcx, rcx 
	call ExitProcess
main endp


rev_string proc
	push rbp 
	mov rbp, rsp
	sub rsp, 256
	
	mov r15, QWORD ptr[rbp + 16]			;string to be rev
	mov rcx, QWORD ptr[rbp + 24]			;length
	
	
	lea r14, [rbp - 256]					;string aftter rev

L1: 										;reverse string to right order
	mov dl, BYTE ptr[r15 + rcx - 1]
	mov BYTE ptr[r14], dl
	add r14, 1
	sub rcx, 1
	cmp rcx, 0
	
	jnz L1
	

;------------------

	lea rdi, [outp_rev]
	push rdi 
	call WriteString		;print 'string after reverse:  ' to screen	


	;push offset ptr[rbp - 256]
	lea rdi, [rbp -256]
	push rdi
	call WriteString

;------------------

	xor r14, r14
	xor r15, r15
	mov rsp, rbp 
	pop rbp
	ret 16
rev_string endp
;_________________________________________________________

	
ioS_proc:
	
	lea rdi, [inps]
	push rdi 
	call WriteString	;print 'input string: ' to screen


	push 100
	lea rdi, offset s
	push rdi 
	call ReadString		;input string


	lea rdi, [outps]
	push rdi 
	call WriteString	;print 'string is: ' to screen
	

	lea rdi, [s]
	push rdi 
	call WriteString	;print s


	ret


;----------------------------------------------------------
WriteString proc
	push rbp 
	mov rbp, rsp 
	sub rsp, 30h 
	
	push rdx
	push rcx
	push rax
	push r15
	push r8
	push r9
	
	mov rcx, QWORD ptr[rbp + 10h]
	call lstrlen
	mov r15 ,rax 
	
	mov rcx, -11
	call GetStdHandle

	
	mov rcx, rax
	mov rdx, QWORD ptr[rbp + 10h]
	mov r8, r15
	lea r9, [rbp - 8]
	call WriteConsole
	
	
	pop r9
	pop r8
	pop r15
	pop rax
	pop rcx
	pop rdx
	
	mov rsp, rbp 
	pop rbp
	ret 8
	
WriteString endp
;----------------------------------------------------------


;----------------------------------------------------------
ReadString proc
	push rbp 
	mov rbp, rsp 
	sub rsp, 30h
	
	push rdx
	push rcx
	push rax
	push r15
	push r8
	push r9
	
	mov r15, QWORD ptr[rbp + 18h]
	
	;mov rcx, QWORD ptr[rbp + 10h]
	;call lstrlen
	;mov slen, rax
	
	mov rcx, -10 
	call GetStdHandle
		
	mov rcx, rax 
	mov rdx, QWORD ptr[rbp + 10h]
	mov r8, r15
	lea r9, [rbp - 8]
	call ReadConsole
	
	pop r9
	pop r8
	pop r15
	pop rax
	pop rcx
	pop rdx
	
	mov rsp, rbp 
	pop rbp
	ret 16
	
ReadString endp
;----------------------------------------------------------
end















