option casemap:none
include C:\masm32\include64\win64.inc
include C:\masm32\include64\kernel32.inc
includelib C:\masm32\lib64\kernel32.lib
include C:\masm32\include64\user32.inc
includelib C:\masm32\lib64\user32.lib


.data

	inpName 		byte "input file name: ", 0
	pReadFileErr 	byte "Could not read file",0

;-----------------------------------
	pDosHeader 			byte "-------------DOS HEADER-----------------------------------",0dh,0ah,0
	pNtHeader 			byte "-------------IMAGE_NT_HEADERS------------------------------------",0dh,0ah,0
	pOptionHeader 		byte "-------------OPTIONAL HEADER------------------------------",0dh,0ah,0
	pDataD				byte "-------------DATA DIRECTIOIES-----------------------------",0dh,0ah,0
	pSectionHeader		byte "-------------SECTION HEADER-------------------------------",0dh,0ah,0
	pFileHeader			byte "-------------FILE HEADER ---------------------------------",0dh,0ah,0
	pOptionalHeader		byte "-------------OPTIONAL HEADER -----------------------------",0dh,0ah,0
	pDataDirection  	byte "-------------DATA DIRECTION-------------------------------",0dh,0ah,0
	pImportDirectory 	byte "-------------IMPORT DIRECTORY-----------------------------",0dh,0ah,0
	pExportDirectory 	byte "-------------EXPORT DIRECTORY-----------------------------",0dh,0ah,0
	pExportName 		byte "-------------EXPORT NAME----------------------------------",0dh,0ah,0

; ---------DOS Header--------------
	p_e_magic		byte "	Magic Number :                            0x",0
	p_e_cblp		byte "	Bytes on the last page of file :          0x",0
	p_e_cp			byte "	Pages in file :                           0x",0
	p_e_crlc		byte "	Relocations :                             0x",0
	p_e_cparhdr		byte "	Size of header in paragraphs :            0x",0 
	p_e_minalloc 	byte "	Minimum extra paragraphs needed :         0x",0
	p_e_maxalloc 	byte "	Maximum extra paragraphs needed :         0x",0
	p_e_ss 			byte "	Initial (relative) SS value :             0x",0
	p_e_sp 			byte "	Initial SP value :                        0x",0
	p_e_csum 		byte "	Check sum :                               0x",0
	p_e_ip			byte "	Initial IP value :                        0x",0
	p_e_cs 			byte "	Initial (relative) CS value :             0x",0		
	p_e_lfarlc		byte "	File address of relocation table:         0x",0
	p_e_ovno		byte "	Overlay number :                          0x",0
	p_e_res			byte " 	Reserved words :                          0x",0
	p_e_oemid		byte "	OEM identifier (for e_oeminfo) :          0x",0
	p_e_oeminfo		byte "	OEM information; e_oemid specific :       0x",0
	p_e_resspace	byte " 	                                          0x",0
	p_e_lfanew		byte "	Offset to start of PE Header :            0x",0

; ---------NT Header---------------
	pSignature 				byte "	Signature :              0x",0
	

	pMachine 				byte "	Machine :                0x",0
	pNumberOfSections 		byte "	NumberOfSections :       0x",0
	pTimeDateStamp 			byte "	TimeDateStamp :          0x",0
	pPointerToSymbolTable 	byte "	PointerToSymbolTable :   0x",0
	pNumberOfSymbols 		byte "	NumberOfSymbols :        0x",0
	pSizeOfOptionalHeader 	byte "	SizeOfOptionalHeader :   0x",0
	pCharacteristics 		byte "	Characteristics :        0x",0

	pMagic                         	byte "	Magic :                          0x",0
	pMajorLinkerVersion            	byte "	MajorLinkerVersion :             0x",0
	pMinorLinkerVersion            	byte "	MinorLinkerVersion :             0x",0
	pSizeOfCode                    	byte "	SizeOfCode :                     0x",0
	pSizeOfInitializedData         	byte "	SizeOfInitializedData :          0x",0
	pSizeOfUninitializedData       	byte "	SizeOfUninitializedData :        0x",0
	pAddressOfEntryPoint           	byte "	AddressOfEntryPoint :            0x",0
	pBaseOfCode                    	byte "	BaseOfCode :                     0x",0
	pBaseOfData                    	byte "	BaseOfData :                     0x",0
	pImageBase                     	byte "	ImageBase :                      0x",0
	pSectionAlignment              	byte "	SectionAlignment :               0x",0
	pFileAlignment                 	byte "	FileAlignment :                  0x",0
	pMajorOperatingSystemVersion   	byte "	MajorOperatingSystemVersion :    0x",0
	pMinorOperatingSystemVersion   	byte "	MinorOperatingSystemVersion :    0x",0
	pMajorImageVersion             	byte "	MajorImageVersion :              0x",0
	pMinorImageVersion             	byte "	MinorImageVersion :              0x",0
	pMajorSubsystemVersion         	byte "	MajorSubsystemVersion :          0x",0
	pMinorSubsystemVersion         	byte "	MinorSubsystemVersion :          0x",0
	pWin32VersionValue             	byte "	Win32VersionValue :              0x",0
	pSizeOfImage                   	byte "	SizeOfImage :                    0x",0
	pSizeOfHeaders                 	byte "	SizeOfHeaders :                  0x",0
	pCheckSum                      	byte "	CheckSum :                       0x",0
	pSubsystem                     	byte "	Subsystem :                      0x",0
	pDllCharacteristics            	byte "	DllCharacteristics :             0x",0
	pSizeOfStackReserve            	byte "	SizeOfStackReserve :             0x",0
	pSizeOfStackCommit             	byte "	SizeOfStackCommit :              0x",0
	pSizeOfHeapReserve             	byte "	SizeOfHeapReserve :              0x",0
	pSizeOfHeapCommit              	byte "	SizeOfHeapCommit :               0x",0
	pLoaderFlags                   	byte "	LoaderFlags :                    0x",0
	pNumberOfRvaAndSizes           	byte "	NumberOfRvaAndSizes :            0x",0

	
