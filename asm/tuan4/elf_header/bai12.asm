section .data
	inpName 		db "input file name: ", 0
	pELF_Header 	db "ELF Header:", 0xA, 0
	phex_symbol 	db "0x", 0
	pbyte_into_file db " (bytes into file)",0
	pbyte			db " (bytes)", 0
	
	
	pmagic 									db 	"Magic:", 0
	pclass 									db 	"Class:", 0
	pdata  	 								db 	"Data:", 0
	pversion 								db 	"Version:", 0
	pOSABI									db 	"OS/ABI:", 0
	pABIVERSION 							db 	"ABI Version:", 0
	ptype 									db 	"Type:", 0
	pmachine								db 	"Machine:", 0
	pentry									db 	"Entry point address:", 0
	pstart_program_header					db 	"Start of program headers:", 0
	pstart_section_header   				db 	"Start of section headers :", 0
	pflag 									db 	"Flags :", 0 
	pSize_of_this_header 					db 	"Size of this header:", 0
	pSize_of_program_header					db 	"Size of program headers:", 0
	pNumber_of_program_header 				db 	"Number of program headers:", 0
	pSize_of_section_header					db 	"Size of section headers:", 0
	pNumber_of_section_header				db 	"Number of section headers:", 0
	pSection_header_string_table_index		db	"Section header string table index:", 0
	
	;---------- Class ------------------
	pELF64	db "ELF64", 0
	pELF32	db "ELF32", 0
	pinvalid_class db "Invalid class", 0
	
	;---------- Data ------------------
	plittle			db	"2's complement, little endian",0 
	pbig			db	"2's complement, big endian",0
	pInvalid_data_encoding db "Invalid data encoding", 0
	
	;---------- Version ------------------
	pver			db "(current)",0 
	;---------- OSABI ------------------
	pSystem_V  										db  "System V", 0
	pHewlett_Packard_HP_UX							db  "Hewlett-Packard HP-UX", 0
	pNetBSD											db  "NetBSD",0
	pGNU_Linux										db  "GNU/Linux",0
	pcac1											db 	"",0
	pcac2 											db 	"",0
	pSun_Solaris									db	"Sun Solaris",0
	pAIX											db	"AIX",0
	pIRIX 											db	"IRIX",0
	pFreeBSD 										db	"FreeBSD",0
	pCompaq_TRU64_UNIX 								db	"Compaq TRU64 UNIX",0
	pNovell_Modesto 								db	"Novell Modesto ",0
	pOpen_BSD 										db	"Open BSD",0
	pOpen_VMS 										db	"Open VMS",0
	pHewlett_Packard_Non_Stop_Kernel 				db	"Hewlett-Packard Non-Stop Kernel",0
	pAmiga_Research_OS 								db	"Amiga Research OS",0
	pThe_FenixOS_highly_scalable_multi_core_OS 		db	"The FenixOS highly scalable multi-core OS",0
	pNuxi_CloudABI 									db	"Nuxi CloudABI ",0
	pStratus_Technologies_OpenVOS				 	db	"Stratus Technologies OpenVOS",0
	
	arr_OSABI	dq pSystem_V, pHewlett_Packard_HP_UX, pNetBSD, pGNU_Linux, pcac1, pcac2, pSun_Solaris, pAIX, pIRIX, pFreeBSD, pCompaq_TRU64_UNIX, pNovell_Modesto, pOpen_BSD, pOpen_VMS, pHewlett_Packard_Non_Stop_Kernel , pAmiga_Research_OS , pThe_FenixOS_highly_scalable_multi_core_OS, pNuxi_CloudABI ,pStratus_Technologies_OpenVOS 
	
	;---------- type ------------------
	pET_NONE		db  "NONE (None)", 0	
	pET_REL			db  "REL (Relocatable file)", 0
	pET_EXEC		db 	"EXEC (Executable file )", 0
	pET_DYN			db	"DYN (Shared object file )", 0
	pET_CORE		db	"CORE (Core file )"
	
	arr_type 	dq pET_NONE, pET_REL, pET_EXEC, pET_DYN, pET_CORE
	
	;---------- machine ------------------
	pSPARC 		db "SPARC",0
	px86 		db "x86",0
	pMIPS 		db "MIPS",0
	pPowerPC 	db "PowerPC",0
	pS390 		db "S390",0
	pARM 		db "ARM",0
	pSuperH 	db "SuperH",0
	pIA_64 		db "IA-64",0
	px86_64 	db "x86-64",0
	pAArch64 	db "AArch64",0
	pRISC_V 	db "RISC-V",0

	
	
	not_elf db "not an elf file !!!", 0  
	endline db "", 0xA
	space db " ", 0

