;Programa par el trazado de segmentos de rectas,dadas las coordenadas de
;sus extremos; y circunferencias o arcos de circunferencias dados el angulo
;inicial y final, asi como su radio y centro.En todos los casos hay que dar
;el color del trazo.


 
Arcoiris	macro
negro			equ	00h
azul			equ	01h
verde			equ	02h
cyan			equ	03h
rojo			equ	04h
magenta			equ	05h
pardo			equ	06h
blanco			equ	07h
gris			equ	08h
azul_palido		equ	09h
verde_palido		equ	0ah
cyan_palido		equ	0bh
rojo_palido		equ	0ch
magenta_palido		equ	0dh
amarillo		equ	0eh
blanco_intenso		equ	0fh
	endm

pushaa	macro
	push	ax
	push	bx
	push	cx
	push	dx
	push	bp
	push	sp
	push	si
	push	di
	endm
popaa	macro
	pop	di
	pop	si
	pop	sp
	pop	bp
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	endm
EsperaTecla	macro
.286c
	pusha
	mov	ah,07h
	int	21h
	popa
	endm

Salir	macro
	mov	ax,4c00h
	int	21h
	endm

Linea	macro	color,XX0,YY0,XX1,YY1	;Para llamar al procedimiento que
	mov	ax,color		;trazara el segmento de recta, se
	push	ax			;utiliza esta macro por ser mas
	mov	ax,XX0			;visual su uso en el momento de
	push	ax			;pasar los parametros adecuados
	mov	ax,YY0			;a este procedimiento.
	push	ax
	mov	ax,XX1
	push	ax
	mov	ax,YY1
	push	ax
	call	recta
	endm
line	struc
	Y1	dw	0h
	X1	dw	0h
	Y0	dw	0h
	X0	dw	0h
line	ends
point	struc
	YY	dw	0h
	XX	dw	0h
point	ends
;Cuad	struc
;	Y11
;	X11
;	Y10
;	X10
;	Y01
;	X01
;	Y00
;	X00
;	ends
PoliCuad	macro	color,X00,Y00,X01,Y01,X10,Y10,X11,Y11
	linea	color,X00,Y00,X10,Y10
	linea	color,X10,Y10,X01,Y01
	linea	color,X01,Y01,X11,Y11
	linea	color,X11,Y11,X00,Y00
	endm
Arco	macro	color,centro_X,centro_Y,radio,alfa_0,alfa_1
	mov	ax,color
	push	ax
	mov	ax,centro_X
	push	ax
	mov	ax,centro_Y
	push	ax
	mov	ax,radio
	push	ax
	mov	ax,alfa_0
	push	ax
	mov	ax,alfa_1
	push	ax
	call	aro
	endm
@p_en_recta	macro	punt_des,punt_seg,px,py,x0,y0,x1,y1
	mov	ax,punt_des
	push	ax
	mov	ax,punt_seg
	push	ax
	mov	ax,px
	push	ax
	mov	ax,py
	push	ax
	mov	ax,x0
	push	ax
	mov	ax,y0
	push	ax
	mov	ax,x1
	push	ax
	mov	ax,y1
	push	ax
	call	p_en_recta
	endm
;*****************************************************************************
;El segmento de datos esta formado por una tabla de los valores de las funcio-
;nes seno y coseno, desde el angulo cero grados hasta el angulo 360 grados en 
;incrementos de 0'5 grados.Esta tabla se utiliza para el trazado de circunfe-
;rencias y arcos de circunferencia.Estos valores estan multiplicados por el
;numero decimal 32767, que en exadecimal es 7FFF,valor positivo mas grande
;representable en palabras de 16 bits.Es decir si se mira en la tabla se vera
;que para el coseno de cero grados aparece un valor de 32767, esto se hace asi
;para aprobechar al maximo la resolucion conseguida con palabras de 16 bits.

datos	segment
sen	dw	00000,00285,00571,00857,01143,01429,01714,02000,02285,02570,02855,03140
	dw	03425,03709,03993,04276,04560,04843,05125,05408,05689,05971,06252,06532
	dw	06812,07092,07370,07649,07927,08204,08480,08756,09031,09306,09580,09853
	dw	10125,10397,10667,10937,11206,11475,11742,12009,12274,12539,12803,13065
	dw	13327,13588,13847,14106,14364,14620,14875,15130,15383,15635,15885,16135
	dw	16383,16630,16876,17120,17363,17605,17846,18085,18323,18559,18794,19027
	dw	19259,19490,19719,19947,20173,20397,20620,20842,21062,21280,21497,21712
	dw	21925,22137,22347,22555,22761,22966,23169,23371,23570,23768,23964,24158
	dw	24350,24541,24729,24916,25100,25183,25464,25643,25820,25995,26168,26339
	dw	26509,26676,26841,27004,27165,27323,27480,27635,27787,27938,28086,28233
	dw	28377,28518,28658,28796,28931,29064,29195,29324,29450,29575,29696,29816
	dw	29934,30049,30162,30272,30381,30486,30590,30695,30790,30887,30981,31073
	dw	31163,31250,31335,31417,31497,31575,31650,31723,31793,31861,31927,31990
	dw	32050,32109,32164,32218,32269,32317,32363,32407,32448,32486,32522,32556
	dw	32587,32616,32642,32665,32687,32705,32722,32735,32747,32755,32762,32765
