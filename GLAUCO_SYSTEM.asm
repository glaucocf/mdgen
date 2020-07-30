;----------------------------------------------------------
;		REGISTER EQUATES
;----------------------------------------------------------
Z80REQ:		EQU	$A11100
Z80RES:		EQU	$A11200
Z80RAM:		EQU	$A00000

B4:			EQU	1<<4
B30:		EQU	1<<30

VDP_DATA:	EQU	$FFC00000
VDP_STATUS:	EQU	$FFC00004
VDP_CONTROL:	EQU	$FFC00004

VRAMW:		EQU	%01*B30+%0000*B4
CRAMW:		EQU	%11*B30+%0000*B4
VSRAMW:		EQU	%01*B30+%0001*B4
VRAMR:		EQU	%00*B30+%0000*B4
CRAMR:		EQU	%00*B30+%0010*B4
VSRAMR:		EQU	%00*B30+%0001*B4

;DMA MEMORY BLOCK DESTINATIONS
DMAVRAM:	EQU	%01*B30+%1000*B4
DMACRAM:	EQU	%11*B30+%1000*B4
DMAVSRAM:	EQU	%01*B30+%1001*B4

STACK_SIZE:	EQU	1024

		RSSET	$FFFF0000
WORKRAM:	RS.B	STACK_SIZE
ENDSTACK:	RS.B	0
SYSTEMRAM:	RS.B	0
DMANUM:		EQU	80

;JOYPAD STUFF
CTRL_1_DATA:	EQU	$00A10003
CTRL_2_DATA:	EQU	$00A10005
CTRL_X_DATA:	EQU	$00A10007
CTRL_1_CONTROL:	EQU	$00A10009
CTRL_2_CONTROL:	EQU	$00A1000b
CTRL_X_CONTROL:	EQU	$00A1000d
MDSCTRL1:		EQU	$00A10013
MDSCTRL2:		EQU	$00A10019
MDSCTRLX:		EQU	$00A1001f

MEM_CONTROL_1_6BUTTON:		EQU $FFFF000A
MEM_CONTROL_HELD:			EQU $FFFF000C
MEM_CONTROL_PRESSED:		EQU $FFFF000E
MEM_CONTROL_6_HELD:			EQU $FFFF0010
MEM_CONTROL_6_PRESSED:		EQU $FFFF0012
MEM_DEBUG_CYCLE1_INIT:		EQU $FFFF0020
MEM_DEBUG_CYCLE2_INIT:		EQU $FFFF0022
MEM_DEBUG_CYCLE3_INIT:		EQU $FFFF0024
MEM_DEBUG_CYCLE4_INIT:		EQU $FFFF0026
MEM_DEBUG_CYCLE5_INIT:		EQU $FFFF0028
MEM_DEBUG_CYCLE6_INIT:		EQU $FFFF002A
MEM_DEBUG_CYCLE7_INIT:		EQU $FFFF002C
MEM_DEBUG_CYCLE8_INIT:		EQU $FFFF002E
MEM_DEBUG_CYCLE9_INIT:		EQU $FFFF0030
MEM_DEBUG_CYCLE1_VBLANK:	EQU $FFFF0032
MEM_DEBUG_CYCLE2_VBLANK:	EQU $FFFF0034
MEM_DEBUG_CYCLE3_VBLANK:	EQU $FFFF0036
MEM_DEBUG_CYCLE4_VBLANK:	EQU $FFFF0038
MEM_DEBUG_CYCLE5_VBLANK:	EQU $FFFF003A
MEM_DEBUG_CYCLE6_VBLANK:	EQU $FFFF003C
MEM_DEBUG_CYCLE7_VBLANK:	EQU $FFFF003E
MEM_DEBUG_CYCLE8_VBLANK:	EQU $FFFF0040
MEM_DEBUG_CYCLE9_VBLANK:	EQU $FFFF0042

J_UP:			EQU	 0
J_DOWN:			EQU	 1
J_LEFT:			EQU	 2
J_RIGHT:		EQU	 3

J_BUT_B:		EQU	 4
J_BUT_C:		EQU	 5
J_BUT_A:		EQU	 6
J_BUT_S:		EQU	 7

J_BUT_Z:		EQU	 4
J_BUT_Y:		EQU	 5
J_BUT_X:		EQU	 6
J_BUT_M:		EQU	 7


