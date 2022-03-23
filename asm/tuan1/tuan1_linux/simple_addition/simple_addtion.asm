section .bss
a resb 15
b resb 15

value resb 100
trueValue resb 100

section .data
pa db "input first number: ", 0xA
pb db "input secon number: ", 0xA
s  db "sum is: "
iv db "invalid number!: ", 0xA

section .text
global _start

_start:


	call inpa			
	call atoi		
	push edx		;nhập a và chuyển sang dạng số rồi push vào stack
;----------------------------

	
	call inpb
	call atoi
	push edx		;nhập b và chuyển sang dạng số rồi push vào stack
;----------------------------

	pop eax
	pop ebx
									;so sánh 2 số nhập với 31 bit 
	cmp eax, 0x7fffffff
	ja invalid
	cmp ebx, 0x7fffffff
	ja invalid
;----------------------------

	add eax, ebx				;cộng tổng 2 số 
	push eax
	call hex2chr
;------------------------------------------------------end _start

inpa:
	mov eax, 4			
	mov ebx, 1
	mov ecx, pa
	mov edx, 20
	int 0x80			;print input first number to screen
	mov eax, 3
	mov ebx, 0
	mov ecx, a
	mov edx, 20
	int 0x80			;input a 
	ret
;------------------------------------------------------end inpa


inpb:
    mov eax, 4
    mov ebx, 1
    mov ecx, pb
    mov edx, 20
    int 0x80			;print input first number to screen
	mov eax, 3
	mov ebx, 0
	mov ecx, b
	mov edx, 20
	int 0x80			;input b
	ret
;------------------------------------------------------end inpb


atoi:
	xor eax, eax
	xor ebx, ebx
	xor edx, edx
	mov DWORD[esp + 4], 10
nextchar:
;chuyển từng ký tự từ char thành int
	mov bl, BYTE[ecx]

	cmp bl, 0xA
	jz end
	
	cmp bl, 0x30
	jl containchr
	cmp bl, 0x39
	ja containchr
	
	sub ebx, 0x30

;chuyển chuỗi sang số lấy 1 eax làm 1 base rồi nhân 10 lên theo từng vòng và cộng với số tiếp theo (eax * 10 + ebx) * 10 + ebx .....
	mul DWORD[esp + 4]
	pushf; lưu các giá trị cờ vào stack
	add eax, ebx
	popf; lấy giá các giá trị cờ
	jo invalid	; lưu giá trị cờ để kiểm tra tràn số 
	
	mov edx, eax
	add ecx, 1
	jmp nextchar
end:
	ret

containchr:
	jmp invalid
;------------------------------------------------------end atoi




;procedure hex2char chuyển ngược số đã được cộng thành kiểu string để có thê in ra màn hình 
hex2chr:
	mov eax, DWORD[esp+4]    ; trước khi procedure hex2char được gọi thì tổng 2 số được đẩy vào stack nên lấy ra bằng cách chuyển 1 DWORD trong [esp + 4] 
						     ; vào eax, esp + 4 do esp đang lưu trữ return address của hex2char


	lea ebx, [value]		 ; gán địa chỉ của biến value cho ebx 
	mov DWORD[esp + 8], 0 	 ; push 0 vào [esp + 8] để làm index cho lable reverse sử dụng sau
hex2chr1:
	mov ecx, 10              ;chuyển 10 vào ecx
	mov edx, 0               ;chuyển 0 vào edx
	div ecx                  ;thực hiện chia, instruction div sẽ chia eax cho ecx và đưa phần dư vào edx, edx lúc này sẽ mang số cuối cùng của tổng

	add dl, 0x30			 ;chuyển số trong edx hay dl thành ký tự tương ứng	
	mov BYTE[ebx], dl
	add ebx, 1               ;cộng ebx lên 1 do ebx trỏ vào địa chỉ đầu tiên của [value] nên làm tuần tự để đưa từng ký tự của tổng vào [value]
	add DWORD[esp+8], 1      ;cộng index của lable reverse lên 1 đơn vị
	cmp eax, 0

 	jnz hex2chr1

;procedure hex2char đã chuyển tổng thành string nhưng bị ngược nên cần đảo ngược lại string chứa tổng
reverse:
	mov eax, DWORD[esp + 8]  ;chuyển giá trị index vào eax
	lea ecx, [trueValue]	 ;gán địa chỉ của truValue cho ecx

;trừ dần từ index là tổng số ký tự của string chứa tổng vào để biết lúc cần kết thúc rồi chuyển từng ký tự lại vào trueValue qua ecx
reverse1:
	mov dl, BYTE[value + eax - 1]
	mov BYTE[ecx], dl

	sub eax, 1
	add ecx, 1
	cmp eax, 0
	jnz reverse1
	mov byte[ecx], 0xA       
;------------------------------------------------------end hex2chr


outp:
	mov eax, 4
    mov ebx, 1
    mov ecx, s
    mov edx, 8
    int 0x80					;print sum is to screen


	mov eax, 4
	mov ebx, 1
	mov ecx, trueValue
	mov edx, 15		
	int 0x80					;print sum of two number 
	
exit:
	mov eax, 1
	int 0x80					;exit program


invalid:
	mov eax, 4
    mov ebx, 1
    mov ecx, iv
    mov edx, 15
    int 0x80				;print invalid to screen
   	jmp exit
;------------------------------------------------------end outp