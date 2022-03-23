option casemap:none
include C:\masm32\include64\win64.inc
include C:\masm32\include64\kernel32.inc
includelib C:\masm32\lib64\kernel32.lib
include C:\masm32\include64\user32.inc
includelib C:\masm32\lib64\user32.lib


.data 
	menu db "chon phep tinh" , 10, 0
	cong db "1. phep cong ", 10, 0
	tru db "2. phep tru ", 10, 0
	nhan db "3. phep nhan ", 10, 0
	chia db "4. phep chia ", 10, 0
	pnum1 db "nhap so 1 = ", 0
	pnum2 db "nhap so 2 = ", 0
	inval db "invalid!!!", 10, 0
	over db "overflow!!!", 10,0
	neg_char db "-",0
	endline db " ",10, 0
	
	maxChar equ 256
.data?
	select QWORD 1 dup(?)
	num1 QWORD 2 dup(?)
	num2 QWORD 2 dup(?)
	res QWORD 4	dup (?)
	
	
.code
 

main proc 
	call printMenu
	call checkSelect
;----------------------------hien thi menu 
	
	call inpN1_N2
;----------------------------nhap 2 so thu nhat va thu 2 	
	lea rdi, [select]
	push rdi
	lea rdi, [res]
	push rdi 
	call calc
;----------------------------thuc hien tinh toan
	
	lea rdi, [endline]
	push rdi 
	call WriteString

	
	mov rcx, 0
	call ExitProcess 

main endp
;-------------------------------------------------

printMenu proc
	lea rdi, [menu]
	push rdi
	call WriteString
	
	lea rdi, [cong]
	push rdi
	call WriteString
	
	lea rdi, [tru]
	push rdi
	call WriteString
	
	lea rdi, [nhan]
	push rdi
	call WriteString
	
	lea rdi, [chia]
	push rdi
	call WriteString
	ret
printMenu endp 
;--------------------------------------------------hien thi menu 
	
	
	
checkSelect proc
	push rbp 
	mov rbp, rsp 
	push r15
	
	lea rdi, [select]
	push rdi 
	call ReadString
	
	mov r15, QWORD ptr[select] 
	cmp r15, 31h
	jz L0
	cmp r15, 32h 
	jz L0
	cmp r15, 33h 
	jz L0 
	cmp r15, 34h 
	jz L0 
	jmp L1 

	
L0:	
	pop r15
	mov rbp, rsp
	pop rbp 
	ret 
L1:
	lea rdi, [inval]
	push rdi
	call WriteString
	
	mov rcx, 0
	call ExitProcess
checkSelect endp
;-------------------------------------------------kiem tra nhap vao la 1, 2, 3, 4


inpN1_N2 proc
	
	push rbx 
	push rax 
	
	lea rdi, [pnum1]
	push rdi
	call WriteString
	
	lea rdi, [num1]
	push rdi
	call ReadString
	
	lea rdi, [num1]
	push rdi
	call checkNum
	
	
	lea rdi, [num1]
	push rdi 
	call atoi

;-----------------------------
	mov rbx, rax 	
	shr rbx, 32 	
	cmp rbx, 0					;check overflow 32 bit 
	ja L0
;-----------------------------
	lea rdi, [pnum2]
	push rdi
	call WriteString
	
	lea rdi, [num2]
	push rdi
	call ReadString
	
	lea rdi, [num2]
	push rdi
	call checkNum
	
	
	lea rdi, [num2]
	push rdi 
	call atoi

;-----------------------------
	mov rbx, rax 	
	shr rbx, 32 	
	cmp rbx, 0					;check overflow 32 bit 
	ja L0
;-----------------------------
	

	
	pop rax 
	pop rbx 
	ret
	
L0:
	lea rdi, [over]
	push rdi
	call WriteString
	
	mov rcx, 0
	call ExitProcess
inpN1_N2 endp
;-------------------------------------------------nhap num1 va num 2