;SPRITE STUFF
S_1X1:		EQU	 0<<8
S_1X2:		EQU	 1<<8
S_1X3:		EQU	 2<<8
S_1X4:		EQU	 3<<8
S_2X1:		EQU	 4<<8
S_2X2:		EQU	 5<<8
S_2X3:		EQU	 6<<8
S_2X4:		EQU	 7<<8
S_3X1:		EQU	 8<<8
S_3X2:		EQU	 9<<8
S_3X3:		EQU	10<<8
S_3X4:		EQU	11<<8
S_4X1:		EQU	12<<8
S_4X2:		EQU	13<<8
S_4X3:		EQU	14<<8
S_4X4:		EQU	15<<8

S_PAL1:		EQU	$0000
S_PAL2:		EQU	$2000
S_PAL3:		EQU	$4000
S_PAL4:		EQU	$6000

;----------------------------------------------------------
;		USEFUL MACROS
;----------------------------------------------------------
WAITDMA:	MACRO
@LOOP\@	 	BTST	#1,VDP_STATUS+1
	 	BNE.S	@LOOP\@
		ENDM

WREG:		MACRO
		MOVE	#$8000!((\1)<<8)!((\2)&$FF),VDP_CONTROL
		ENDM

WREGR:		MACRO
	 	AND	#$00FF,\2
	 	OR	#VDP_R\1,\2
	 	MOVE	\2,VDP_CONTROL
		ENDM

WDEST:		MACRO
	 	MOVE.L	#\1+((\2)&$3FFF)<<16+(\2)>>14,VDP_CONTROL
		ENDM

WDESTR:		MACRO
		ROL.L	#2,\2
		ROR	#2,\2
	 	SWAP	\2
	 	AND.L	#$3FFF0003,\2
	 	OR.L	#\1,\2
	 	MOVE.L	\2,VDP_CONTROL
		ENDM

WAITVBI:	MACRO
		MOVE.W	#0,VBLANKON
@LOOP\@:	CMP.W	#0,VBLANKON
		BEQ.S	@LOOP\@
		ENDM

DMADUMP:	MACRO
		MOVE.L	#(\2)/2,D0
		MOVE.L	#\1,D1
		MOVE.L	#\3,D2
		JSR	DMADUMPS
		ENDM

DMAFPAL:	MACRO
		MOVE.L	#(((\2)/2)&$FF)<<16+(((\2)/2)&$FF00)>>8+$93009400,D0	;LENGTH
		MOVE.L	#((((\1)/2)&$FF)<<16)+((((\1)/2)&$FF00)>>8)+$95009600,D1
		MOVE.W	#(((\1)/2)&$7F0000)>>16+$9700,D2	;SOURCE
		MOVE.W	#((\3)&$3FFF)+$C000,D3			;CRAM
		MOVE.W	#((\3)&$C000)>>14+$0080,D4		;CRAM
		JSR	RAMDMAF
		ENDM

;----------------------------------------------------------
;		SYSTEM VARIABLES
;----------------------------------------------------------
		RSSET	SYSTEMRAM	;POINT AT SYSTEM RAM (AFTER STACK)
STARTVARS:	RS.B	0		;POINTER TO START OF VARS
HOTSTART:	RS.W	1		;HOT START FLAG
VBLANKON:	RS.W	1		;FLAG TO SAY WHEN VERTICAL BLANK CODE IS FINISHED
VBIVECTOR:	RS.L	1		;LOCATION OF VBLANK ROUTINE
JOYPAD6:	RS.B	1		;JOYPAD INFORMATION
JOYPAD3:	RS.B	1		;JOYPAD INFORMATION
JOYPADOLD3:
		RS.B	1		;JOYPAD INFORMATION FROM LAST FRAME
		RS.W	1		;QUICK SOURCE UNUSED
JOYPADOLD6:
		RS.B	1		;JOYPAD INFORMATION FROM LAST FRAME
		RS.W	1		;QUICK SOURCE UNUSED
QSOURCE:	RS.L	1		;QUICK SOURCE
		RS.W	1		;QUICK SOURCE
QSIZE:		RS.L	1		;QUICK SIZE RAM
DMAREQ:		RS.W	DMANUM*7	;DMA REQUEST STORE
		RS.L	1		;OVERRUN
RAMDMA:		RS.B	200		;RAM DMAS
PALETTES:	RS.W	16*4		;PALETTE ON SCREEN
SPRITETEMP:	RS.W	120*4		;TABLE FOR SPRITE DATA(80 SPRITES + 40 OVERRUN)

USERRAM:	RS.B	0

;----------------------------------------------------------
;		CARTRIDGE HEADER INFORMATION
;----------------------------------------------------------
		ORG	$0000
		DC.L	ENDSTACK		;STACK POINTER
		DC.L	CODESTART		;PROGRAM COUNTER

		ORG	$0068

		DC.L	EXTINT
		DC.L	ERROR
		DC.L	HBLANK
		DC.L	ERROR
		DC.L	VBLANK

		REPT	33
		DC.L	ERROR
		ENDR

