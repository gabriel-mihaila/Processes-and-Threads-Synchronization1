.586
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern printf: proc

includelib canvas.lib
extern BeginDrawing: proc


;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;--MINESWEEPER-- Proiect realizat de Gabriel Mihaila grupa 9;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.data
;aici declaram date
window_title DB "Minesweeper - proiect",0
area_width EQU 750
area_height EQU 550
area DD 0

counter DD 0 ; numara evenimentele de tip timer

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

symbol_width EQU 10
symbol_height EQU 20

;dimensiuni matrice litere mari
symbol_width_grow equ 20
symbol_height_grow equ 36

;dimensiuni matrice bomba mare
symbol_width_grow_bomb equ 30
symbol_height_grow_bomb equ 37

;dimensiuni numere+bombe din interiorul matrice_joc
symbol_width_cell_matrice_joc equ 29
symbol_height_cell_matrice_joc equ 29

;placuta pt generarea unui joc easy
x0_new_easy dd 210
y0_new_easy dd 105
active_easy dd 0

;placuta pt generarea unui nou joc mediu
x0_new_medium dd 330
y0_new_medium dd 105
active_medium dd 1

;placuta pt generarea unui joc hard
x0_new_hard dd 450
y0_new_hard dd 105
active_hard dd 0

all_bombs dd 0

;punctul stanga sus al matricii/placutei de joc si dimeniunea unui cell
X0_matrice_joc dd 100
Y0_matrice_joc dd 100
x1_matrice_joc dd 100
y1_matrice_joc dd 160
x2_matrice_joc dd 100
y2_matrice_joc dd 130
len_matrice_joc dd 30
coloane_matrice_joc dd 18
randuri_matrice_joc dd 12
matrice_joc dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

linia_curenta dd 0
coloana_curenta dd 0			
width_matrice_joc dd 540
height_matrice_joc dd 360

valoare_curenta_matrice_eax dd 0

matrice_joc_vizitate dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 
matrice_joc_flaguri  dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
					 
flag_activator dd 0
nr_flaguri dd 40
x0_flag dd 40
y0_flag dd 280
x1_flag dd 41
y1_flag dd 281

nr_random dd 0 ;se retine nr random 0-215 unde se va plasa bomba in matrice
format db "%d ",0
rand_nou db " ",13,10,0

bomb dd 9
nr_bombe dd 40
contor_nr_bombe_vecine dd 0
contor_victorie dd 0

;contor+plasare counter bombe
counter_nr_bombe dd 40
x0_counter_bombe dd 135
y0_counter_bombe dd 105

;counter timp incepere joc
counter_timp_joc dd 0
x0_counter_timp_joc dd 580
y0_counter_timp_joc dd 105

 
include digits.inc
include letters.inc
include grow_letters.inc
include grow_bomb.inc
include numere_colorate.inc
include flag_color.inc
include cell_vida.inc

.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0FF0000h
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0 ;desenem pe langa cu culoarea fontului
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

; un macro ca sa apelam mai usor desenarea simbolului 
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

;desenarea de litere mai mari
make_text_grow proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	sub eax, 'A'
	cmp eax, 32
	je make_space_grow
	lea esi, grow_letters
	jmp draw_text_grow
	
make_space_grow:
	mov eax,26
	lea esi, grow_letters

draw_text_grow:
	mov ebx, symbol_width_grow
	mul ebx
	mov ebx, symbol_height_grow
	mul ebx
	add esi, eax
	mov ecx, symbol_height_grow
bucla_simbol_linii_grow:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height_grow
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width_grow
bucla_simbol_coloane_grow:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb_grow
	mov dword ptr [edi], 0FFh
	jmp simbol_pixel_next_grow
simbol_pixel_alb_grow:
	mov dword ptr [edi], 0C3B9B7h ;desenem pe langa cu culoarea fontului
simbol_pixel_next_grow:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane_grow
	pop ecx
	loop bucla_simbol_linii_grow
	popa
	mov esp, ebp
	pop ebp
	ret
make_text_grow endp

; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro_grow macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text_grow
	add esp, 16
endm

make_grow_bomb proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax,0
	lea esi, grow_bomb

draw_text_grow_bomb:
	mov ebx, symbol_width_grow_bomb
	mul ebx
	mov ebx, symbol_height_grow_bomb
	mul ebx
	add esi, eax
	mov ecx, symbol_height_grow_bomb
bucla_simbol_linii_grow_bomb:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height_grow_bomb
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width_grow_bomb
	
bucla_simbol_coloane_grow_bomb:
	cmp byte ptr [esi], 0
	je simbol_pixel_font_grow_bomb
	cmp byte ptr [esi], 1
	je simbol_pixel_negru_grow_bomb
	cmp byte ptr [esi], 2
	je simbol_pixel_alb_grow_bomb
	cmp byte ptr [esi], 3
	je simbol_pixel_rosu_grow_bomb
	cmp byte ptr [esi], 4
	je simbol_pixel_portocaliu_grow_bomb
	mov dword ptr [edi], 0FFF826h
	jmp simbol_pixel_next_grow_bomb
simbol_pixel_font_grow_bomb:
	mov dword ptr [edi], 0C3B9B7h ;desenem pe langa cu culoarea fontului
	jmp simbol_pixel_next_grow_bomb
simbol_pixel_negru_grow_bomb:
	mov dword ptr [edi], 0
	jmp simbol_pixel_next_grow_bomb
simbol_pixel_alb_grow_bomb:
	mov dword ptr [edi], 0FFFFFFh
	jmp simbol_pixel_next_grow_bomb
simbol_pixel_rosu_grow_bomb:
	mov dword ptr [edi], 0F42C2Ch
	jmp simbol_pixel_next_grow_bomb
simbol_pixel_portocaliu_grow_bomb:
	mov dword ptr [edi], 0FF8826h

simbol_pixel_next_grow_bomb:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane_grow_bomb
	pop ecx
	loop bucla_simbol_linii_grow_bomb
	popa
	mov esp, ebp
	pop ebp
	ret
make_grow_bomb endp

; un macro ca sa apelam mai usor desenarea simbolului
make_grow_bomb_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_grow_bomb
	add esp, 16
endm

make_numere_colorate proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	;sub eax, '0'
	lea esi,numere_colorate

draw_numere_colorate:
	mov ebx, symbol_width_cell_matrice_joc
	mul ebx
	mov ebx, symbol_height_cell_matrice_joc
	mul ebx
	shl eax,2 ;inmultim cu 4 pt ca avem un dword
	add esi, eax
	mov ecx, symbol_height_cell_matrice_joc
bucla_simbol_linii_numere_colorate:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height_cell_matrice_joc
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width_cell_matrice_joc
bucla_simbol_coloane_numere_colorate:
	cmp dword ptr[esi],0
	je simbol_gri_numere_colorate
	cmp dword ptr[esi],1
	je simbol_cifra1_numere_colorate
	cmp dword ptr[esi],2
	je simbol_cifra2_numere_colorate
	cmp dword ptr[esi],3
	je simbol_cifra3_numere_colorate
	cmp dword ptr[esi],4
	je simbol_cifra4_numere_colorate
	cmp dword ptr[esi],5
	je simbol_cifra5_numere_colorate
	cmp dword ptr[esi],6
	je simbol_cifra6_numere_colorate
	cmp dword ptr[esi],7
	je simbol_cifra7_numere_colorate
	cmp dword ptr[esi],8
	je simbol_cifra8_numere_colorate
	cmp dword ptr[esi],9
	je simbol_bomba_numere_colorate
simbol_gri_numere_colorate:
	mov dword ptr[edi],0818287h
	jmp simbol_pixel_next_numere_colorate
simbol_cifra1_numere_colorate:
	mov dword ptr[edi],00F44D7h
	jmp simbol_pixel_next_numere_colorate
simbol_cifra2_numere_colorate:
	mov dword ptr[edi],008CA13h
	jmp simbol_pixel_next_numere_colorate
simbol_cifra3_numere_colorate:
	mov dword ptr[edi],0F74107h
	jmp simbol_pixel_next_numere_colorate
simbol_cifra4_numere_colorate:
	mov dword ptr[edi],07C07F7h
	jmp simbol_pixel_next_numere_colorate
simbol_cifra5_numere_colorate:
	mov dword ptr[edi],0975D24h
	jmp simbol_pixel_next_numere_colorate
simbol_cifra6_numere_colorate:
	mov dword ptr[edi],02FBD8Dh
	jmp simbol_pixel_next_numere_colorate
simbol_cifra7_numere_colorate:
	mov dword ptr[edi],01E2B27h
	jmp simbol_pixel_next_numere_colorate
