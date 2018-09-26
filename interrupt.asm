SECTION "VBlankInt", ROM0 [$40]
VBlankInt::
	push af
	ld a, $91
	ldh [rLCDC], a
	pop af
	reti

SECTION "HBlankInt", ROM0 [$48]
HBlankInt::
	push af
	ldh a, [hLCDC]
	ldh [rLCDC], a
	pop af
	reti
