global _start

section .data
	inpS db "input S: "
	inpC db "input C: "
	outpS db "S is: "
	outpC db "C is: "
	endline db "", 10

section .bss
	s resb 100
	c resb 10
	
	s_len resb 100
	c_len resb 10
	count resb 4
	pos_arr  resb 100
	pos resb 4
	
	

section .text

_start:
	
	call ioS_proc
	call ioC_proc 
	
	push c
	call getlen
	mov DWORD[c_len] , eax		;độ dài của xâu c
;-----------------------------------------
	
	push s
	call getlen
	mov DWORD[s_len] , eax		;độ dài của xâu s
;-----------------------------------------

	call compare
	push count			
	call printNumber			;in số lần xuất hiện của xâu c trong xâu s 

;____________________	
	mov rax, 1
	mov rdi, 1
	mov rsi, endline
	mov rdx, 1
	syscall		;in ký tự xuống dòng
;____________________	
;__________________________________________________________	



;=------------------------
	lea r10, [pos_arr]	
.L0:

	mov dl, BYTE[r10]		;lấy ra từ mảng pos_arr từng byte là vị trí xuất hiện của xâu c trong xâu s
	mov BYTE[pos], dl
	
	push pos 				
	call printNumber

	
	add r10, 1
	cmp BYTE[r10], 0
;=------------------------
	jnz .L0
	
	
	mov rax, 60
	mov rdi, 0
	syscall

;_________________________________________________________


printNumber:
	push rbp 
	mov rbp, rsp
	sub rsp, 0x18
	
	mov ebx, DWORD[rbp + 0x10]		;number to be print
	mov eax, DWORD[ebx]
	
	lea r13, [rbp - 0x18]					;base  
	lea r15, [rbp - 0x10]           			;numbber store in string
	lea r14, [rbp - 0x8]						;numbber store in string in the right order
	
	
.L0:												;convert number to string
	mov edx, 0	
	mov ebx, 10    
	div ebx 
	add edx, 0x30
	mov DWORD[r15], edx
	add QWORD[r13], 1
	add r15, 1
	cmp rax, 0
	jnz .L0



	mov rcx, QWORD[r13]				; base to reverse
	lea r15, [rbp - 0x10] 		
	
.L1: 											; reverse string to right order
	mov dl, BYTE[r15 + rcx - 1]
	mov BYTE[r14], dl
	add r14, 1
	mov BYTE[r14], 0x20
	sub rcx, 1
	cmp rcx, 0
	
	jnz .L1
		
	;mov BYTE[rbp - 0x8], 0xA
;------------------
	mov rax, 1
	mov rdi, 1
	lea rsi, [rbp - 0x8]
	mov rdx, 4
	syscall
;------------------
	xor r13, r13
	xor r14, r14
	xor r15, r15
	mov rsp, rbp 
	pop rbp
	ret 
;_________________________________________________________




getlen:
	push rbp 
	mov rbp, rsp
	sub rsp, 0x8

	 
	mov r15d, DWORD[rbp - 0x8]	; store string_len	

	mov r14, [rbp + 0x10]				;string to get len
	
	
.L1:
	mov dl, BYTE[r14]
	cmp dl, 0xA
	jz .L2
	add r14, 1								; next char of string
	add r15d, 1							; number char of string 
	jmp .L1
	
.L2:
	mov eax, r15d
	mov rsp, rbp
	pop rbp
	ret 
	
;---------------------------------------------------------------------------------------------

compare:
	xor rax, rax
	xor rdx, rdx
	xor rcx, rcx		;rcx lưu trữ index của s
	
	lea r11, [pos_arr]
	lea r15, [s]
	mov r13, QWORD[s_len]
	
.L0:
	lea r14, [c]
	mov r12, QWORD[c_len]
	
	
.L1:	
	mov dl, BYTE[r15]
	cmp dl, BYTE[r14]	;so sánh 2 ký tự của c và s
	
	jz .L3				;nếu 2 ký tự đang xét bằng nhau thì jump đến .L3	
	jnz .L2				;nếu 2 ký tự đang xét không bằng nhau thì jump đến .L2

.L2:
	cmp rcx, QWORD[s_len]
	jz .L5
	
	add r15, 1			;.L2 cộng chuỗi s lên 1 để xét ký tự tiếp
	;sub r13, 1
	add rcx, 1
	
	jmp .L0
	
.L3:
	add r15, 1			;xét tiếp 1 ký tự tiếp theo khi ký tự trước giống nhau
	add r14, 1			;-----------------------------------------------------
	
	add rcx, 1
	;sub r13, 1			;sau mỗi ký tự xét thì trừ length đi 1
	sub r12, 1				
	
	cmp r12, 0			;nếu len(c) = 0 thì c có trong s, nhảy đến .L4 để cộng số lần xuất hiện lên 1
	jz .L4
	jnz .L1
	
	cmp rcx, QWORD[s_len]
	jz .L5			



.L4:
	add eax, 1
	
	mov rbx, rcx			;rbx -  len(c) ==> s[index] if s[index] == c 
	sub rbx, QWORD[c_len]	;lưu các index vào offset pos_arr qua r11 
	mov QWORD[r11], rbx
	
	add r11, 1
					
	jmp .L0				;quay lại .L0 để xét lại chuỗi c
	
.L5:
	mov DWORD[count], eax
	ret
;---------------------------------------------------------------------------------------------
	

;cong hoa xa hoi chu nghia 
;ho
	
	
ioS_proc:
	
	mov rax, 1
	mov rdi, 1
	mov rsi, inpS
	mov rdx, 9
	syscall		;print 'input S: ' to screen

	mov rax, 0
	mov rdi, 0
	mov rsi, s
	mov rdx, 100
	syscall		;input S

	mov rax, 1
	mov rdi, 1
	mov rsi, outpS
	mov rdx, 6 	;print 'S is: ' to screen
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, s
	mov rdx, 100
	syscall		;print S 

	ret

ioC_proc:
	mov rax, 1
	mov rdi, 1
	mov rsi, inpC
	mov rdx, 9
	syscall		;print 'input C: ' to screen

	mov rax, 0
	mov rdi, 0
	mov rsi, c
	mov rdx, 10
	syscall		;input C

	mov rax, 1
	mov rdi, 1
	mov rsi, outpC
	mov rdx, 6
	syscall		;print 'C is: ' to screen

	mov rax, 1
	mov rdi, 1
	mov rsi, c 	;print C
	mov rdx, 10
	syscall

	ret














