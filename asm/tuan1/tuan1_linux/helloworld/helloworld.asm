section .data					;section .data để lưu dữ liệu
s db "hello world!" , 0xA		;tạo 1 biến s với mỗi ký tự là 1 byte và ký tự cuối cùng là ký tự xuống dòng
s_len equ $-s					;s_len là độ lớn của biến s 


section .text					;section .text để viết code thực thi
global _start					;tạo 1 global lable _start làm entry point của chương trình
_start:							
	mov eax, 4					;gán system_call của sys_write là 4 trong linux system call table vào eax 
	mov ebx, 1					;gán file descriptor của stdout là 1 vào ebx
	mov ecx, s                  ;gán địa chỉ của s vào ecx
	mov edx, s_len              ;gán độ lớn của s vào edx 
	int 0x80					;ngắt chương trình

	mov eax, 1                  ;gán system_call của sys_exit là 1 trong linux system call table vào eax 
	int 0x80					;ngắt chương trình

