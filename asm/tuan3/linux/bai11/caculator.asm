section .data 
	menu db "chon phep tinh" , 0xA, 0
	cong db "1. phep cong ", 0xA, 0
	tru db "2. phep tru ", 0xA, 0
	nhan db "3. phep nhan ", 0xA, 0
	chia db "4. phep chia ", 0xA, 0
	pnum1 db "nhap so 1 = ", 0
	pnum2 db "nhap so 2 = ", 0
	inval db "invalid!!!", 0xA, 0
	over db "overflow!!!", 0xA,0
	neg_char db "-",0
	endline db " ",0xA, 0
	
	maxChar equ 256
section .bss 
	select resq 1
	num1 resq 2
	num2 resq 2 
	res resq 4
	
section .text
 
global _start	
_start:


	call printMenu
	call checkSelect

	call inpN1_N2
	
	
	push select
	push res
	call calc
	
	push endline
	call PrintString
	
	mov rax, 60
	mov rdi, 0
	syscall
	



printMenu:
	push menu
	call PrintString
	
	push cong 
	call PrintString
	
	push tru
	call PrintString
	
	push nhan
	call PrintString
	
	push chia
	call PrintString
	ret
;-------------------------------------------------end printMenu
	
	
checkSelect:
	push rbp 
	mov rbp, rsp 
	push r15
	
	push select
	call ReadString
	
	
	mov r15, QWORD[select] 
	cmp r15, 0x31
	jz .L0
	cmp r15, 0x32 
	jz .L0
	cmp r15, 0x33 
	jz .L0 
	cmp r15, 0x34 
	jz .L0 
	jmp .L1 

	
.L0:	
	pop r15
	mov rbp, rsp
	pop rbp 
	ret 
.L1:
	push inval
	call PrintString
	
	mov rax, 60
	mov rdi, 0
	syscall
;-------------------------------------------------end seclect


inpN1_N2:
	
	push rbx 
	push rax 
	
	push pnum1
	call PrintString
	
	push num1
	call ReadString
	
	push num1 
	call checkNum
	
	push num1 
	call atoi

;-----------------------------
	mov rbx, rax 	
	shr rbx, 32 	
	cmp rbx, 0					;check overflow 32 bit 
	ja .L0
;-----------------------------

	push pnum2
	call PrintString
	
	push num2
	call ReadString
	
	push num2 
	call checkNum
	
	push num2 
	call atoi
;-----------------------------
	mov rbx, rax 	
	shr rbx, 32 	
	cmp rbx, 0					;check overflow 32 bit 
	ja .L0
;-----------------------------
	
	
	pop rax 
	pop rbx 
	ret
	
.L0:
	push over
	call PrintString
	
	mov rax, 60
	mov rdi, 0
	syscall
;-------------------------------------------------end inpN


calc:
	push rbp 
	mov rbp, rsp 
	
	push num2
	call atoi
	mov rdx, rax 				;num2 = rdx
	
	push num1
	call atoi						;num1 = rax 
	
	;push result
	;call PrintString
	
	mov r13, QWORD[rbp + 24]
	cmp QWORD[r13], 0x31
	jz .L0
	cmp QWORD[r13], 0x32 
	jz .L1
	cmp QWORD[r13], 0x33 
	jz .L2 
	cmp QWORD[r13], 0x34 
	jz .L3 
	
	
.L0:
;----------------------------
	add rax, rdx
	mov r15, rax 
	
	
	shr r15, 24 
	cmp r15, 0x7f 
	jle .L01
	neg eax 
	push neg_char
	call PrintString
.L01: 

	push rax  
	call PrintNumber
	jmp .L4
	
;----------------------------phép cộng
	
;----------------------------
.L1: 			
;1 -1     = 0
;1 - - 1  = 2
;-1 - 1   = -2 
; -1 - -1 = 0
	sub eax, edx
	mov r15, rax 
	shr r15, 24
	cmp r15, 0x7f 
	jle .L11 
	neg eax 
	push neg_char
	call PrintString
.L11:	
	push rax 
	call PrintNumber
	jmp .L4
	
;----------------------------phép trừ	

