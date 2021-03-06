global _start

section .data
	inps db "input string: ", 10
	rev_s db "rev string is: ", 10
	outps db "string is: ", 10
	outp_rev db "string after reverse: ", 10

section .bss
	s resb 256
	s_len resb 256

section .text

_start:
	
	call ioS_proc
	
	push s
	call getlen
	mov DWORD[s_len], eax
	
	push QWORD[s_len]
	push s
	call rev_string
	
	mov rax, 60
	mov rdi, 0
	syscall
;_________________________________________________________
getlen:
	push rbp 
	mov rbp, rsp
	sub rsp, 0x8
 
	mov r15d, DWORD[rbp - 0x8]	; store string_len	
	mov r14, [rbp + 0x10]		;string to get len
	
.L1:
	mov dl, BYTE[r14]
	cmp dl, 0xA
	jz .L2
	add r14, 1		; next char of string
	add r15d, 1		; number char of string 
	jmp .L1
	
.L2:
	mov eax, r15d	;len(string) store in eax 
	mov rsp, rbp
	pop rbp
	ret 8
;_________________________________________________________	
	
rev_string:
	push rbp 
	mov rbp, rsp
	sub rsp, 0x100
	
	mov r15, QWORD[rbp + 0x10]			;string to be rev
	mov rcx, QWORD[rbp + 0x18]			;length
	
	
	lea r14, [rbp - 0x100]				;string aftter rev

.L1: 									;reverse string to right order
	mov dl, BYTE[r15 + rcx - 1]
	mov BYTE[r14], dl
	add r14, 1
	sub rcx, 1
	cmp rcx, 0
	
	jnz .L1
	

;------------------

	mov rax, 1
	mov rdi, 1
	mov rsi, outp_rev
	mov rdx, 23 	;print 'string after reverse:  ' to screen
	syscall

	mov rax, 1
	mov rdi, 1
	lea rsi, [rbp - 0x100]
	mov rdx, QWORD[rbp + 0x18]
	syscall
;------------------

	xor r14, r14
	xor r15, r15
	mov rsp, rbp 
	pop rbp
	ret 16
;_________________________________________________________

	
ioS_proc:
	
	mov rax, 1
	mov rdi, 1
	mov rsi, inps
	mov rdx, 15
	syscall		;print 'input string: ' to screen

	mov rax, 0
	mov rdi, 0
	mov rsi, s
	mov rdx, 256
	syscall		;input string

	mov rax, 1
	mov rdi, 1
	mov rsi, outps
	mov rdx, 12 	;print 'string is: ' to screen
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, s
	mov rdx, 256
	syscall		;print S 

	ret
