; ---------Section Header-----------

	pVirtualSize				byte "	VirtualSize:						0x",0	
	pVirtualAddress				byte "	VirtualAddress:						0x",0
	pSizeOfRawData1				byte "	SizeOfRawData:						0x",0
	pPointerToRawData1			byte "	PointerToRawData:					0x",0
	pPointerToRelocations		byte "	PointerToRelocations:					0x",0
	pPointerToLinenumbers1		byte "	PointerToLinenumbers:					0x",0
	pNumberOfRelocations		byte "	NumberOfRelocations:					0x",0
	pNumberOfLinenumbers		byte "	NumberOfLinenumbers:					0x",0
	pCharacteristics1			byte "	Characteristics:					0x",0

; ---------Export Directory-----------
	pMajorVersion 			byte "	MajorVersion :           0x", 0
	pMinorVersion 			byte "	MinorVersion :           0x", 0
	pName 					byte "	Name :                   0x", 0
	pBase 					byte "	Base :                   0x", 0
	pNumberOfFunctions	 	byte "	NumberOfFunctions :      0x", 0
	pNumberOfNames 			byte "	NumberOfNames :          0x", 0
	pAddressOfFunctions 	byte "	AddressOfFunctions :     0x", 0
	pAddressOfNames 		byte "	AddressOfNames :         0x", 0
	pAddressOfNamesOrdinal 	byte "	AddressOfNamesOrdinal :  0x", 0

	numberOfFunctions 		dword 0
	numberOfNames 			dword 0
	addressOfFunctions 		dword 0
	addressOfNames 			dword 0	


	maxChar equ 256
	NULL equ 0

.data?
	stdInHandle 	HANDLE ?
	stdOutHandle 	HANDLE ?
	fileHandle 		HANDLE ? 
	filename 		db 256	dup(?) 
	fbuffer 		db 10240 dup(?)
	buffer  		db 256  dup(?)
	ImageNTHeader 	db 256  dup(?)
	
.code

main proc	
	
	lea rdi, [inpName]
	push rdi 
	call PrintString
	
	lea rdi, [filename]
	push rdi 
	call ReadString
	
	 
	call open_read
	
	
		
	call PrintDosHHeader
	call PrintNTHeader
	call PrintOptionalHeader
	call PrintImportDirectory
	call PrintExportDirectory
	
	
	push 0 
	call ExitProcess
	

main endp

PrintDosHHeader proc
.data 
	pnotpe db "file is not an PE file!!", 0 
.code

	cmp (IMAGE_DOS_HEADER ptr [fbuffer]).e_magic, 5A4Dh
	jz L0
	
	lea rdi, [pnotpe]
	push rdi 
	call PrintString
	
	push 0 
	call ExitProcess

L0:
	lea rdi, offset pDosHeader
	push rdi
	call PrintString

;e_magic
	lea rdi, offset p_e_magic
	push rdi
	call PrintString
	movzx rax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_magic
	push 4
	push rax
	call PrintHex
	call EndString
;e_cblp
	lea rdi, offset p_e_cblp
	push rdi
	call PrintString
	movzx rax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_cblp
	push 4
	push rax 
	call PrintHex
	call EndString
;e_cp
	lea rdi, offset p_e_cp
	push rdi
	call PrintString
	movzx rax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_cp
	push 4
	push rax 
	call PrintHex
	call EndString
;e_crlc
	lea rdi, offset p_e_crlc
	push rdi
	call PrintString
	movzx rax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_crlc
	push 4
	push rax 
	call PrintHex
	call EndString	
;e_cparhdr
	lea rdi, offset p_e_cparhdr
	push rdi
	call PrintString
	movzx rax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_cparhdr
	push 4
	push rax 
	call PrintHex
	call EndString
;e_minialloc
	lea rdi, offset p_e_minalloc
	push rdi
	call PrintString
	movzx rax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_minalloc
	push 4
	push rax 
	call PrintHex
	call EndString
;e_maxalloc
	lea rdi, offset p_e_maxalloc
	push rdi
	call PrintString
	movzx rax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_maxalloc
	push 4
	push rax 
	call PrintHex
	call EndString
;e_ss
	lea rdi, offset p_e_ss
	push rdi
	call PrintString
	movzx rax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_ss
	push 4
	push rax 
	call PrintHex
	call EndString
;e_sp
	lea rdi, offset p_e_sp
	push rdi
	call PrintString
	movzx rax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_sp
	push 4
	push rax 
	call PrintHex
	call EndString
;e_csum
	lea rdi, offset p_e_csum
	push rdi
	call PrintString
	movzx rax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_csum
	push 4
	push rax 
	call PrintHex
	call EndString
;e_ip
	lea rdi, offset p_e_ip
	push rdi
	call PrintString
	movzx rax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_ip
	push 4
	push rax 
	call PrintHex
	call EndString
;e_cs
	lea rdi, offset p_e_cs
	push rdi
	call PrintString
	movzx rax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_cs
	push 4
	push rax 
	call PrintHex
	call EndString
;e_lfarlc
	lea rdi, offset p_e_lfarlc
	push rdi
	call PrintString
	movzx rax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_lfarlc
	push 4
	push rax 
	call PrintHex
	call EndString
