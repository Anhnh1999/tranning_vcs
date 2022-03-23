option casemap:none
include C:\masm32\include64\win64.inc
include C:\masm32\include64\kernel32.inc
includelib C:\masm32\lib64\kernel32.lib
include C:\masm32\include64\user32.inc
includelib C:\masm32\lib64\user32.lib

.data
	inpn1 db "input num1: ", 0
	inpn2 db "input num2: ", 0
	outpn1 db "num1 is: ", 0
	outpn2 db "num2 is: ", 0
	inval db "invalid!!", 0
	endline db " ", 10

.data?
	num1 db 100 dup(?)
	num2 db 100 dup(?)
	sum db 100 dup(?)
	
	num1_len db 100 dup(?)
	num2_len db 100 dup(?)
	sum_len  db 100 dup(?)
	rev_num1 db 100 dup(?)
	rev_num2 db 100 dup(?)
	rev_sum db 100 dup(?)


.code

	
main proc
	call ion1_proc
	call ion2_proc 
	
	lea rdi, [num1]
	push rdi
	call checkNum
	
	lea rdi, [num2]
	push rdi
	call checkNum
	
;--------------------	
	lea rcx, QWORD ptr[num1]
	call lstrlen
	sub rax, 2		;trừ đi 2 byte ký tự \r \n
	mov QWORD ptr[num1_len], rax 


	lea rcx, QWORD ptr[num2]
	call lstrlen
	sub rax, 2 		;trừ đi 2 byte ký tự \r \n
	mov QWORD ptr[num2_len], rax 
;--------------------
	
	
	
;--------------------	
	push QWORD ptr[num1_len]
	lea rdi, [num1]
	push rdi						;push num1
	lea rdi, [rev_num1]
	push rdi						;push rev_num1
	call rev_string
	
	push QWORD ptr[num2_len]
	lea rdi, [num2]
	push rdi						;push num2
	lea rdi, [rev_num2]
	push rdi						;push rev_num2
	call rev_string
	
	

;--------------------	
	
	mov rax, QWORD ptr[num1_len]
	cmp rax, QWORD ptr[num2_len]
	jle L0
	
	lea rdi, [sum]
	push rdi						;push sum
	lea rdi, [rev_num2]
	push rdi						;push rev_num2
	lea rdi, [rev_num1]
	push rdi						;push rev_num1
	call addNum1_2			;cộng nếu số ký tự số thứ nhất lớn hơn số thứ 2
		
	
	lea rcx, QWORD ptr[sum]
	call lstrlen
	sub rax, 1 		;trừ đi 1 byte ký tự \n
	mov QWORD ptr[sum_len], rax
	
	push QWORD ptr[sum_len]
	lea rdi, [sum]
	push rdi			;push sum
	lea rdi, [rev_sum]
	push rdi			;push rev_sum
	call rev_string
	
	
	lea rdi, [rev_sum]
	push rdi 
	call WriteString
	
	xor rcx, rcx 
	call ExitProcess
	
	
L0:
	lea rdi, [sum]
	push rdi 		;push sum
	lea rdi, [rev_num1]
	push rdi 		;push rev_num1
	lea rdi, [rev_num2]
	push rdi 		;push rev_num2
	call addNum2_1		;cộng nếu số ký tự số thứ 2 lớn hơn số thứ nhất
	
	
	lea rcx, QWORD ptr[sum]
	call lstrlen
	sub rax, 1 		;trừ đi 1 byte ký tự \n
	mov QWORD ptr[sum_len], rax	
	
	
	
	push QWORD ptr[sum_len]
	lea rdi, [sum]
	push rdi		;push sum
	lea rdi, [rev_sum]
	push rdi		;push rev_sum
	call rev_string
	
	lea rdi, [rev_sum]
	push rdi
	call WriteString
	
	xor rcx, rcx 
	call ExitProcess

main endp

;_________________________________________________________

checkNum proc
	push rbp
	mov rbp, rsp 
	
	mov r15, [rbp + 10h]
	mov rcx, [rbp + 10h]
	call lstrlen
	cmp rax, 22		
	ja invalid			;nếu số có 20 ký tự + 2 ký tự \r \n là 22 thì số không hợp lệ 
	
L0:
	mov dl, BYTE ptr[r15]
	cmp dl, 30h
	jl invalid
	cmp dl, 39h
	ja invalid
	
	
	add r15, 1
	cmp BYTE ptr[r15], 13 	;kiểm tra đến ký tự \r
	jz L1
	jmp L0
L1:
	mov rsp, rbp
	pop rbp
	ret 8
checkNum endp
;_________________________________________________________

;_________________________________________________________
addNum1_2 proc							
	push rbp
	mov rbp, rsp
	sub rsp, 10h
	
	mov r15, QWORD ptr[rbp + 10h]		;num1
	mov r14, QWORD ptr[rbp + 18h]		;num2
	mov r13, QWORD ptr[rbp + 20h]		;sum
	
	mov r12b, 0			;store carry number 