CARTRIDGEDATA:
		DC.B	"SEGA MEGA DRIVE " ; System type
		DC.B	"(C)GCFG 2020.JUL" ; Copyright!
TITLE:
		DC.B	"MDGEN: The Sega Mega Drive/Genesis Cartgide Rom " ; Domestic title
		DC.B	"MDGEN: The Sega Mega Drive/Genesis Cartgide Rom " ; Overseas title
		DC.B	"GF YYYYYYYY-ZZ"	;PRODUCT NO;VERSION
		DC.W	0			;CHECKSUM
		DC.B	"6               "	;CONTROL DATA
		DC.L	$000000,$3FFFFF 	;ROM ADDRESS
		DC.L	$FF0000,$FFFFFF   	;RAM ADDRESS
		DC.B	"            "    	;EXTERNAL RAM.
		DC.B	"            "    	;MODEM DATA
		DC.B	"                                        "	;MEMO
		DC.B	"F               "	;RELEASE CODES FOR REGIONS (F is ALL 50Hz and 60Hz)
;		NORG	$0200
;----------------------------------------------------------
;	SYSTEM INIT
;----------------------------------------------------------
CODESTART:
		MOVE.W	#$2700,SR	;TURN OFF INTERUPTS
		MOVE.W	#1,HOTSTART
		TST.L	$A10008
		BNE.S	@HOTSTART
		TST.W	$A1000C
		BNE.S	@HOTSTART
		CLR.W	HOTSTART
		MOVE.B	$A10001,D0
		ANDI.B	#$F,D0
		BEQ.S	@J1
		MOVE.L	#'SEGA',$A14000
@J1:
		MOVE.L  #$C0000000,$C00004
		CLR.L	D1
		MOVE.W  #$3F,D0
@CLR1:
		MOVE.W	D1,$C00000
		DBF	D0,@CLR1
		LEA.L	$FFFF0000,A0
		MOVE.W	#$3FFF,D0
@CLR2:
		MOVE.L	D1,(A0)+
		DBF	D0,@CLR2

@HOTSTART:
		LEA.L	ENDSTACK,SP		;SET UP STACK POINTER
		BSR.W   INIT_Z80
		MOVE.W	#$2300,SR

		WAITDMA				;WAIT FOR ANY DMA TO FINISH
		MOVE.W	#$2700,SR		;STOP ALL INTERUPTS

		MOVE.L	#NULL,VBIVECTOR		;SETUP DUMMY VERTICAL BLANK ROUTINE

		JSR	INIT_VDP_REG

		JSR	CLEARCRAM
		JSR	CLEARVSRAM
		JSR	CLEARVRAM

		MOVE	#$2000,SR		;ENABLE INTERUPTS
		WREG	1,%01100100		;ENABLE VBLANK
		WREG	0,%00000100		;DISABLE HBLANK

		TST.W	HOTSTART		;WAS IT A 'HOT START'?
		BNE.S	@HOT
;HARD RESET CODE HERE IF NEEDED
		BRA.S	@SKIP

@HOT:
		MOVE.W	#50-1,D0		;STOP RESET BUG
@PAUSE:
		WAITVBI
		DBRA	D0,@PAUSE

@SKIP:
		JSR	JOYINIT			;INITIALIZE JOYPADS

		JSR	SETUPRAM		;COPY IN PERMANENT RAM ROUTINES

		WDEST	VSRAMW,$0000	;VSCROLL OFFSET
		MOVE.L	#0,VDP_DATA
		WDEST	VRAMW,$FC00		;HSCROLL OFFSET
		MOVE.L	#0,VDP_DATA

		MOVE.L	#$FC00,A0		;CLEAR HSCROLL TABLE
		MOVE.L	#896,D0
		BSR	CLEARVRAM2

		MOVE.L	#$C000,A0		;CLEAR MAP1
		MOVE.L	#4096,D0
		BSR	CLEARVRAM2

		MOVE.L	#$E000,A0		;CLEAR MAP2
		MOVE.L	#4096,D0
		BSR	CLEARVRAM2

		MOVE.L	#$0000,A0		;CLEAR FIRST BLOCK IN VIDEO MEMORY
		MOVE.L	#32,D0
		BSR	CLEARVRAM2

		LEA.L	SYSPALETTE1,A0
		BSR	SETPAL1
		LEA.L	SYSPALETTE2,A0
		BSR	SETPAL2
		LEA.L	SYSPALETTE1,A0
		BSR	SETPAL3
		LEA.L	SYSPALETTE2,A0
		BSR	SETPAL4

		JSR	DUMPCOLS

		JSR	SPRITEINIT

		JSR	USERINIT

		MOVE.L	#MAINVBI,VBIVECTOR	;START MAIN VERTICAL BLANK ROUTINE

		JMP	MAIN			;JUMP TO START OF USER CODE

