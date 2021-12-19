section .bss
s resb 255


section .text
global _start

_start:
	call inp
	call uppercase
	call outp
	call exit

inp:
	mov eax, 3
	mov ebx, 0
	mov ecx, s
	mov edx, 32
	int 80h
	ret

outp:
	mov eax, 4
	mov ebx, 1
	mov ecx, s
	mov edx, 32
	int 80h
	ret
uppercase:
	mov dl, [ecx]
	cmp dl , 0xA
	jz done
	jnz check
continue:
	sub dl, 32
notlower:
	mov [ecx], dl
	add ecx, 1
	jmp uppercase

check:
	cmp dl, 0x61
	jl notlower
	cmp dl, 0x7a
	jg notlower
	jmp continue
done:
	ret

exit:
	mov eax, 1
	int 80h


