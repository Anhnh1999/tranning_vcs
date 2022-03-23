; À compiler avec nasm -felf64 cat.asm && ld cat.o -o cat

%define SYS_EXIT 60
%define SYS_READ 0
%define SYS_WRITE 1
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDOUT 1

%define BUFFER_SIZE 2048

section .text
global  _start
_start:
  ; Récupère le premier argument
  add rsp, byte 10h
  pop rdi

  ; Ouvre le fichier
  mov rax, SYS_OPEN
  mov rsi, 0
  syscall
  mov [fd], rax


_read_write:
  ; Lit le fichier dans un buffer
  mov rax, SYS_READ
  mov rdi, [fd]
  mov rsi, file_buffer
  mov rdx, BUFFER_SIZE
  syscall

  ; Si on a atteint la fin du fichier, on quitte
  cmp rax, 0
  je _exit

  ; Affiche le contenu du buffer
  mov rdx, rax
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, file_buffer
  syscall

  jp _read_write


_exit:
  ; Ferme le fichier
  mov rax, SYS_CLOSE
  mov rdi, fd
  syscall



  ; Quitte
  mov rax, 60
  mov rdi, 0
  syscall


section .data
fd dw 0

section .bss
file_buffer resb BUFFER_SIZE