cos	dw	32767
	dw	32765,32762,32755,32747,32735,32722,32705,32687,32665,32642,32616,32587
	dw	32556,32522,32486,32448,32407,32363,32317,32269,32218,32164,32109,32050
	dw	31990,31927,31861,31793,31723,31650,31575,31497,31417,31335,31250,31163
	dw	31073,30981,30887,30790,30695,30590,30486,30381,30272,30162,30049,29934
	dw	29816,29696,29575,29450,29324,29195,29064,28931,28796,28658,28518,28377
	dw	28233,28086,27938,27787,27635,27480,27323,27165,27004,26841,26676,26509
	dw	26339,26168,25995,25820,25643,25464,25283,25100,24916,24729,24541,24350
	dw	24158,23964,23768,23570,23371,23169,22966,22761,22555,22347,22137,21925
	dw	21712,21497,21280,21062,20842,20620,20397,20173,19947,19719,19490,19259
	dw	19027,18794,18559,18323,18085,17846,17605,17363,17120,16876,16630,16383
	dw	16135,15885,15635,15383,15130,14875,14620,14364,14106,13847,13588,13327
	dw	13065,12803,12539,12274,12009,11742,11475,11206,10937,10667,10397,10125
	dw	09853,09580,09306,09031,08756,08480,08204,07927,07649,07370,07092,06812
	dw	06532,06252,05971,05689,05408,05125,04843,04560,04276,03993,03709,03425
	dw	03140,02855,02570,02285,02000,01714,01429,01143,00857,00571,00285,00000
	dw	       -00285,-00571,-00857,-01143,-01429,-01714,-02000,-02285,-02570,-02855,-03140
	dw	-03425,-03709,-03993,-04276,-04560,-04843,-05125,-05408,-05689,-05971,-06252,-06532
	dw	-06812,-07092,-07370,-07649,-07927,-08204,-08480,-08756,-09031,-09306,-09580,-09853
	dw	-10125,-10397,-10667,-10937,-11206,-11475,-11742,-12009,-12274,-12539,-12803,-13065
	dw	-13327,-13588,-13847,-14106,-14364,-14620,-14875,-15130,-15383,-15635,-15885,-16135
	dw	-16383,-16630,-16876,-17120,-17363,-17605,-17846,-18085,-18323,-18559,-18794,-19027
	dw	-19259,-19490,-19719,-19947,-20173,-20397,-20620,-20842,-21062,-21280,-21497,-21712
	dw	-21925,-22137,-22347,-22555,-22761,-22966,-23169,-23371,-23570,-23768,-23964,-24158
	dw	-24350,-24541,-24729,-24916,-25100,-25183,-25464,-25643,-25820,-25995,-26168,-26339
	dw	-26509,-26676,-26841,-27004,-27165,-27323,-27480,-27635,-27787,-27938,-28086,-28233
	dw	-28377,-28518,-28658,-28796,-28931,-29064,-29195,-29324,-29450,-29575,-29696,-29816
	dw	-29934,-30049,-30162,-30272,-30381,-30486,-30590,-30695,-30790,-30887,-30981,-31073
	dw	-31163,-31250,-31335,-31417,-31497,-31575,-31650,-31723,-31793,-31861,-31927,-31990
	dw	-32050,-32109,-32164,-32218,-32269,-32317,-32363,-32407,-32448,-32486,-32522,-32556
	dw	-32587,-32616,-32642,-32665,-32687,-32705,-32722,-32735,-32747,-32755,-32762,-32765
	dw	-32767								
	dw	-32765,-32762,-32755,-32747,-32735,-32722,-32705,-32687,-32665,-32642,-32616,-32587
	dw	-32556,-32522,-32486,-32448,-32407,-32363,-32317,-32269,-32218,-32164,-32109,-32050
	dw	-31990,-31927,-31861,-31793,-31723,-31650,-31575,-31497,-31417,-31335,-31250,-31163
	dw	-31073,-30981,-30887,-30790,-30695,-30590,-30486,-30381,-30272,-30162,-30049,-29934
	dw	-29816,-29696,-29575,-29450,-29324,-29195,-29064,-28931,-28796,-28658,-28518,-28377
	dw	-28233,-28086,-27938,-27787,-27635,-27480,-27323,-27165,-27004,-26841,-26676,-26509
	dw	-26339,-26168,-25995,-25820,-25643,-25464,-25283,-25100,-24916,-24729,-24541,-24350
	dw	-24158,-23964,-23768,-23570,-23371,-23169,-22966,-22761,-22555,-22347,-22137,-21925
	dw	-21712,-21497,-21280,-21062,-20842,-20620,-20397,-20173,-19947,-19719,-19490,-19259
	dw	-19027,-18794,-18559,-18323,-18085,-17846,-17605,-17363,-17120,-16876,-16630,-16383
	dw	-16135,-15885,-15635,-15383,-15130,-14875,-14620,-14364,-14106,-13847,-13588,-13327
	dw	-13065,-12803,-12539,-12274,-12009,-11742,-11475,-11206,-10937,-10667,-10397,-10125
	dw	-09853,-09580,-09306,-09031,-08756,-08480,-08204,-07927,-07649,-07370,-07092,-06812
	dw	-06532,-06252,-05971,-05689,-05408,-05125,-04843,-04560,-04276,-03993,-03709,-03425
	dw	-03140,-02855,-02570,-02285,-02000,-01714,-01429,-01143,-00857,-00571,-00285,-00000
	dw	      00285,00571,00857,01143,01429,01714,02000,02285,02570,02855,03140
	dw	03425,03709,03993,04276,04560,04843,05125,05408,05689,05971,06252,06532
	dw	06812,07092,07370,07649,07927,08204,08480,08756,09031,09306,09580,09853
	dw	10125,10397,10667,10937,11206,11475,11742,12009,12274,12539,12803,13065
	dw	13327,13588,13847,14106,14364,14620,14875,15130,15383,15635,15885,16135
	dw	16383,16630,16876,17120,17363,17605,17846,18085,18323,18559,18794,19027
	dw	19259,19490,19719,19947,20173,20397,20620,20842,21062,21280,21497,21712
	dw	21925,22137,22347,22555,22761,22966,23169,23371,23570,23768,23964,24158
	dw	24350,24541,24729,24916,25100,25183,25464,25643,25820,25995,26168,26339
	dw	26509,26676,26841,27004,27165,27323,27480,27635,27787,27938,28086,28233
	dw	28377,28518,28658,28796,28931,29064,29195,29324,29450,29575,29696,29816
	dw	29934,30049,30162,30272,30381,30486,30590,30695,30790,30887,30981,31073
	dw	31163,31250,31335,31417,31497,31575,31650,31723,31793,31861,31927,31990
	dw	32050,32109,32164,32218,32269,32317,32363,32407,32448,32486,32522,32556
	dw	32587,32616,32642,32665,32687,32705,32722,32735,32747,32755,32762,32765
	dw	32767
	dw	32765,32762,32755,32747,32735,32722,32705,32687,32665,32642,32616,32587

