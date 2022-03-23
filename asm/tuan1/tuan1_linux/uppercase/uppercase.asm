section .bss
s resb 32

section .text
global _start


_start:
	call inp         
	call uppercase
	call outp

	mov eax, 1
	int 0x80

;------------------------------------------------------
inp:								;input s 
	mov eax, 3
	mov ebx, 0
	mov ecx, s
	mov edx, 32
	int 0x80
	ret
;------------------------------------------------------end inp
	
	

;------------------------------------------------------
;uppercase là procedure để chuyển ký tự in thường thành in hoa, các ký tự số hay ký tự khác được giữ nguyên
uppercase:

	mov dl, [ecx] ;chuyển từng ký tự vào dl 
	cmp dl , 0xA  ;so sánh từng ký tự trong dl với ký tự kết thúc chỗi
	jz done	      ;nếu dl bằng ký tự kết thúc chỗi thì procedure uppercase sẽ kết thúc
	jnz check	  ;nếu không thì sẽ chuyển đến lable check

continue:
	sub dl, 32
	mov BYTE[ecx], dl

nextchar:
	add ecx, 1
	jmp uppercase

;label check kiểm tra nếu ký tự đang xét là ký tự từ a-z thì chuyển đến lable continue để chuyển thành chữ in hoa bằng cách trừ cho 32 
;còn không thì sẽ chuyển đến lable nextchar để xét ký tự tiếp theo 
check:
	cmp dl,0x61
	jl nextchar
	cmp dl, 0x7b
	jg nextchar
	jmp continue
done:
	ret
;------------------------------------------------------end uppercase

	
	
;------------------------------------------------------	
outp:										;output s 
	mov eax, 4
	mov ebx, 1
	mov ecx, s
	mov edx, 32
	int 0x80
	ret
;------------------------------------------------------end outp
	
	