section .bss 
	fileName resb 100 
	fbuffer resb 256
	buffer resb 256 
	
	maxChar equ 256


section .text
global _start

_start:


;=================
	push fileName
	call PrintString		;"input file name: "
;=================
		
;=================
	push fileName
	call ReadString 		;đọc file 	
;=================
	mov edx, DWORD[fbuffer]
	cmp edx, 464C457Fh
	jnz .L0
	
	
	push pELF_Header
	call PrintString
	
	call PrintMagic
	call PrintClass
	call PrintData
	call PrintVersion
	call PrintOSABI
	call PrintABIVERSION
	call PrintType
	call PrintMachine
	call PrintVersion2
	call PrintEntryPoint
	call PrintStart_Program_header
	call PrintStart_Section_header
	call PrintFlag
	call PrintSize_of_this_header
	call PrintSize_of_program_header
	call PrintNumber_of_program_header
	call PrintSize_of_section_header
	call PrintNumber_of_section_header
	call PrintSection_header_string_table_index
	
	jmp .L1 
	
.L0:
	push not_elf
	call PrintString

.L1:
	mov rax, 60
	mov rdi, 0
	syscall
;-------------------------------------------------end _start

getlen:
	push rbp 
	mov rbp, rsp 
		
	push r15
	push rdx
	push rcx
	
	mov r15, QWORD[rbp + 16]
	xor rcx, rcx
	
.L0:
	mov dl, BYTE[r15]
	cmp dl, 0
	jz .L1
	add r15, 1
	add rcx, 1
	
	jmp .L0
	
.L1:
	mov rax, rcx 
	
	pop rcx
	pop rdx 
	pop r15
	mov rsp, rbp 
	pop rbp 
	ret 8
;-------------------------------------------------end getlen	


rev_string:
	push rbp 
	mov rbp, rsp
	sub rsp, 0x100
	
	push r15 
	push r14 
	push rcx 
	
	mov r15, QWORD[rbp + 16]			;string to be rev
	mov rcx, QWORD[rbp + 24]			;length
	
	
	lea r14, [rbp - 0x100]				;string aftter rev

.L1: 									;reverse string to right order
	mov dl, BYTE[r15 + rcx - 1]
	mov BYTE[r14], dl
	add r14, 1
	sub rcx, 1
	cmp rcx, 0
	jnz .L1
	
	lea rax, [rbp - 0x100]
	
	pop rcx 
	pop r14 
	pop r15 
	mov rsp, rbp 
	pop rbp
	ret 16
;-------------------------------------------------end rev_string	


PrintHexChar:
	push rbp 
	mov rbp, rsp 
	sub rsp, 32 
	
	push r15
	push r14
	push r13
	push r12
	push rcx 
	
	
	lea r14, [rbp - 32]			;buffer to store hex char 
	mov r15, [rbp + 16]			;hex num to print vd: 0x12345 
	mov r13, QWORD[rbp + 24]	;number of character to print 	
	mov r12, 0 					;count number hex to print 
	lea rdi, [buffer]			;buffer to print hex char  
;=============================================
.L0:	
	mov rax, 0
	mov rcx, 2
	mov rbx, 16
	mov rdx, 0 
	mov al, BYTE[r15]
