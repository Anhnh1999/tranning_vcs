global _start

section .data
	inpN db "input number: ", 10
	outpN db "number is: "	, 10
	inval db "invalid!!",   10
	space db " "

section .bss
	n resb 2
	
section .text

_start:
	

	
	call ioN_proc		;input n 
;-------------------------------
	
	push n
	call checkNum		;check is a number 
;-------------------------------
	
	push QWORD[n]
	call atoi				;convert string n to number n 
;-------------------------------
	
	push rax
	call fibo				;print fibonanci 	
;-------------------------------
	
	mov rax, 60
	mov rdi, 0
	syscall


	

checkNum:
	push rbp
	mov rbp, rsp 
	
	mov rcx, 0
	mov r15, [rbp + 0x10]
	
.L0:
	add rcx, 1
	mov dl, BYTE[r15]
	cmp dl, 0x30
	jl invalid
	cmp dl, 0x39
	ja invalid
	
	cmp rcx, 3
	jge invalid
	
	add r15, 1
	cmp BYTE[r15], 0xA
	jz .L1
	jmp .L0
.L1:
	mov rsp, rbp
	pop rbp
	ret
;--------------------------------end checkNum



atoi:
	push rsp
	mov rbp, rsp
	sub rsp, 0x8

	xor eax, eax
	xor ebx, ebx
	xor edx, edx
	lea r15, [rbp + 0x10]
	mov QWORD[rbp - 0x8], 10
	
nextchar:
;chuyển từng ký tự từ char thành int vd: ;1234 = ((10 + 2)*10 + 3) * 10 + 4
	mov bl, BYTE[r15]

	cmp bl, 0xA
	jz done
	
	sub rbx, 0x30

	mul QWORD[rbp - 0x8]
	add rax, rbx	
	mov rdx, rax
	add r15, 1
	jmp nextchar

done:
	mov rsp, rbp
	pop rbp
	ret
;_____________________________end atoi




fibo:
	push rbp 
	mov rbp, rsp
	sub rsp, 0x20

	xor rbx, rbx 
	lea r15, [rbp + 0x10]			;n
	
	mov BYTE[rbp - 0x18], 0		;f0	
	mov BYTE[rbp - 0x10], 1		;f1
	mov BYTE[rbp - 0x8], 1		;fn
	mov bl, 2					;i
	
	
	lea r14, [rbp - 0x20]
	lea r13, [rbp - 0x18]
	lea r12, [rbp - 0x10]
	lea r10, [rbp - 0x8]
	

	cmp QWORD[r15], 0			;n = 0 thì thoát
	jle .L3	
	cmp QWORD[r15], 1			;n = 1 thì in ra màn hình 0
	jz .L4
	cmp QWORD[r15], 2			;n = 2 thì in ra màn hình 0, 0
	jz .L01
	
;0, 1, 1, 2, 3, 5, 8, 13, 21, 34				

;--------------------------------------------
.L01:	
	mov BYTE[r14], 0			
	add BYTE[r14], 0x30
	mov rax, 1
	mov rdi, 1
	mov rsi, r14
	mov rdx, 2
	syscall						;in ra màn hình 0
	
;----------------------
	mov rax, 1
	mov rdi, 1
	mov rsi, space
	mov rdx, 2
	syscall						;in dấu cách
;----------------------
	mov BYTE[r14], 1			
	add BYTE[r14], 0x30
	mov rax, 1
	mov rdi, 1
	mov rsi, r14
	mov rdx, 2
	syscall						;in ra màn hình 1
	cmp QWORD[r15], 2
	jz .L3
	
;----------------------
	mov rax, 1
	mov rdi, 1
	mov rsi, space
	mov rdx, 2
	syscall						;in dấu cách
;----------------------
	
	mov BYTE[r14], 1			
	add BYTE[r14], 0x30
	mov rax, 1
	mov rdi, 1
	mov rsi, r14
	mov rdx, 2
	syscall						;in ra màn hình 1
	add bl, 1
	cmp QWORD[r15], 3
	jz .L3