simbol_cifra8_numere_colorate:
	mov dword ptr[edi],0D7A1B3h
	jmp simbol_pixel_next_numere_colorate
simbol_bomba_numere_colorate:
	mov dword ptr[edi],0
simbol_pixel_next_numere_colorate:
	add esi,4
	add edi,4
	dec ecx
	jne bucla_simbol_coloane_numere_colorate ;nu se face cu loop pt ca loop e pt short jumps (-128,127)
	pop ecx
	dec ecx
	jne bucla_simbol_linii_numere_colorate
	popa
	mov esp, ebp
	pop ebp
	ret
make_numere_colorate endp

; un macro ca sa apelam mai usor desenarea simbolului
make_numere_colorate_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_numere_colorate
	add esp, 16
endm

make_flag_color proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax,[ebp+arg1] 
	lea esi, flag_color

draw_flag_color:
	mov ebx, symbol_width_cell_matrice_joc
	mul ebx
	mov ebx, symbol_height_cell_matrice_joc
	mul ebx
	shl eax,2
	add esi, eax
	mov ecx, symbol_height_cell_matrice_joc
bucla_simbol_linii_flag_color:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height_cell_matrice_joc
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width_cell_matrice_joc
	
bucla_simbol_coloane_flag_color:
	cmp dword ptr [esi], 0
	je simbol_pixel_font_flag_color
	cmp dword ptr [esi], 1
	je simbol_pixel_negru_flag_color
	cmp dword ptr [esi], 2
	je simbol_pixel_rosu_flag_color
	cmp dword ptr [esi], 3
	je simbol_pixel_gri_inchis_flag_color
simbol_pixel_font_flag_color:
	mov dword ptr [edi], 0C3B9B7h ;desenem pe langa cu culoarea fontului
	jmp simbol_pixel_next_flag_color
simbol_pixel_negru_flag_color:
	mov dword ptr [edi], 0
	jmp simbol_pixel_next_flag_color
simbol_pixel_rosu_flag_color:
	mov dword ptr [edi], 0F42C2Ch
	jmp simbol_pixel_next_flag_color
simbol_pixel_gri_inchis_flag_color:
	mov dword ptr [edi], 0818287h

simbol_pixel_next_flag_color:
	add esi,4
	add edi,4
	loop bucla_simbol_coloane_flag_color
	pop ecx
	loop bucla_simbol_linii_flag_color
	popa
	mov esp, ebp
	pop ebp
	ret
make_flag_color endp

; un macro ca sa apelam mai usor desenarea simbolului
make_flag_color_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_flag_color
	add esp, 16
endm

make_cell_vida proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax,0
	lea esi, cell_vida

draw_cell_vida:
	mov ebx, symbol_width_cell_matrice_joc
	mul ebx
	mov ebx, symbol_height_cell_matrice_joc
	mul ebx
	shl eax,2
	add esi, eax
	mov ecx, symbol_height_cell_matrice_joc
bucla_simbol_linii_cell_vida:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height_cell_matrice_joc
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width_cell_matrice_joc
	
bucla_simbol_coloane_cell_vida:
	mov dword ptr [edi], 0BAB7B6h ;desenem pe langa cu culoarea fontului

simbol_pixel_next_cell_vida:
	add esi,4
	add edi, 4
	loop bucla_simbol_coloane_cell_vida
	pop ecx
	loop bucla_simbol_linii_cell_vida
	popa
	mov esp, ebp
	pop ebp
	ret
make_cell_vida endp

; un macro ca sa apelam mai usor desenarea simbolului
make_cell_vida_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_cell_vida
	add esp, 16
endm

;desenare linie orizontala
;[ebp+8]->x
;[ebp+12]->y
;[ebp+16]->len
;[ebp+20]->color
line_horizontal proc
	push ebp
	mov ebp,esp
	
	mov eax,[ebp+12]
	mov ebx, area_width
	mul ebx
	add eax,[ebp+8]
	shl eax,2 ;pt ca pixelul e dword
	add eax,area
	
	mov ecx,[ebp+16]
	bucla_line_horizontal:
		mov ebx,[ebp+20] 
		mov dword ptr [eax],ebx
		add eax,4
	loop bucla_line_horizontal
	
	mov esp,ebp
	pop ebp
	ret
line_horizontal endp

line_horizontal_macro macro x,y,len,color ;macro pt apelarea desenarii de linii orizontale
	push color
	push len
	push y
	push x
	call line_horizontal
	add esp,16
endm	

;desenare linie verticala
line_vertical proc
	push ebp
	mov ebp,esp
	
	mov eax,[ebp+12]
	mov ebx, area_width
	mul ebx
	add eax,[ebp+8]
	shl eax,2
	add eax,area
	
	mov ecx,[ebp+16]
	bucla_lini_vertical:
		mov ebx,[ebp+20]
		mov dword ptr[eax],ebx
		add eax, area_width*4
	loop bucla_lini_vertical
	
	mov esp,ebp
	pop ebp
	ret
line_vertical endp

line_vertical_macro macro x,y,len,color ;macro pt apelarea desenarii de linii verticale
	push color
	push len
	push y
	push x
	call line_vertical
	add esp,16
endm

;desenez liniile matricei
fasii_orizontale_macro macro x,y,len,linii,coloane

	mov esi,0 ;contor de linii
	 bucla_de_linii_orizontale:
		 cmp esi,linii
		 je iesire_bucla_de_linii_orizontale
		
		mov eax,x
		mov ebx,y

		mov ecx,esi
		aduna_fasii_orizontale:
			jecxz continua_bucla_de_linii_orizontale
			add ebx,len
		loop aduna_fasii_orizontale
		
		continua_bucla_de_linii_orizontale:
		mov ecx,coloane
		bucla_desenare_fasii_orizontale:

			push ecx
			push ebx
			push eax
			line_horizontal_macro eax,ebx,len,0
			pop eax ;pt ca in macro se modifica eax,ebx si ecx
			pop ebx
			pop ecx
			
			add eax,len
		loop bucla_desenare_fasii_orizontale
		
		inc esi
	jmp bucla_de_linii_orizontale
	
	iesire_bucla_de_linii_orizontale:
 endm
 
fasii_verticale_macro macro x,y,len,linii,coloane

	mov esi,0 ;contor de linii
	 bucla_de_linii_verticale:
		 cmp esi,coloane
		 jg iesire_bucla_de_linii_verticale
		
		mov eax,x
		mov ebx,y

		mov ecx,esi
		aduna_fasii_verticale:
			jecxz continua_bucla_de_linii_verticale
			add eax,len
		loop aduna_fasii_verticale
		
		continua_bucla_de_linii_verticale:
		mov ecx,linii
		bucla_desenare_fasii_verticale:

			push ecx
			push ebx
			push eax
			line_vertical_macro eax,ebx,len,0
			pop eax ;pt ca in macro se modifica eax,ebx si ecx
			pop ebx
			pop ecx
			
			add ebx,len
		loop bucla_desenare_fasii_verticale
		
		inc esi
	jmp bucla_de_linii_verticale
	
	iesire_bucla_de_linii_verticale:
 endm
 