.L1:							;tách từng 4 bit riêng thành 1 byte -> chuyển thành ký tự hex 
	div rbx 			
	mov BYTE[r14], dl 
	add r14, 1
	loop .L1 
	
	add r15, 1
	add r12, 2 
	cmp r12, r13
	jnz .L0  
;=============================================


	mov rcx, r13 
	lea r14, [rbp - 32]
;=============================================
.L2:
	xor rdx, rdx 
	mov dl, BYTE[r14]
	cmp dl, 9 
	ja .L3 
	add dl, 0x30				;ký tự trong khoảng từ 0-9
	add r14, 1
	jmp .L4 
;=============================================

;=============================================
.L3:	
	add dl, 'a'
	sub dl, 10					;ký tự trong khoảng từ 10-15 
	add r14, 1
	
.L4:
	mov BYTE[rdi], dl
	add rdi, 1 
	loop .L2 
;=============================================	
	mov r15, QWORD[rbp + 24]
	lea r14, [buffer]
	
.L5:
	push 2  
	push r14 
	call rev_string
	
	push rax 
	call PrintString
	
	;push space
	;call PrintString
	
	add r14, 2
	sub r15, 2 
	cmp r15, 0 
	jnz .L5 
	
	pop rcx 
	pop r12
	pop r13
	pop r14
	pop r15
	
	mov rsp, rbp 
	pop rbp 
	ret 16 
;-------------------------------------------------end PrintHexChar	


PrintMagic: 
	push rbp
	mov rbp, rsp 
	sub rsp, 8
	
	push space
	call PrintString
		
	
	push pmagic
	call getlen
	mov QWORD[rbp - 8], rax 
		
	mov rax, 1								;sys_write
	mov rdi, 1  							;fd 
	mov rsi, pmagic							;string 
	mov rdx, QWORD[rbp - 8]					;string_len
	syscall

;=================	
	push space
	call PrintString
	push space
	call PrintString
	push space
	call PrintString
;=================
	
;=================
	mov rcx, 16
	lea r15, [fbuffer]
.L0:
	push 2
	push r15
	call PrintHexChar 
	
	push space
	call PrintString
	add r15, 1
	loop .L0
;=================
	
	push endline
	call PrintString
		
	mov rsp, rbp 
	pop rbp 
	ret 
;-------------------------------------------------end PrintMagic	


PrintClass:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8

	push pclass
	call PrintString

	mov rcx, 30 
.cach:	
	push space
	call PrintString
	loop .cach
	
	mov dl, BYTE[fbuffer + 4]
	cmp dl, 01 
	jz .L0
	cmp dl, 02
	jz .L1
	jnz .L2 
	
.L0:
	push pELF32
	call PrintString
	jmp .L3
.L1:
	push pELF64
	call PrintString
	jmp .L3 
	
.L2:
	push pinvalid_class
	call PrintString
	
.L3:	
	push endline
	call PrintString

	mov rsp, rbp 
	pop rbp 
	ret 
;-------------------------------------------------end PrintMagic	


PrintData:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8

	push pdata
	call PrintString

	mov rcx, 31 
.cach:	
	push space
	call PrintString
	loop .cach
	
	mov dl, BYTE[fbuffer + 5]
	cmp dl, 01 
	jz .L0
	cmp dl, 02
	jz .L1
	jnz .L2 
	
.L0:
	push plittle
	call PrintString
	jmp .L3
.L1:
	push pbig
	call PrintString
	jmp .L3 
	
.L2:
	push pInvalid_data_encoding
	call PrintString
	
.L3:	
	push endline
	call PrintString

	mov rsp, rbp 
	pop rbp 
	ret 
;-------------------------------------------------end PrintData


PrintVersion:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8
	

	
	push pversion
	call PrintString
	
	mov rcx, 28 
.cach:	
	push space
	call PrintString
	loop .cach
	
	movzx rdx, BYTE[fbuffer +6]
	push rdx
	call PrintNumber
	
	push space
	call PrintString
	
	push pver
	call PrintString
	
	
	push endline
	call PrintString
	
	mov rsp, rbp 
	pop rbp 
	ret 
;-------------------------------------------------end PrintVersion	