;----------------------
	mov rax, 1
	mov rdi, 1
	mov rsi, space
	mov rdx, 2
	syscall						;in dấu cách
;----------------------
;--------------------------------------------		
	
	
.L0:
	add bl, 1
	cmp bl, BYTE[r15]
	ja .L3
	mov r9, QWORD[rbp - 0x10]	;f1
	mov QWORD[rbp - 0x18], r9	;f0 = f1
	
	mov r8, QWORD[rbp - 0x8]	;fn
	mov QWORD[rbp - 0x10], r8 	;f1 = fn
		
	add r8, r9					;fn = f1 + f0
	mov QWORD[rbp - 0x8], r8
	
	cmp r8, 0x9
	ja .L2
	
	mov QWORD[r14], r8		;r14b la de in ra man hinh
	add QWORD[r14], 0x30
	
	
.L1:
	mov rax, 1
	mov rdi, 1
	mov rsi, r14
	mov rdx, 2
	syscall

;----------------------
	mov rax, 1
	mov rdi, 1
	mov rsi, space
	mov rdx, 2
	syscall		;in dấu cách
;----------------------

	
	cmp BYTE[r14], 1
	jnz .L0

	
.L4:	
	mov BYTE[r14], 0			
	add BYTE[r14], 0x30
	mov rax, 1
	mov rdi, 1
	mov rsi, r14
	mov rdx, 2
	syscall			;in ra màn hình 0
	jmp .L3

.L2:
	push r8
	call splitnum
	
	jmp .L0

.L3:
	mov rsp, rbp
	pop rbp
	ret

;---------------------------------------------------------end fibo 



splitnum:
	push rbp
	mov rbp, rsp
	sub rsp, 0x80
	
	mov rcx, 0					;base
	mov DWORD[rbp - 0x8], 10 	;div BYTE[rbp - 0x8] => rax / 10 R rdx
	
	lea rax, [rbp + 0x10]		;số có nhiều hơn 1 chữ số 
	mov eax, DWORD[rbp + 0x10]
	
	lea r11, [rbp - 0x40]		;lưu trữ chuỗi của số có nhiều hơn 1 chữ số
	
	
.L0:
	mov edx, 0
	div DWORD[rbp - 0x8]
	add edx, 0x30
	mov DWORD[r11], edx
	add r11, 1
	add rcx, 1
	cmp eax, 0
	jnz .L0
	

	lea rax, [rbp - 0x40]		;lưu trữ chuỗi của số có 2 chữ số
	lea r11, [rbp - 0x80]		;lưu trữ chuỗi đảo ngược của số có 2 chữ số
.L1:
	mov dl, BYTE[rax + rcx - 1] 
	mov BYTE[r11], dl
	
	sub rcx, 1
	add r11, 1
	cmp rcx, 0
	jnz .L1
	
;------------------------------	
	mov rax, 1
	mov rdi, 1
	lea rsi, [rbp - 0x80]
	mov rdx, 8
	syscall			;in số có nhiều hơn 1 chữ số
	
	mov rax, 1
	mov rdi, 1
	mov rsi, space
	mov rdx, 1
	syscall		;in dấu cách

;------------------------------
	
	mov rsp, rbp
	pop rbp
	ret	8
;---------------------------------------------------------end splitnum 

	
	
	
ioN_proc:
	
	mov rax, 1
	mov rdi, 1
	mov rsi, inpN
	mov rdx, 15
	syscall		;print 'input number: ' to screen

	mov rax, 0
	mov rdi, 0
	mov rsi, n
	mov rdx, 100
	syscall		;input n

	mov rax, 1
	mov rdi, 1
	mov rsi, outpN
	mov rdx, 12 	
	syscall		;print 'number is: ' to screen

	mov rax, 1
	mov rdi, 1
	mov rsi, n
	mov rdx, 100
	syscall		;print number  

	ret
;---------------------------------------------------------end ioN_proc 

	
	
invalid:
	mov rax, 1
	mov rdi, 1
	mov rsi, inval
	mov rdx, 10
	syscall		;print invalid!!  

	mov rax, 60
	mov rdi, 0
	syscall










