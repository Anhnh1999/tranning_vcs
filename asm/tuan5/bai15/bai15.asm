option casemap:none
include C:\masm32\include64\win64.inc
include C:\masm32\include64\kernel32.inc
includelib C:\masm32\lib64\kernel32.lib
include C:\masm32\include64\gdi32.inc
include C:\masm32\include64\user32.inc
includelib C:\masm32\lib64\user32.lib
includelib C:\masm32\lib64\gdi32.lib

.data 

	szWindowsName 			byte "bai15", 0
	szClassName				byte "ball", 0 
	szedit 					byte "edit", 0
.data?	
	hInstance 				HINSTANCE ?
	pcommandline 			LPSTR	?
	hWnd					HWND  ?
	wParam					WPARAM ?
	msg						MSG{}
	wcex					WNDCLASSEX {?}


.code 
main proc 
	push rbp 
	mov rbp, rsp 
	
	
	
	mov rcx, 0 
	call GetModuleHandle 
	mov hInstance, rax 
	
	call GetCommandLine
	mov pcommandline, rax 
	
	
	mov r9, SW_SHOWNORMAL
	mov r8, pcommandline
	xor edx, edx 
	mov rcx, hInstance
	call WinMain

	
main endp 

WinMain proc 
	push rbp 
	mov rbp, rsp 
	sub rsp, 100h 
	mov rbx, rcx 
	mov r11, r9 
	
	
	mov (WNDCLASSEX ptr [wcex]).cbSize, sizeof WNDCLASSEX
	mov (WNDCLASSEX ptr [wcex]).style, CS_HREDRAW or CS_VREDRAW	
;----------------lpfnWndProc
	push rsi
	lea rsi, [WndProc]
	mov (WNDCLASSEX ptr [wcex]).lpfnWndProc, rsi 
	pop rsi 
;----------------
	mov (WNDCLASSEX ptr [wcex]).cbClsExtra, 0
	mov (WNDCLASSEX ptr [wcex]).cbWndExtra, 0
;----------------hInstance
	
	mov (WNDCLASSEX ptr [wcex]).hInstance, rbx 
;----------------hIcon, hIconSm
	mov rcx, rbx
	mov rdx, IDI_APPLICATION
	call LoadIconA  
	mov (WNDCLASSEX ptr [wcex]).hIcon, rax 
	mov (WNDCLASSEX ptr [wcex]).hIconSm, rax 
;----------------hCursor	
	mov rcx, 0
	mov rdx, IDC_ARROW
	call LoadCursorA
	mov (WNDCLASSEX ptr [wcex]).hCursor, rax
;----------------
	mov (WNDCLASSEX ptr [wcex]).hbrBackground, COLOR_WINDOW+1
	mov (WNDCLASSEX ptr [wcex]).lpszMenuName, 0
;----------------lpszClassName	
	push rsi 
	mov rsi, offset szClassName
	mov (WNDCLASSEX ptr [wcex]).lpszClassName, rsi
	pop rsi 
;----------------
	mov rcx, offset wcex
	call RegisterClassEx

	
	
	mov rcx, WS_EX_OVERLAPPEDWINDOW
	mov rdx, offset szClassName	 
	mov r8, offset szWindowsName
	mov r9d, WS_OVERLAPPEDWINDOW
	mov QWORD ptr[rsp + 32], CW_USEDEFAULT	
	mov QWORD ptr[rsp + 40], CW_USEDEFAULT			 
	mov QWORD ptr[rsp + 48], CW_USEDEFAULT	
	mov QWORD ptr[rsp + 56], CW_USEDEFAULT
	mov QWORD ptr[rsp + 64], 0
	mov QWORD ptr[rsp + 72], 0
	mov QWORD ptr[rsp + 80], rbx
	mov QWORD ptr[rsp + 88], 0
	call CreateWindowEx
	mov hWnd, rax 	
	
	
	mov rcx, hWnd
	mov rdx, SW_SHOWNORMAL 		
	call ShowWindow 
	
	mov rcx, hWnd
	call UpdateWindow
	

	
	mov rcx, offset msg
	mov rdx, 0
	mov r8, 0 
	mov r9, 0 
	call GetMessage 
	test eax, eax 
	jz exit1

GetMessageLoop:	
	mov rcx, offset msg 
	call TranslateMessage
	mov rcx, offset msg
	call DispatchMessage

	mov rcx, offset msg
	mov rdx, 0
	mov r8, 0 
	mov r9, 0 
	call GetMessage 
	test eax, eax 
	jnz GetMessageLoop
exit1:
	mov rax, (MSG ptr[msg]).wParam
exit:
	
	mov rsp, rbp 
	pop rbp 
	ret 
WinMain endp 

WndProc proc
.data 
	
	hwnd1 		HWND ? 
	hwnd2 		HWND ? 
	
	string1 db 255	dup(?) 
	string2 db 255	dup(?)
	
	maxChar equ 255
	hMenu1 equ 1
	hMenu2 equ 2
	edit  byte "editbox", 0
	
	