PrintOSABI:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8

	push pOSABI
	call PrintString

	mov rcx, 29 
.cach:	
	push space
	call PrintString
	loop .cach
	
	movzx rdx, BYTE[fbuffer + 7]
	push QWORD[arr_OSABI + rdx * 8] 
	call PrintString
	
	push endline
	call PrintString

	mov rsp, rbp 
	pop rbp 
	ret 
;-------------------------------------------------end PrintOSABI


PrintABIVERSION:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8

	push pABIVERSION
	call PrintString

	mov rcx, 24 
.cach:	
	push space
	call PrintString
	loop .cach
	
	movzx rdx, BYTE[fbuffer + 9]
	push rdx 
	call PrintNumber
	
	push endline
	call PrintString

	mov rsp, rbp 
	pop rbp 
	ret 
;-------------------------------------------------end PrintABIVERSION

PrintType:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8

	push ptype
	call PrintString

	mov rcx, 31 
.cach:	
	push space
	call PrintString
	loop .cach
	
	movzx rdx, WORD[fbuffer + 16]
	push QWORD[arr_type + rdx * 8]
	call PrintString
	
	push endline
	call PrintString

	mov rsp, rbp 
	pop rbp 
	ret 
;-------------------------------------------------end PrintType


PrintMachine:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8

	push pmachine
	call PrintString

	mov rcx, 28 
.cach:	
	push space
	call PrintString
	loop .cach
	
	movzx rdx, WORD[fbuffer + 18]
	cmp dl, 0x2 
	jz .L2
	cmp dl, 0x3
	jz .L3
	cmp dl, 0x8
	jz .L4
	cmp dl, 0x14
	jz .L5
	cmp dl, 0x16
	jz .L6
	cmp dl, 0x28
	jz .L7
	cmp dl, 0x2A
	jz .L8
	cmp dl, 0x32
	jz .L9
	cmp dl, 0x3E
	jz .L10
	cmp dl, 0xB7
	jz .L11
	cmp dl, 0xF3
	jz .L12
.L2:
	push pSPARC
	call PrintString
	jmp .L0
.L3:
	push px86
	call PrintString
	jmp .L0 
.L4:
	push pMIPS
	call PrintString
	jmp .L0 
.L5:
	push pPowerPC
	call PrintString
	jmp .L0
.L6:
	push pS390
	call PrintString
	jmp .L0
.L7:
	push pARM
	call PrintString
	jmp .L0
.L8:
	push pSuperH
	call PrintString
	jmp .L0
.L9:
	push pIA_64
	call PrintString
	jmp .L0
.L10:
	push px86_64
	call PrintString
	jmp .L0
.L11:
	push pAArch64
	call PrintString
	jmp .L0
.L12:
	push pRISC_V
	call PrintString
	jmp .L0
	
.L0:	
	push endline
	call PrintString

	mov rsp, rbp 
	pop rbp 
	ret 
;-------------------------------------------------end PrintMachine


PrintVersion2:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8
	
	push pversion
	call PrintString
	
	mov rcx, 28 
.cach:	
	push space
	call PrintString
	loop .cach
	
	lea r15, [fbuffer + 20]
	
	push phex_symbol
	call PrintString
	push 2
	push r15 
	call PrintHexChar
	jmp .L0
	
.L0:
	push endline
	call PrintString
	
	mov rsp, rbp 
	pop rbp 
	ret 
;-------------------------------------------------end PrintVersion2

PrintEntryPoint:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8
	
	push pentry
	call PrintString
	
	mov rcx, 16
.cach:	
	push space
	call PrintString
	loop .cach
	
.check32_64:	
	movzx rdx, BYTE[fbuffer + 4]
	cmp rdx, 1		;kiểm tra byte thứ 5 nếu bằng 1 thì là 32 bit, bằng 2 là 64 bit  
	jz	.L32
.L64:	
	lea r15, [fbuffer + 31]
	push phex_symbol
	call PrintString
	mov rcx, 8
