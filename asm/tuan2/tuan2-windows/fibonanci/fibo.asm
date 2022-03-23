option casemap:none
include C:\masm32\include64\win64.inc
include C:\masm32\include64\kernel32.inc
includelib C:\masm32\lib64\kernel32.lib
include C:\masm32\include64\user32.inc
includelib C:\masm32\lib64\user32.lib


.data
	inpN db "input number : ", 0
	outpN db " number is : "	, 0
	inval db "invalid!!",   0
	space db " ", 0
	endline db " " ,10


.data?
	n db 2 dup(?)
	
.code

main proc	

	call ioS_proc		;input n 
;-------------------------------
	
	lea rdi, offset endline
	push rdi 
	call WriteString	;print \n
;-------------------------------

	push QWORD ptr[n]
	call checkNum		;check is a number 
;-------------------------------	

	push QWORD ptr[n]
	call atoi				;convert string n to number n 
;-------------------------------
	
	push rax
	call fibo				;print fibonanci 
;-------------------------------
	
	xor ecx, ecx 
	call ExitProcess
main endp

	

checkNum proc
	push rbp
	mov rbp, rsp 
	
	mov rcx, 0
	lea r15, [rbp + 10h]
	
L0:
	add rcx, 1
	mov dl, BYTE ptr[r15]
	cmp dl, 13 			;nếu có 1 ký tự thì kết thúc bằng 0xD thì kết thúc check
	je L1
	cmp dl, 30h
	jl invalid
	cmp dl, 39h
	ja invalid
	
	cmp rcx, 3
	jge invalid
	
	add r15, 1
	cmp BYTE ptr[r15], 0
	jz L1
	jmp L0
L1:
	mov rsp, rbp
	pop rbp
	ret 8
checkNum endp
;------------------------------------end checkNum



atoi proc
	push rsp
	mov rbp, rsp
	sub rsp, 8

	xor eax, eax
	xor ebx, ebx
	xor edx, edx
	lea r15, [rbp + 10h]
	mov QWORD ptr[rbp - 8], 10
	
nextchar:
;chuyển từng ký tự từ char thành int  vd: ;1234 = ((10 + 2)*10 + 3) * 10 + 4
	mov bl, BYTE[r15]
	mov bl, BYTE ptr[r15]

	cmp bl, 13
	jz done
	cmp bl, 0
	jz done
	
	sub rbx, 30h

	mul QWORD ptr[rbp - 8]
	add rax, rbx	
	mov rdx, rax
	add r15, 1
	jmp nextchar

done:
	mov rsp, rbp
	pop rbp
	ret 8
atoi endp
;_____________________________end atoi




fibo proc
	push rbp 
	mov rbp, rsp
	sub rsp, 20h

	xor rbx, rbx 
	lea r15, [rbp + 10h]					;n
	
	mov BYTE ptr[rbp - 18h], 0		;f0	
	mov BYTE ptr[rbp - 10h], 1		;f1
	mov BYTE ptr[rbp - 8h], 1		;fn
	mov bl, 2								;i
	
	
	lea r14, [rbp - 20h]
	lea r13, [rbp - 18h]
	lea r12, [rbp - 10h]
	lea r10, [rbp - 8h]
	

	cmp QWORD ptr[r15], 0			;n < 0 thì thoát
	jle L3	
	cmp QWORD ptr[r15], 1			;n = 1 thì in ra màn hình 0
	jz L4
	cmp QWORD ptr[r15], 2			;n = 2 thì in ra màn hình 0, 1
	jz L01
	
;0, 1, 1, 2, 3, 5, 8, 13, 21, 34				
L01:	
	mov BYTE ptr[r14], 0			
	add BYTE ptr[r14], 30h
	
	
	lea rdi, [r14]
	push rdi
	call WriteString		;in ra màn hình 0
	 
;----------------------
	lea rdi, offset space
	push rdi 
	call WriteString			;in dấu cách	
;----------------------

	mov BYTE ptr[r14], 1			
	add BYTE ptr[r14], 30h
	
	lea rdi, [r14]
	push rdi
	call WriteString		;in ra màn hình 1
	cmp QWORD ptr[r15], 2
	jz L3
	
;----------------------
	lea rdi, offset space
	push rdi 
	call WriteString			;in dấu cách	
;----------------------
	
	mov BYTE ptr[r14], 1			
	add BYTE ptr[r14], 30h
	
	lea rdi, [r14]
	push rdi
	call WriteString		;in ra màn hình 1
	add bl, 1