;e_ovno
	lea rdi, offset p_e_ovno
	push rdi
	call PrintString
	movzx rax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_ovno
	push 4
	push rax 
	call PrintHex
	call EndString
;e_oemid
	lea rdi, offset p_e_oemid
	push rdi
	call PrintString
	movzx rax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_oemid
	push 4
	push rax 
	call PrintHex
	call EndString
;e_oeminfo
	lea rdi, offset p_e_oeminfo
	push rdi
	call PrintString
	movzx rax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_oeminfo
	push 4
	push rax 
	call PrintHex
	call EndString
;e_lfanew
	lea rdi, offset p_e_lfanew
	push rdi
	call PrintString
	mov eax, (IMAGE_DOS_HEADER ptr [fbuffer]).e_lfanew
	push 8
	push rax 
	call PrintHex
	call EndString
	ret 

PrintDosHHeader endp 


PrintNTHeader proc 
.data 
	ImportDirectoryRVA 	QWORD ?
	ExportDirectoryRVA 	QWORD ?
	Entry			   	QWORD ?
	magic 				WORD ?
.code 
	mov rdx, 0
	lea rsi, [fbuffer]
	mov edx, (IMAGE_DOS_HEADER ptr [fbuffer]).e_lfanew
	add rsi, rdx
	 

	lea rdi, pNtHeader
	push rdi 
	call PrintString
	
;signature-------------------------------------------------
	lea rdi, offset pSignature
	push rdi
	call PrintString
	mov eax, (IMAGE_NT_HEADERS ptr [rsi]).Signature
	push 8
	push rax 
	call PrintHex
	call EndString		
;FileHeader------------------------------------------------
	lea rdi, offset pFileHeader
	push rdi 
	call PrintString

;machine 
	lea rdi, offset pMachine
	push rdi
	call PrintString
	movzx rax, (IMAGE_NT_HEADERS ptr [rsi]).FileHeader.Machine
	push 4
	push rax 
	call PrintHex
	call EndString		
;NumberOfSections
	lea rdi, offset pNumberOfSections
	push rdi
	call PrintString
	movzx rax, (IMAGE_NT_HEADERS ptr [rsi]).FileHeader.NumberOfSections
	push 4
	push rax 
	call PrintHex
	call EndString	
;TimeDateStamp
	lea rdi, offset pTimeDateStamp
	push rdi
	call PrintString
	mov eax, (IMAGE_NT_HEADERS ptr [rsi]).FileHeader.TimeDateStamp
	push 8
	push rax 
	call PrintHex
	call EndString	
;PointerToSymbolTable
	lea rdi, offset pPointerToSymbolTable
	push rdi
	call PrintString
	mov eax, (IMAGE_NT_HEADERS ptr [rsi]).FileHeader.PointerToSymbolTable
	push 8
	push rax 
	call PrintHex
	call EndString
;NumberOfSymbols
	lea rdi, offset pNumberOfSymbols
	push rdi
	call PrintString
	mov eax, (IMAGE_NT_HEADERS ptr [rsi]).FileHeader.NumberOfSymbols
	push 8
	push rax 
	call PrintHex
	call EndString
;SizeOfOptionalHeader
	lea rdi, offset pSizeOfOptionalHeader
	push rdi
	call PrintString
	movzx rax, (IMAGE_NT_HEADERS ptr [rsi]).FileHeader.SizeOfOptionalHeader
	push 4
	push rax 
	call PrintHex
	call EndString
;Characteristics
	lea rdi, offset pCharacteristics
	push rdi
	call PrintString
	movzx rax, (IMAGE_NT_HEADERS ptr [rsi]).FileHeader.Characteristics
	push 4
	push rax 
	call PrintHex
	call EndString
	
	
;Optional Header-------------------------------------------------
;----– standard fields-----–
	lea rdi, [pOptionHeader]
	push rdi 
	call PrintString
	
;Magic 
	lea rdi, offset pMagic
	push rdi
	call PrintString
	movzx rax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.Magic
	mov magic ,ax
	push 4
	push rax 
	call PrintHex
	call EndString		
;MajorLinkerVersion
	lea rdi, offset pMajorLinkerVersion
	push rdi
	call PrintString
	movzx rax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.MajorLinkerVersion
	push 2
	push rax 
	call PrintHex
	call EndString	
;MinorLinkerVersion
	lea rdi, offset pMinorLinkerVersion
	push rdi
	call PrintString
	movzx rax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.MinorLinkerVersion
	push 2
	push rax 
	call PrintHex
	call EndString	
;SizeOfCode
	lea rdi, offset pSizeOfCode
	push rdi
	call PrintString
	mov eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.SizeOfCode
	push 8
	push rax 
	call PrintHex
	call EndString	
;SizeOfInitializedData
	lea rdi, offset pSizeOfInitializedData
	push rdi
	call PrintString
	mov eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.SizeOfInitializedData
	push 8
	push rax 
	call PrintHex
	call EndString	
;SizeOfUninitializedData
	lea rdi, offset pSizeOfUninitializedData
	push rdi
	call PrintString
	mov eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.SizeOfUninitializedData
	push 8
	push rax 
	call PrintHex
	call EndString	
;AddressOfEntryPoint
	lea rdi, offset pAddressOfEntryPoint
	push rdi
	call PrintString
	mov eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.AddressOfEntryPoint
	mov Entry, rax 
	push 8
	push rax 
	call PrintHex
	call EndString	
;BaseOfCode
	lea rdi, offset pBaseOfCode
	push rdi
	call PrintString
	mov eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.BaseOfCode
	push 8
	push rax 
	call PrintHex
	call EndString	
;------NT additional fields-----
;BaseOfData	=== trường này chỉ có ở file 32