;----------------------------------------------------------
;		INITIALIZE VDP
;		SETUP VIDEO FOR 40 COLUMNS AND
;		28 LINES (320x224).
;----------------------------------------------------------
INIT_VDP_REG:
		WREG	15,%00000010		;ALWAYS ASSUME WORD INC

		WREG	00,%00000100		;INTERUPTS OFF
		WREG	01,%00000100		;SCREEN SETUP
		WREG	02,%00110000		;SCREEN A
		WREG	03,%00000000		;WINDOW
		WREG	04,%00000111		;SCREEN B
		WREG	05,%00000000		;SPRITE ATTRIBUTE TABLE
		WREG	06,%00000000		;
		WREG	07,%00000000		;BACKGROUND COLOUR
		WREG	08,%00000000		;
		WREG	09,%00000000		;
		WREG	10,%11111111		;HORIZ INT COUNT
		WREG	11,%00000000		;FULL SCROLL
		WREG	12,%10000001		;320 WIDE NO HALF BRITE
		WREG	13,%00111111		;HORIZ SCROLL TABLE POINT
		WREG	14,%00000000		;
		WREG	16,%00000001		;SCROLL SIZE
		WREG	17,%00000000		;WINDOW H POS
		WREG	18,%00000000		;WINDOW V POS

		WREG	15,%00000010		;ALWAYS ASSUME WORD INC

		RTS

;----------------------------------------------------------
;		CLEAR VRAM TO 0
;----------------------------------------------------------
CLEARVRAM:
		WDEST	VRAMW,$0000
		MOVE.L	#$800-1,D0
		MOVEQ.L	#$0,D1
		LEA.L	VDP_DATA,A0
@LOOP:
		MOVE.L	D1,(A0)
		MOVE.L	D1,(A0)
		MOVE.L	D1,(A0)
		MOVE.L	D1,(A0)
		MOVE.L	D1,(A0)
		MOVE.L	D1,(A0)
		MOVE.L	D1,(A0)
		MOVE.L	D1,(A0)
		DBRA	D0,@LOOP
		RTS

;----------------------------------------------------------
;		CLEAR VRAM FROM A0
;		LENGTH D0 TO 0
;----------------------------------------------------------
CLEARVRAM2:
		MOVE.L	A0,D1
		WDESTR	VRAMW,D1
		MOVEQ.L	#$0,D1
		LSR.L	#2,D0
		SUB.L	#1,D0
		LEA.L	VDP_DATA,A0
@LOOP:
		MOVE.L	D1,(A0)
		DBRA	D0,@LOOP
		RTS

;----------------------------------------------------------
;		CLEAR COLOUR RAM (CRAM) TO 0
;----------------------------------------------------------
CLEARCRAM:
		WDEST	CRAMW,$0000
		MOVE.L	#64-1,D0
		MOVEQ.L	#0,D1
		LEA.L	VDP_DATA,A0
@LOOP:
		MOVE.W	D1,(A0)
		DBRA	D0,@LOOP
		RTS

;----------------------------------------------------------
;		CLEAR VIDEO RAM (VSRAM) TO 0
;----------------------------------------------------------
CLEARVSRAM:
		WDEST	VSRAMW,$0000
		MOVE.L	#128/2-1,D0
		MOVEQ.L	#0,D1
		LEA.L	VDP_DATA,A0
@LOOP:
		MOVE.W	D1,(A0)
		DBRA	D0,@LOOP
		RTS

;----------------------------------------------------------
;		CLEAR USER RAM TO 0
;----------------------------------------------------------
CLEARRAM:
		LEA.L	STARTVARS,A0
		MOVE.L	#(ENDVARS-STARTVARS)-1,D0
		MOVEQ.L	#0,D1
@LOOP:
		MOVE.B	D1,(A0)+
		DBRA	D0,@LOOP
		RTS

;----------------------------------------------
; 		INITIALIZE THE Z80
;----------------------------------------------
INIT_Z80:
		MOVE.W	#$100,D0
		LEA.L	Z80REQ,A0
		LEA.L	Z80RES,A1
		MOVE.W	D0,(A0)
		MOVE.W	D0,(A1)

@WAIT_Z80:
		BTST	#0,(A0)
		BNE.S	@WAIT_Z80

		LEA.L	@INITCODE,A2
		LEA.L	Z80RAM,A3
		MOVE.W	#@CODEEND-@INITCODE-1,D1