generator_matrice_joc proc
 
	;initializam matricea la 0
	mov esi,0 ;contor linii
	bucla_linii_initializare:
		cmp esi,randuri_matrice_joc
		je iesire_bucla_linii_initializare
		mov edi,0 ;contor coloane
		bucla_coloane_initializare:
			cmp edi,coloane_matrice_joc
			je iesire_bucla_coloane_initializare
			mov eax,coloane_matrice_joc
			mov ebx,esi
			mul ebx
			add eax,edi
			shl eax,2
			mov matrice_joc[eax],0
			
			inc edi
		jmp bucla_coloane_initializare
		iesire_bucla_coloane_initializare:
		
		inc esi
	jmp bucla_linii_initializare
	iesire_bucla_linii_initializare:
	
	mov edi,0 ;contor mine
	bucla_adauga_mina:
		cmp edi,nr_bombe
		je iesire_bucla_adauga_mina
		rdtsc                       
		push eax
		xor al,al
		pop ebx
		sub ebx,eax
		mov nr_random,ebx
		
		mov esi,nr_random
		cmp esi,216
		jge scadere_nr
			jmp afara
		scadere_nr:
			sub esi,216
			
		afara:
		while_verifica:
			cmp esi,216
			je scade_esi
				jmp sari_scade_esi
			scade_esi:
			mov esi,0
			sari_scade_esi:
			cmp matrice_joc[esi*4],9
			je adauga_esi
				mov matrice_joc[esi*4],9
				jmp iesire_while_verifica
				
			adauga_esi:
			inc esi
		jmp while_verifica
		
		iesire_while_verifica:
		inc edi
	jmp bucla_adauga_mina
	
	iesire_bucla_adauga_mina:	
	
	;adaugare de nr vecini ai bombelor
	mov esi,0 ;contor linii
	bucla_adauga_vecini_linie:
		cmp esi,randuri_matrice_joc
		je iesire_bucla_adauga_vecini_linie
		
		mov edi,0 ;contor coloane
		bucla_adauga_vecini_coloana:
			cmp edi,coloane_matrice_joc
			je iesire_bucla_adauga_vecini_coloana
			
			mov contor_nr_bombe_vecine,0 ;resetam contorul
			mov eax,coloane_matrice_joc
			mov ebx,esi
			mul ebx
			add eax,edi
			shl eax,2
			cmp matrice_joc[eax],9
			je cazul_0_finalizare
				cmp esi,0
				je caz_1_5_2
					cmp esi,11
					je caz_3_8_4
						cmp edi,0
						je cazul_6
							cmp edi,17
							je cazul_7
								cazul_9:
									cmp matrice_joc[eax-76],9
									je cazul_91
										jmp n_cazul_91
									cazul_91:
										inc contor_nr_bombe_vecine
									n_cazul_91:
									cmp matrice_joc[eax-72],9
									je cazul_92
										jmp n_cazul_92
									cazul_92:
										inc contor_nr_bombe_vecine
									n_cazul_92:
									cmp matrice_joc[eax-68],9
									je cazul_93
										jmp n_cazul_93
									cazul_93:
										inc contor_nr_bombe_vecine
									n_cazul_93:
									cmp matrice_joc[eax-4],9
									je cazul_94
										jmp n_cazul_94
									cazul_94:
										inc contor_nr_bombe_vecine
									n_cazul_94:
									cmp matrice_joc[eax+4],9
									je cazul_95
										jmp n_cazul_95
									cazul_95:
										inc contor_nr_bombe_vecine
									n_cazul_95:
									cmp matrice_joc[eax+68],9
									je cazul_96
										jmp n_cazul_96
									cazul_96:
										inc contor_nr_bombe_vecine
									n_cazul_96:
									cmp matrice_joc[eax+72],9
									je cazul_97
										jmp n_cazul_97
									cazul_97:
										inc contor_nr_bombe_vecine
									n_cazul_97:
									cmp matrice_joc[eax+76],9
									je cazul_98
										jmp cazul_9_finalizare
									cazul_98:
										inc contor_nr_bombe_vecine
									cazul_9_finalizare:
									
									mov ebx,contor_nr_bombe_vecine
									mov matrice_joc[eax],ebx
									
								jmp cazul_0_finalizare
							cazul_7:
								cmp matrice_joc[eax-72],9
								je cazul_71
									jmp n_cazul_71
								cazul_71:
									inc contor_nr_bombe_vecine
								n_cazul_71:
								cmp matrice_joc[eax-76],9
								je cazul_72
									jmp n_cazul_72
								cazul_72:
									inc contor_nr_bombe_vecine
								n_cazul_72:
								cmp matrice_joc[eax-4],9
								je cazul_73
									jmp n_cazul_73
								cazul_73:
									inc contor_nr_bombe_vecine
								n_cazul_73:
								cmp matrice_joc[eax+68],9
								je cazul_74
									jmp n_cazul_74
								cazul_74:
									inc contor_nr_bombe_vecine
								n_cazul_74:
								cmp matrice_joc[eax+72],9
								je cazul_75
									jmp cazul_7_finalizare
								cazul_75:
									inc contor_nr_bombe_vecine
								cazul_7_finalizare:
								
								mov ebx,contor_nr_bombe_vecine
								mov matrice_joc[eax],ebx
								
							jmp cazul_0_finalizare
						cazul_6:
							cmp matrice_joc[eax-72],9
							je cazul_61
								jmp n_cazul_61
							cazul_61:
								inc contor_nr_bombe_vecine
							n_cazul_61:
							cmp matrice_joc[eax-68],9
							je cazul_62
								jmp n_cazul_62
							cazul_62:
								inc contor_nr_bombe_vecine
							n_cazul_62:
							cmp matrice_joc[eax+4],9
							je cazul_63
								jmp n_cazul_63
							cazul_63:
								inc contor_nr_bombe_vecine
							n_cazul_63:
							cmp matrice_joc[eax+72],9
							je cazul_64
								jmp n_cazul_64
							cazul_64:
								inc contor_nr_bombe_vecine
							n_cazul_64:
							cmp matrice_joc[eax+76],9
							je cazul_65
								jmp cazul_6_finalizare
							cazul_65:
								inc contor_nr_bombe_vecine
							cazul_6_finalizare:
							
							mov ebx,contor_nr_bombe_vecine
							mov matrice_joc[eax],ebx
							
						jmp cazul_0_finalizare
					caz_3_8_4:
						cmp edi,0
						je cazul_3
							cmp edi,17
							je cazul_4
								cazul_8:
									cmp matrice_joc[eax-4],9
									je cazul_81
										jmp n_cazul_81
									cazul_81:
										inc contor_nr_bombe_vecine
									n_cazul_81:
									cmp matrice_joc[eax-76],9
									je cazul_82
										jmp n_cazul_82
									cazul_82:
										inc contor_nr_bombe_vecine
									n_cazul_82:
									cmp matrice_joc[eax-72],9
									je cazul_83
										jmp n_cazul_83
									cazul_83:
										inc contor_nr_bombe_vecine
									n_cazul_83:
									cmp matrice_joc[eax-68],9
									je cazul_84
										jmp n_cazul_84
									cazul_84:
										inc contor_nr_bombe_vecine
									n_cazul_84:
									cmp matrice_joc[eax+4],9
									je cazul_85
										jmp cazul_8_finalizare
									cazul_85:
										inc contor_nr_bombe_vecine
									cazul_8_finalizare:
									
									mov ebx,contor_nr_bombe_vecine
									mov matrice_joc[eax],ebx
								
								jmp cazul_0_finalizare
							cazul_4:
								cmp matrice_joc[eax-4],9
								je cazul_41
									jmp n_cazul_41
								cazul_41:
									inc contor_nr_bombe_vecine
								n_cazul_41:
								cmp matrice_joc[eax-72],9
								je cazul_42
									jmp n_cazul_42
								cazul_42:
									inc contor_nr_bombe_vecine
								n_cazul_42:
								cmp matrice_joc[eax-76],9
								je cazul_43
									jmp cazul_4_finalizare
								cazul_43:
									inc contor_nr_bombe_vecine
								cazul_4_finalizare:
								
								mov ebx,contor_nr_bombe_vecine
								mov matrice_joc[eax],ebx
								
							jmp cazul_0_finalizare
						cazul_3:
							cmp matrice_joc[eax-72],9
							je cazul_31
								jmp n_cazul_31
							cazul_31:
								inc contor_nr_bombe_vecine
							n_cazul_31:
							cmp matrice_joc[eax-68],9
							je cazul_32
								jmp n_cazul_32
							cazul_32:
								inc contor_nr_bombe_vecine
							n_cazul_32:
							cmp matrice_joc[eax+4],9
							je cazul_33
								jmp cazul_3_finalizare
							cazul_33:
								inc contor_nr_bombe_vecine
							cazul_3_finalizare:
							
							mov ebx,contor_nr_bombe_vecine
							mov matrice_joc[eax],ebx
							
						jmp cazul_0_finalizare
				caz_1_5_2:
					cmp edi,0
					je cazul_1
						cmp edi,17
						je cazul_2
							cazul_5:
								cmp matrice_joc[eax-4],9
								je cazul_51
									jmp n_cazul_51
								cazul_51:
									inc contor_nr_bombe_vecine
								n_cazul_51:
								cmp matrice_joc[eax+4],9
								je cazul_52
									jmp n_cazul_52
								cazul_52:
									inc contor_nr_bombe_vecine
								n_cazul_52:
								cmp matrice_joc[eax+68],9
								je cazul_53
									jmp n_cazul_53
								cazul_53:
									inc contor_nr_bombe_vecine
								n_cazul_53:
								cmp matrice_joc[eax+72],9
								je cazul_54
									jmp n_cazul_54
								cazul_54:
									inc contor_nr_bombe_vecine
								n_cazul_54:
								cmp matrice_joc[eax+76],9
								je cazul_55
									jmp cazul_5_finalizare
								cazul_55:
									inc contor_nr_bombe_vecine
								cazul_5_finalizare:
								
								mov ebx,contor_nr_bombe_vecine
								mov matrice_joc[eax],ebx
								
							jmp cazul_0_finalizare
						cazul_2:
							cmp matrice_joc[eax-4],9
							je cazul_21
								jmp n_cazul_21
							cazul_21:
								inc contor_nr_bombe_vecine
							n_cazul_21:
							cmp matrice_joc[eax+72],9
							je cazul_22
								jmp n_cazul_22
							cazul_22:
								inc contor_nr_bombe_vecine
							n_cazul_22:
							cmp matrice_joc[eax+68],9
							je cazul_23
								jmp cazul_2_finalizare
							cazul_23:
								inc contor_nr_bombe_vecine
							cazul_2_finalizare:
							mov ebx,contor_nr_bombe_vecine
							mov matrice_joc[eax],ebx
							
						jmp cazul_0_finalizare
					cazul_1:
						cmp matrice_joc[eax+4],9
						je cazul_11
							jmp n_cazul_11
						cazul_11:
							inc contor_nr_bombe_vecine
						n_cazul_11:
						cmp matrice_joc[eax+72],9
						je cazul_12
							jmp n_cazul_12
						cazul_12:
							inc contor_nr_bombe_vecine
						n_cazul_12:
						cmp matrice_joc[eax+76],9
						je cazul_13
							jmp cazul_1_finalizare
						cazul_13:
							inc contor_nr_bombe_vecine
							
						cazul_1_finalizare:	
							mov ebx,contor_nr_bombe_vecine
							mov matrice_joc[eax],ebx
							
					jmp cazul_0_finalizare
					
			cazul_0_finalizare:
			
			
			inc edi
		jmp bucla_adauga_vecini_coloana
		iesire_bucla_adauga_vecini_coloana:
		
		inc esi
	jmp bucla_adauga_vecini_linie
	
	iesire_bucla_adauga_vecini_linie:
	
	;afisare matrice
	mov esi,0 ;contor linii
	bucla_linii:
		cmp esi,randuri_matrice_joc
		je iesire_bucla_linii
		mov edi,0 ;contor coloane
		bucla_coloane:
			cmp edi,coloane_matrice_joc
			je iesire_bucla_coloane
			mov eax,coloane_matrice_joc
			mov ebx,esi
			mul ebx
			add eax,edi
			shl eax,2
			push matrice_joc[eax]
			push offset format
			call printf
			add esp,8
			
			inc edi
		jmp bucla_coloane
		iesire_bucla_coloane:
		push offset rand_nou
		call printf
		add esp,4
		
		inc esi
	jmp bucla_linii
	iesire_bucla_linii:
	
	push offset rand_nou
	call printf
	add esp,4
	
 ret