.Loop64:	
	push 2
	push r15
	call PrintHexChar
	sub r15, 1 
	loop .loop32 
	jmp .L0

.L32:
	lea r15, [fbuffer + 27]
	push phex_symbol
	call PrintString
	mov rcx, 4
.loop32:
	push 2
	push r15 
	call PrintHexChar
	sub r15, 1
	loop .loop32 
	jmp .L0
	
.L0:
	push endline
	call PrintString
	
	mov rsp, rbp 
	pop rbp 
	ret 
;-------------------------------------------------end PrintEntryPoint

PrintStart_Program_header:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8
	
	push pstart_program_header
	call PrintString
	
	mov rcx, 11
.cach:	
	push space
	call PrintString
	loop .cach
	
.check32_64:	
	movzx rdx, BYTE[fbuffer + 4]
	cmp rdx, 1		;kiểm tra byte thứ 5 nếu bằng 1 thì là 32 bit, bằng 2 là 64 bit  
	jz	.L32
.L64:	
	mov r15, QWORD[fbuffer + 32]
	push r15
	call PrintNumber
	push pbyte_into_file
	call PrintString
	jmp .L0
	
.L32:
	mov r15, 0
	mov r15d, DWORD[fbuffer + 28]
	push r15
	call PrintNumber
	push pbyte_into_file
	call PrintString
	jmp .L0
	
.L0:
	push endline
	call PrintString
	
	mov rsp, rbp 
	pop rbp 
	ret 
;-------------------------------------------------end PrintStart_Program_header

PrintStart_Section_header:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8
	
	push pstart_section_header
	call PrintString
	
	mov rcx, 10
.cach:	
	push space
	call PrintString
	loop .cach
	
.check32_64:	
	movzx rdx, BYTE[fbuffer + 4]
	cmp rdx, 1		;kiểm tra byte thứ 5 nếu bằng 1 thì là 32 bit, bằng 2 là 64 bit  
	jz	.L32
.L64:	
	mov r15, QWORD[fbuffer + 40]
	push r15
	call PrintNumber
	push pbyte_into_file
	call PrintString
	jmp .L0
	
.L32:
	mov r15, 0
	mov r15d, DWORD[fbuffer + 32]
	push r15
	call PrintNumber
	push pbyte_into_file
	call PrintString
	jmp .L0
	
.L0:
	push endline
	call PrintString
	
	mov rsp, rbp 
	pop rbp 
	ret 
;-------------------------------------------------end PrintStart_Section_header

PrintFlag:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8
	
	push pflag
	call PrintString
	
	mov rcx, 29
.cach:	
	push space
	call PrintString
	loop .cach
	
	push phex_symbol
	call PrintString
	
.check32_64:	
	movzx rdx, BYTE[fbuffer + 4]
	cmp rdx, 1		;kiểm tra byte thứ 5 nếu bằng 1 thì là 32 bit, bằng 2 là 64 bit  
	jz	.L32
.L64:	
	lea r15, [fbuffer + 51]
	mov rcx, 4
.loop64:
	push 2
	push r15
	call PrintHexChar
	sub r15, 1
	loop .loop64
	jmp .L0
	
.L32:
	lea r15, [fbuffer + 39]
	mov rcx, 4
.loop32:
	push 2
	push r15
	call PrintHexChar
	sub r15, 1
	loop .loop32
	jmp .L0
	
.L0:
	push endline
	call PrintString
	
	mov rsp, rbp 
	pop rbp 
	ret 
;-------------------------------------------------end PrintFlag

PrintSize_of_this_header:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8
	
	push pSize_of_this_header
	call PrintString
	
	mov rcx, 16
.cach:	
	push space
	call PrintString
	loop .cach
	

.check32_64:	
	movzx rdx, BYTE[fbuffer + 4]
	cmp rdx, 1		;kiểm tra byte thứ 5 nếu bằng 1 thì là 32 bit, bằng 2 là 64 bit  
	jz	.L32
.L64:	
	movzx r15, WORD[fbuffer + 52]
	push r15
	call PrintNumber
	jmp .L0
	
