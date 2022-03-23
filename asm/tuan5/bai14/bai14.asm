option casemap:none
include C:\masm32\include64\win64.inc
include C:\masm32\include64\kernel32.inc
includelib C:\masm32\lib64\kernel32.lib
include C:\masm32\include64\gdi32.inc
include C:\masm32\include64\user32.inc
includelib C:\masm32\lib64\user32.lib
includelib C:\masm32\lib64\gdi32.lib

.data 

	szWindowsName 			byte "bai1", 0
	
	szClassName				byte "ball", 0 
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
	
	
	mov r9, SW_SHOWDEFAULT
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
	mov rdx, SW_SHOWDEFAULT 		
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
	ps  PAINTSTRUCT {}
	hdc HDC ?
	hbrush 	HBRUSH ?
    hpen HPEN ?
	wd   RECT{}
	
	return		QWORD ?
	htronleft 	QWORD ?
	htrontop	QWORD ?
	htronright	QWORD ?
	htronbottom	QWORD ?
	goc 		QWORD ?
	
.code

	push rbp 
	mov rbp, rsp 
	sub rsp, 100h 
	mov eax, edx		;UINT
	mov rbx, rcx 		;HWND
	
	
	cmp eax, WM_CREATE
	jnz paitLable
	
	
;lấy kích thước của sổ 
	lea rdx, [wd]
	mov rcx, rbx			;hWnd
	call GetClientRect

;lấy random 1 trong 4 góc lúc bắt đầu
    ;1 == 315
    ;2 == 45
    ;3 == 225 
    ;4 == 135 
	mov rcx, 4
	call RandomNum 
	mov goc, rax 

;lấy random vị trí trái phải hình tròn trong khoảng độ dài của cửa sổ
	xor rcx, rcx 
	mov ecx, wd.right 
	call RandomNum
	mov htronright, rax 
	sub rax, 100
	mov htronleft, rax 
;lấy random vị trí trái phải hình tròn trong khoảng độ rộng của cửa sổ	
	xor rcx, rcx 
	mov ecx, wd.bottom 
	call RandomNum
	mov htronbottom, rax 
	sub rax, 100
	mov htrontop, rax 
	
	mov rax, 0
	jmp exitLable
	
	

paitLable:
	cmp eax, WM_PAINT
	jnz DestroyLable
	
	lea rdx, [ps]
	mov rcx, rbx		;hWnd
	call BeginPaint
	mov hdc, rax  
	
;vẽ viền đen cho hình tròn 
	mov r8,  0 
	mov rdx, 2 
	mov rcx, PS_SOLID
	call CreatePen
	
	mov hpen, rax 
	
	mov rdx, hpen
	mov rcx, hdc 
	call SelectObject
	
;vẽ màu đỏ cho hình tròn 
	mov rcx, 255
	call CreateSolidBrush
	mov hbrush, rax 
	
	mov rdx, hbrush 
	mov rcx, hdc 
	call SelectObject
	
	mov r15, htronbottom
	mov [rsp + 32], r15
	mov r9, htronright
	mov r8, htrontop
	mov rdx, htronleft
	mov rcx, hdc 
	call Ellipse
	
	mov rdx, offset ps  
	mov rcx, rbx 		;hWnd
	call EndPaint
	
	mov r8, TRUE 
	mov rdx, 0 
	mov rcx, rbx 		;hWnd
	call InvalidateRect
	mov rcx, 5
	call Sleep 
	;lấy kích thước cửa sổ 
	lea rdx, [wd]
	mov rcx, rbx			;hWnd
	call GetClientRect

;xử lý va chạm với cửa sổ 
;---------------------------------
	mov r10d, wd.top
	cmp htrontop, r10
	jnz bottom_touch
	mov r10, goc 
	cmp goc, 2
	jnz short top1
	mov r10, 1
	mov goc, r10
top1:
	cmp goc, 4
	jnz bottom_touch
	mov r10, 3
	mov goc, r10
	
;---------------------------------	
bottom_touch:
	mov r10d, wd.bottom
	cmp htronbottom, r10
	jnz right_touch
	mov r10, goc 
	cmp goc, 1
	jnz short bottom1
	mov r10, 2
	mov goc, r10
bottom1:
	cmp goc, 3
	jnz right_touch
	mov r10, 4
	mov goc, r10 
	
;---------------------------------
right_touch:
	mov r10d, wd.right
	cmp htronright, r10
	jnz left_touch
	mov r10, goc 
	cmp goc, 2
	jnz short right1
	mov r10, 4
	mov goc, r10
right1:
	cmp goc, 1
	jnz left_touch
	mov r10, 3
	mov goc, r10 
	
;---------------------------------	
left_touch:
	mov r10d, wd.left
	cmp htronleft, r10
	jnz left2
	mov r10, goc 
	cmp goc, 4
	jnz short left1 
	mov r10, 2
	mov goc, r10
left1:
	cmp goc, 3
	jnz left2
	mov r10, 1
	mov goc, r10

left2: 
;di chuyển các hướng 
	mov rax, goc
	cmp eax, 1
	jnz goc2_45	
;goc1_315
	inc htronleft 
	inc htrontop 
	inc htronright
	inc htronbottom 
	jmp exitLable
	
goc2_45:
	cmp eax, 2
	jnz goc3_225
	inc htronleft 
	dec htrontop 
	inc htronright
	dec htronbottom 
	jmp exitLable
	
goc3_225:
	cmp eax, 3
	jnz goc4_135
	dec htronleft 
	inc htrontop 
	dec htronright
	inc htronbottom 
	jmp exitLable
	
goc4_135:
	dec htronleft 
	dec htrontop 
	dec htronright
	dec htronbottom 
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



;----------------------------------------------------------
PrintString proc
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
	
PrintString endp
;----------------------------------------------------------


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