generator_matrice_joc endp

;reinitializam matricea de vizitate si matricea de flaguri
reinitializare_matrici proc

	;initializam matricea la 0
	mov esi,0 ;contor linii
	bucla_linii_reinitializare_mat_vizitate:
		cmp esi,randuri_matrice_joc
		je iesire_bucla_linii_reinitializare_mat_vizitate
		mov edi,0 ;contor coloane
		bucla_coloane_reinitializare_mat_vizitate:
			cmp edi,coloane_matrice_joc
			je iesire_bucla_coloane_reinitializare_mat_vizitate
			mov eax,coloane_matrice_joc
			mov ebx,esi
			mul ebx
			add eax,edi
			shl eax,2
			mov matrice_joc_vizitate[eax],0
			
			inc edi
		jmp bucla_coloane_reinitializare_mat_vizitate
		iesire_bucla_coloane_reinitializare_mat_vizitate:
		
		inc esi
	jmp bucla_linii_reinitializare_mat_vizitate
	iesire_bucla_linii_reinitializare_mat_vizitate:
	
	mov esi,0 ;contor linii
	bucla_linii_reinitializare_mat_flaguri:
		cmp esi,randuri_matrice_joc
		je iesire_bucla_linii_reinitializare_mat_flaguri
		mov edi,0 ;contor coloane
		bucla_coloane_reinitializare_mat_flaguri:
			cmp edi,coloane_matrice_joc
			je iesire_bucla_coloane_reinitializare_mat_flaguri
			mov eax,coloane_matrice_joc
			mov ebx,esi
			mul ebx
			add eax,edi
			shl eax,2
			mov matrice_joc_flaguri[eax],0
			
			inc edi
		jmp bucla_coloane_reinitializare_mat_flaguri
		iesire_bucla_coloane_reinitializare_mat_flaguri:
		
		inc esi
	jmp bucla_linii_reinitializare_mat_flaguri
	iesire_bucla_linii_reinitializare_mat_flaguri:
	
	ret
reinitializare_matrici endp

plasare_celule_vide proc

	mov esi,0 ;contor linii
	bucla_linii_plasare_celule_vide:
		cmp esi,randuri_matrice_joc
		je iesire_bucla_linii_plasare_celule_vide
		mov edi,0 ;contor coloane
		bucla_coloane_plasare_celule_vide:
			cmp edi,coloane_matrice_joc
			je iesire_bucla_coloane_plasare_celule_vide
			mov ecx,len_matrice_joc
			mov eax,edi
			mul ecx
			mov ecx,eax
			mov eax,x2_matrice_joc
			add eax,ecx
			inc eax
			push eax ;pastram x din mat
			mov ecx,len_matrice_joc
			mov eax,esi
			mul ecx
			mov ecx,eax
			mov eax,y2_matrice_joc
			add eax,ecx
			inc eax
			push eax ;pastram y din mat
			
			pop ebx ;y 
			pop eax ;x
			make_cell_vida_macro 0,area,eax,ebx
			
			inc edi
		jmp bucla_coloane_plasare_celule_vide
		iesire_bucla_coloane_plasare_celule_vide:
		
		inc esi
	jmp bucla_linii_plasare_celule_vide
	iesire_bucla_linii_plasare_celule_vide:
	
	;plasam celule vide unde scrie u win sau u lose
	make_cell_vida_macro 0,area,310,500
	make_cell_vida_macro 0,area,339,500
	make_cell_vida_macro 0,area,368,500

	ret
plasare_celule_vide endp

;s-a acivat bomba=>meciul e pierdut
bomba_activa proc
	
	mov contor_victorie,0
	mov esi,0 ;contor linii
	bucla_linii_bomba_activa:
		cmp esi,randuri_matrice_joc
		je iesire_bucla_linii_bomba_activa
		mov edi,0 ;contor coloane
		bucla_coloane_bomba_activa:
			cmp edi,coloane_matrice_joc
			je iesire_bucla_coloane_bomba_activa
			mov eax,coloane_matrice_joc
			mov ebx,esi
			mul ebx
			add eax,edi
			shl eax,2
			mov matrice_joc_vizitate[eax],1
			
			inc edi
		jmp bucla_coloane_bomba_activa
		iesire_bucla_coloane_bomba_activa:
		
		inc esi
	jmp bucla_linii_bomba_activa
	iesire_bucla_linii_bomba_activa:
	
	;afisam intreaga matrice
	mov esi,0 ;contor linii
	bucla_linii_afisare_matrice:
		cmp esi,randuri_matrice_joc
		je iesire_bucla_linii_afisare_matrice
		mov edi,0 ;contor coloane
		bucla_coloane_afisare_matrice:
			cmp edi,coloane_matrice_joc
			je iesire_bucla_coloane_afisare_matrice
			mov ecx,len_matrice_joc
			mov eax,edi
			mul ecx
			mov ecx,eax
			mov eax,x2_matrice_joc
			add eax,ecx
			inc eax
			push eax ;pastram x din mat
			mov ecx,len_matrice_joc
			mov eax,esi
			mul ecx
			mov ecx,eax
			mov eax,y2_matrice_joc
			add eax,ecx
			inc eax
			push eax ;pastram y din mat
			
			;afisam celula cu celula
			mov eax,esi
			mov ecx,coloane_matrice_joc
			mul ecx
			mov ebx, edi
			add eax,ebx
			shl eax,2
			mov ecx,matrice_joc[eax]
			pop ebx
			pop eax
			make_numere_colorate_macro ecx,area,eax,ebx
			
			inc edi
		jmp bucla_coloane_afisare_matrice
		iesire_bucla_coloane_afisare_matrice:
		
		inc esi
	jmp bucla_linii_afisare_matrice
	iesire_bucla_linii_afisare_matrice:
	
	make_text_macro 'Y',area,310,505
	make_text_macro 'O',area,320,505	
	make_text_macro 'U',area,330,505
	make_text_macro ' ',area,340,505
	make_text_macro 'L',area,350,505
	make_text_macro 'O',area,360,505
	make_text_macro 'S',area,370,505
	make_text_macro 'E',area,380,505
	mov nr_flaguri,0
	mov counter_nr_bombe,0
	
	ret
