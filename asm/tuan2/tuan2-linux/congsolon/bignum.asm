global _start

section .data
	inpn1 db "input num1: "
	inpn2 db "input num2: "
	outpn1 db "num1 is: "
	outpn2 db "num2 is: "
	inval db "invalid!!"
	endline db "", 10

section .bss
	num1 resb 100
	num2 resb 100
	sum resb 100
	
	num1_len resb 100
	num2_len resb 100
	sum_len  resb 100
	rev_num1 resb 100
	rev_num2 resb 100
	rev_sum resb 100


section .text

_start:
	
	call ion1_proc		;input num1 
	call ion2_proc 	;input num2
;--------------------
	
	push num1
	call checkNum		;check num1 is a number 


	push num2
	call checkNum		;check num1 is a number 
;--------------------
	
	
	
	push num1
	call getlen
	mov QWORD[num1_len], rax


	push num2
	call getlen
	mov QWORD[num2_len], rax
;--------------------
	
	
	
;--------------------	
	push QWORD[num1_len]
	push num1
	push rev_num1
	call rev_string						;rev_num1 là xâu chứa số num1 đảo ngược 
;--------------------
	
	push QWORD[num2_len]
	push num2
	push rev_num2
	call rev_string						;rev_num2 là xâu chứa số num1 đảo ngược 
;--------------------
	

;--------------------	
	
	mov rax, QWORD[num1_len]
	cmp rax, QWORD[num2_len]
	jle .L0
	
	push sum
	push rev_num2
	push rev_num1
	call addNum1_2			;cộng nếu số ký tự số thứ nhất lớn hơn số thứ 2
		
	
	push sum 			
	call getlen
	mov QWORD[sum_len], rax	
	
	push QWORD[sum_len]
	push sum
	push rev_sum
	call rev_string
	

;--------------------	
	mov rax, 1
	mov rdi, 1
	mov rsi, rev_sum			;chuỗi chứa tổng 2 số 
	mov rdx, 100
	syscall	
;--------------------

	mov rax, 60
	mov rdi, 0
	syscall
	
	
.L0:
	push sum
	push rev_num1
	push rev_num2
	call addNum2_1		;cộng nếu số ký tự số thứ 2 lớn hơn số thứ nhất
	
	push sum 			
	call getlen
	mov QWORD[sum_len], rax	
	
	push QWORD[sum_len]
	push sum
	push rev_sum
	call rev_string
	
;--------------------	
	mov rax, 1
	mov rdi, 1
	mov rsi, rev_sum			;chuỗi chứa tổng 2 số 
	mov rdx, 100
	syscall	
;--------------------
	
	mov rax, 60
	mov rdi, 0
	syscall





checkNum:
	push rbp
	mov rbp, rsp 
	
	mov rbx, [rbp + 0x10]
	push QWORD [rbp + 0x10]
	call getlen
	cmp rax, 21
	
	ja invalid
	
	
.L0:
	mov dl, BYTE[rbx]
	cmp dl, 0x30
	jl invalid
	cmp dl, 0x39
	ja invalid
	
	
	add rbx, 1
	cmp BYTE[rbx], 0xA
	jz .L1
	jmp .L0
.L1:
	mov rsp, rbp
	pop rbp
	ret 8
;_________________________________________________________end checkNum



addNum1_2:							
	push rbp
	mov rbp, rsp
	sub rsp, 0x10
	
	mov r15, QWORD[rbp + 0x10]		;num1
	mov r14, QWORD[rbp + 0x18]		;num2
	mov r13, QWORD[rbp + 0x20]		;sum
	
	mov r12b, 0			;store carry number 
.L0:	
	mov cl, BYTE[r15]	
	cmp cl, 0 			;if dl == 0 => endofline => al = 0
	jz .L1
	sub cl, 0x30		;mov 1 digit num2 to al 
	 
	
	mov bl, BYTE[r14]	;mov 1 digit num1 to bl
	cmp bl, 0 			;if bl == 0 => endofline => bl = 0
	jz .L1			
	sub bl, 0x30		
.L1:
	add cl, bl	
	add cl, r12b
	cmp cl, 9
	ja .L2
	jle .L3

.L2:
	mov al, cl
	mov edx, 0
	mov ebx, 10
	div ebx 			;eax lưu số nhớ và edx lưu số cần cộng => cộng edx nhớ ebx
	mov r12b, al	
	
	add dl, 0x30 
	mov BYTE [r13], dl
	jmp .L4
	
.L3:
	add cl, 0x30
	mov BYTE [r13], cl
	mov r12b, 0
	
.L4:
	add r13, 1
	add r14, 1
	add r15, 1
	
	cmp BYTE[r15] ,0
	jnz .L0
	
	cmp r12b, 0
	jnz .L5
	jz .L6
	

