Include Irvine16.inc
.data
;main
mainstr00 BYTE "Select the number of task to perform",0ah,0dh,0
mainstr01 BYTE "1. Given integer array of size N. Remove from the array of all elements that occur more than two times.",0ah,0dh,0
mainstr02 BYTE "2. Search and replace the specified sequence of bytes into another sequence in a file or group of files.",0ah,0dh,0
mainstr03 BYTE "3. Exit.",0ah,0dh,"You choose:",0
mainstr04 BYTE "Wrong input data, please repeat enter.",0ah,0dh,0
ChosenTask WORD 0
;First
;SFAZ=24
Mugeno BYTE 100 dup (?)
Numeno BYTE 100 dup (?)
SizeOfArray WORD 0
str00 BYTE "Enter the size N of array (Range from 1 to 100):",0ah,0dh,0
str0 BYTE "Content before processing:",0ah,0dh,0
str1 BYTE "Content after processing:",0ah,0dh,0
str2 BYTE "Result array:",0ah,0dh,0
count  BYTE 0
;Second 
BufSizeF=1
SequenceOfBytes0 BYTE 6 DUP(0)
SequenceOfBytes1 BYTE 6 DUP(0)
NumR BYTE ?
TempE BYTE 65
Temp2 WORD 0
NumFs BYTE 0
SwitchF WORD 1 DUP(0)
ac_strm3 BYTE 0
strm0 BYTE "Please enter string, what must find:",0,0dh,0ah
strm1 BYTE "Please enter string in what must replace:",0,0dh,0ah
strm2 BYTE "Please enter the adress of the file:",0,0dh,0ah
strm3 BYTE "Content of the file before processing:",0,0dh,0ah
strm5 BYTE "Want to replace this sequence of bytes in more files? (Yes (1)/No (Other)):",0,0dh,0ah
strm6 BYTE "Processing is completed.",0,0dh,0ah
ErrorMsg BYTE "Error! Can't do this operation.",0,0dh,0ah
NameofFile0 BYTE 20 DUP(0)
inHandle  WORD ?
bytesRead WORD 0
OutSymb WORD ?
bufferF BYTE BufSizeF DUP(?)
countF BYTE 0
.code
main PROC
	mov ax,@data
	mov ds,ax
;vivod soobsheniya 
	mov ah,40h
	mov bx,1
	mov cx,SIZEOF mainstr00
	mov dx,OFFSET mainstr00
	int 21h
;vivod soobsheniya 
	mov ah,40h
	mov bx,1
	mov cx,SIZEOF mainstr01
	mov dx,OFFSET mainstr01
	int 21h
;vivod soobsheniya 
	mov ah,40h
	mov bx,1
	mov cx,SIZEOF mainstr02
	mov dx,OFFSET mainstr02
	int 21h
;vivod soobsheniya 
	mov ah,40h
	mov bx,1
	mov cx,SIZEOF mainstr03
	mov dx,OFFSET mainstr03
	int 21h
	jmp begins
reptask:
	mov ah,40h
	mov bx,1
	mov cx,SIZEOF mainstr04
	mov dx,OFFSET mainstr04
	int 21h
begins:
;enter task
 	Call ReadInt
	mov ChosenTask,ax
	Call GOSTR
 	cmp ChosenTask,1
	je ftask
	cmp ChosenTask,2
	je stask
	cmp ChosenTask,3
	je etask
	jmp reptask
ftask:	Call FirstP
stask: 	Call SecondP
etask:	mov ah,4Ch
	int 21h	
main ENDP
FirstP PROC
;vivod	
	mov dx,OFFSET str00
	Call WriteString
	Call ReadInt
	mov SizeOfArray,ax
	Call GOSTR
;zapolnenie	
	mov cx,SizeOfArray
	mov si,0
allctd:
	mov ax,25
	call RandomRange
	;add ax,65
	mov Mugeno[si],al
	inc si
	loop allctd
;vivod	
	mov dx,OFFSET str0
	Call WriteString
	mov cx,SizeOfArray
	mov si,0
	xor ax,ax
	mov ah,0
