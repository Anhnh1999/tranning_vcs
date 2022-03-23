option casemap:none
include C:\masm32\include64\win64.inc
include C:\masm32\include64\kernel32.inc
includelib C:\masm32\lib64\kernel32.lib
include C:\masm32\include64\user32.inc
includelib C:\masm32\lib64\user32.lib


.data
	n_out db "input n: ", 0
	arr_index1 db "arr[", 0
	arr_index2 db "] = ", 0
	pmax 	db "max = ", 0
	pmin 	db "min = ", 0
	inval db "invalid!!!", 10, 0
	over db "overflow!!!", 10,0
	endline db " ",10

	maxChar equ 256

.data?
	arr dd 100 dup(?)
	n dd 1 dup(?)
	min dd 1 dup(?)
	max dd 1 dup(?)
	inp dd 1 dup(?)
	
	
.code

main proc	


	call inpN 				;input n 
;-----------------------------

	
	lea rdi, [n]
	push rdi 
	call checkNum			;kiểm tra n có phải số không?
;-----------------------------	



	call inpARR				;nhập từng phần tử vào trong mảng 
;-----------------------------
	

	call findMax			;tìm giá trị lớn nhất để in ra màn hình
;----------------------------	

	lea rdi, [endline]
	push rdi
	call WriteString		;in ký tự xuống dòng 
;----------------------------
	
	call findMin				;tìm giá trị nhỏ nhất để in ra màn hình
;----------------------------
	
	xor ecx, ecx 
	call ExitProcess
main endp
;=========================================================

	
findMax proc 
	push rbp 
	mov rbp, rsp 
	sub rsp, 8
	
	push r15
	push r14
	push rdx


;--------------------------------------------	
	lea r15, [arr]
L0:
	mov edx, DWORD ptr[r15]
L1:
	add r15, 4
	cmp DWORD ptr[r15], 0
	jz L2
	cmp edx, DWORD ptr[r15]
	ja	L1
	jle L0 
;--------------------------------------------kiểm tra từng số với số nằm ở 4 byte tiếp theo, số nào lớn hơn thì sẽ là max 

;--------------------------------------------
L2:
	mov r14, rdx
	
	lea rdi, [pmax]
	push rdi
	call WriteString
	
	push r14
	call PrintNumber
;--------------------------------------------in giá trị max ra màn hình 

	pop rdx
	pop r14
	pop r15
	mov rsp, rbp 
	pop rbp
	ret
findMax endp 
;===========================================================================================
	

findMin proc 
	push rbp 
	mov rbp, rsp 
	sub rsp, 8
	
	push r15
	push r14
	push rdx
		
	lea r15, [arr]
	
;--------------------------------------------
L0:
	mov edx, DWORD ptr[r15]
L1:
	add r15, 4
	cmp DWORD ptr[r15], 0
	jz L2
	cmp edx, DWORD ptr[r15]
	ja	L0
	jle L1 

;--------------------------------------------kiểm tra từng số với số nằm ở 4 byte tiếp theo, số nào nhỏ hơn thì sẽ là min

;--------------------------------------------
L2:
	mov r14, rdx
	
	lea rdi, [pmin]
	push rdi
	call WriteString
	
	push r14
	call PrintNumber
;--------------------------------------------in giá trị min ra màn hình 

	
	pop rdx
	pop r14
	pop r15
	mov rsp, rbp 
	pop rbp
	ret
findMin endp
;===========================================================================================


inpARR proc 
	push rbp
	mov rbp, rsp 
	sub rsp, 8
	
	lea rdi, [n]
	push rdi 
	call atoi
	
	mov QWORD ptr[rbp - 8], rax						;arr_length(n)
	lea r15, [arr]
	mov r14, 0												;index number 

	
L0:
	cmp   QWORD ptr[rbp - 8] , 0
	jz L1