@LOOP:
		MOVE.B	(A2)+,(A3)+
		DBF	D1,@LOOP

		CLR.W	(A1)
		CLR.W	(A0)
		MOVE.W	D0,(A1)
		RTS

@INITCODE:
		DC.W	$AF01,$D91F,$1127,$0021,$2600,$F977,$EDB0,$DDE1
		DC.W	$FDE1,$ED47,$ED4F,$D1E1,$F108,$D9C1,$D1E1,$F1F9
		DC.W	$F3ED,$5636,$E9E9
@CODEEND:

;----------------------------------------------------------
;		INIT JOY
;----------------------------------------------------------
JOYINIT:
		MOVE.B	#$00,MDSCTRL1
		MOVE.B	#$00,MDSCTRL2
		MOVE.B	#$00,MDSCTRLX
		MOVE.B	#$40,CTRL_1_CONTROL
		MOVE.B	#$40,CTRL_2_CONTROL
		MOVE.B	#$40,CTRL_X_CONTROL
		MOVE.B	#$40,CTRL_1_DATA	; load address to read controller 1 data
		MOVE.B	#$40,CTRL_2_DATA	; load address to read controller 2 data
		MOVE.B	#$40,CTRL_X_DATA
		RTS

;----------------------------------------------------------
;		READ JOYSTICK
;----------------------------------------------------------


JOYGET6:	;D0 = 1P joystick, D1 = 2P joystick -- 7654S321RLDU
		
		movem.l	d1/d2/d3/d4/d5/a0,-(sp)
		moveq		#0,d0
		cmp.w		#$0002,d1
		bhi			@JOYGET6_0_ERR
		add.w		d1,d1
		move.l	#$00a10003,a0	;joystick data RW port address for player 1

		
		; Primeiramente: Para setar os botões _ _ C B R L D U, deve-se setar TH como 1
		; Depois: Para setar os botões _ _ S A _ _ D U, deve-se setar TH como 0
		; Depois: Para setar os botões _ _ C B X Y Z M, deve-se setar TH como 1, depois 0, depois 1, depois 0, depois 1 (aqui vira 6 botões), depois 0 (para resetar)
		
		move.b	#$40,6(a0,d1.w)	;set TH high
		nop						;delay
		nop
	;---------------------------------
	; set counter to 1 + TH high
	;---------------------------------
		move.b	#$40,(a0,d1.w)	;select [ ? 1 C B R L D U ] -> --CBRLDU store in D2 -> 8 em binario eh 00010000
		moveq		#0,d2		;
		nop						;delay
		nop
		nop
		move.b	$00(a0,d1.w),d2 ;d2 = x x x x|x x x x|? 1 C B R L D U
		cmp.b		#$70,d2		;checking for mouse or other handshaking device
		beq			@JOYGET6_0_ERR
	;---------------------------------
	; set counter to 2 + TH low
	;---------------------------------
		move.b	#$00,(a0,d1.w)	;select [ ? 0 S A 0 0 D U ] -> --SA--DU store in D2 -> 8 em binario eh 00010000
		lsl.w		#8,d2		;d2 = ? 1 C B R L D U|0 0 0 0 0 0 0 0
		move.b	$00(a0,d1.w),d2 ;d2 = ? 1 C B R L D U|? 0 S A 0 0 D U
		cmp.b		#$3f,d2		;checking for nothing connected
		beq			@JOYGET6_0_ERR
	;---------------------------------
	; set counter to 3 + TH high
	;---------------------------------
		move.b	#$40,(a0,d1.w)	; select [ ? 1 C B R L D U ]
		moveq		#0,d3
		nop
		nop
		nop
		move.b	$00(a0,d1.w),d3 ;d3 = x x x x|x x x x|? 1 C B R L D U
	;---------------------------------
	; set counter to 4 + TH low
	;---------------------------------	
		move.b	#$00,(a0,d1.w)	;select [ ? 0 S A 0 0 D U ]
		lsl.w		#8,d3
		move.b	$00(a0,d1.w),d3 ;d3 = ? 1 C B R L D U|? 0 S A 0 0 D U
	;---------------------------------
	; set counter to 5 + TH high
	;---------------------------------	
		move.b	#$40,(a0,d1.w)	;select [ ? 1 C B R L D U ]
		moveq		#0,d4
		nop
		nop
		nop
		move.b	$00(a0,d1.w),d4 ;d4 = x x x x|x x x x|? 1 C B R L D U
	;---------------------------------
	; set counter to 6 + TH low
	;---------------------------------	
		move.b	#$00,(a0,d1.w)	;select [ ? 0 S A 0 0 0 0 ]
		lsl.w		#8,d4
		move.b	$00(a0,d1.w),d4 ;d4 = ? 1 C B R L D U|? 0 S A 0 0 0 0
	;---------------------------------
	; set counter to 7 + TH high
	;---------------------------------	
		move.b	#$40,(a0,d1.w)	;select [ ? 1 0 0 M X Y Z ]
		moveq		#0,d5
		nop
		nop
		nop
		move.b	$00(a0,d1.w),d5 ;d5 = 0 0 0 0|0 0 0 0|? 1 0 0 M X Y Z
	;---------------------------------
	; set counter to 8 + TH low
	;---------------------------------	
		move.b	#$00,(a0,d1.w)	;select [ ? 0 0 0 1 1 1 1 ]
		lsl.w		#8,d5
		move.b	$00(a0,d1.w),d5 ;d5 = ? 1 0 0 M X Y Z|? 0 0 0 1 1 1 1
	;---------------------------------
	; set counter to 9 + TH high
	;---------------------------------
		move.b	#$40,(a0,d1.w)

		cmp.w		d2,d3
		bne			@JOYGET6_0_ERR	;nothing connected or unknown device
		cmp.w		d3,d4
		beq			@JOYGET3_0_PAD	;regular 3 button controller
		and.w		#$000f,d4
		bne			@JOYGET6_0_ERR
		
		move.b	d2,d0
		lsl.w		#4,d0			;d0.w = 0 0 0 0|? 0 S A 0 0 D U 0 0 0 0
		lsr.w		#8,d2			;d2.w = 0 0 0 0|0 0 0 0|? 1 C B R L D U
		
		move.b	d2,d0				;d0.w = 0 0 0 0|? 0 S A ? 1 C B R L D U
		lsl.b		#2,d0			;d0.w = 0 0 0 0|? 0 S A C B R L D U 0 0
		lsr.w		#2,d0			;d0.w = 0 0 0 0|0 0 ? 0|S A C B R L D U
		and.l		#$000000ff,d0
		
		lsl.b		#4,d5			;d5.w = ? 1 0 0 M X Y Z|1 1 1 1 0 0 0 0
		lsl.w		#4,d5			;d5.w = M X Y Z 1 1 1 1 0 0 0 0 0 0 0 0
		or.w		d5,d0			;d0.w = M X Y Z 1 1 1 1 S A C B R L D U
		
		MOVE.B	D0,JOYPAD3
		ror.w		#8,d0 ; Se isso for usado S A C B serão M X Y Z, e deixarao de funcionar R L D U
		MOVE.B	D0,JOYPAD6
		;or.l		#$80000000,d0	;d0.l = 1 x x x|x x x x|x x x x|x x x x|M X Y Z S A C B R L D U

	;---------------------------------
	; done reading controller
	;---------------------------------
		bra			@JOYGET6_0_ERR

