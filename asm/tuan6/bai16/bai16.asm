option casemap:none
include C:\masm32\include64\win64.inc
include C:\masm32\include64\kernel32.inc
includelib C:\masm32\lib64\kernel32.lib
include C:\masm32\include64\user32.inc
includelib C:\masm32\lib64\user32.lib



.data 
	BrowserClassName 	byte "Chrome_WidgetWin_1", 0
	endline 			byte " ",0dh,0ah,0
	hWnd 				HWND  ?
	lParam 				LPARAM ?
	pid 				DWORD 1 dup(?)
	exitCode 			DWORD 1 dup(?)
	className 			byte 1024 dup(?)
.code 

main proc 
	
	
L0:
	mov rcx, 10000 
	call Sleep

	lea rcx, [EnumWindowsProc]
	mov rdx, 0
	call EnumWindows
	jmp L0 
	
	
main endp 

	
EnumWindowsProc proc 

	;HWND hWnd = [rbp + 16]

	push rbp 
	mov rbp, rsp 
	sub rsp, 500
	
	mov QWORD ptr[rbp - 184], 0	;pid 

	mov [rbp + 16], rcx		;hWnd 
	mov [rbp + 24], rdx 	;lParam
	mov rcx, [rbp + 16]
	call IsWindowVisible
	
	lea rdx, [rbp - 184]	;pid offset
	mov rcx, [rbp + 16]		;hWnd
	call GetWindowThreadProcessId
	;mov r15, [rbp - 184]
	
	mov rcx, [rbp + 16]
	lea rdx, className
	mov r8, 256
	call GetClassNameA
	
	push rax 
	lea r10, [BrowserClassName]
	push r10 
	lea r10, [className]
	push r10
	call compareString
	cmp rax, 0 
	jnz L0 
	 
	
	mov rcx, 1	;DesiredAccess = 1 <=> PROCESS_TERMINATE
	mov rdx, 1  ;InheritHandle = 1 <=> true
	mov r8, [rbp - 184]	;pid offset
	call OpenProcess
	
	mov [rbp - 200], rax 	;process handle
	
	mov rdx, 1				;ExitCode
	mov rcx, [rbp - 200]	;process handle
	call TerminateProcess
	
	mov rcx, [rbp - 200]
	call CloseHandle
L0:
	pop rax
	mov rsp, rbp 
	pop rbp
	ret
	
EnumWindowsProc endp 

compareString proc 
	push rbp 
	mov rbp, rsp
	
	push r15
	push r14 
	push rdx
	mov r15, [rbp + 16]
	mov r14, [rbp + 24]
compare:	
	mov dl, byte ptr[r15] 
	cmp dl, byte ptr[r14]
	jnz L1
	mov rax, 0
	add r15, 1 
	add r14, 1
	
	cmp byte ptr[r15], 0
	jz L0
	cmp byte ptr[r14], 0
	jz L0
	jmp compare
L1:
	mov rax, 1
L0:	
	pop rdx 
	pop r14
	pop r15 
	mov rsp, rbp 
	pop rbp 
	ret 16
	



compareString endp 





end 