.L5:
	add r12b, 0x30
	mov BYTE [r13], r12b 
	add r13, 1

.L6:	
	mov BYTE[r13], 0xA
	
	mov rsp, rbp
	pop rbp
	ret 24
;_________________________________________________________end addNum1_2




addNum2_1:							
	push rbp
	mov rbp, rsp
	sub rsp, 0x10
	
	mov r15, QWORD[rbp + 0x10]		;num2
	mov r14, QWORD[rbp + 0x18]		;num1
	mov r13, QWORD[rbp + 0x20]		;sum
	
	mov r12b, 0			;store carry number 
.L0:	
	mov cl, BYTE[r15]	
	cmp cl, 0 			;if dl == 0 => endofline => al = 0
	jz .L1
	sub cl, 0x30		;mov 1 digit num1 to al 
	 
	
	mov bl, BYTE[r14]	;mov 1 digit num2 to bl
	cmp bl, 0 			;if bl == 0 => endofline => bl = 0
	jz .L1			
	sub bl, 0x30		
.L1:
	add cl, bl	
	add cl, r12b
	cmp cl, 9
	ja .L2
	jle .L3

.L2:
	mov al, cl
	mov edx, 0
	mov ebx, 10
	div ebx 			;eax lưu số nhớ và edx lưu số cần cộng => cộng edx nhớ ebx
	mov r12b, al	
	
	add dl, 0x30 
	mov BYTE [r13], dl
	jmp .L4
	
.L3:
	add cl, 0x30
	mov BYTE [r13], cl
	mov r12b, 0
	
.L4:
	add r13, 1
	add r14, 1
	add r15, 1
	
	cmp BYTE[r15] ,0
	jnz .L0
	
	cmp r12b, 0
	jnz .L5
	jz .L6
	

.L5:
	add r12b, 0x30
	mov BYTE [r13], r12b 
	add r13, 1

.L6:	
	mov BYTE[r13], 0xA
	
	mov rsp, rbp
	pop rbp
	ret 24
;_________________________________________________________end addNum2_1


getlen:
	push rbp 
	mov rbp, rsp
 
	mov r15, 0	
	mov r14, [rbp + 0x10]		;string to get len
	
.L1:
	mov dl, BYTE[r14]
	cmp dl, 0xA
	jz .L2
	add r14, 1		; next char of string
	add r15, 1		; number char of string 
	jmp .L1
	
.L2:
	mov rax, r15	;len(string) store in eax 
	mov rsp, rbp
	pop rbp
	ret 
;_________________________________________________________end getlen




rev_string:
	push rbp 
	mov rbp, rsp
	
	xor rcx, rcx
	mov rcx, QWORD[rbp + 0x20]			;length	
	mov r15, QWORD[rbp + 0x18]			;num string to be rev
	mov r14, QWORD[rbp +0x10]			;num string aftter rev
	

.L1: 									;reverse string to right order
	mov dl, BYTE[r15 + rcx - 1]
	mov BYTE[r14], dl
	add r14, 1
	sub rcx, 1
	cmp rcx, 0
	
	jnz .L1
	xor r15, r15
	xor rcx, rcx 
	mov rsp, rbp 
	pop rbp
	ret 24
;_________________________________________________________end rev_string
	

	
	
ion1_proc:
	
	mov rax, 1
	mov rdi, 1
	mov rsi, inpn1
	mov rdx, 12
	syscall		;print 'input num1: ' to screen

	mov rax, 0
	mov rdi, 0
	mov rsi, num1
	mov rdx, 100
	syscall		;input num1

	mov rax, 1
	mov rdi, 1
	mov rsi, outpn1
	mov rdx, 9 	;print 'num1 is: ' to screen
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, num1
	mov rdx, 100
	syscall		;print num1
	ret
;_________________________________________________________end ion1_proc

	
ion2_proc:
	mov rax, 1
	mov rdi, 1
	mov rsi, inpn2
	mov rdx, 12
	syscall		;print 'input num2: ' to screen

	mov rax, 0
	mov rdi, 0
	mov rsi, num2
	mov rdx, 100
	syscall		;input num2

	mov rax, 1
	mov rdi, 1
	mov rsi, outpn2
	mov rdx, 9
	syscall		;print 'num2 is: ' to screen

	mov rax, 1
	mov rdi, 1
	mov rsi, num2	
	mov rdx, 100
	syscall		;print num1

	ret
;_________________________________________________________end ion2_proc

	
invalid:
	mov rax, 1
	mov rdi, 1
	mov rsi, inval
	mov rdx, 10
	syscall		;print invalid!!  

	mov rax, 60
	mov rdi, 0
	syscall
;_________________________________________________________end invalid