@JOYGET3_0_PAD:
		move.b	d2,d0
		lsl.w		#4,d0			;d0.w = 0000|? 0 St TA 0 0 D U 0 0 0 0
		lsr.w		#8,d2			;d2.w = 0000|0000|? 1 TC TB R L D U
		move.b	d2,d0				;d0.w	= 0000|? 0 St TA ? 1 TC TB R L D U
		lsl.b		#2,d0			;d0.w	= 0000|? 0 St TA TC TB R L D U 0 0
		lsr.w		#2,d0			;d0.w	=	0000|0 0 ? 0|St TA TC TB R L D U
		and.l		#$000000ff,d0	;d0.l=0xxx|xxxx|xxxx|xxxx|xxxx|xxxx|St,TA,TC,TB,R,L,D,U
@JOYGET6_0_ERR:
		movem.l	(sp)+,d1/d2/d3/d4/d5/a0
		rts

;----------------------------------------------------------
;		NEW READ JOY
;----------------------------------------------------------
READJOYSTICK:
		MOVE.W	#$100,Z80REQ
@L1:
		BTST	#0,Z80REQ
		BNE.S	@L1

		MOVE.B	JOYPAD6,JOYPADOLD3	;STORE OLD PAD INFO FOR DEBOUNCE IF NEEDED
		MOVE.B	JOYPAD3,JOYPADOLD6	;STORE OLD PAD INFO FOR DEBOUNCE IF NEEDED

		MOVE.W	#0,D1
		BSR	JOYGET6

		MOVE.W	#0,Z80REQ

;		TST.B	D0	  	;DID JOYPAD READ FAIL?
;		BNE.S	@PASS
;		MOVE.B	#$FF,D0
;@PASS:
;		MOVE.B	D0,JOYPAD6 ; Esta instrução foi copiada para dentro da 9ª etapa TH em JOYGET6
		RTS

