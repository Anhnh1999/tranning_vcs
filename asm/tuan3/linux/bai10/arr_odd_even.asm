section .data
	n_out db "input n: ",  0
	arr_index1 db "arr[", 0
	arr_index2 db "] = ", 0
	oddNum 	db "sum of odd numbers = ", 0
	evenSum db "sum of even numbers = ", 0
	inval db "invalid!!!", 0xA, 0
	over db "overflow!!!", 0xA,0
	endline db " ",0xA, 0

	maxChar equ 256

section .bss 
	arr resd 100 
	n resd 1
	inp resd 1
	

section .text	
global _start


_start:

	call inpN

	
	push n 
	call checkNum
	
	call inpARR
	
	call sumOdd
	
	push endline
	call WriteString
	
	call sumEven
	
	push endline
	call WriteString
	
	
	
	mov rax, 60
	mov rdi, 0
	syscall
		
;-------------------------------------------------end start


sumOdd:
	push rbp 
	mov rbp, rsp 
	
	push r15
	push r14
	push rdx
	

;--------------------------------------------
	lea r15, [arr]
	mov r14, 0
.L0:
	mov edx, DWORD[r15]
	add r15, 4
	test edx, 1						;edx = edx & 1 
									;if edx = 1 => oddnum else 
									;else evennum
	jnz .L1
	jz .L2
								
.L1:
	add r14, rdx
	mov rbx, r14 
	shr rbx, 28 
	cmp rbx, 8
	jae .L4
.L2:
	cmp DWORD[r15], 0
	jnz .L0
;--------------------------------------------
	
.L3:
	lea rdi, [oddNum]
	push rdi
	call WriteString
	
	push r14
	call PrintNumber 
	
	
	pop rdx
	pop r14
	pop r15
	mov rsp, rbp 
	pop rbp
	ret
	
.L4:
	push over
	call WriteString
	
	mov rax, 60
	mov rdi, 0
	syscall
;-------------------------------------------------end sumOdd


sumEven:
	push rbp 
	mov rbp, rsp 
	
	push r15
	push r14
	push rdx
	
		
	lea r15, [arr]
	mov r14, 0

.L0:
	mov edx, DWORD[r15]
	add r15, 4
	test edx, 1					;edx = edx & 1 
								;if edx = 0 => oddnum else 
								;else evennum
	jz .L1
	jnz .L2
								
.L1:
	add r14, rdx
	mov rbx, r14 
	shr rbx, 32 
	cmp rbx, 0
	jnz .L4
.L2:
	cmp DWORD[r15], 0
	jnz .L0

	
.L3:
	push evenSum
	call WriteString
	
	push r14
	call PrintNumber
	
	
	pop rdx
	pop r14
	pop r15
	mov rsp, rbp 
	pop rbp
	ret
	
.L4:
	push over
	call WriteString
	
	mov rax, 60
	mov rdi, 0
	syscall
;-------------------------------------------------end sumEven


		
inpARR:
	push rbp
	mov rbp, rsp 
	sub rsp, 8
	
	push n 
	call atoi
	mov QWORD[rbp - 8], rax						;arr_length(n)
	lea r15, [arr]
	mov r14, 0									;index number 

	
.L0:
	cmp   QWORD[rbp - 8] , 0
	jz .L1

;--------------------------------------------------
	push arr_index1
	call WriteString
	push r14 
	call PrintNumber
	push arr_index2
	call WriteString
	
	
	push inp									;enter value for array
	call ReadString

	push inp
	call checkNum
	
	push inp
	call atoi
	
	mov rbx, rax 
	shr rbx, 32 
	cmp rbx, 0
	jnz .L2
	
	
	mov edx, eax
	mov DWORD[r15], edx
;--------------------------------------------------

	sub  QWORD[rbp - 8], 1
	add r15, 4
	add r14, 1
	jmp .L0
	
.L1:
	mov rsp, rbp 
	pop rbp 
	ret 
.L2:
	push over
	call WriteString
	
	mov rax, 60
	mov rdi, 0
	syscall
;-------------------------------------------------end inpARR
	

checkNum:
	push rbp
	mov rbp, rsp 

	push r15 

	mov r15, QWORD[rbp + 16]
	push r15 
	call getlen
.L0:	
	mov dl, BYTE[r15]
	cmp rax, 0 
	jz .L2
	cmp dl, 0
	jz .L1 
	cmp dl, 0x30 
	jl .L2
	cmp dl, 0x39
	ja .L2
	
	add r15, 1
	jmp .L0
	
.L1:
	pop r15
	mov rsp, rbp 
	pop rbp 
	ret 8

