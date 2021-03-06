
option casemap:none
include C:\masm32\include64\win64.inc
include C:\masm32\include64\kernel32.inc
includelib C:\masm32\lib64\kernel32.lib
include C:\masm32\include64\user32.inc
includelib C:\masm32\lib64\user32.lib

.data
	inpS db "input S: ", 0
	inpC db "input C: ", 0
	outpS db "S is: ", 0
	outpC db "C is: ", 0
	endline db " ", 10

.data?
	s db 100 dup(?)
	c db 10 dup(?)
	
	s_len db  100 dup(?)
	c_len db 10 dup(?)
	count dq 4 dup(?)
	pos_arr db  100 dup(?)
	pos db 4 dup(?)
	
	

.code

main proc
	
	call ioS_proc
	call ioC_proc 
	
	
	
	;push c
	lea rcx, [c]
	push rcx 
	call getlen
	;call lstrlen
	mov DWORD ptr[c_len] , eax
	
	;push s
	lea rcx, [s]
	push rcx
	call getlen
	;call lstrlen
	mov DWORD ptr[s_len] , eax
	
	
	call compare

	lea rdi, [count]
	push rdi			
	call printNumber

;____________________	
	lea rdi, offset endline
	push rdi 
	call WriteString	;print \n
;____________________	
;__________________________________________________________	


;----------------------------------------------------	
	lea r8, [pos_arr]	
L0:

	mov dl, BYTE ptr[r8]		;lấy ra từ mảng pos_arr từng byte là vị trí xuất hiện của xâu c trong xâu s
	mov BYTE ptr[pos], dl
	
	lea rdi, [pos]
	push rdi
	call printNumber

	add r8, 1
	cmp BYTE ptr[r8], 0
;----------------------------------------------------	

	jnz L0
	
	
	xor rcx, rcx 
	call ExitProcess

;_________________________________________________________
main endp 


printNumber proc
	push rbp 
	mov rbp, rsp
	sub rsp, 18h
	
	mov rbx, QWORD ptr[rbp + 10h]		;number to be print
	mov rax, QWORD ptr[rbx]
	
	lea r13, [rbp - 18h]						;base  
	mov QWORD ptr[r13], 0
	lea r15, [rbp - 10h]          			;numbber store in string
	lea r14, [rbp - 8h]						;numbber store in string in the right order
	
	
L0:												;convert number to string
	mov rdx, 0	
	mov rbx, 10    
	div rbx 
	add rdx, 30h
	mov QWORD ptr[r15], rdx
	add QWORD ptr[r13], 1
	add r15, 1
	cmp rax, 0
	jnz L0



	mov rcx, QWORD ptr[r13]				; base to reverse
	lea r15, [rbp - 10h] 		
	
L1: 								; reverse string to right order
	mov dl, BYTE ptr[r15 + rcx - 1]
	mov BYTE ptr[r14], dl
	add r14, 1
	mov BYTE ptr[r14], 20h
	sub rcx, 1
	cmp rcx, 0
	
	jnz L1
		
	;mov BYTE[rbp - 0x8], 0xA
;------------------	
	lea rdi, [rbp - 8h]
	push rdi 
	call WriteString
;------------------
	xor r13, r13
	xor r14, r14
	xor r15, r15
	mov rsp, rbp 
	pop rbp
	ret 8
;_________________________________________________________
printNumber endp



getlen proc
	push rbp 
	mov rbp, rsp
	sub rsp, 8h

	 
	mov r15d, DWORD ptr[rbp - 8h]	; store string_len	

	mov r14, [rbp + 10h]			;string to get len
	
	
L1:
	mov dl, BYTE ptr[r14]
	cmp dl, 13
	jz L2
	add r14, 1							;next char of string
	add r15d, 1							;number char of string 
	jmp L1
	
L2:
	mov eax, r15d
	mov rsp, rbp
	pop rbp
	ret 8

getlen endp
;---------------------------------------------------------------------------------------------

compare proc 
	xor rax, rax
	xor rdx, rdx
	xor rcx, rcx		;rcx lưu trữ index của s
	
	lea r11, [pos_arr]
	lea r15, [s]
	mov r13, QWORD ptr[s_len]
	
L0:
	lea r14, [c]
	mov r12, QWORD ptr[c_len]
	
	
L1:	
	mov dl, BYTE ptr[r15]
	cmp dl, BYTE ptr[r14]	;so sánh 2 ký tự của c và s
	
	jz L3					;nếu 2 ký tự đang xét bằng nhau thì jump đến .L3	
	jnz L2					;nếu 2 ký tự đang xét không bằng nhau thì jump đến .L2

L2:
	cmp rcx, QWORD ptr[s_len]
	jz L5
	
	add r15, 1			;.L2 cộng chuỗi s lên 1 để xét ký tự tiếp
	;sub r13, 1
	add rcx, 1
	
	jmp L0
	
L3:
	add r15, 1			;xét tiếp 1 ký tự tiếp theo khi ký tự trước giống nhau
	add r14, 1			;-----------------------------------------------------
	
	add rcx, 1
	;sub r13, 1			;sau mỗi ký tự xét thì trừ length đi 1
	sub r12, 1				
	
	cmp r12, 0			;nếu len(c) = 2 thì c có trong s, nhảy đến .L3 để cộng số lần xuất hiện lên 1( = 2 do 2 ký tự \r \n => hết chuỗi)
	jz L4
	jnz L1
	
	cmp rcx, QWORD ptr[s_len]
	jz L5			



L4:
	add eax, 1
	
	mov rbx, rcx				;rbx -  len(c) ==> s[index] if s[index] == c 
	sub rbx, QWORD ptr[c_len]	;lưu các index vào offset pos_arr qua r11 
	mov QWORD ptr[r11], rbx
	
	add r11, 1
					
	jmp L0				;quay lại .L0 để xét lại chuỗi c
	
L5:
	mov DWORD ptr[count], eax
	ret
compare endp
;---------------------------------------------------------------------------------------------
	

;cong hoa xa hoi chu nghia 
;ho
	


;-----------------------------------------	
ioS_proc proc
		
	lea rdi, [inpS]
	push rdi 
	call WriteString	;print 'input S: ' to screen



	push 100
	lea rdi, offset s
	push rdi 
	call ReadString			;input S


	lea rdi, [outpS]
	push rdi 
	call WriteString	;print 'S is: ' to screen
	

	lea rdi, [s]
	push rdi 
	call WriteString	;print S 

	ret
ioS_proc endp
;-----------------------------------------


;-----------------------------------------
ioC_proc proc


	lea rdi, [inpC]
	push rdi 
	call WriteString	;print 'input C: ' to screen



	push 100
	lea rdi, offset c
	push rdi 
	call ReadString			;input C


	lea rdi, [outpC]
	push rdi 
	call WriteString	;print 'C is: ' to screen
	

	lea rdi, [c]
	push rdi 
	call WriteString	;print C 

	ret
ioC_proc endp
;-----------------------------------------

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

	
	mov rcx, rax								;hConsoleOutput
	mov rdx, QWORD ptr[rbp + 10h]		;*lpBuffer
	mov r8, r15								;nNumberOfCharsToWrite
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
		
	mov rcx, rax 								;hConsoleInput
	mov rdx, QWORD ptr[rbp + 10h]		;*lpBuffer
	mov r8, r15								;nNumberOfCharsToRead
	lea r9, [rbp - 8]							;lpNumberOfCharsRead
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