L0:	
	mov cl, BYTE ptr[r15]	
	cmp cl, 0 			;if dl == 0 => endofline => al = 0
	jz L1
	sub cl, 30h		;mov 1 digit num2 to al 
	 
	
	mov bl, BYTE ptr[r14]	;mov 1 digit num1 to bl
	cmp bl, 0 			;if bl == 0 => endofline => bl = 0
	jz L1			
	sub bl, 30h		
L1:
	add cl, bl	
	add cl, r12b
	cmp cl, 9
	ja L2
	jle L3

L2:
	mov al, cl
	mov edx, 0
	mov ebx, 10
	div ebx 			;eax lưu số nhớ và edx lưu số cần cộng => cộng edx nhớ ebx
	mov r12b, al	
	
	add dl, 30h 
	mov BYTE ptr[r13], dl
	jmp L4
	
L3:
	add cl, 30h
	mov BYTE ptr[r13], cl
	mov r12b, 0
	
L4:
	add r13, 1
	add r14, 1
	add r15, 1
	
	cmp BYTE ptr[r15] ,0
	jnz L0
	
	cmp r12b, 0
	jnz L5
	jz L6
	

L5:
	add r12b, 30h
	mov BYTE ptr[r13], r12b 
	add r13, 1

L6:	
	mov BYTE ptr[r13], 10
	
	mov rsp, rbp
	pop rbp
	ret 24
addNum1_2 endp
;_________________________________________________________


;_________________________________________________________
addNum2_1 proc							
	push rbp
	mov rbp, rsp
	sub rsp, 10h
	
	mov r15, QWORD ptr[rbp + 10h]		;num2
	mov r14, QWORD ptr[rbp + 18h]		;num1
	mov r13, QWORD ptr[rbp + 20h]		;sum
	
	mov r12b, 0			;store carry number 
L0:	
	mov cl, BYTE ptr[r15]	
	cmp cl, 0 			;if dl == 0 => endofline => al = 0
	jz L1
	sub cl, 30h		;mov 1 digit num1 to al 
	 
	
	mov bl, BYTE ptr[r14]	;mov 1 digit num2 to bl
	cmp bl, 0 			;if bl == 0 => endofline => bl = 0
	jz L1			
	sub bl, 30h		
L1:
	add cl, bl	
	add cl, r12b
	cmp cl, 9
	ja L2
	jle L3

L2:
	mov al, cl
	mov edx, 0
	mov ebx, 10
	div ebx 			;eax lưu số nhớ và edx lưu số cần cộng => cộng edx nhớ ebx
	mov r12b, al	
	
	add dl, 30h 
	mov BYTE ptr[r13], dl
	jmp L4
	
L3:
	add cl, 30h
	mov BYTE ptr[r13], cl
	mov r12b, 0
	
L4:
	add r13, 1
	add r14, 1
	add r15, 1
	
	cmp BYTE ptr[r15] ,0
	jnz L0
	
	cmp r12b, 0
	jnz L5
	jz L6
	

L5:
	add r12b, 30h
	mov BYTE ptr[r13], r12b 
	add r13, 1

L6:	
	mov BYTE ptr[r13], 10
	
	mov rsp, rbp
	pop rbp
	ret 24
addNum2_1 endp
;_________________________________________________________



;_________________________________________________________
rev_string proc
	push rbp 
	mov rbp, rsp
	
	xor rcx, rcx
	mov rcx, QWORD ptr[rbp + 20h]			;length	
	mov r15, QWORD ptr[rbp + 18h]			;num string to be rev
	mov r14, QWORD ptr[rbp + 10h]			;num string aftter rev
	

L1: 									;reverse string to right order
	mov dl, BYTE ptr[r15 + rcx - 1]
	mov BYTE ptr[r14], dl
	add r14, 1
	sub rcx, 1
	cmp rcx, 0
	
	jnz L1
	xor r15, r15
	xor rcx, rcx 
	mov rsp, rbp 
	pop rbp
	ret 24
rev_string endp
;_________________________________________________________
	

	
	
ion1_proc:
	
	lea rdi, [inpn1]
	push rdi 
	call WriteString	;print 'input num1: ' to screen


	push 100
	lea rdi, offset num1
	push rdi 
	call ReadString		;input num1


	lea rdi, [outpn1]
	push rdi 
	call WriteString	;print 'num1 is: ' to screen

	lea rdi, [num1]
	push rdi 
	call WriteString	;print num1
	
	ret

ion2_proc:

	lea rdi, [inpn2]
	push rdi 
	call WriteString	;print 'input num2: ' to screen

	push 100
	lea rdi, offset num2
	push rdi 
	call ReadString		;input num2


	lea rdi, [outpn2]
	push rdi 
	call WriteString	;print 'num2 is: ' to screen

	lea rdi, [num2]
	push rdi 
	call WriteString	;print num2

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
invalid proc	
	lea rdi, [inval]
	push rdi 
	call WriteString	;print 'invalid!!!'

	xor rcx, rcx 
	call ExitProcess
invalid endp

end