;--------------------------------------------------
	lea rdi, [arr_index1]
	push rdi						
	call WriteString				;in ký tự arr[
	
	push r14 
	call PrintNumber				;in số bắt đầu từ 0 => a[0, a[1,... a[n
	
	lea rdi, [arr_index2]	
	push rdi
	call WriteString				;in ký tự ] = 
	
	
	lea rdi, [inp]		
	push rdi				
	call ReadString					;nhập giá trị cho mảng 
	
	lea rdi, [inp]
	push rdi 
	call checkNum					;kiểm tra tính hợp lệ của số nhập 
	
	
	lea rdi, [inp]
	push rdi 
	call atoi						;chuyển số nhập từ kiểu chuỗi sang kiểu số 
	
	
	mov rbx, rax 
	shr rbx, 28
	cmp rbx, 8 
	jae L2							;kiểm tra tràn số 32 bit 
		
	
	mov edx, eax
	mov DWORD ptr[r15], edx
;--------------------------------------------------;nhập từng phần tử cho mảng

	sub  QWORD ptr[rbp - 8], 1
	add r15, 4
	add r14, 1
	jmp L0
	
L1:
	mov rsp, rbp 
	pop rbp 
	ret 
L2:
	lea rdi, [over]
	push rdi
	call WriteString
	
	mov rcx, 0 
	call ExitProcess
inpARR endp
;===========================================================================================

	
checkNum proc 
	push rbp
	mov rbp, rsp 
	
	push r15 
	mov r15, QWORD ptr[rbp + 16]
	push r15 
	call getlen
;----------------------------------------------------
L0:	
	mov dl, BYTE ptr[r15]
	cmp rax, 0 
	jz L2
	cmp dl, 0
	jz L1 
	cmp dl, 30h 
	jl L2
	cmp dl, 39h
	ja L2
	
	add r15, 1
	jmp L0
;----------------------------------------------------kiểm tra các ký tự có phải là số không bằng cách check trong khoảng từ 0x30-0x39
L1:
	pop r15
	mov rsp, rbp 
	pop rbp 
	ret 8

L2:
	lea rdi, [inval]
	push rdi 
	call WriteString
	
	xor rcx, rcx
	call ExitProcess
checkNum endp
;===========================================================================================end checkNum



atoi proc
;1234 = ((10 + 2)*10 + 3) * 10 + 4
	push rbp 
	mov rbp, rsp 
	sub rsp, 8
	
	push r15 
	push r14
	push rbx
	
	xor rax, rax
	xor rbx, rbx
	mov r15, QWORD ptr[rbp + 16]
	mov QWORD ptr[rbp - 8], 10

L0:
	mov bl, BYTE ptr[r15]
	cmp bl , 0
	jz L1
	sub rbx, 30h 
	mul QWORD ptr[rbp - 8]				;rax = rax * 10
	
	add rax, rbx 						;((rax * 10) + rbx) * 10 + rbx...............
	mov r14, rax
;-------------------------------
	shr r14, 24 
	cmp r14, 127									
	ja L2								;kiểm tra tràn số 
;-------------------------------
	
	add r15, 1
	jmp L0

L1:	
	pop rbx
	pop r14
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
;_____________________________end atoi




getlen proc 
	push rbp 
	mov rbp, rsp 
		
	push r15
	push rdx
	push rcx
	
	mov r15, QWORD ptr[rbp + 16]
	mov rcx, 0
	
L0:
;-------------------------------------
	mov dl, BYTE ptr[r15]
	cmp dl, 0
	jz L1
	add r15, 1
	add rcx, 1
	jmp L0
;-------------------------------------duyệt chuỗi cho đến ký tự kết thúc, mỗi lần cộng rcx lên 1 
	
L1:
	mov rax, rcx 
	
	pop rcx
	pop rdx 
	pop r15
	mov rsp, rbp 
	pop rbp 
	ret 8
getlen endp 
;===========================================================================================



inpN proc 
	
	lea rdi, [n_out]
	push rdi 
	call WriteString					;n chuỗi input n 
	
	lea rdi, [n]
	push rdi 
	call ReadString					;nhập n 
	
	lea rdi, [n]
	push rdi 
	call atoi
	cmp rax, 100					
	ja L0								;kiểm tra n không vượt quá 100 
	ret
	
L0:
	lea rdi, [over]
	push rdi
	call WriteString
	
	xor rcx, rcx 
	call ExitProcess
inpN endp 
;=========================================================================================== 


PrintNumber proc  
	push rbp
	mov rbp, rsp 
	sub rsp, 32
	
	push r15
	push r14
	push rdx 
	push rcx 
	push rbx
	push rax
	
	mov r15, QWORD ptr[rbp + 16]			;number
	mov QWORD ptr[rbp - 8], 10				
	lea r14, [rbp - 16]							;store string of number 
	mov rcx, 0
	mov rax, r15
	
;----------------------------------------------	
L0:
	mov rdx, 0
	div QWORD ptr[rbp - 8]
	add rdx, 30h
	mov BYTE ptr[r14], dl  
	add r14, 1
	add rcx, 1
	cmp rax, 0
	jnz L0
;----------------------------------------------tách chữ số của số rồi cộng với 30 để đổi thành xâu 	

	lea r15, [rbp - 32]
	lea r14, [rbp - 16]
	mov rdx, 0
;----------------------------------------------
L1:
	mov bl, BYTE ptr[r14 + rcx -1]
	mov BYTE ptr[r15], bl
	add r15, 1
	add rdx, 1									;string_len
	sub rcx, 1
	cmp rcx, 0
	jnz L1
	
	mov QWORD ptr[r15], 0						;thêm ký tự null vào cuối chuỗi
	
	lea rdi, [rbp - 32]
	push rdi 
	call WriteString
;----------------------------------------------in xâu của chữ số vửa đổi ra màn hình 
	
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
;=========================================================================================== 



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

	
	mov rcx, rax										;hConsoleOutput
	mov rdx, QWORD ptr[rbp + 10h]				;*lpBuffer
	mov r8, r15										;nNumberOfCharsToWrite
	lea r9, [rbp - 8]									;lpNumberOfCharsWritten
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
	sub rsp, 28h
	
	push rdx
	push rcx
	push rax
	push r8
	push r9
	
	
	mov rcx, -10 
	call GetStdHandle
		
	mov rcx, rax 											;hConsoleInput
	mov rdx, QWORD ptr[rbp + 10h]							;*lpBuffer
	mov r8, maxChar											;nNumberOfCharsToRead
	lea r9, [rbp - 8]										;lpNumberOfCharsRead
	call ReadConsole
	
L0:
	mov dl, BYTE ptr[rdi]
	cmp dl, 13	
	jz L1
	add rdi, 1
	jmp L0

L1:
	mov BYTE ptr[rdi], 0									;remove 13 at end of string
	
	pop r9
	pop r8
	pop rax
	pop rcx
	pop rdx
	
	mov rsp, rbp 
	pop rbp
	ret 8
	
ReadString endp
;----------------------------------------------------------
end