bomba_activa endp

zona0 proc
	push ebp
	mov ebp,esp
	
	;verificare ca nu se iese din matrice_joc
	mov eax,[ebp+16] ;linia curenta in matrice
	cmp eax,0
	jl board_out
	cmp eax,randuri_matrice_joc
	jge board_out
	mov eax,[ebp+20] ;coloana curenta in matrice
	cmp eax,0
	jl board_out
	cmp eax,coloane_matrice_joc
	jge board_out
	
	;verificare ca cell nu a fost deja vizitat
	mov eax,[ebp+16] ;linia curenta
	mov ebx,[ebp+20] ;coloana curenta
	mov ecx,coloane_matrice_joc
	mul ecx
	add eax,ebx
	shl eax,2
	cmp matrice_joc_vizitate[eax],1
	je board_out
	;nu a fost vizitat
	mov matrice_joc_vizitate[eax],1
	mov ecx,matrice_joc[eax]
	push eax ;pt a verif mai incolo daca e 0 in mat
	mov eax,[ebp+8] ;linia unde se deseneaza
	mov ebx,[ebp+12] ;coloana unde se deseneaza
	make_numere_colorate_macro ecx,area,eax,ebx
	inc contor_victorie
	
	;verificam daca in cell din mat e 0
	pop eax
	cmp matrice_joc[eax],0
	jne board_out
	;e 0
	;cazul1: row - 1, col
	mov eax,[ebp+8]
	mov ebx,[ebp+12]
	sub ebx,len_matrice_joc
	mov ecx,[ebp+16]
	dec ecx
	mov edx,[ebp+20]
	;apelare recursiva
	push edx
	push ecx
	push ebx
	push eax
	call zona0
	
	;cazul2: row, col - 1
	mov eax,[ebp+8]
	sub eax,len_matrice_joc
	mov ebx,[ebp+12]
	mov ecx,[ebp+16]
	mov edx,[ebp+20]
	dec edx
	;apelare recursiva
	push edx
	push ecx
	push ebx
	push eax
	call zona0
	
	;cazul3: row, col + 1
	mov eax,[ebp+8]
	add eax,len_matrice_joc
	mov ebx,[ebp+12]
	mov ecx,[ebp+16]
	mov edx,[ebp+20]
	inc edx
	;apelare recursiva
	push edx
	push ecx
	push ebx
	push eax
	call zona0
	
	;cazul4: row + 1, col
	mov eax,[ebp+8]
	mov ebx,[ebp+12]
	add ebx,len_matrice_joc
	mov ecx,[ebp+16]
	inc ecx
	mov edx,[ebp+20]
	;apelare recursiva
	push edx
	push ecx
	push ebx
	push eax
	call zona0
	
	;cazul5: row-1, col-1
	mov eax,[ebp+8]
	sub eax,len_matrice_joc
	mov ebx,[ebp+12]
	sub ebx,len_matrice_joc
	mov ecx,[ebp+16]
	dec ecx
	mov edx,[ebp+20]
	dec edx
	;apelare recursiva
	push edx
	push ecx
	push ebx
	push eax
	call zona0
	
	;cazul6: row-1,col+1
	mov eax,[ebp+8]
	add eax,len_matrice_joc
	mov ebx,[ebp+12]
	sub ebx,len_matrice_joc
	mov ecx,[ebp+16]
	dec ecx
	mov edx,[ebp+20]
	inc edx
	;apelare recursiva
	push edx
	push ecx
	push ebx
	push eax
	call zona0
	
	;cazul7: row+1,col-1
	mov eax,[ebp+8]
	sub eax,len_matrice_joc
	mov ebx,[ebp+12]
	add ebx,len_matrice_joc
	mov ecx,[ebp+16]
	inc ecx
	mov edx,[ebp+20]
	dec edx
	;apelare recursiva
	push edx
	push ecx
	push ebx
	push eax
	call zona0
	
	;cazul8: row+1,col+1
	mov eax,[ebp+8]
	add eax,len_matrice_joc
	mov ebx,[ebp+12]
	add ebx,len_matrice_joc
	mov ecx,[ebp+16]
	inc ecx
	mov edx,[ebp+20]
	inc edx
	;apelare recursiva
	push edx
	push ecx
	push ebx
	push eax
	call zona0
	
	board_out:
	mov esp,ebp
	pop ebp
	
	ret 16
zona0 endp
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 0C3B9B7h
	push area
	; rep stosd
	call memset
	add esp, 12
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	jmp afisare_litere
	