calc proc 
	push rbp 
	mov rbp, rsp 
	
	lea rdi, [num2]
	push rdi
	call atoi
	mov rdx, rax 				;num2 = rdx
	
	
	lea rdi, [num1]
	push rdi
	call atoi						;num1 = rax 
	

	
	mov r13, QWORD ptr[rbp + 24]
	cmp QWORD ptr[r13], 31h
	jz L0
	cmp QWORD ptr[r13], 32h 
	jz L1
	cmp QWORD ptr[r13], 33h 
	jz L2 
	cmp QWORD ptr[r13], 34h 
	jz L3 
	
	
L0:
;----------------------------
	add rax, rdx
	mov r15, rax 
	
	shr r15, 24 
	cmp r15, 127 
	jle L01						;kiem tra 4 byte dau tien lon hon 127 thi la so am 
	neg eax
	lea rdi, [neg_char]
	push rdi
	call WriteString
L01: 

	push rax  
	call PrintNumber
	jmp L4
	
;----------------------------phép c?ng
	
;----------------------------
L1: 			
;1 -1     = 0
;1 - - 1  = 2
;-1 - 1   = -2 
; -1 - -1 = 0
	sub eax, edx
	mov r15, rax 
	shr r15, 24
	cmp r15, 127 
	jle L11 				;kiem tra 4 byte dau tien lon hon 127 thi la so am 
	neg eax 
	lea rdi, [neg_char]
	push rdi
	call WriteString
L11:	
	push rax 
	call PrintNumber
	jmp L4
	
;----------------------------phép tr?	

;----------------------------
L2:
	mov rbx, rdx 
	cqo
	imul rbx 
	push rax 
	call PrintNumber
	jmp L4
;----------------------------phép nhân

;----------------------------
L3:
	mov rbx, rdx 
	cqo
	idiv rbx
	push rax 
	call PrintNumber
	jmp L4
;----------------------------phép chia 

L4:
	mov rsp, rbp
	pop rbp 
	ret
	
L5:
	lea rdi, [over]
	push rdi
	call WriteString
	
	mov rcx, 0 
	call ExitProcess
calc endp 
;-------------------------------------------------thuc hien tinh toan 



getlen proc 
	push rbp 
	mov rbp, rsp 
		
	push r15
	push rdx
	push rcx
	
	mov r15, QWORD ptr[rbp + 16]
	xor rcx, rcx
	
L0:
	mov dl, BYTE ptr[r15]
	cmp dl, 0
	jz L1
	add r15, 1
	add rcx, 1
	
	jmp L0
	
L1:
	mov rax, rcx 
	
	pop rcx
	pop rdx 
	pop r15
	mov rsp, rbp 
	pop rbp 
	ret 8
getlen endp
;-------------------------------------------------lay do dai cua chuoi dua vao rax 
		


checkNum proc
	push rbp
	mov rbp, rsp 

	push r15 

	mov r15, QWORD ptr[rbp + 16]
	push r15 
	call getlen
L0:	
	mov dl, BYTE ptr[r15]
	cmp rax, 0 
	jz L2
	cmp dl, 0
	jz L1 
	cmp dl, 2dh
	jz L01  
	cmp dl, 30h 
	jl L2
	cmp dl, 39h
	ja L2

L01:
	add r15, 1
	jmp L0
	
L1:
	pop r15
	mov rsp, rbp 
	pop rbp 
	ret 8

L2:
	lea rdi, [inval]
	push rdi 
	call WriteString
	
	mov rcx, 0
	call ExitProcess
checkNum endp 
;-------------------------------------------------kiem tra so nhap vao co hop le khong?
	
atoi proc 
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
	mov r15, QWORD ptr[rbp + 16]
	mov QWORD ptr[rbp - 8], 10

L0:
	mov bl, BYTE ptr[r15]
	cmp bl , 0
	jz L02