.code



	push rbp 
	mov rbp, rsp 
	sub rsp, 200h 

	mov     eax, edx		;msg 
	mov     rbx, rcx		;hwnd
		
		
	cmp eax, WM_CREATE
	jnz command
	
;tạo cửa sổ edit 1	
	mov ecx, 0
	mov rdx, offset szedit	 
	mov r8, 0 ;				szWindowsName
	mov r9d, WS_BORDER or WS_CHILD or WS_VISIBLE or ES_LEFT or ES_MULTILINE 
	mov QWORD ptr[rsp + 32], 100	
	mov QWORD ptr[rsp + 40], 120			 
	mov QWORD ptr[rsp + 48], 300	
	mov QWORD ptr[rsp + 56], 30
	mov QWORD ptr[rsp + 64], rbx 		;HWND
	mov QWORD ptr[rsp + 72], hMenu1
	mov rax, hInstance
	mov QWORD ptr[rsp + 80], rax		
	mov QWORD ptr[rsp + 88], 0
	call CreateWindowEx
	mov hwnd1, rax

;đặt con trỏ bàn phím vào cửa sổ edit 1
	mov rcx, hwnd1 
	call SetFocus 

;tạo cửa sổ edit 2
	mov rcx, 0
	mov rdx, offset szedit	 
	mov r8, 0 ;				szWindowsName
	mov r9d, WS_BORDER or WS_CHILD or WS_VISIBLE or ES_LEFT or ES_MULTILINE or WS_DISABLED
	mov QWORD ptr[rsp + 32], 100	
	mov QWORD ptr[rsp + 40], 200			 
	mov QWORD ptr[rsp + 48], 300	
	mov QWORD ptr[rsp + 56], 30
	mov QWORD ptr[rsp + 64], rbx 		;HWND
	mov QWORD ptr[rsp + 72], hMenu2
	mov rax, hInstance
	mov QWORD ptr[rsp + 80], rax		
	mov QWORD ptr[rsp + 88], 0
	call CreateWindowEx
	mov hwnd2, rax
	
	
	jmp exitLable
	
	

command:
	cmp eax, WM_COMMAND
	jnz DestroyLable
	
	;check lParam == hwnd1 ? 
	mov rax, hwnd1 
	cmp r9, rax					;lParam
	jnz exitcommandLable
	
	
	mov ebx, r8d 				;wParam
	mov edx, hMenu1	
	
	cmp bx, dx  
	jnz exitcommandLable
	shr ebx, 16
	
	cmp bx, EN_CHANGE
	jnz exitcommandLable
	
	mov r8,  maxChar
	lea rdx, [string1]
	mov rcx, hwnd1
	call GetWindowText
	
	mov rcx, offset string1
	mov rdx, offset string2 
	call rev_string 
	
	lea rdx, offset string2 
	mov rcx, hwnd2
	call SetWindowText
	
	
	
exitcommandLable:	
	jmp exitLable
	
	

DestroyLable:
	cmp eax, WM_DESTROY
	jnz defaultl
	mov rcx, 0 
	call PostQuitMessage
	jmp exitLable


defaultl:	
	call DefWindowProc
	mov rsp, rbp 
	pop rbp 
	ret
exitLable:
	mov rax, 0
	mov rsp, rbp 
	pop rbp 
	ret  
WndProc endp 



rev_string proc
	push rbp 
	mov rbp, rsp
	sub rsp, 256
	push r15 
	push r14 
	
	
	mov r15, rcx			;string to be rev
	mov r14, rdx			;string aftter rev
	
	
	call lstrlenA			;length
	mov rcx, rax
	
	or ecx, ecx 
	jz L2 
	

L1: 										;reverse string to right order
	mov dl, BYTE ptr[r15 + rcx - 1]
	mov BYTE ptr[r14], dl
	add r14, 1
	sub rcx, 1
	cmp rcx, 0
	
	jnz L1
	

	;mov rax, r14

L2:
	mov BYTE ptr[r14], 0
	pop r14
	pop r15
	mov rsp, rbp 
	pop rbp
	ret 
rev_string endp
;_________________________________________________________



RandomNum proc
	
	push rbp 
	mov rbp, rsp
	sub rsp, 28h
	push rdx
	push rcx
	push rbx 
	push r15
	push r14
	push r13
	push r12
	push r11
	push r10
	push r9
	push r8
	
	mov r12, rcx 
	call GetTickCount 
	
	mov rdx, 0
	div r12
	add rdx, 1
	
	mov rax, rdx 

	pop r8
	pop r9
	pop r10
	pop r11
	pop r12
	pop r13
	pop r14
	pop r15
	pop rbx 
	pop rcx
	pop rdx
	mov rsp, rbp
	pop rbp 
	ret 


RandomNum endp 

end