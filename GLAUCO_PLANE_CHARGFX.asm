;----------------------------------------------------------
;		CHARACTER CODES TO BUILD OUR PATTERN
;
;		THE CODE IS IN THE FORMAT $NNNN
;
;		THE LAST TWO NUMBERS ($00NN) REFER TO THE CHARACTER NUMBER IN VRAM TO USE
;		(THE CHARACTER NUMBER IS THE VRAM ADDRESS DIVIDED BY 32 (OR DIVIDED BY $20 HEXADECIMAL))
;
;		IF THE FIRST NUMBER  ($N000) IS '1' IT MEANS MIRROR THE CHARACTER VERTICALLY
;		IF THE SECOND NUMBER ($0N00) IS '8' IT MEANS MIRROR THE CHARACTER HORIZONTALLY
;
;		SO WHEN WE HAVE A DIAGONAL CHARACTER LINE THIS - / WE CAN MIRROR IT TO GET THIS \
;		SO WE CAN BUILD THIS - /\
;				       \/   USING ONE DIAGONAL AND MIRRORING
;----------------------------------------------------------
CHARGFX:
		DC.W	$1804,$1802,$1803,$0001,$0801,$1003,$1002,$1004
		DC.W	$0000,$0000,$0000,$0004,$0804,$0800,$0800,$0800
		DC.W	$1000,$1000,$1000,$1004,$1804,$1800,$1800,$1800
		DC.W	$0804,$0802,$0803,$1001,$1801,$0003,$0002,$0004