datos	ends

codigo segment
assume	cs:codigo,ss:pila,ds:datos
;*********************************
;Procedimiento para el trazado de circunferencias y arcos de circunferencia

aro	proc
.286c
	jmp	sig
D	dw	?		;Se pretende trazar arcos de radio variable,
sig:				;por tanto los valores de la tabla de senos
	pushaa			;y cosenos han, de ser divididos por un numero
	mov	bp,sp		;que dependera del radio deseado, este numero
	mov	dx,0		;es D. Aqui esta su lugar de almacenamiento
	mov	ax,32767	;y en estas lineas de codigo se procede a su
	mov	bx,[bp+22]	;calculo.[bp+22] es la direccion en el segmen-
	div	bx		;de pila del parametro "radio".
	mov	cs:D,ax


	mov	cx,[bp+18]	;Angulo final en CX
	sub	cx,[bp+20]	;Amplitud del arco en CX (en grados enteros)
	sal	cx,1h		;Multiplicar por dos, los valores en la
				;tabla van en incrementos de 0'5 grados
				;CX se utiliza como contador del numero de
				;puntos ha ver del arco de circunferencia

bucle:	mov	di,[bp+20]	;Conversion del angulo inicial de trazado del
				;arco de circunferencia, en su correcta posi-
				;cion en la tabla de senos y cosenos
	sal	di,2h		;Multiplicar por cuatro.Por cada grado hay dos
				;valores en la tabla, y cada valor acupa una
				;palabra de dos bytes.Se recuerda que en la
				;familia del 8086, el direccionamiento es de
				;bytes
	sal	cx,1h		;Multiplicar por dos, cada valor ocupa una pa-
	add	di,cx		;labra de dos bytes
	sar	cx,1h		;DI apunta a palabras de 16 bits
	mov	ax,sen[di]	;Cargar AX con el seno del angulo

	cmp	ax,0h		;Codigo para el tratamiento correcto de los
	js	negativo	;valores de seno negativos en el calculo del
	mov	dx,0		;radio efectivo.
	div	cs:D		;Se pone cs:D porque no esta en el segmento de
	jmp	siguiente	;datos, y hay que explicitar este echo.