showd:
	mov al,Mugeno[si]
	Call WriteDec
	Call GOSTR
	inc si
	loop showd
;copirovanie
	mov cx,SizeOfArray
	mov si,0
	xor ax,ax
	mov ah,0
copyd:
	mov al,Mugeno[si]
	mov Numeno[si],al
	inc si
	loop copyd	
;obrabotka	
	mov cx,SizeOfArray
	mov si,0
	xor ax,ax
	mov ah,0
	mov di,0
	mov count,0
procng:	
	mov ah,Numeno[di]
	cmp Mugeno[si],ah
	je eqll
	jmp ndlt
eqll:	inc count
	cmp count,3
	jae dlt
	jmp ndlt
dlt:	mov Numeno[di],0
ndlt:	inc di	
	cmp di,SizeOfArray ;SFAZ
	jne procng
        mov di,0
	mov count,0
	inc si
	cmp si,SizeOfArray ;SFAZ
	je nprocng
	jmp procng
nprocng: 
;vivod	
	mov dx,OFFSET str1
	Call WriteString
	
	mov cx,SizeOfArray
	mov si,0
	xor ax,ax
	mov ah,0
showd2:
	mov al,Numeno[si]
	Call WriteDec
	Call GOSTR
	inc si
	loop showd2
;copirovanie v 1
	mov cx,49
	mov si,0
	mov di,0
copyd2:
 	cmp Numeno[di],0
	je incN
	jmp noincN
incN:	inc di
 	jmp copyd2
noincN:	
	mov al,Numeno[di]
	mov Mugeno[si],al
	inc di
	inc si
	cmp di,SizeOfArray
	jb copyd2
cmpext:	cmp si,SizeOfArray ;25
	jne extendedzero
	jmp nextendedzero
extendedzero:
	mov al,0
	mov Mugeno[si],al
	inc si
	jmp cmpext
nextendedzero:	

;vivod	
	mov dx,OFFSET str2
	Call WriteString
	mov cx,SizeOfArray
	mov si,0
	mov ax,0
showd3:
	mov al,Mugeno[si]
	Call WriteDec
	Call GOSTR
	inc si
	loop showd3
;end
	Call GOSTR
	Call WaitMsg
 	mov ah,4Ch
	int 21h
FirstP ENDP
SecondP PROC
;vivod soobsheniya str0
	mov ah,40h
	mov bx,1
	mov cx,SIZEOF strm0
	mov dx,OFFSET strm0
	int 21h
;vvod kol-va simvolov
	mov dx,OFFSET SequenceOfBytes0
	mov cx,5
	Call ReadSequenceOfBytes
	mov NumR,al
	;dec NumR
	Call GOSTR
;perehod na novyu stroku	
	Call GOSTR
;vivod soobsheniya str1
	mov ah,40h
	mov bx,1
	mov cx,SIZEOF strm1
	mov dx,OFFSET strm1
	int 21h
;vvod kol-va simvolov
	mov dx,OFFSET SequenceOfBytes1
	mov cx,5
	Call ReadSequenceOfBytes
;	mov NumR,al
;perehod na novyu stroku	
	Call GOSTR
;vivod vvedennoy inf 
	mov ah,40h
	mov bx,1
	mov cx,SIZEOF SequenceOfBytes0
	mov dx,OFFSET SequenceOfBytes0
	int 21h
;perehod na novyu stroku	
repfl:  mov OutSymb,0
	mov Temp2,0
	mov NumFs,0
	mov countF,0
	mov SwitchF,0
	Call GOSTR
;vivod soobsheniya str2
	mov ah,40h
	mov bx,1
	mov cx,SIZEOF strm2
	mov dx,OFFSET strm2
	int 21h
	mov ac_strm3,1
;vvedite adres faila dlya obrabotki
	mov dx,OFFSET NameofFile0
	mov cx,19
	Call ReadSequenceOfBytes
;perehod na novyu stroku	
	Call GOSTR
;otkritie faila
	mov ax,716Ch
	mov bx,2
	mov cx,0
	mov dx,1
	mov si,OFFSET NameofFile0
	int 21h
	jc errorM
	mov inHandle,ax
	mov si,0