;----------------------
	lea rdi, offset space
	push rdi 
	call WriteString			;in dấu cách	
;----------------------

	
L0:
	add bl, 1
	cmp bl, BYTE ptr[r15]
	ja L3
	mov r9, QWORD ptr[rbp - 10h]	;f1
	mov QWORD ptr[rbp - 18h], r9	;f0 = f1
	
	mov r8, QWORD ptr[rbp - 8h]	;fn
	mov QWORD ptr[rbp - 10h], r8 	;f1 = fn
		
	add r8, r9				;fn = f1 + f0
	mov QWORD ptr[rbp - 8h], r8
	
	cmp r8, 9h
	ja L2
	
	mov QWORD ptr[r14], r8		;r14b la de in ra man hinh
	add QWORD ptr[r14], 30h
	

	
L1:	
	
	lea rdi, [r14]
	push rdi
	call WriteString

;----------------------
	lea rdi, offset space
	push rdi 
	call WriteString			;in dấu cách	
;----------------------

	cmp BYTE ptr[r14], 1
	jnz L0

	
L4:	
	mov BYTE ptr [r14], 0			
	add BYTE ptr[r14], 30h

	lea rdi, [r14]
	push rdi
	call WriteString		;in ra màn hình 0
	jmp L3

L2:
	push r8
	call splitnum
	jmp L0

L3:
	mov rsp, rbp
	pop rbp
	ret 8
fibo endp
;--------------------------------------------------------end fibo



splitnum proc
	push rbp
	mov rbp, rsp
	sub rsp, 80h
	
	mov rcx, 0						;base
	mov QWORD ptr[rbp - 8h], 10 	;div BYTE[rbp - 0x8] => rax / 10 R rdx
	
	lea rax, [rbp + 10h]			;số có nhiều hơn 1 chữ số 
	mov rax, QWORD ptr[rbp + 10h]
	
	lea r11, [rbp - 40h]			;lưu trữ chuỗi của số có nhiều hơn 1 chữ số
	
	
L0:
	mov rdx, 0
	div QWORD ptr [rbp - 8h]
	add rdx, 30h
	mov DWORD ptr[r11], edx
	add r11, 1
	add rcx, 1
	cmp rax, 0
	jnz L0
	

	lea rax, [rbp - 40h]		;lưu trữ chuỗi của số có 2 chữ số
	lea r11, [rbp - 80h]		;lưu trữ chuỗi đảo ngược của số có 2 chữ số
L1:
	mov dl, BYTE ptr[rax + rcx - 1] 
	mov BYTE ptr[r11], dl
	
	sub rcx, 1
	add r11, 1
	cmp rcx, 0
	jnz L1
	
	mov QWORD ptr[r11], 0		;thêm ký tự null vào cuối chuỗi
;------------------------------	
	
	lea rdi, [rbp - 80h]
	push rdi
	call WriteString		;in số có nhiều hơn 1 chữ số
	
	
	lea rdi, offset space
	push rdi 
	call WriteString	;in dấu cách
;------------------------------
	
	mov rsp, rbp
	pop rbp
	ret	8
splitnum endp
;---------------------------------------------------------end splitnum


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
	;add rax, 1
	mov r15 ,rax 
	
	mov rcx, -11
	call GetStdHandle

	
	mov rcx, rax								;hConsoleOutput
	mov rdx, QWORD ptr[rbp + 10h]				;*lpBuffer
	mov r8, r15									;nNumberOfCharsToWrite
	lea r9, [rbp - 8]							;lpNumberOfCharsWritten
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
		
	mov rcx, rax 									;hConsoleInput
	mov rdx, QWORD ptr[rbp + 10h]					;*lpBuffer
	mov r8, r15										;nNumberOfCharsToRead
	lea r9, [rbp - 8]								;lpNumberOfCharsRead
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
	
	
ioS_proc proc
	
	
	lea rdi, offset inpN
	push rdi 
	call WriteString	;print 'input number: ' to screen
	
	
	push 2
	lea rdi, offset n
	push rdi 
	call ReadString	;input n
	
	
	lea rdi, offset outpN
	push rdi 
	call WriteString	;print 'number is: ' to screen
	
	
	lea rdi, offset n
	push rdi 
	call WriteString	;print number
	

	ret
ioS_proc endp

invalid proc
	mov rdi, offset inval
	push rdi 
	call WriteString ;print invalid!! 
	
	xor ecx, ecx 
	call ExitProcess
invalid endp

end
