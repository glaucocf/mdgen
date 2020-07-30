;----------------------------------------------------------
;		MAP GRAPHICS PLANE A/B
;
;       Each byte represents one byte of the color palette
;       Byte $00 is byte 0 of palette and byte 0 of palette
;       Byte $7F is byte 7 of palette and byte F of palette
;       Byte $80 is byte 8 of palette and byte 0 of palette
;       Byte $FF is byte F of palette and byte F of palette
;       Byte 0 is always transparent
;
;       Sega Mega Drive/Genesis pallete support is 16 colors at max 4 palletes (64 colors in screen)
;       15 real colors and 1 transparent.
;----------------------------------------------------------
MAPGFX:


		DC.B	$22,$22,$21,$12		;1st MAP TILE
		DC.B	$00,$00,$00,$12
		DC.B	$00,$00,$00,$12
		DC.B	$00,$00,$00,$12
		DC.B	$00,$00,$00,$12
		DC.B	$00,$00,$00,$24
		DC.B	$00,$00,$02,$47

		DC.B	$00,$00,$00,$00		;2nd MAP TILE
		DC.B	$00,$00,$00,$00
		DC.B	$00,$00,$00,$00
		DC.B	$00,$00,$00,$00
		DC.B	$00,$00,$00,$00
		DC.B	$00,$00,$00,$02
		DC.B	$11,$11,$11,$24
		DC.B	$22,$22,$22,$47

		DC.B	$00,$00,$00,$00		;3rd MAP TILE
		DC.B	$00,$00,$00,$00
		DC.B	$00,$00,$00,$00
		DC.B	$00,$00,$00,$00
		DC.B	$00,$00,$00,$00
		DC.B	$00,$00,$00,$00
		DC.B	$11,$11,$11,$11
		DC.B	$22,$22,$22,$22

		DC.B	$00,$00,$02,$22		;4t
		DC.B	$00,$02,$24,$44
		DC.B	$00,$24,$22,$22
		DC.B	$02,$42,$00,$00
		DC.B	$02,$20,$00,$00
		DC.B	$24,$20,$00,$00
		DC.B	$24,$20,$00,$00
		DC.B	$24,$20,$00,$00
		