negativo:
	mov	dx,0
	neg	ax
	div	cs:D
	neg	ax
siguiente:

;	sar	ax,7h
	add	ax,[bp+24]
	mov	bx,ax
	mov	ax,cos[di]

	cmp	ax,0h
	js	negat
	mov	dx,0
	div	cs:D
	jmp	sigui
negat:	mov	dx,0
	neg	ax
	div	cs:D
	neg	ax
sigui:


;	sar	ax,7h
	add	ax,[bp+26]
	mov	dx,ax
	mov	ax,[bp+28]
	push	ax		;Color en la pila
	push	dx		;Coordenada X en la pila
	push	bx		;Coordenada Y en la pila
				;Preparandose para llamar al procedimiento
				;de trazado de segmentos de recta.La primera
				;parte de sus parametros ya esta en la pila.

;****************************
	jmp	passss
_bucle:	jmp	bucle		;Subterfugio usado por haber saltos largos
passss:				;fuera de rango
;****************************
	mov	ax,sen[di+2]

	cmp	ax,0h
	js	_negativo
	mov	dx,0
	div	cs:D
	jmp	_siguiente
_negativo:
	mov	dx,0
	neg	ax
	div	cs:D
	neg	ax
_siguiente:

;	sar	ax,7h
	add	ax,[bp+24]
	mov	bx,ax
	mov	ax,cos[di+2]

	cmp	ax,0h
	js	_negat
	mov	dx,0
	div	cs:D
	jmp	_sigui
_negat:	mov	dx,0
	neg	ax
	div	cs:D
	neg	ax
_sigui:


;	sar	ax,7h
	add	ax,[bp+26]
	mov	dx,ax
	mov	ax,[bp+28]
	push	dx
	push	bx
	call	recta
;***************************

;	call	punto
;	linea	[bp+28],[bp+26],[bp+24],dx,bx
	loop	_bucle		;Decrementa CX y repeticion si CX<>0 
	popaa
	ret	12		;Desechar los parametros pasados en la llamda
				;y volver al codigo que llam¢.
aro	endp
;****************************************************************************
;Procedimiento para el trazado de segmentos de rectas.
;Este procedimiento es recursivo es decir se llama asi mismo.Dado los puntos
;inicial y final del segmento de recta, trazar este es lo mismo que trazar
;primero sus dos mitades, que asu vez son segmentos de recta.La condicion de
;escape es cuando el segmento esta formado por unicamente dos puntos.
recta	proc
	pushaa
	mov	bp,sp
	mov	ax,ss:[bp+18].Y1
	sub	ax,ss:[bp+18].Y0
	jns	cx_pos
	neg	ax
	sar	ax,1h
	neg	ax
	jmp	cx_sal
cx_pos:	sar	ax,1h
cx_sal:	mov	cx,ax
	mov	ax,ss:[bp+18].X1
	sub	ax,ss:[bp+18].X0

	jns	dx_pos
	neg	ax
	sar	ax,1h
	neg	ax
	jmp	dx_sal
dx_pos:	sar	ax,1h
dx_sal:	mov	dx,ax
	cmp	dx,0h
	jne	equis_no_cero		;Ver condicion de escape

	cmp	cx,0h
	jne	yes_no_cero		;Ver condicion de escape

	mov	ax,ss:[bp+26]		;Preparacion para llamar al procedimi-
	push	ax			;que visualizara el punto.
	mov	ax,ss:[bp+18].X0
	push	ax
	mov	ax,ss:[bp+18].Y0
	push	ax
	call	punto			;LLamar al procedimiento "punto".
	jmp	exit
