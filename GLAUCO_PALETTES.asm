;----------------------------------------------------------
;		USER PALETTES
;
;PALLETENAME:  ;and bytes
;		DC.W	0,1,2,3
;		DC.W	4,5,6,7
;		DC.W	8,9,A,B
;		DC.W	C,D,E,F
;
;	Each byte has 0BGR (0, Blue, Green and Red) format
;	Sega Mega Drive/Genesis RGB Support bytes:
;	0 (no R or G or B), 2, 4, 6, 8, A, C and E (max R or G or B)
;
;	The byte 0 is always the transparent color.
;----------------------------------------------------------

PALETTE0:	;BLACK
		DC.W	$0000,$0EEE,$0CCC,$0AAA,$0888,$0666,$0444,$0222	;Bytes 0,1,2,3,4,5,6,7
		DC.W	$0EEE,$0CCC,$0AAA,$0888,$0666,$0444,$0222,$0000	;Bytes 8,9,A,B,C,D,E,F
		
PALETTE1:	;YELLOW
		DC.W	$0000,$0022,$0044,$0066,$0088,$00AA,$00CC,$00EE	;Bytes 0,1,2,3,4,5,6,7
		DC.W	$02EE,$04EE,$06EE,$08EE,$0AEE,$0CEE,$0EEE,$0000	;Bytes 8,9,A,B,C,D,E,F

PALETTE2:	;BLUE
		DC.W	$0000,$0200,$0400,$0600,$0800,$0A00,$0C00,$0E00	;Bytes 0,1,2,3,4,5,6,7
		DC.W	$0E22,$0E44,$0E66,$0E88,$0EAA,$0ECC,$0EEE,$0000	;Bytes 8,9,A,B,C,D,E,F

PALETTE3:	;MAGENTA
		DC.W	$0000,$0202,$0404,$0606,$0808,$0A0A,$0C0C,$0E0E	;Bytes 0,1,2,3,4,5,6,7
		DC.W	$0E2E,$0E4E,$0E6E,$0E8E,$0EAE,$0ECE,$0EEE,$0000	;Bytes 8,9,A,B,C,D,E,F

PALETTE4:	;GREEN
		DC.W	$0000,$0020,$0040,$0060,$0080,$00A0,$00C0,$00E0	;Bytes 0,1,2,3,4,5,6,7
		DC.W	$02E2,$04E4,$06E6,$08E8,$0AEA,$0CEC,$0EEE,$0000	;Bytes 8,9,A,B,C,D,E,F

PALETTE5:	;CYAN
		DC.W	$0000,$0220,$0440,$0660,$0880,$0AA0,$0CC0,$0EE0	;Bytes 0,1,2,3,4,5,6,7
		DC.W	$0EE2,$0EE4,$0EE6,$0EE8,$0EEA,$0EEC,$0EEE,$0000	;Bytes 8,9,A,B,C,D,E,F

PALETTE6:	;RED
		DC.W	$0000,$0002,$0004,$0006,$0008,$000A,$000C,$000E	;Bytes 0,1,2,3,4,5,6,7
		DC.W	$022E,$044E,$066E,$088E,$0AAE,$0CCE,$0EEE,$0000	;Bytes 8,9,A,B,C,D,E,F

PALETTE7:	;WHITE
		DC.W	$0000,$0222,$0444,$0666,$0888,$0AAA,$0CCC,$0EEE	;Bytes 0,1,2,3,4,5,6,7
		DC.W	$0222,$0444,$0666,$0888,$0AAA,$0CCC,$0EEE,$0000	;Bytes 8,9,A,B,C,D,E,F