;struct không có BaseOfData nên từ đây sẽ dùng BaseOfCode 
;làm base với thanh ghi r14 cho 32 bits
	cmp (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.Magic, 20Bh	;10bh la 32 bit, 20bh la 64bit 
	jz ImageBase
	lea rdi, offset pBaseOfData
	push rdi
	call PrintString
	lea r14, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.BaseOfCode
	add r14, 4
	mov eax, DWORD ptr[r14]
	push 8
	push rax 
	call PrintHex
	call EndString	
	
ImageBase:	
	;file cần đọc mà là file 32 bits thì dùng r14 làm baseoffset
	;file cần đọc là 64 bit thì dùng thanh ghi r15 làm base offset
	lea r15, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.ImageBase
	add r14, 4
	;add r15, 4
;Imagebase 
	lea rdi, offset pImageBase
	push rdi
	call PrintString
	cmp (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.Magic, 20Bh
	jz L0
;32bits
	mov eax, DWORD ptr [r14]
	push 8
	push rax 
	jmp L1 
;baseData + BaseOfCode
L0: ;64bits	
	mov rax, QWORD ptr [r15]
	push 16
	push rax
	
L1:	
	call PrintHex
	call EndString	
;SectionAlignment
	lea rdi, offset pSectionAlignment
	push rdi
	call PrintString
	mov eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.SectionAlignment
	push 8
	push rax 
	call PrintHex
	call EndString	

;FileAlignment
	lea rdi, offset pFileAlignment
	push rdi
	call PrintString
	mov eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.FileAlignment
	push 8
	push rax 
	call PrintHex
	call EndString
;MajorSubsystemVersion
	lea rdi, offset pMajorOperatingSystemVersion
	push rdi
	call PrintString
	movzx eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.MajorOperatingSystemVersion
	push 4
	push rax 
	call PrintHex
	call EndString
;MinorOperatingSystemVersion
	lea rdi, offset pMinorOperatingSystemVersion
	push rdi
	call PrintString
	movzx eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.MinorOperatingSystemVersion
	push 4
	push rax 
	call PrintHex
	call EndString
;MajorImageVersion
	lea rdi, offset pMajorImageVersion
	push rdi
	call PrintString
	movzx eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.MajorImageVersion
	push 4
	push rax 
	call PrintHex
	call EndString
;MinorImageVersion
	lea rdi, offset pMinorImageVersion
	push rdi
	call PrintString
	movzx eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.MinorImageVersion
	push 4
	push rax 
	call PrintHex
	call EndString
;MajorSubsystemVersion
	lea rdi, offset pMajorSubsystemVersion
	push rdi
	call PrintString
	movzx eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.MajorSubsystemVersion
	push 4
	push rax 
	call PrintHex
	call EndString
;MinorSubsystemVersion
	lea rdi, offset pMinorSubsystemVersion
	push rdi
	call PrintString
	movzx eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.MinorSubsystemVersion
	push 4
	push rax 
	call PrintHex
	call EndString
;Win32VersionValue
	lea rdi, offset pWin32VersionValue
	push rdi
	call PrintString
	mov eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.Win32VersionValue
	push 8
	push rax 
	call PrintHex
	call EndString
;SizeOfImage
	lea rdi, offset pSizeOfImage
	push rdi
	call PrintString
	mov eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.SizeOfImage
	push 8
	push rax 
	call PrintHex
	call EndString
;SizeOfHeaders
	lea rdi, offset pSizeOfHeaders
	push rdi
	call PrintString
	mov eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.SizeOfHeaders
	push 8
	push rax 
	call PrintHex
	call EndString
;CheckSum
	lea rdi, offset pCheckSum
	push rdi
	call PrintString
	mov eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.CheckSum
	push 8
	push rax 
	call PrintHex
	call EndString
;Subsystem
	lea rdi, offset pSubsystem
	push rdi
	call PrintString
	movzx eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.Subsystem
	push 4
	push rax 
	call PrintHex
	call EndString
;DllCharacteristics
	lea rdi, offset pDllCharacteristics
	push rdi
	call PrintString
	movzx eax, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.DllCharacteristics
	push 4
	push rax 
	call PrintHex
	call EndString

;-------------------
;SizeOfStackReserve thì 32 bits và 64 bits khác nhau về kích thước 
;SizeOfStackReserve
	lea rdi, offset pSizeOfStackReserve
	push rdi 
	call PrintString
	cmp (IMAGE_NT_HEADERS ptr[rsi]).OptionalHeader.Magic, 20Bh
	jz	L2
;32 bits
	push 8
	mov rax, (IMAGE_NT_HEADERS ptr[rsi]).OptionalHeader.SizeOfStackReserve
	push rax 
	jmp L3
L2: ;64bit
	push 16
	mov rax, (IMAGE_NT_HEADERS ptr[rsi]).OptionalHeader.SizeOfStackReserve
	push rax 
L3:
	call PrintHex
	call EndString
	
;từ SizeOfStackCommit thì 32 bits và 64 bits khác nhau về kích thước
;và offset nên từ đây sẽ dùng SizeOfStackReserve làm base offset

	;file cần đọc mà là file 32 bits thì dùng r14 làm base offset
	;file cần đọc là 64 bit thì dùng thanh ghi r15 làm base offset
	lea r15, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.SizeOfStackReserve
	lea r14, (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.SizeOfStackReserve
	add r14, 4
	add r15, 8
;SizeOfStackCommit 
	lea rdi, offset pSizeOfStackCommit
	push rdi
	call PrintString
	cmp (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.Magic, 20Bh
	jz L4
;32bits
	mov eax, DWORD ptr [r14]
	push 8
	push rax 
	jmp L5 
L4: ;64bits	
	mov rax, QWORD ptr [r15]
	push 16
	push rax
L5:	
	call PrintHex
	call EndString	
	
	
;SizeOfHeapReserve
	add r14, 4	;offset SizeOfStackCommit + 4
	add r15, 8	;offset SizeOfStackCommit + 8
	;file cần đọc mà là file 32 bits thì dùng r14 làm base offset
	;file cần đọc là 64 bit thì dùng thanh ghi r15 làm base offset
	lea rdi, offset pSizeOfHeapReserve
	push rdi
	call PrintString
	cmp (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.Magic, 20Bh
	jz L6
;32bits
	mov eax, DWORD ptr [r14]
	push 8
	push rax 
	jmp L7 
L6: ;64bits	
	mov rax, QWORD ptr [r15]
	push 16
	push rax
L7:	
	call PrintHex
	call EndString	

;SizeOfHeapCommit
	add r14, 4	;offset SizeOfHeapReserve + 4
	add r15, 8	;offset SizeOfHeapReserve + 8
	;file cần đọc mà là file 32 bits thì dùng r14 làm base offset
	;file cần đọc là 64 bit thì dùng thanh ghi r15 làm base offset
	lea rdi, offset pSizeOfHeapCommit
	push rdi
	call PrintString
	cmp (IMAGE_NT_HEADERS ptr [rsi]).OptionalHeader.Magic, 20Bh
	jz L8
;32bits
	mov eax, DWORD ptr [r14]
	push 8
	push rax 
	jmp L9 
;baseData + BaseOfCode
L8: ;64bits	
	mov rax, QWORD ptr [r15]
	push 16
	push rax
L9:	
	call PrintHex
	call EndString	
	
	
;từ LoaderFlags thì chỉ khác nhau về offset		
;LoaderFlags
	add r14, 4	;offset SizeOfHeapCommit + 4
	add r15, 8	;offset SizeOfHeapCommit + 8
	
	lea rdi, offset pLoaderFlags
	push rdi 
	call PrintString
	cmp (IMAGE_NT_HEADERS ptr[rsi]).OptionalHeader.Magic, 20Bh
	jz	L10
;32 bits
	push 8
	mov eax, DWORD ptr[r14]
	push rax 
	jmp L11
L10: ;64bit
	push 8
	mov eax, DWORD ptr[r15]
	push rax 
L11:
	call PrintHex
	call EndString


;NumberOfRvaAndSizes
	add r14, 4	;offset LoaderFlags + 4
	add r15, 4	;offset LoaderFlags + 4
	
	lea rdi, offset pNumberOfRvaAndSizes
	push rdi 
	call PrintString
	cmp (IMAGE_NT_HEADERS ptr[rsi]).OptionalHeader.Magic, 20Bh
	jz	L12
;32 bits
	push 8
	mov eax, DWORD ptr[r14]
	push rax 
	jmp L13
L12: ;64bit
	push 8
	mov eax, DWORD ptr[r15]
	push rax 
L13:
	call PrintHex
	call EndString
	
	cmp (IMAGE_NT_HEADERS ptr[rsi]).OptionalHeader.Magic, 20Bh
	jz L14
	mov rsi, r14
	jmp L15
	
L14:
	mov rsi, r15
L15:
	add rsi, 4
	mov eax, DWORD ptr[rsi]
	

	mov ExportDirectoryRVA, rax

	add rsi, 8
	mov eax, DWORD ptr[rsi]
	mov eax, DWORD ptr[rsi]
	mov ImportDirectoryRVA, rax 

	ret

PrintNTHeader endp


PrintOptionalHeader proc 

.data 
	text_rawOffset 	QWORD ?
	text_VA 	   	QWORD ? 
	virtual_size 	QWORD ?
	store_section	QWORD ?
.code 
	
	lea rdi, offset pOptionHeader
	push rdi
	call PrintString

;offset IMAGE_SECTION_HEADER = IMAGE_NT_HEADERS + 124 + 8 
	mov ax, magic
	cmp magic, 20Bh
	jnz L1 
	mov rsi, r15  
	jmp L2 
L1:
	mov rsi, r14
L2:
	add rsi, 124
	add rsi, 8
L0:	
	push rsi
	call PrintSectionName
	
	lea rdi, offset endl
	push rdi 
	call PrintString

;VirtualSize		
	lea rdi, offset pVirtualSize
	push rdi 
	call PrintString

	push 8 
	mov eax, DWORD ptr[rsi + 8]
	push rax 
	call PrintHex 
	call EndString
	mov eax, DWORD ptr[rsi + 8]
	mov virtual_size, rax 

;VirtualAddress
	lea rdi, offset pVirtualAddress
	push rdi 
	call PrintString

	push 8 
	mov eax, DWORD ptr[rsi + 12]
	push rax 
	call PrintHex 
	;cmp DWORD ptr[rsi], 7865742eh
	;;jnz L2
	mov eax, DWORD ptr[rsi + 12]
	mov text_VA, rax
;L2:
	call EndString
	
;SizeOfRawData
	lea rdi, offset pSizeOfRawData1
	push rdi 
	call PrintString

	push 8 
	mov eax, DWORD ptr[rsi + 16]
	push rax 
	call PrintHex 
	call EndString

;PointerToRawData
	lea rdi, offset pPointerToRawData1
	push rdi 
	call PrintString

	push 8 
	mov eax, DWORD ptr[rsi + 20]
	push rax 
	call PrintHex 
	;cmp DWORD ptr[rsi], 7865742eh
	;jnz L1
	mov eax, DWORD ptr[rsi + 20]
	mov text_rawOffset, rax
;L1:
	call EndString
	
;PointerToRelocations
	lea rdi, offset pPointerToRelocations
	push rdi 
	call PrintString

	push 8 
	mov eax, DWORD ptr[rsi + 24]
	push rax 
	call PrintHex 
	call EndString
	
;PointerToLinenumbers
	lea rdi, offset pPointerToLinenumbers1
	push rdi 
	call PrintString

	push 8 
	mov eax, DWORD ptr[rsi + 28]
	push rax 
	call PrintHex 
	call EndString
	
;NumberOfRelocations
	lea rdi, offset pNumberOfRelocations
	push rdi 
	call PrintString

	push 4
	mov eax, DWORD ptr[rsi + 32]
	push rax 
	call PrintHex 
	call EndString
	
;NumberOfLinenumbers
	lea rdi, offset pNumberOfLinenumbers
	push rdi 
	call PrintString

	push 4
	mov eax, DWORD ptr[rsi + 34]
	push rax 
	call PrintHex 
	call EndString
	
;Characteristics
	lea rdi, offset pCharacteristics1
	push rdi 
	call PrintString

	push 8
	mov eax, DWORD ptr[rsi + 36]
	push rax 
	call PrintHex 
	call EndString
	
	; if(ImportDirectoryRVA >= VirualAddress && lImportDirectoryRVA < VirualAddress + VirualSize)
	;			=> ImportDirectory thuộc section này
	
	mov rax, text_VA		;VirtualAddress
	mov rbx, virtual_size
	add rbx, rax			;VirualAddress + VirualSize
	cmp ImportDirectoryRVA, rax
	jl	L5
	cmp ImportDirectoryRVA, rbx
	jae L5 
	mov store_section, rsi 
	
	
L5:
	mov r10b, BYTE ptr[rsi + 40]
	add rsi, 40
	cmp r10b, 2Eh		;ký tự . để xác định section
	jz L0
	add r15, 8
	ret 
	
PrintOptionalHeader endp 
;----------------------------------------------------------


PrintImportDirectory proc 
.data
	imageBase1 QWORD ? 
	Ordinal 	byte "Ordinal : 0x",0
	tab 		byte "	", 0
.code 
;tính offset của ImportDirectory theo link https://www.ired.team/miscellaneous-reversing-forensics/windows-kernel-internals/pe-file-header-parser-in-c++
	
	lea rdi, [pImportDirectory]
	push rdi 
	call PrintString
	
;offset = imageBase+text.RawOffset+(importDirectory.RVA−text.VA)
	xor r14, r14
	mov rsi, offset fbuffer
	mov rdi, store_section 
	mov r14d, (IMAGE_SECTION_HEADER ptr [rdi]).PointerToRawData		;text.RawOffset =  PointerToRawData của offset lưu tính ở trên 
	add rsi, r14		
	mov imageBase1, rsi 
	mov r15,   ImportDirectoryRVA									;ImportDirectoryRVA tính trong NT header 
	mov r14d, (IMAGE_SECTION_HEADER ptr [rdi]).VirtualAddress		;text.VA = Virtual Address của section tính ở trên 
	sub r15, r14				
	
;tính được offset của PIMAGE_IMPORT_DESCRIPTOR vào rsi 
	add rsi, r15 
;cộng 12 trong PIMAGE_IMPORT_DESCRIPTOR để ra offset của Name 
	add rsi, 12
	mov ebx, DWORD ptr [rsi] 


;DLL đầu tiên offset = imageBase+text.RawOffset+(nameRVA−text.VA)
	mov rax, imageBase1
	add rax, rbx				;imageBase + text.RawOffset + nameRVA
	mov ebx, (IMAGE_SECTION_HEADER ptr [rdi]).VirtualAddress		;text.VA = Virtual Address của section tính ở trên 
	sub rax, rbx

	push rax 
	call PrintString
	
	lea rax, [endl]
	push rax 
	call PrintString
	
	lea rax, [tab]
	push rax 
	call PrintString
	
	
	
	
;tính các DLL Imported Functions
	; if OriginalFirstThunk != 0
	;		=> thunk = OriginalFirstThunk
	; else thunk = FirstThunk	
	
	cmp  DWORD ptr [rsi - 12], 0 			;OriginalFirstThunk với offset là Name 
	jz L1 
	mov ebx, DWORD ptr [rsi + 4]			;thunk				với offset là Name 
	jmp L2
L1:	
	mov ebx, 0 
L2:

	mov rax, imageBase1
	add rax, rbx				;imageBase + text.RawOffset + thunk 
	mov ebx, (IMAGE_SECTION_HEADER ptr [rdi]).VirtualAddress		;text.VA = Virtual Address của section tính ở trên 
	sub rax, rbx

;tính offset của PIMAGE_THUNK_DATA32
	mov rsi, rax 
	
;for (; thunkData->u1.AddressOfData != 0; thunkData++) {
			;//a cheap and probably non-reliable way of checking if the function is imported via its ordinal number ¯\_(ツ)_/¯
			;if (thunkData->u1.AddressOfData > 0x80000000) {
				;//show lower bits of the value to get the ordinal ¯\_(ツ)_/¯
				;printf("\t\tOrdinal: %x\n", (WORD)thunkData->u1.AddressOfData);
			;} else {
				;printf("\t\t%s\n", (rawOffset + (thunkData->u1.AddressOfData - importSection->VirtualAddress + 2)));
L5:
	cmp DWORD ptr[rsi], 0
	jz L4 
	cmp DWORD ptr[rsi], 80000000h
	ja L6 
;else {
		;printf("\t\t%s\n", (rawOffset + (thunkData->u1.AddressOfData - importSection->VirtualAddress + 2)));
	mov rax, imageBase1
	mov edx, DWORD ptr[rsi] 
	add rax, rdx
	mov edx, (IMAGE_SECTION_HEADER ptr [rdi]).VirtualAddress
	sub rax, rdx
	add rax, 2
	push rax
	call PrintString
	
	lea rax, [endl]
	push rax 
	call PrintString
	
	lea rax, [tab]
	push rax 
	call PrintString
	
	jmp L7
L6: ;if (thunkData->u1.AddressOfData > 0x80000000) {
				;//show lower bits of the value to get the ordinal ¯\_(ツ)_/¯
				;printf("\t\tOrdinal: %x\n", (WORD)thunkData->u1.AddressOfData);
	lea r15, [Ordinal]
	push r15 
	call PrintString

	mov eax, DWORD ptr[rsi]
	push 4
	push rax 
	call PrintHex
	call EndString

L7:
	add rsi, 4
	jmp L5 

L4: 
	ret 
PrintImportDirectory endp 
;----------------------------------------------------------


PrintExportDirectory proc 
	cmp ExportDirectoryRVA, 0 
	jz L10 
	
	lea rdi, [ExportDirectoryRVA]
	push rdi 
	call PrintString
	
;tính offset của IMAGE_EXPORT_DIRECTORY theo công thức của link 
;https://www.ired.team/miscellaneous-reversing-forensics/windows-kernel-internals/pe-file-header-parser-in-c++ 

;imageBase+text.RawOffset+(ExportDirectoryRVA−text.VA)
 	xor r14, r14
	mov rsi, offset fbuffer
	mov rdi, store_section 
	mov r14d, (IMAGE_SECTION_HEADER ptr [rdi]).PointerToRawData		;text.RawOffset =  PointerToRawData của offset lưu tính ở trên 
	add rsi, r14		
	mov imageBase1, rsi 
	mov r15,   ExportDirectoryRVA									;ExportDirectoryRVA tính trong NT header 
	mov r14d, (IMAGE_SECTION_HEADER ptr [rdi]).VirtualAddress		;text.VA = Virtual Address của section tính ở trên 
	sub r15, r14	

;offset của IMAGE_EXPORT_DIRECTORY
	mov rsi, r15 
		
;Characteristics
	lea rdi, offset pCharacteristics
	push rdi 
	call PrintString
	mov eax, (IMAGE_EXPORT_DIRECTORY ptr [rsi]).Characteristics
	push 8
	push rax
	call PrintHex
	call EndString

;TimeDateStamp
	lea rdi, offset pTimeDateStamp
	push rdi 
	call PrintString
	mov eax, (IMAGE_EXPORT_DIRECTORY ptr [rsi]).TimeDateStamp
	push 8
	push rax
	call PrintHex
	call EndString

;MajorVersion
	lea rdi, offset pMajorVersion
	push rdi 
	call PrintString
	push 4
	movzx rax,(IMAGE_EXPORT_DIRECTORY ptr [rsi]).MajorVersion
	push rax
	call PrintHex
	call EndString

;MinorVersion
	lea rdi, offset pMinorVersion
	push rdi 
	call PrintString
	push 4
	movzx rax,(IMAGE_EXPORT_DIRECTORY ptr [rsi]).MinorVersion
	push rax
	call PrintHex
	call EndString

;Name 
	lea rdi, offset pName
	push rdi 
	call PrintString
	mov eax, (IMAGE_EXPORT_DIRECTORY ptr [rsi]).nName
	push 8
	push rax
	call PrintHex
	call EndString
;Base 
	lea rdi, offset pBase
	push rdi 
	call PrintString
	mov eax, (IMAGE_EXPORT_DIRECTORY ptr [rsi]).nBase
	push 8
	push rax
	call PrintHex
	call EndString

;NumberOfFunctions
	lea rdi, offset pNumberOfFunctions
	push rdi 
	call PrintString
	mov eax, (IMAGE_EXPORT_DIRECTORY ptr [rsi]).NumberOfFunctions
	push 8
	push rax
	call PrintHex
	call EndString

;NumberOfNames
	lea rdi, offset pNumberOfNames
	push rdi 
	call PrintString
	mov eax, (IMAGE_EXPORT_DIRECTORY ptr [rsi]).NumberOfNames
	push 8
	push rax
	call PrintHex
	call EndString

;AddressOfFunctions
	lea rdi, offset pAddressOfFunctions
	push rdi 
	call PrintString
	mov eax, (IMAGE_EXPORT_DIRECTORY ptr [rsi]).AddressOfFunctions
	push 8
	push rax
	call PrintHex
	call EndString

;AddressOfNames
	lea rdi, offset pAddressOfNames
	push rdi 
	call PrintString
	mov eax, (IMAGE_EXPORT_DIRECTORY ptr [rsi]).AddressOfNames
	push 8
	push rax
	call PrintHex
	call EndString

;AddressOfNameOrdinals
	lea rdi, offset pAddressOfNamesOrdinal
	push rdi 
	call PrintString
	mov eax, (IMAGE_EXPORT_DIRECTORY ptr [rsi]).AddressOfNameOrdinals
	push 8
	push rax
	call PrintHex
	call EndString

L10:
	ret 
	
PrintExportDirectory endp 
;----------------------------------------------------------
open_read proc
	push rbp
	mov rbp, rsp 
	sub rsp, 190h 
	
	push rdx
	push rcx
	push r8
	push r9

;_openfile:
	mov     QWORD ptr[rsp+170h-140h], 0 		; hTemplateFile
	mov     QWORD ptr[rsp+170h-148h], 80h 		; dwFlagsAndAttributes
	mov     QWORD ptr[rsp+170h-150h], 3 		; dwCreationDisposition 
	mov     r9d, 0          ; lpSecurityAttributes
	mov     r8d, 1         	; dwShareMode
	mov     edx, 80000000h  ; dwDesiredAccess
	lea     rax, [filename]   		
	mov     rcx, rax        ; fileName
	call CreateFile

	lea rdi, [pReadFileErr]
	cmp rax,INVALID_HANDLE_VALUE
	jne L1
	push rdi		;pReadFileErr
	call PrintString 

	push 0
	call ExitProcess
L1:
	mov fileHandle,	rax
	
;_readfile:	
	
	mov QWORD ptr[rbp+0F0h-10h], 100h
	mov QWORD ptr[rbp+0F0h-14h], 2800h	;10mb
	mov QWORD ptr[rbp+0F0h-124h], 0
	mov QWORD ptr [rsp+170h-150h], 0 	; lpOverlapped
	lea r9, [rbp+0F0h-124h]
	mov r8d, [rbp+0F0h-14h]
	lea rdx, [fbuffer] ; lpBuffer
	mov rcx, fileHandle

	call ReadFile
	
	
	pop r9 
	pop r8 
	pop rcx 
	pop rdx 
	
	mov rsp, rbp 
	pop rbp 
	ret 
	
open_read endp
;----------------------------------------------------------

EndString Proc
.data 
	endl byte 0dh, 0ah, 0
.code 
	lea rdi, [endl]
	push rdi 
	call PrintString
	ret 
EndString endp 


PrintHex proc
.data 
	hbuffer db 256 dup(?)
.code 
	push rbp 
	mov rbp, rsp 
	sub rsp, 32 
	
	push r15
	push r14
	push rcx 
	
	

	lea r14, [hbuffer]					;buffer to print hex char 
	mov r15, QWORD ptr[rbp + 16]		
	mov rcx, QWORD ptr[rbp + 24]
	add r14, maxChar 
	dec r14 
	
;=============================================	
L1:						
	
	mov rbx, 16
	mov rdx, 0 
	div rbx 			
	cmp dl, 9
	ja L2 
	add dl, 30h 				;ký tự trong khoảng từ 0-9
	jmp L3 
L2:	
	add dl, 'a'
	sub dl, 10					;ký tự trong khoảng từ 10-15 
	
L3:
	mov BYTE ptr[r14], dl
	
	dec r14 
	dec rcx
	cmp rcx, 0 
	jnz L1

	inc r14 
	push r14
	call PrintString

	pop rcx 
	pop r14
	pop r15
	
	mov rsp, rbp 
	pop rbp 
	ret 16 
PrintHex endp
;===========================================================================================


PrintSectionName proc 
	push rbp 
	mov rbp, rsp 
	sub rsp, 30h 
	
	push rdx
	push rcx
	push rax
	push r15
	push r8
	push r9
	

	
	mov rcx, -11
	call GetStdHandle

	
	mov rcx, rax								;hConsoleOutput
	mov rdx, QWORD ptr[rbp + 10h]				;*lpBuffer
	mov r8, 8									;nNumberOfCharsToWrite
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
PrintSectionName endp 



PrintNumber proc  
	push rbp
	mov rbp, rsp 
	sub rsp, 32
	
	push r15
	push r14
	push rdx 
	push rcx 
	push rbx
	push rax
	
	mov r15, QWORD ptr[rbp + 16]				;number
	mov QWORD ptr[rbp - 8], 10				
	lea r14, [rbp - 16]							;store string of number 
	mov rcx, 0
	mov rax, r15
	
;----------------------------------------------	
L0:
	mov rdx, 0
	div QWORD ptr[rbp - 8]
	add rdx, 30h
	mov BYTE ptr[r14], dl  
	add r14, 1
	add rcx, 1
	cmp rax, 0
	jnz L0
;----------------------------------------------tách chữ số của số rồi cộng với 30 để đổi thành xâu 	

	lea r15, [rbp - 32]
	lea r14, [rbp - 16]
	mov rdx, 0
;----------------------------------------------
L1:
	mov bl, BYTE ptr[r14 + rcx -1]
	mov BYTE ptr[r15], bl
	add r15, 1
	add rdx, 1											;string_len
	sub rcx, 1
	cmp rcx, 0
	jnz L1
	
	mov QWORD ptr[r15], 0								;thêm ký tự null vào cuối chuỗi
	
	lea rdi, [rbp - 32]
	push rdi 
	call PrintString
;----------------------------------------------in xâu của chữ số vửa đổi ra màn hình 
	
	pop rax 
	pop rbx
	pop rcx
	pop rdx 
	pop r14
	pop r15
	mov rsp, rbp 
	pop rbp 
	ret 8
PrintNumber endp
;=========================================================================================== 



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


;----------------------------------------------------------
ReadString proc
	push rbp 
	mov rbp, rsp 
	sub rsp, 28h
	
	push rdx
	push rcx
	push rax
	push r8
	push r9
	
	
	mov rcx, -10 
	call GetStdHandle
		
	mov rcx, rax 											;hConsoleInput
	mov rdx, QWORD ptr[rbp + 10h]							;*lpBuffer
	mov r8, maxChar											;nNumberOfCharsToRead
	lea r9, [rbp - 8]										;lpNumberOfCharsRead
	call ReadConsole
	
L0:
	mov dl, BYTE ptr[rdi]
	cmp dl, 13	
	jz L1
	add rdi, 1
	jmp L0

L1:
	mov BYTE ptr[rdi], 0									;remove 13 at end of string
	
	pop r9
	pop r8
	pop rax
	pop rcx
	pop rdx
	
	mov rsp, rbp 
	pop rbp
	ret 8
	
ReadString endp
;----------------------------------------------------------
end