.L32:
	movzx r15, WORD[fbuffer + 40]
	push r15
	call PrintNumber
	jmp .L0
	
.L0:
	push pbyte
	call PrintString
	push endline
	call PrintString
	
	mov rsp, rbp 
	pop rbp 
	ret
;-------------------------------------------------end PrintSize_of_this_header

PrintSize_of_program_header:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8
	
	push pSize_of_program_header
	call PrintString
	
	mov rcx, 12
.cach:	
	push space
	call PrintString
	loop .cach
	

.check32_64:	
	movzx rdx, BYTE[fbuffer + 4]
	cmp rdx, 1		;kiểm tra byte thứ 5 nếu bằng 1 thì là 32 bit, bằng 2 là 64 bit  
	jz	.L32
.L64:	
	movzx r15, WORD[fbuffer + 54]
	push r15
	call PrintNumber
	jmp .L0
	
.L32:
	movzx r15, WORD[fbuffer + 42]
	push r15
	call PrintNumber
	jmp .L0
	
.L0:
	push pbyte
	call PrintString
	push endline
	call PrintString
	
	mov rsp, rbp 
	pop rbp 
	ret
;-------------------------------------------------end PrintSize_of_program_header

PrintNumber_of_program_header:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8
	
	push pNumber_of_program_header
	call PrintString
	
	mov rcx, 10
.cach:	
	push space
	call PrintString
	loop .cach
	

.check32_64:	
	movzx rdx, BYTE[fbuffer + 4]
	cmp rdx, 1		;kiểm tra byte thứ 5 nếu bằng 1 thì là 32 bit, bằng 2 là 64 bit  
	jz	.L32
.L64:	
	movzx r15, WORD[fbuffer + 56]
	push r15
	call PrintNumber
	jmp .L0
	
.L32:
	movzx r15, WORD[fbuffer + 44]
	push r15
	call PrintNumber
	jmp .L0
	
.L0:
	push endline
	call PrintString
	
	mov rsp, rbp 
	pop rbp 
	ret
;-------------------------------------------------end PrintNumber_of_program_header	

PrintSize_of_section_header:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8
	
	push pSize_of_section_header
	call PrintString
	
	mov rcx, 12
.cach:	
	push space
	call PrintString
	loop .cach
	

.check32_64:	
	movzx rdx, BYTE[fbuffer + 4]
	cmp rdx, 1		;kiểm tra byte thứ 5 nếu bằng 1 thì là 32 bit, bằng 2 là 64 bit  
	jz	.L32
.L64:	
	movzx r15, WORD[fbuffer + 58]
	push r15
	call PrintNumber
	jmp .L0
	
.L32:
	movzx r15, WORD[fbuffer + 46]
	push r15
	call PrintNumber
	jmp .L0
	
.L0:
	push pbyte
	call PrintString
	push endline
	call PrintString
	
	mov rsp, rbp 
	pop rbp 
	ret
;-------------------------------------------------end PrintSize_of_section_header	

PrintNumber_of_section_header:
	push rbp 
	mov rbp, rsp 
	sub rsp, 8
	
	push pNumber_of_section_header
	call PrintString
	
	mov rcx, 10
.cach:	
	push space
	call PrintString
	loop .cach
	

.check32_64:	
	movzx rdx, BYTE[fbuffer + 4]
	cmp rdx, 1		;kiểm tra byte thứ 5 nếu bằng 1 thì là 32 bit, bằng 2 là 64 bit  
	jz	.L32
.L64:	
	movzx r15, WORD[fbuffer + 60]
	push r15
	call PrintNumber
	jmp .L0
	
.L32:
	movzx r15, WORD[fbuffer + 48]
	push r15
	call PrintNumber
	jmp .L0
	
.L0:
	push endline
	call PrintString
	
	mov rsp, rbp 
	pop rbp 
	ret
;-------------------------------------------------end Number_of_section_header
		

PrintSection_header_string_table_index:
		push rbp 
	mov rbp, rsp 
	sub rsp, 8
	
	push pSection_header_string_table_index
	call PrintString
	
	mov rcx, 2