evt_click:
	;;;;;call generator_matrice_joc
	; verificare click flag
	;;! sa vedem daca trebe push si pop la eax
	mov eax,[ebp+arg2]
	cmp eax,x0_flag
	jl n_click_flag
	mov edx,len_matrice_joc
	add edx,x0_flag
	cmp eax,edx
	jg n_click_flag
	mov eax,[ebp+arg3]
	cmp eax,y0_flag
	jl n_click_flag
	mov edx,len_matrice_joc
	add edx,y0_flag
	cmp eax,edx
	jg n_click_flag
	;s-a dat click pe flag
	cmp flag_activator,0
	je incrementeaza_flag
		dec flag_activator
		jmp n_click_flag
	incrementeaza_flag:
	inc flag_activator	
	n_click_flag:
	
	;;;;;desenare mtrice joc la click
	mov eax,[ebp+arg2] ;x
	cmp eax, x2_matrice_joc
	jl n_click_matrice_joc
	mov edx,x2_matrice_joc
	add edx,width_matrice_joc
	cmp eax,edx
	jge n_click_matrice_joc
	mov eax,[ebp+arg3] ;y
	cmp eax,y2_matrice_joc
	jl n_click_matrice_joc
	mov edx,y2_matrice_joc
	add edx,height_matrice_joc
	cmp eax,edx
	jge n_click_matrice_joc
	;s-a dat click in matricea de joc
	mov eax,[ebp+arg2] ;x
	sub eax,x2_matrice_joc
	mov ebx,len_matrice_joc
	mov edx,0
	div ebx
	push eax ;memoram coloana unde am dat click
	mov eax,[ebp+arg3] ;y
	sub eax,y2_matrice_joc
	mov ebx,len_matrice_joc
	mov edx,0
	div ebx
	push eax ;memoram linia unde am dat click
	
	pop eax ;pt a vedea ce se afla in matrice_joc
	pop ebx
	
	push ebx ;pt a desene la coord corecte in matrice
	push eax
	
	mov ecx,coloane_matrice_joc
	mul ecx
	add eax,ebx
	shl eax,2
	mov valoare_curenta_matrice_eax,eax ;retinem poz din mat unde s-a dat click
	mov ecx,matrice_joc[eax]
	
	pop eax ;linia
	mov linia_curenta,eax
	pop ebx	;coloana
	mov coloana_curenta,ebx
	push ecx ;pastram ce se afla in ecx din mat
	
	mov ecx,eax
	mov eax,len_matrice_joc
	mul ecx
	mov ecx,eax
	mov eax,y2_matrice_joc
	add eax,ecx
	inc eax
	push eax ;pastram coord y din matrice
	mov ecx,ebx
	mov eax,len_matrice_joc
	mul ecx
	mov ecx,eax
	mov eax,x2_matrice_joc
	add eax,ecx
	inc eax
	push eax ;pastram coord x din matrice
	
	pop eax ;x matrice_joc
	pop ebx ;y matrice_joc
	pop ecx ;nr ce trb pus in matrice_joc
			;linia_curenta
			;coloana_curenta
	push ebx ;y matrice_joc
	push eax ;x matrice_joc
	cmp flag_activator,0 ;verificam daca flagul e activ
	je n_flag
		;daca e activ verificam daca mai avem destule flaguri
		cmp nr_flaguri,0
		je pop_eax_ebx
		;mai avem flaguri=>adaugam flag,incrementam mat de viz si mat de flag daca nu e deza inc la 1,dec si restul
		;stabilim cell din matrice
		mov eax,linia_curenta
		mov ebx,coloane_matrice_joc
		mul ebx
		add eax,coloana_curenta
		shl eax,2
		cmp matrice_joc_vizitate[eax],1 ;verificam daca nu cumva a fost vizitat acel cell
		je pop_eax_ebx
		;nu a fost vizitat
		cmp matrice_joc_flaguri[eax],1
		je pop_eax_ebx
		mov matrice_joc_vizitate[eax],1
		mov matrice_joc_flaguri[eax],1
		inc contor_victorie
		dec nr_flaguri
		dec counter_nr_bombe
		pop eax
		pop ebx
		make_flag_color_macro 0,area,eax,ebx
		
		jmp n_click_matrice_joc		
	;nu e activ flagul
	n_flag:
	
	
	;stabilim cell din matrice
	mov eax,linia_curenta
	mov ebx,coloane_matrice_joc
	mul ebx
	add eax,coloana_curenta
	shl eax,2
	cmp matrice_joc_flaguri[eax],0
	je pune_numere_colorate
	;daca acolo e flag pus
	mov matrice_joc_vizitate[eax],0
	mov matrice_joc_flaguri[eax],0
	inc nr_flaguri
	inc counter_nr_bombe
	dec contor_victorie
	pop eax
	pop ebx
	make_cell_vida_macro 0,area,eax,ebx
	jmp n_click_matrice_joc
	
	pune_numere_colorate:
	;stabilim cell din matrice
	mov eax,linia_curenta
	mov ebx,coloane_matrice_joc
	mul ebx
	add eax,coloana_curenta
	shl eax,2
	cmp matrice_joc_vizitate[eax],1
	je pop_eax_ebx
	;nu e vizitat
	;verificam daca se da click pe bomba
	;daca contor e 0
	
	cmp ecx,9
	jne n_bomba
		;e bomba
		cmp contor_victorie,0
		jne apelam_afisare_mat
		bucla_plasare_0_9:
			;daca dam din prima click pe o bomba sa nu pierdem
			call generator_matrice_joc
			mov eax,valoare_curenta_matrice_eax
			mov ecx,matrice_joc[eax]
			cmp ecx,0 
			je zona0_confirmed
		
		jmp bucla_plasare_0_9
			
		apelam_afisare_mat:
		call bomba_activa
		jmp pop_eax_ebx
	n_bomba:
	;verificam daca e zona 0
	cmp ecx,0
	jne n_zona0
		;am atins zona 0
		zona0_confirmed:
		pop eax
		pop ebx ;zona de desen
		
		push coloana_curenta
		push linia_curenta
		push ebx
		push eax
		call zona0
		jmp n_click_matrice_joc
	n_zona0:
	;daca contorul e 0 sa facem sa ne duca pe zona 0 
	cmp contor_victorie,0
	jne plasare_numere_colorate
		bucla_plasare_0_colorate:
			;daca dam din prima click pe un nr sa generam o zona 0
			call generator_matrice_joc
			mov eax,valoare_curenta_matrice_eax
			mov ecx,matrice_joc[eax]
			cmp ecx,0 
			je zona0_confirmed
		
		jmp bucla_plasare_0_colorate
		
	plasare_numere_colorate:
	mov matrice_joc_vizitate[eax],1
	inc contor_victorie
	pop eax
	pop ebx
	make_numere_colorate_macro ecx,area,eax,ebx
	jmp n_click_matrice_joc
			
	pop_eax_ebx:
	pop eax
	pop ebx
	n_click_matrice_joc:
	
	;verificare click new plate medium si resetarea jocului
	mov eax,[ebp+arg2] ;x 
	cmp eax,x0_new_medium
	jl n_click_new_medium
	cmp eax,410
	jg n_click_new_medium
	mov eax,[ebp+arg3] ;y
	cmp eax,y0_new_medium
	jl n_click_new_medium
	cmp eax,125
	jg n_click_new_medium
	;s-a dat click pe new_plate_medium
	mov nr_bombe,40
	
	call generator_matrice_joc ;resetam matricea de bombe
	call reinitializare_matrici ;resetam matricea de vizitate si matricea de flaguri
	mov counter_nr_bombe,40 
	mov counter_timp_joc,0
	mov nr_flaguri,40
	call plasare_celule_vide ;resetam campul de joc
	mov flag_activator,0
	mov contor_victorie,0
	mov counter,0
	mov active_medium,1
	mov active_hard,0
	mov active_easy,0
	jmp afisare_litere
	
	n_click_new_medium:
	
	;verificare click new plate easy si resetarea jocului
	mov eax,[ebp+arg2] ;x 
	cmp eax,x0_new_easy
	jl n_click_new_easy
	cmp eax,290
	jg n_click_new_easy
	mov eax,[ebp+arg3] ;y
	cmp eax,y0_new_easy
	jl n_click_new_easy
	cmp eax,125
	jg n_click_new_easy
	;s-a dat click pe new_plate_easy
	mov nr_bombe,30
	call reinitializare_matrici ;resetam matricea de vizitate si matricea de flaguri
	call plasare_celule_vide ;resetam campul de joc
	; call plasare_celule_vide ;resetam campul de joc
	; call reinitializare_matrici ;resetam matricea de vizitate si matricea de flaguri
	; call plasare_celule_vide ;resetam campul de joc
	; mov randuri_matrice_joc,10
	; mov coloane_matrice_joc,10
	; call generator_matrice_joc ;resetam matricea de bombe
	
	mov counter_nr_bombe,30 
	mov counter_timp_joc,0
	mov nr_flaguri,30
	call plasare_celule_vide ;resetam campul de joc
	mov flag_activator,0
	mov contor_victorie,0
	mov counter,0
	mov active_easy,1
	mov active_medium,0
	mov active_hard,0
	jmp afisare_litere
	
	n_click_new_easy:
	
	;verificare click new plate hard si resetarea jocului
	mov eax,[ebp+arg2] ;x 
	cmp eax,x0_new_hard
	jl n_click_new_hard
	cmp eax,530
	jg n_click_new_hard
	mov eax,[ebp+arg3] ;y
	cmp eax,y0_new_hard
	jl n_click_new_hard
	cmp eax,125
	jg n_click_new_hard
	;s-a dat click pe new_plate_hard
	mov nr_bombe,50

	call generator_matrice_joc ;resetam matricea de bombe
	call reinitializare_matrici ;resetam matricea de vizitate si matricea de flaguri
	mov counter_nr_bombe,50 
	mov counter_timp_joc,0
	mov nr_flaguri,50
	call plasare_celule_vide ;resetam campul de joc
	mov flag_activator,0
	mov contor_victorie,0
	mov counter,0
	mov active_easy,0
	mov active_medium,0
	mov active_hard,1
	jmp afisare_litere
	
	n_click_new_hard:
	
	;verificare victorie la easy chiar daca nu am flaguit toate bombele dar am descoperit restul zonelor
	
	cmp active_easy,1
	jne n_active_easy
	;este active place-ul de easy
	cmp contor_victorie,186 ;verificam daca nu cumva restul cell-urilor nedesc sunt doar bombe
	jnge n_active_easy
		
	mov all_bombs,1
	mov esi,0 ;contor linii
	bucla_linii_verif_win_easy:
		cmp esi,randuri_matrice_joc
		je iesire_bucla_linii_verif_win_easy
		mov edi,0 ;contor coloane
		bucla_coloane_verif_win_easy:
			cmp edi,coloane_matrice_joc
			je iesire_bucla_coloane_verif_win_easy
			
			mov eax,esi
			mov ecx,coloane_matrice_joc
			mul ecx
			mov ebx, edi
			add eax,ebx
			shl eax,2
			cmp matrice_joc_vizitate[eax],0
			je verif_all_bombs_easy
				jmp n_verif_all_bombs_easy
			verif_all_bombs_easy:
				cmp matrice_joc[eax],9 ;e bomba
				je e_bomba_easy
					mov all_bombs,0
				e_bomba_easy:
			n_verif_all_bombs_easy:				
			
			;daca nu sunt numa bombe nu face nimic
			cmp all_bombs,0
			je iesire_bucla_linii_verif_win_easy
			
			
			inc edi
		jmp bucla_coloane_verif_win_easy
		iesire_bucla_coloane_verif_win_easy:
		
		inc esi
	jmp bucla_linii_verif_win_easy
	iesire_bucla_linii_verif_win_easy:
	
	cmp all_bombs,0
	je n_active_easy
	;ne afla in cazul special de win
	
	
	mov esi,0
	bucla_linii_plasare_caz_special_easy:
		cmp esi,randuri_matrice_joc
		je iesire_bucla_linii_plasare_caz_special_easy
		mov edi,0
		bucla_coloane_plasare_caz_special_easy:
			cmp edi, coloane_matrice_joc
			je iesire_bucla_coloane_plasare_caz_special_easy
			
			mov eax,esi
			mov ecx,coloane_matrice_joc
			mul ecx
			mov ebx, edi
			add eax,ebx
			shl eax,2
			cmp matrice_joc[eax],9
			jne n_montare_flag
				cmp matrice_joc_vizitate[eax],0
				jne n_montare_flag
				;montam flag
				 mov ecx,len_matrice_joc
				 mov eax,edi
				 mul ecx
				 mov ecx,eax
				 mov eax,x2_matrice_joc
				 add eax,ecx
				 inc eax
				 push eax ;pastram x din mat
				 mov ecx,len_matrice_joc
				 mov eax,esi
				 mul ecx
				 mov ecx,eax
				 mov eax,y2_matrice_joc
				 add eax,ecx
				 inc eax
				 push eax ;pastram y din mat
				 
				 pop ebx
				 pop eax
				make_flag_color_macro 0,area,eax,ebx
			
			n_montare_flag:
			
			inc edi
		jmp bucla_coloane_plasare_caz_special_easy
		
		iesire_bucla_coloane_plasare_caz_special_easy:
		
		inc esi
	jmp bucla_linii_plasare_caz_special_easy
	iesire_bucla_linii_plasare_caz_special_easy:
	
	mov contor_victorie,216
	mov nr_flaguri,0
	mov all_bombs,0
	mov counter_nr_bombe,0
	jmp afisare_litere	
	
	n_active_easy:
	
	;verificare victorie la medium chiar daca nu am flaguit toate bombele dar am descoperit restul zonelor
	
	cmp active_medium,1
	jne n_active_medium
	;este active place-ul de easy
	cmp contor_victorie,176 ;verificam daca nu cumva restul cell-urilor nedesc sunt doar bombe
	jnge n_active_medium
		
	mov all_bombs,1
	mov esi,0 ;contor linii
	bucla_linii_verif_win_medium:
		cmp esi,randuri_matrice_joc
		je iesire_bucla_linii_verif_win_medium
		mov edi,0 ;contor coloane
		bucla_coloane_verif_win_medium:
			cmp edi,coloane_matrice_joc
			je iesire_bucla_coloane_verif_win_medium
			
			mov eax,esi
			mov ecx,coloane_matrice_joc
			mul ecx
			mov ebx, edi
			add eax,ebx
			shl eax,2
			cmp matrice_joc_vizitate[eax],0
			je verif_all_bombs_medium
				jmp n_verif_all_bombs_medium
			verif_all_bombs_medium:
				cmp matrice_joc[eax],9 ;e bomba
				je e_bomba_medium
					mov all_bombs,0
				e_bomba_medium:
			n_verif_all_bombs_medium:				
			
			;daca nu sunt numa bombe nu face nimic
			cmp all_bombs,0
			je iesire_bucla_linii_verif_win_medium
			
			
			inc edi
		jmp bucla_coloane_verif_win_medium
		iesire_bucla_coloane_verif_win_medium:
		
		inc esi
	jmp bucla_linii_verif_win_medium
	iesire_bucla_linii_verif_win_medium:
	
	cmp all_bombs,0
	je n_active_medium
	;ne afla in cazul special de win
	
	
	mov esi,0
	bucla_linii_plasare_caz_special_medium:
		cmp esi,randuri_matrice_joc
		je iesire_bucla_linii_plasare_caz_special_medium
		mov edi,0
		bucla_coloane_plasare_caz_special_medium:
			cmp edi, coloane_matrice_joc
			je iesire_bucla_coloane_plasare_caz_special_medium
			
			mov eax,esi
			mov ecx,coloane_matrice_joc
			mul ecx
			mov ebx, edi
			add eax,ebx
			shl eax,2
			cmp matrice_joc[eax],9
			jne n_montare_flag_medium
				cmp matrice_joc_vizitate[eax],0
				jne n_montare_flag_medium
				;montam flag
				 mov ecx,len_matrice_joc
				 mov eax,edi
				 mul ecx
				 mov ecx,eax
				 mov eax,x2_matrice_joc
				 add eax,ecx
				 inc eax
				 push eax ;pastram x din mat
				 mov ecx,len_matrice_joc
				 mov eax,esi
				 mul ecx
				 mov ecx,eax
				 mov eax,y2_matrice_joc
				 add eax,ecx
				 inc eax
				 push eax ;pastram y din mat
				 
				 pop ebx
				 pop eax
				make_flag_color_macro 0,area,eax,ebx
			
			n_montare_flag_medium:
			
			inc edi
		jmp bucla_coloane_plasare_caz_special_medium
		
		iesire_bucla_coloane_plasare_caz_special_medium:
		
		inc esi
	jmp bucla_linii_plasare_caz_special_medium
	iesire_bucla_linii_plasare_caz_special_medium:
	
	mov contor_victorie,216
	mov nr_flaguri,0
	mov all_bombs,0
	mov counter_nr_bombe,0
	jmp afisare_litere	
	
	n_active_medium:
	
	;verificare victorie la hard chiar daca nu am flaguit toate bombele dar am descoperit restul zonelor
	
	cmp active_hard,1
	jne n_active_hard
	;este active place-ul de easy
	cmp contor_victorie,166 ;verificam daca nu cumva restul cell-urilor nedesc sunt doar bombe
	jnge n_active_hard
		
	mov all_bombs,1
	mov esi,0 ;contor linii
	bucla_linii_verif_win_hard:
		cmp esi,randuri_matrice_joc
		je iesire_bucla_linii_verif_win_hard
		mov edi,0 ;contor coloane
		bucla_coloane_verif_win_hard:
			cmp edi,coloane_matrice_joc
			je iesire_bucla_coloane_verif_win_hard
			
			mov eax,esi
			mov ecx,coloane_matrice_joc
			mul ecx
			mov ebx, edi
			add eax,ebx
			shl eax,2
			cmp matrice_joc_vizitate[eax],0
			je verif_all_bombs_hard
				jmp n_verif_all_bombs_hard
			verif_all_bombs_hard:
				cmp matrice_joc[eax],9 ;e bomba
				je e_bomba_hard
					mov all_bombs,0
				e_bomba_hard:
			n_verif_all_bombs_hard:				
			
			;daca nu sunt numa bombe nu face nimic
			cmp all_bombs,0
			je iesire_bucla_linii_verif_win_hard
			
			
			inc edi
		jmp bucla_coloane_verif_win_hard
		iesire_bucla_coloane_verif_win_hard:
		
		inc esi
	jmp bucla_linii_verif_win_hard
	iesire_bucla_linii_verif_win_hard:
	
	cmp all_bombs,0
	je n_active_hard
	;ne afla in cazul special de win
	
	mov esi,0
	bucla_linii_plasare_caz_special_hard:
		cmp esi,randuri_matrice_joc
		je iesire_bucla_linii_plasare_caz_special_hard
		mov edi,0
		bucla_coloane_plasare_caz_special_hard:
			cmp edi, coloane_matrice_joc
			je iesire_bucla_coloane_plasare_caz_special_hard
			
			mov eax,esi
			mov ecx,coloane_matrice_joc
			mul ecx
			mov ebx, edi
			add eax,ebx
			shl eax,2
			cmp matrice_joc[eax],9
			jne n_montare_flag_hard
				cmp matrice_joc_vizitate[eax],0
				jne n_montare_flag_hard
				;montam flag
				 mov ecx,len_matrice_joc
				 mov eax,edi
				 mul ecx
				 mov ecx,eax
				 mov eax,x2_matrice_joc
				 add eax,ecx
				 inc eax
				 push eax ;pastram x din mat
				 mov ecx,len_matrice_joc
				 mov eax,esi
				 mul ecx
				 mov ecx,eax
				 mov eax,y2_matrice_joc
				 add eax,ecx
				 inc eax
				 push eax ;pastram y din mat
				 
				 pop ebx
				 pop eax
				make_flag_color_macro 0,area,eax,ebx
			
			n_montare_flag_hard:
			
			inc edi
		jmp bucla_coloane_plasare_caz_special_hard
		
		iesire_bucla_coloane_plasare_caz_special_hard:
		
		inc esi
	jmp bucla_linii_plasare_caz_special_hard
	iesire_bucla_linii_plasare_caz_special_hard:
	
	mov contor_victorie,216
	mov nr_flaguri,0
	mov all_bombs,0
	mov counter_nr_bombe,0
	jmp afisare_litere	
	
	n_active_hard:
	
	jmp afisare_litere
	
	