;-------------------------
	cmp bl, 2dh  									;check ký t? d?u -
	jz L01
;-------------------------
	sub rbx, 30h 
	imul QWORD ptr[rbp - 8]					;rax = rax * 10
	
	
	add rax, rbx 									;((rax * 10) + rbx) * 10 + rbx...............
	mov r14, rax
	shr r14, 32 
	cmp r14, 0
	ja L2
	
	add r15, 1
	jmp L0
	
;-------------------------
L01:
	add rcx,1 							;check ký t? d?u - 
	add r15, 1		
	jmp L0
;-------------------------	

L02:
	cmp rcx, 1
	jnz L1 
	neg eax
	
L1:	
	pop rcx 
	pop rbx
	pop rdx 
	pop r15 
	mov rsp, rbp
	pop rbp 
	ret 8

L2:
	lea rdi, [over]
	push rdi
	call WriteString
	
	mov rcx, 0
	call ExitProcess
atoi endp 
	
;-------------------------------------------------chuyen chuoi thanh so tuong ung

	
PrintNumber proc 
	push rbp
	mov rbp, rsp 
	sub rsp, 64
	
	push r15
	push r14
	push rdx 
	push rcx 
	push rbx
	push rax
	
	mov r15, QWORD ptr[rbp + 16]			;number
	mov QWORD ptr[rbp - 8], 10				
	lea r14, [rbp - 64]								;store string of number 
	mov rcx, 0
	
	
	mov rax, r15
L0:
	mov rdx, 0
	div QWORD ptr[rbp - 8]
	add rdx, 30h
	mov BYTE ptr[r14], dl  
	add r14, 1
	add rcx, 1
	cmp rax, 0
	jnz L0
	

	lea r15, [rbp - 32]
	lea r14, [rbp - 64]
	mov rdx, 0
L1:
	mov bl, BYTE ptr[r14 + rcx -1]
	mov BYTE ptr[r15], bl
	add r15, 1
	add rdx, 1											;string_len
	sub rcx, 1
	cmp rcx, 0
	jnz L1
	
		
	lea rdi, [rbp - 32]
	push rdi 
	call WriteString
	
	
	pop rax 
	pop rbx
	pop rcx
	pop rdx 
	pop r14
	pop r15
	mov rsp, rbp 
	pop rbp 
	ret 8
PrintNumber endp
;-------------------------------------------------end PrintNumber



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

	
	mov rcx, rax											;hConsoleOutput
	mov rdx, QWORD ptr[rbp + 10h]				;*lpBuffer
	mov r8, r15												;nNumberOfCharsToWrite
	lea r9, [rbp - 8]										;lpNumberOfCharsWritten
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
;----------------------------------------------------------ghi chuoi tu buffer ra man hinh 


;----------------------------------------------------------
ReadString proc
	push rbp 
	mov rbp, rsp 
	sub rsp, 28h
	
	push rdx
	push rcx
	push rax
	push r8
	push r9
	
	
	mov rcx, -10 
	call GetStdHandle
		
	mov rcx, rax 												;hConsoleInput
	mov rdx, QWORD ptr[rbp + 10h]					;*lpBuffer
	mov r8, maxChar											;nNumberOfCharsToRead
	lea r9, [rbp - 8]											;lpNumberOfCharsRead
	call ReadConsole
	
L0:
	mov dl, BYTE ptr[rdi]
	cmp dl, 13	
	jz L1
	add rdi, 1
	jmp L0

L1:
	mov BYTE ptr[rdi], 0									;remove 13 at end of string
	add rdi, 1
	mov BYTE ptr[rdi], 0
	
	pop r9
	pop r8
	pop rax
	pop rcx
	pop rdx
	
	mov rsp, rbp 
	pop rbp
	ret 8
	
ReadString endp
;----------------------------------------------------------doc chuoi vao buffer, loai bo ky tu \r o cuoi chuoi
end
	
	
	


	