;----------------------------
.L2:
	mov rbx, rdx 
	cqo
	imul rbx 
	push rax 
	call PrintNumber
	jmp .L4
;----------------------------phép nhân

;----------------------------
.L3:
	mov rbx, rdx 
	cqo
	idiv rbx
	push rax 
	call PrintNumber
	jmp .L4
;----------------------------phép chia 

.L4:
	mov rsp, rbp
	pop rbp 
	ret
	
.L5:
	push over
	call PrintString
	
	mov rax, 60
	mov rdi, 0
	syscall
		
	
;-------------------------------------------------end calc



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
	cmp dl, 0x2d
	jz .L01  
	cmp dl, 0x30 
	jl .L2
	cmp dl, 0x39
	ja .L2

.L01:
	add r15, 1
	jmp .L0
	
.L1:
	pop r15
	mov rsp, rbp 
	pop rbp 
	ret 8

.L2:
	push inval
	call PrintString
	
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
	
	push rdx 
	push rbx
	push rcx 
	
	xor rax, rax
	xor rbx, rbx
	xor rcx, rcx 
	mov r15, QWORD[rbp + 16]
	mov QWORD[rbp - 8], 10

.L0:
	mov bl, BYTE[r15]
	cmp bl , 0
	jz .L02
;-------------------------
	cmp bl, 0x2d 								;check ký tự dấu -
	jz .L01
;-------------------------
	sub rbx, 0x30 
	mul QWORD[rbp - 8]					;rax = rax * 10
	
	
	add rax, rbx 								;((rax * 10) + rbx) * 10 + rbx...............
	mov r14, rax,
	shr r14, 32 
	cmp r14, 0
	ja .L2
	
	add r15, 1
	jmp .L0
	
;-------------------------
.L01:
	add rcx,1 									;check ký tự dấu - 
	add r15, 1
	jmp .L0
;-------------------------	

.L02:
	cmp rcx, 1
	jnz .L1 
	neg eax
	
.L1:	
	pop rcx 
	pop rbx
	pop rdx 
	pop r15 
	mov rsp, rbp
	pop rbp 
	ret 8

.L2:
	push over
	call PrintString
	
	mov rax, 60
	mov rdi, 0
	syscall
	
;-------------------------------------------------end atoi

	
PrintNumber: 
	push rbp
	mov rbp, rsp 
	sub rsp, 64
	
	push r15
	push r14
	push rdx 
	push rcx 
	push rbx
	push rax
	
	mov r15, QWORD[rbp + 16]			;number
	mov QWORD[rbp - 8], 10				
	lea r14, [rbp - 64]						;store string of number 
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
	lea r14, [rbp - 64]
	mov rdx, 0
.L1:
	mov bl, BYTE[r14 + rcx -1]
	mov BYTE[r15], bl
	add r15, 1
	add rdx, 1									;string_len
	sub rcx, 1
	cmp rcx, 0
	jnz .L1
	
		
	mov rax, 1
	mov rdi, 1  
	lea rsi, [rbp - 32]								;string 
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


PrintString: 
	push rbp
	mov rbp, rsp 
	sub rsp, 16
	
	push rax 
	
	push QWORD[rbp + 16]
	call getlen
	mov QWORD[rbp - 16], rax 
		
	mov rax, 1
	mov rdi, 1  
	mov rsi, QWORD[rbp + 16]				;string 
	mov rdx, QWORD[rbp - 16]				;string_len
	syscall
		
	pop rax 
	mov rsp, rbp 
	pop rbp 
	ret 8
;-------------------------------------------------end PrintString

	

ReadString:
	push rbp 
	mov rbp, rsp 
	
	push rdx
	mov rax, 0 
	mov rdi, 0 	
	mov rsi, QWORD[rbp + 16]					;string
	mov rdx, maxChar								;max length of string 
	syscall
	
.L0:
	mov dl, BYTE[rsi]
	cmp dl, 0xA 
	jz .L1
	add rsi, 1
	jmp .L0


.L1:

	mov BYTE[rsi], 0									;remove 0xA at end of string
	pop rdx
	mov rsp, rbp 
	pop rbp
	ret 8
;-------------------------------------------------end ReadString
	
	
	


	