GLOBALF:
	mov countF,0
;Point
	mov ah,42h
	mov al,0
	mov bx,inHandle
	mov cx,0
	mov dx,OutSymb
	int 21h
	jc  errorM
; Read the input file
	mov ah,3Fh	; read file or device
	mov bx,inHandle	; file handle
	mov cx,BufSizeF	; max bytes to read
	mov dx,OFFSET bufferF	; buffer pointer
	int 21h
	jc  errorM	; quit if error
	inc OutSymb
	;mov bytesRead,ax
	cmp ax,BufSizeF 
	je rcrd
	jmp norcrd
rcrd:	mov countF,1
	mov al,bufferF
	cmp SequenceOfBytes0[si],al
	je CMPR
	jmp noCMPR
CMPR: 	inc si
	mov ah,0 ;xor ah,ah
	mov al,NumR
	cmp si,ax
	je RMVSTR
	jmp noCMPR
RMVSTR: 
	sub OutSymb,si
	mov Temp2,si
	mov si,0
	mov cx,0
LP1:		
	;Point
	mov ah,42h
	mov al,0
	mov bx,inHandle
	mov cx,0
	mov dx,OutSymb
	int 21h
	jc  errorM
	; Write buffer to new file
	mov ah,40h	; write file or device
	mov bx,inHandle	; output file handle
	mov cx,1	; number of bytes
	mov al,SequenceOfBytes1[si]
	mov TempE,al
	mov dx,OFFSET TempE ; buffer pointer
	int 21h
	inc OutSymb
	inc si
 	jc  errorM	; quit if error
 	dec Temp2
 	cmp Temp2,0
 	jne LP1
noCMPR: 
	cmp ac_strm3,1
	je showsstrm3
	jmp noshowsstrm3
showsstrm3:
	mov ac_strm3,0
;vivod soobsheniya str3
	mov ah,40h
	mov bx,1
	mov cx,SIZEOF strm3
	mov dx,OFFSET strm3
	int 21h
noshowsstrm3:
	; Display the buffer
	mov ah,40h	; write file or device
	mov bx,1	; console output handle
	mov cx,1	; number of bytes
	mov dx,OFFSET bufferF	; buffer pointer
	int 21h
	jc  errorM	; quit if error
	cmp countF,1
	je GLOBALF
norcrd:
	; Close the file
	mov  ah,3Eh    	; function: close file
	mov  bx,inHandle	; input file handle
	int  21h       	; call MS-DOS
	xor ax,ax
	mov inHandle,ax
	jc  errorM	; quit if error	
	;vivod soobsheniya str6
	Call GOSTR
	mov ah,40h
	mov bx,1
	mov cx,SIZEOF strm6
	mov dx,OFFSET strm6
	int 21h
	jmp wtg
errorM:
	mov ah,40h
 	mov bx,1
	mov cx,SIZEOF ErrorMsg
	mov dx,OFFSET ErrorMsg
	int 21h
wtg:	
;vivod soobsheniya str5
	mov ah,40h
	mov bx,1
	mov cx,SIZEOF strm5
	mov dx,OFFSET strm5
	int 21h
;vvedite komandu na povtorenie
	mov ah,1
	int 21h
	mov ah,0
	mov inHandle,0	
 	cmp al,1
 	jne repfl
;exit
	mov ah,4Ch
	int 21h
SecondP ENDP
GOSTR PROC
	push ax
	mov ah,0Eh
	mov al,0ah
	int 10h
	mov ah,0Eh
	mov al,0dh
	int 10h
	pop ax
	ret
GOSTR ENDP
ReadSequenceOfBytes PROC
	push cx
	push si
	push cx
	mov si,dx
L1R:
	mov ah,1
	int 21h
	cmp al,0Dh
	je L2R
	mov [si],al
	inc si
	loop L1R
L2R:
	mov byte ptr [si],0
	pop ax
	sub ax,cx
	pop si
	pop cx
	ret
ReadSequenceOfBytes ENDP
END main