.cach:	
	push space
	call PrintString
	loop .cach
	

.check32_64:	
	movzx rdx, BYTE[fbuffer + 4]
	cmp rdx, 1		;kiểm tra byte thứ 5 nếu bằng 1 thì là 32 bit, bằng 2 là 64 bit  
	jz	.L32
.L64:	
	movzx r15, WORD[fbuffer + 62]
	push r15
	call PrintNumber
	jmp .L0
	
.L32:
	movzx r15, WORD[fbuffer + 50]
	push r15
	call PrintNumber
	jmp .L0
	
.L0:
	push endline
	call PrintString
	
	mov rsp, rbp 
	pop rbp 
	ret
;-------------------------------------------------end PrintSection_header_string_table_index
	
PrintString: 
	push rbp
	mov rbp, rsp 
	sub rsp, 8
	
	push rcx 
	
	push QWORD[rbp + 16]
	call getlen
	mov QWORD[rbp - 8], rax 
		
	mov rax, 1								;sys_write
	mov rdi, 1  							;fd 
	mov rsi, QWORD[rbp + 16]				;string 
	mov rdx, QWORD[rbp - 8]					;string_len
	syscall
		
	pop rcx 
	
	mov rsp, rbp 
	pop rbp 
	ret 8
;-------------------------------------------------end PrintString

PrintNumber: 
	push rbp
	mov rbp, rsp 
	sub rsp, 32
	
	push r15
	push r14
	push rdx 
	push rcx 
	push rbx
	push rax
	
	mov r15, QWORD[rbp + 16]			;number
	mov QWORD[rbp - 8], 10				
	lea r14, [rbp - 16]					;store string of number 
	mov rcx, 0
	
	
	mov rax, r15
.L0:
	mov rdx, 0
	div QWORD[rbp - 8]
	add rdx, 0x30
	mov BYTE[r14], dl  
	add r14, 1
	add rcx, 1
	cmp rax, 0
	jnz .L0
	

	lea r15, [rbp - 32]
	lea r14, [rbp - 16]
	mov rdx, 0
.L1:
	mov bl, BYTE[r14 + rcx -1]
	mov BYTE[r15], bl
	add r15, 1
	add rdx, 1								;string_len
	sub rcx, 1
	cmp rcx, 0
	jnz .L1
	
		
	mov rax, 1
	mov rdi, 1  
	lea rsi, [rbp - 32]						;string 
	;mov rdx, QWORD[rbp - 8]				;string_len
	syscall
	
	
	pop rax 
	pop rbx
	pop rcx
	pop rdx 
	pop r14
	pop r15
	mov rsp, rbp 
	pop rbp 
	ret 8
;-------------------------------------------------end PrintNumber


ReadString:
	push rbp 
	mov rbp, rsp 
	
	push rdx
	mov rax, 0 
	mov rdi, 0 	
	mov rsi, QWORD[rbp + 16]					;string
	mov rdx, maxChar							;max length of string 
	syscall
	
.L0:
	mov dl, BYTE[rsi]
	cmp dl, 0xA 
	jz .L1
	add rsi, 1
	jmp .L0


.L1:

	mov BYTE[rsi], 0							;remove 0xA at end of string
	pop rdx	
	mov rsp, rbp 
	pop rbp
	ret 8
;-------------------------------------------------end ReadString



ReadFile:
	push rbp 
	mov rbp, rsp 
	
	mov rax, 2 
	mov rdi, QWORD[rbp + 16]
	mov rsi, 0 
	mov rdx, 777
	syscall
	
	 
	mov rdi, rax 		;tên file 
	mov rax, 0			;sys_read
	mov rsi, fbuffer	;lưu nội dung đọc vào fbuffer	
	mov rdx, maxChar
	syscall
	
	mov rax, 3			;sys_close
	pop rdi 
	syscall

	syscall
	
	mov rsp, rbp 
	pop rbp 
	ret 8 
	
	
	
	
	