;----------------------------------------------------------
;		INTERUPT ROUTINES
;----------------------------------------------------------

;----------------------------------------------------------
;		VERTICAL BLANK HANDLER
;----------------------------------------------------------
VBLANK:
		MOVE.L	VBIVECTOR,-(A7)
		RTS

NULL:
		MOVE.W	#1,VBLANKON
		RTE

MAINVBI:
		MOVEM.L	A0-A6/D2-D7,-(SP)	;PUSH REGISTERS

		JSR	USERVBI

		MOVEM.L	(SP)+,A0-A6/D2-D7	;RESTORE REGISTERS
		MOVE.W	#1,VBLANKON		;TELL MAIN LOOP THAT VBI CODE HAS FINISHED
		RTE
;----------------------------------------------------------
;		HORIZONTAL BLANK INTERUPT
;----------------------------------------------------------
HBLANK:		RTE

;----------------------------------------------------------
;		EXTERNAL INTERUPT
;----------------------------------------------------------
EXTINT:		RTE

;------------------------------
;	ERROR HANDLING CODE
;------------------------------
ERROR:		MOVE.W	#$2700,SR		;TURN OFF INTERUPTS
@INF:		BRA.S	@INF			;INFINITE LOOP

;----------------------------------------------------------
;		DUMP DATA VIA DMA
;		D0=SIZE IN WORDS
;		D1=SOURCE ADDRESS
;		D2=DESTINATION ADDRESS
;		A0,A1,D3,D4,D5,D6 TRASHED
;----------------------------------------------------------
DMADUMPS:
		LEA.L	VDP_CONTROL,A1

		AND.L	#$FFFFFF,D1	;MAKE SURE IN ROM/RAM

		MOVE.W	D0,D3
		ADD.W	D3,D3
		MOVE.W	D1,D4
		ADD.W	D3,D4
		BEQ.S	@PASS
		BCS	@TWO

@PASS:
		MOVE.W	#$100,Z80REQ
@L1:
		BTST	#0,Z80REQ
		BNE.S	@L1
		WREG	01,%01110100		;DMA ENABLE

		JSR	RAMDMA

		WAITDMA

		WREG	01,%01100100		;DMA DISABLE
		MOVE.W	#0,Z80REQ

		RTS

@TWO:
		SUB.W	D4,D3
		LSR.W	#1,D3
		MOVE.W	D3,D0
		MOVE.L	D1,D5
		MOVE.L	D2,D6

 		MOVE.W	#$100,Z80REQ
@L2:
		BTST	#0,Z80REQ
		BNE.S	@L2
		WREG	01,%01110100		;DMA ENABLE

		JSR	RAMDMA

		MOVE.L	D5,D1
		MOVE.L	D6,D2
		ADD.W	D3,D2
		ADD.W	D3,D2
		ADD.L	#$10000,D1
		CLR.W	D1
		MOVE.W	D4,D0
		LSR.W	#1,D0

		JSR	RAMDMA

		WAITDMA

		WREG	01,%01100100		;DMA DISABLE
		MOVE.W	#0,Z80REQ

		RTS

;----------------------------------------------------------
;		RAM DMA ROUTINES
;		A1=VDP_CONTROL
;		D0=SIZE
;		D1=SOURCE
;		D2=DEST
;		A0,D1,D2 TRASHED
;----------------------------------------------------------
RAMDMAC:
		LEA.L	QSOURCE+10,A0
		LSR.L	#1,D1
		LSL.L	#2,D2
		LSR.W	#2,D2
		SWAP	D2
		AND.W	#$3,D2
		OR.L	#$40000080,D2

		MOVEP.W	D0,-3(A0)
		MOVEP.L	D1,-11(A0)

		MOVE.W	-(A0),(A1)
		MOVE.W	-(A0),(A1)
		MOVE.W	-(A0),(A1)
		MOVE.W	-(A0),(A1)
		MOVE.W	-(A0),(A1)
		SWAP	D2
		MOVE.W	D2,(A1)
		SWAP	D2
		MOVE.W	D2,(A1)
		RTS

RAMDMAFC:
		MOVE.L	D0,(A1)
		MOVE.L	D1,(A1)
		MOVE.W	D2,(A1)
		MOVE.W	D3,(A1)
		MOVE.W	D4,(A1)
		RTS

RAMVERTC:
		LEA.L	DMAREQ,A0
		MOVE.W	#$8000,D1

		MOVE.W	#$8174,(A2)		;DMA ENABLE

@BACK:		MOVE.W	(A0)+,D0
		BGE.S	@CHECK