equis_no_cero:
yes_no_cero:
	mov	ax,ss:[bp+26]		;Preparacion para llamarse a si mismo
	push	ax
	mov	ax,ss:[bp+18].X0
	push	ax
	mov	ax,ss:[bp+18].Y0
	push	ax
	add	dx,ss:[bp+18].X0
	push	dx
	add	cx,ss:[bp+18].Y0
	push	cx
	call	recta			;LLamarse a si mismo

	mov	ax,ss:[bp+26]		;Preparacion para llamarse a si mismo
	push	ax
	push	dx
	push	cx
	mov	ax,ss:[bp+18].X1
	push	ax
	mov	ax,ss:[bp+18].Y1
	push	ax
	call	recta			;LLamarse a si mismo
exit:	popaa				;Recuperar registros
	ret	10			;Retornar y desechar los parametros
					;pasados en la llamada
recta	endp

p_en_recta	proc
;Procedimiento con parametros pasados, en el momento de la llamada, en la pila
;Estructura de los parametros: retorno:apuntador_palabra,punto_X:palabra,
;punto_Y:palabra, X0:palabra, Y0:palabra, X1:palabra, Y1:palabra.El apuntador
;a palabra esta formado por una direccion segmento y desplazamiento dentro de
;ese segmento, por lo tanto su tama¤o es de 32 bits.
	jmp	_00
_desp	dw	?
_segm	dw	?
aint_10	label dword
aint10_des	dw	?
aint10_seg	dw	?
_00:	pushaa
	mov	bp,sp
	mov	ax,[bp+30]
	mov	cs:_desp,ax
	mov	ax,[bp+32]
	mov	cs:_segm,ax
	mov	ah,35h
	mov	al,10h
	int	21h
	mov	cs:aint10_des,bx
	mov	cs:aint10_seg,es
	push	cs
	pop	ds
	lea	dx,nint10
	mov	ah,25h
	mov	al,10h
	int	21h
	Linea	negro,[bp+24],[bp+22],[bp+20],[bp+18]
	lea	dx,aint10_des
	lea	ax,aint10_seg
	mov	ds,ax
	mov	ah,25h
	mov	al,10h
	int	21h
	popaa
	ret	16
nint10:	
	cmp	ah,0ch
	jne	_01
	cmp	cx,[bp+28]
	jne	no
	cmp	dx,[bp+26]
	jne	no
	pushaa
	mov	ax,cs:_desp
	mov	ds,ax
	mov	di,cs:_segm
	mov	word ptr ds:[di],01h
no:	popaa
	iret
_01:	jmp	aint_10
p_en_recta	endp



punto	proc
	pushaa				;Salvar registros
	mov	bp,sp			;Preparacion para llamar al BIOS
	mov	ax,ss:[bp+22]		;Color del punto
	mov	ah,0ch			;Funcion 0C de int 10h
	mov	bh,0h			;Pagina cero de pantalla
	mov	cx,ss:[bp+18].XX	;Coordenada X
	mov	dx,ss:[bp+18].YY	;Coordenada Y
	int	10h			;LLamar al BIOS de la ROM
	popaa				;Recuperar registros
	ret	6			;Retornar y desechar parametros
punto	endp

	Arcoiris			;Instruir sobre los colores
entrada:
	mov	ax,datos		;Inicializar el registro de segmento
	mov	ds,ax			;DS con la direccion segmento de datos
	
	mov	ah,00h
	mov	al,12h			;Modo de video
	int	10h			;LLamar al BIOS de la ROM

	linea	verde,400,400,0,0
	linea	azul,400,200,0,0
	linea	blanco,640,0,400,200
	linea	gris,400,100,0,0
	linea	rojo,640,0,400,100
	linea	cyan,640,0,400,400
	PoliCuad	blanco_intenso,40,50,50,200,20,150,80,100
	PoliCuad	rojo,100,80,300,280,100,280,300,80
	PoliCuad	rojo,150,130,350,330,150,330,350,130
	linea		rojo,100,80,150,130
	linea		rojo,300,280,350,330
	linea		rojo,100,280,150,330
	linea		rojo,300,80,350,130
	PoliCuad	rojo,200,10,400,210,200,210,400,10
	linea		rojo,100,80,200,10
	linea		rojo,100,280,200,210
	linea		rojo,300,80,400,10
	linea		rojo,300,280,400,210
	linea	blanco,0,300,400,310
	mov	cx,1
otra:	
;	Arco	verde,320,240,cx,0,90
;	Arco	rojo,320,240,cx,270,360
;	Arco	amarillo,320,240,cx,180,270
	Arco	amarillo,320,240,cx,0,360
;	Arco	azul,320,240,cx,90,180
	add	cx,1h
	cmp 	cx,300
	jnae	otra
	EsperaTecla
	mov	ah,00h
	mov	al,03h
	int	10h
	Salir
codigo	ends
pila	segment	stack
	db	200h	dup(?)
pila	ends

	end	entrada
                                                                            