evt_timer:
	cmp contor_victorie,0
	je afisare_litere
	;e mai mare decat 0
	cmp contor_victorie,216
	je afisare_litere
	inc counter
	mov eax,counter
	xor edx,edx
	mov ebx,5
	div ebx
	cmp edx,0
	jne afisare_litere
	inc counter_timp_joc
	
afisare_litere:
	; afisam valoarea counter-ului curent (sute, zeci si unitati)
	; mov ebx, 10
	; mov eax, counter
	; cifra unitatilor
	; mov edx, 0
	; div ebx
	; add edx, '0'
	; make_text_macro edx, area, 30, 10
	; cifra zecilor
	; mov edx, 0
	; div ebx
	; add edx, '0'
	; make_text_macro edx, area, 20, 10
	; cifra sutelor
	; mov edx, 0
	; div ebx
	; add edx, '0'
	; make_text_macro edx, area, 10, 10
	
	;afisare counter de bombe
	mov ebx,10
	mov eax,counter_nr_bombe
	;cifra unitatilor
	mov edx,0
	div ebx
	add edx,'0'
	push ebx ;ca sa nu pierdem eax si ebx
	push eax
	mov eax,symbol_width
	add eax,x0_counter_bombe
	make_text_macro edx,area,eax,y0_counter_bombe
	;cifra zecilor
	pop eax
	pop ebx
	mov edx,0
	div ebx
	add edx,'0'
	make_text_macro edx,area,x0_counter_bombe,y0_counter_bombe
	
	;afisare_counter_timp_joc
	mov ebx,10
	mov eax,counter_timp_joc
	;cifra unitatilor
	mov edx,0
	div ebx
	add edx,'0'
	push ebx
	push eax
	mov eax,symbol_width
	add eax,symbol_width
	add eax,x0_counter_timp_joc
	make_text_macro edx,area,eax,y0_counter_timp_joc
	;cifra zecilor
	pop eax
	pop ebx
	mov edx,0
	div ebx
	add edx,'0'
	push ebx
	push eax
	mov eax,symbol_width
	add eax,x0_counter_timp_joc
	;cifra sutelor
	make_text_macro edx,area,eax,y0_counter_timp_joc
	pop eax
	pop ebx
	mov edx,0
	div ebx
	add edx,'0'
	make_text_macro edx,area,x0_counter_timp_joc,y0_counter_timp_joc
	
	;scriem un mesaj
	make_text_macro_grow 'M', area, 230, 30
	make_text_macro_grow 'I', area, 250, 30
	make_text_macro_grow 'N', area, 270, 30
	make_text_macro_grow 'E', area, 295, 30
	make_text_macro_grow 'S', area, 320, 30
	make_text_macro_grow 'W', area, 345, 30
	make_text_macro_grow 'E', area, 370, 30
	make_text_macro_grow 'E', area, 395, 30
	make_text_macro_grow 'P', area, 420, 30
	make_text_macro_grow 'E', area, 445, 30
	make_text_macro_grow 'R', area, 470, 30
	
	make_grow_bomb_macro 0, area, 495, 30
	
	;;;;;CAZ SPECIAL PRIMA LINIE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;modificare nr linii si coloane
	
	
	
	mov eax,X0_matrice_joc
	mov ebx,Y0_matrice_joc
	mov ecx,coloane_matrice_joc
	bucla_desenare_matrice_partea_de_sus:

		push ecx
		push ebx
		push eax
		line_horizontal_macro eax,ebx,len_matrice_joc,0262BFFh
		pop eax ;pt ca in macro se modifica eax,ebx si ecx
		pop ebx
		pop ecx
		
		add ebx,len_matrice_joc
		
		push ecx
		push ebx
		push eax
		line_horizontal_macro eax,ebx,len_matrice_joc,0
		pop eax
		pop ebx
		pop ecx
		
		add eax,len_matrice_joc
		sub ebx,len_matrice_joc
	loop bucla_desenare_matrice_partea_de_sus
	
	line_vertical_macro X0_matrice_joc,Y0_matrice_joc,len_matrice_joc,0262BFFh
	mov eax,1
	mov ebx,len_matrice_joc
	mul ebx
	mov ebx,coloane_matrice_joc
	mul ebx
	add eax,X0_matrice_joc
	line_vertical_macro eax,Y0_matrice_joc,len_matrice_joc,0262BFFh
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	; cmp active_easy,1
	; jne deseneaza_nemodificat
		; mov randuri_matrice_joc,10
		; mov coloane_matrice_joc,10
	; deseneaza_nemodificat:
	
	;desenare fasii orizontale
	fasii_orizontale_macro x1_matrice_joc,y1_matrice_joc,len_matrice_joc,randuri_matrice_joc,coloane_matrice_joc
	;desenare fasii verticale
	fasii_verticale_macro x1_matrice_joc,y2_matrice_joc,len_matrice_joc,randuri_matrice_joc,coloane_matrice_joc
	
	; make_numere_colorate_macro 0,area,101,131
	; make_numere_colorate_macro 1,area,131,131 
	; make_numere_colorate_macro 2,area,161,131
	; make_numere_colorate_macro 3,area,191,131	
	; make_numere_colorate_macro 4,area,221,131	
	; make_numere_colorate_macro 5,area,251,131
	; make_numere_colorate_macro 6,area,281,131
	; make_numere_colorate_macro 7,area,311,131
	; make_numere_colorate_macro 8,area,341,131
	; make_numere_colorate_macro 9,area,371,131
	
	;make_cell_vida_macro 1,area,101,131
	
	;desenare patratel flag
	line_vertical_macro x0_flag,y0_flag,len_matrice_joc,0
	mov eax,x0_flag
	add eax,len_matrice_joc
	line_vertical_macro eax,y0_flag,len_matrice_joc,0
	line_horizontal_macro x0_flag,y0_flag,len_matrice_joc,0
	mov eax,y0_flag
	add eax,len_matrice_joc
	line_horizontal_macro x0_flag,eax,len_matrice_joc,0
	cmp flag_activator,0
	je flag_neactivat
		make_flag_color_macro 1,area,x1_flag,y1_flag
		jmp finalizare_flag
	flag_neactivat:
		make_flag_color_macro 0,area,x1_flag,y1_flag
	finalizare_flag:
	
	;desenare placuta new medium
	make_text_macro ' ',area,x0_new_medium,y0_new_medium
	mov edx,x0_new_medium
	add edx,symbol_width
	make_text_macro 'M',area,edx,y0_new_medium
	add edx,symbol_width
	make_text_macro 'E',area,edx,y0_new_medium
	add edx,symbol_width
	make_text_macro 'D',area,edx,y0_new_medium
	add edx,symbol_width
	make_text_macro 'I',area,edx,y0_new_medium
	add edx,symbol_width
	make_text_macro 'U',area,edx,y0_new_medium
	add edx,symbol_width
	make_text_macro 'M',area,edx,y0_new_medium
	add edx,symbol_width
	make_text_macro ' ',area,edx,y0_new_medium
	
	;desenare placuta new easy
	make_text_macro ' ',area,x0_new_easy,y0_new_easy
	mov edx,x0_new_easy
	add edx,symbol_width
	make_text_macro ' ',area,edx,y0_new_easy
	add edx,symbol_width
	make_text_macro 'E',area,edx,y0_new_easy
	add edx,symbol_width
	make_text_macro 'A',area,edx,y0_new_easy
	add edx,symbol_width
	make_text_macro 'S',area,edx,y0_new_easy
	add edx,symbol_width
	make_text_macro 'Y',area,edx,y0_new_easy
	add edx,symbol_width
	make_text_macro ' ',area,edx,y0_new_easy
	add edx,symbol_width
	make_text_macro ' ',area,edx,y0_new_easy
	
	;desenare placuta new hard
	make_text_macro ' ',area,x0_new_hard,y0_new_hard
	mov edx,x0_new_hard
	add edx,symbol_width
	make_text_macro ' ',area,edx,y0_new_hard
	add edx,symbol_width
	make_text_macro 'H',area,edx,y0_new_hard
	add edx,symbol_width
	make_text_macro 'A',area,edx,y0_new_hard
	add edx,symbol_width
	make_text_macro 'R',area,edx,y0_new_hard
	add edx,symbol_width
	make_text_macro 'D',area,edx,y0_new_hard
	add edx,symbol_width
	make_text_macro ' ',area,edx,y0_new_hard
	add edx,symbol_width
	make_text_macro ' ',area,edx,y0_new_hard

	;verificare victorie
	cmp contor_victorie,216
	je desenare_victorie
	;atentie la acest jmp
	jmp final_draw
	desenare_victorie:
		make_text_macro 'Y',area,310,505
		make_text_macro 'O',area,320,505	
		make_text_macro 'U',area,330,505
		make_text_macro ' ',area,340,505
		make_text_macro 'W',area,350,505
		make_text_macro 'I',area,360,505
		make_text_macro 'N',area,370,505
		mov nr_flaguri,0
		mov flag_activator,1
		
	final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	call generator_matrice_joc ;;;se genereaza matricea de joc
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start