.L2:
	push inval
	call WriteString
	
	mov rax, 60
	mov rdi, 0
	syscall
;-------------------------------------------------end checkNum

	
atoi: 

;1234 = ((10 + 2)*10 + 3) * 10 + 4
	push rbp 
	mov rbp, rsp 
	sub rsp, 8
	
	push r15 
	push rbx
	
	xor rax, rax
	xor rbx, rbx
	mov r15, QWORD[rbp + 16]
	mov QWORD[rbp - 8], 10

.L0:
	mov bl, BYTE[r15]
	cmp bl , 0
	jz .L1
	sub rbx, 0x30 
	mul QWORD[rbp - 8]			;rax = rax * 10
	
	pushf
	add rax, rbx 				;((rax * 10) + rbx) * 10 + rbx...............
	popf
	jo .L2
	add r15, 1
	jmp .L0

.L1:	
	pop rbx
	pop r15 
	mov rsp, rbp
	pop rbp 
	ret 8

.L2:
	push over
	call WriteString
	
	mov rax, 60
	mov rdi, 0
	syscall
	
;-------------------------------------------------end atoi


	
	
getlen:
	push rbp 
	mov rbp, rsp 
		
	push r15
	push rdx
	push rcx
	
	mov r15, QWORD[rbp + 16]
	xor rcx, rcx
	
.L0:
	mov dl, BYTE[r15]
	cmp dl, 0
	jz L1
	add r15, 1
	add rcx, 1
	
	jmp .L0
	
L1:
	mov rax, rcx 
	
	pop rcx
	pop rdx 
	pop r15
	mov rsp, rbp 
	pop rbp 
	ret 8
;-------------------------------------------------end getlen
	

inpN:
	
	push n_out
	call WriteString
	
	push n 
	call ReadString
	
	push n 
	call atoi
	cmp rax, 100
	ja .L0
	
	ret
	
.L0:
	push over
	call WriteString
	
	mov rax, 60
	mov rdi, 0
	syscall
;-------------------------------------------------end inpN


PrintNumber: 
	push rbp
	mov rbp, rsp 
	sub rsp, 32
	
	push r15
	push r14
	push rdx 
	push rcx 
	push rbx
	push rax
	
	mov r15, QWORD[rbp + 16]			;number
	mov QWORD[rbp - 8], 10				
	lea r14, [rbp - 16]					;store string of number 
	mov rcx, 0
	
	
	mov rax, r15
.L0:
	mov rdx, 0
	div QWORD[rbp - 8]
	add rdx, 0x30
	mov BYTE[r14], dl  
	add r14, 1
	add rcx, 1
	cmp rax, 0
	jnz .L0
	

	lea r15, [rbp - 32]
	lea r14, [rbp - 16]
	mov rdx, 0
.L1:
	mov bl, BYTE[r14 + rcx -1]
	mov BYTE[r15], bl
	add r15, 1
	add rdx, 1							;string_len
	sub rcx, 1
	cmp rcx, 0
	jnz .L1
	
		
	mov rax, 1
	mov rdi, 1  
	lea rsi, [rbp - 32]						;string 
	;mov rdx, QWORD[rbp - 8]				;string_len
	syscall
	
	
	pop rax 
	pop rbx
	pop rcx
	pop rdx 
	pop r14
	pop r15
	mov rsp, rbp 
	pop rbp 
	ret 8
;-------------------------------------------------end PrintNumber


WriteString: 
	push rbp
	mov rbp, rsp 
	sub rsp, 8
	
	push QWORD[rbp + 16]
	call getlen
	mov QWORD[rbp - 8], rax 
		
	mov rax, 1
	mov rdi, 1  
	mov rsi, QWORD[rbp + 16]			;string 
	mov rdx, QWORD[rbp - 8]				;string_len
	syscall
		
	mov rsp, rbp 
	pop rbp 
	ret 8
;-------------------------------------------------end WriteString

	

ReadString:
	push rbp 
	mov rbp, rsp 
	
	push rdx
	mov rax, 0 
	mov rdi, 0 	
	mov rsi, QWORD[rbp + 16]					;string
	mov rdx, maxChar							;max length of string 
	syscall
	
.L0:
	mov dl, BYTE[rsi]
	cmp dl, 0xA 
	jz .L1
	add rsi, 1
	jmp .L0


.L1:

	mov BYTE[rsi], 0								;remove 0xA at end of string
	pop rdx
	mov rsp, rbp 
	pop rbp
	ret 8
;-------------------------------------------------end ReadString

	
	
	
	