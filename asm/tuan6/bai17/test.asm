
section .data
command db "/usr/bin/pkill", 0
agrument1 db "top", 0

argv dq  command, agrument1, 0x0

  timeval:
    tv_sec  dq 0
    tv_usec dq 0

  bmessage  db "Sleep", 10, 0
 

  emessage  db "Continue", 10, 0
  emessagel equ $ - emessage

section .text
global _start
_start:
	


.L0:
  ; Sleep for 10 seconds and 0 nanoseconds
	mov Qword [tv_sec], 5
	mov Qword [tv_usec], 0
	mov rax, 35
	mov rdi, timeval
	xor rsi, rsi        
	syscall

;fork()
;----------------
	mov rax, 57 			
	syscall
;----------------	
	
	cmp rax, 0 		
	jz KillProcess			

;Parrent process
;----------------
;waitpid - 32bit  	
	mov ebx, eax 			;waitpid - 32bit  
	mov eax, 7 
	mov ecx, 0
	int 0x80 
	jmp .L0
;----------------

;child process
;----------------
KillProcess:				;execv
    mov rax, 59
    mov rdi, command
    mov rsi, argv
    mov rdx, 0
    syscall 
;----------------
;exit
	mov rax, 60
	mov rdi, 0
	syscall
	

;https://stackoverflow.com/questions/19580282/nasm-assembly-linux-timer-or-sleep
;https://stackoverflow.com/questions/13808640/requesting-examples-of-sys-fork-in-nasm