@L1:
		MOVE.W	D0,(A2)			;FIRST PASS
		MOVE.L	(A0)+,(A2)		;SIZE/SOURCE
		MOVE.L	(A0)+,(A2)		;SOURCE/SOURCE
		MOVE.W	(A0)+,(A2)		;DEST
		MOVE.W	(A0)+,(A2)		;DEST/MODE

		MOVE.W	(A0)+,D0		;SIZE
		BLT.S	@L1

@CHECK:
		BEQ.S	@DONE			;END
		OR.W	D1,D0
		MOVE.W	D0,(A2)
		BRA.S	@BACK

@DONE:
		MOVE.L	#0,DMAREQ

		MOVE.W	#$8164,(A2)		;DMA DISABLE

		RTS

RAMDMAEND:

;----------------------------------------------------------
;		COPY RAM ROUTINES TO RAM
;----------------------------------------------------------
SETUPRAM:
		MOVE.L	#$94009300,QSIZE
		MOVE.L	#$97009600,QSOURCE
		MOVE.W	#$9500,QSOURCE+4

		LEA.L	RAMDMAC,A0
		LEA.L	RAMDMA,A1

		MOVE.W	#RAMDMAEND-RAMDMAC-1,D0
@L1:
		MOVE.B	(A0)+,(A1)+
		DBRA	D0,@L1
		RTS

RAMDMAF:	EQU	RAMDMA+(RAMDMAFC-RAMDMAC)
RAMVERT:	EQU	RAMDMA+(RAMVERTC-RAMDMAC)

;----------------------------------------------------------
;		PALETTE SETUPS
;----------------------------------------------------------
SETPAL1:
		MOVE.W	#16-1,D0
		LEA.L	PALETTES,A1
@LOOP1:
		MOVE.W	(A0)+,(A1)+
		DBRA	D0,@LOOP1
		RTS

SETPAL2:
		MOVE.W	#16-1,D0
		LEA.L	PALETTES+32,A1
@LOOP1:
		MOVE.W	(A0)+,(A1)+
		DBRA	D0,@LOOP1
		RTS

SETPAL3:
		MOVE.W	#16-1,D0
		LEA.L	PALETTES+64,A1
@LOOP1:
		MOVE.W	(A0)+,(A1)+
		DBRA	D0,@LOOP1
		RTS

SETPAL4:
		MOVE.W	#16-1,D0
		LEA.L	PALETTES+96,A1
@LOOP1:
		MOVE.W	(A0)+,(A1)+
		DBRA	D0,@LOOP1
		RTS

;----------------------------------------------------------
;		COPY PALETTE TO MEMORY
;----------------------------------------------------------
DUMPCOLS:
		MOVEM.L	D0-D4,-(SP)

		MOVE.W	#$100,Z80REQ
@L1:
		BTST	#0,Z80REQ
		BNE.S	@L1
		WREG	01,%01110100		;DMA ENABLE
		LEA.L	VDP_CONTROL,A1
		DMAFPAL	PALETTES,128,$0000
		WREG	01,%01100100		;DMA DISABLE
		MOVE.W	#0,Z80REQ

		MOVEM.L	(SP)+,D0-D4

		RTS

;----------------------------------------------------------
;		SPRITE CODE
;----------------------------------------------------------
SPRITEINIT:
		WREG	5,$7C	;SPRITE ATTRIBUTE TABLE

		LEA.L	VDP_DATA,A1
		WDEST	VRAMW,$F800

		MOVE.W	#1,(A1)
		MOVE.W	#0,(A1)
		MOVE.W	#0,(A1)
		MOVE.W	#1,(A1)

		LEA.L	SPRITETEMP,A1
		MOVE.W	#1,(A1)+
		MOVE.W	#0,(A1)+
		MOVE.W	#0,(A1)+
		MOVE.W	#1,(A1)+

		JSR	SPRITEDUMP

		RTS

SPRITEDUMP:
		DMADUMP	SPRITETEMP,640,$F800
		RTS

;----------------------------------------------------------
;		SYSTEM PALETTE
;----------------------------------------------------------
SYSPALETTE1:
		DC.W	$0002,$0020,$0200,$0222
		DC.W	$0006,$0060,$0600,$0666
		DC.W	$000A,$00A0,$0A00,$0AAA
		DC.W	$000E,$00E0,$0E00,$0EEE
SYSPALETTE2:
		DC.W	$000E,$00E0,$0E00,$0000
		DC.W	$044E,$04E4,$0E44,$0444
		DC.W	$088E,$08E8,$0E88,$0888
		DC.W	$0CCE,$0CEC,$0ECC,$0CCC
