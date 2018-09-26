INCLUDE "constants.asm"

INCLUDE "rst.asm"
INCLUDE "interrupt.asm"

SECTION "Entry", ROM0 [$100]
Entry::
	di
	jp Start

SECTION "Header", ROM0 [$104]
	ds $4c  ; this is filled in by rgbfix

SECTION "Start", ROM0 [$150]
Start::
	xor a
	ldh [rIF], a
	ldh [hCurrFrame], a
	ldh [rSCX], a
	ldh [rSCY], a
	inc a ; 1
	ld [MBC5RomBank], a
	ld [hROMBank], a
	ld a, $3 ; VBlank, HBlank
	ldh [rIE], a
	ld a, $40
	ldh [rSTAT], a
	ld a, $91
	ldh [hLCDC], a
	ld a, $50
	ldh [rLYC], a
	ld a, $1b
	ldh [rBGP], a
	call unk_030f
	ld hl, ImageHeader
	ld a, [hli]
	cp "I"
	jr nz, .asm_01e9
	ld a, [hli]
	cp "M"
	jr nz, .asm_01e9
	ld a, [hli]
	cp "G"
	jr nz, .asm_01e9
	ld b, $00
.asm_018b
	ld a, [hli]
	or a
	jr z, .asm_0195
	inc b
	inc hl
	inc hl
	inc hl
	jr .asm_018b

.asm_0195
	ld a, b
	ldh [hNumFrames], a
	call DelayFrame
.asm_019b
	ld a, $1b
	ldh [rBGP], a
	call DrawFrame
	ei

.asm_01a3
	call DelayFrame
	xor a
	ldh [rIF], a
	call PollJoypad
	ldh a, [hJoyNew]
	bit 4, a
	jr z, .asm_01b7
	ldh a, [rBGP]
	cpl
	ldh [rBGP], a
.asm_01b7
	ld hl, hNumFrames
	ldh a, [hCurrFrame]
	ld b, a
	ld c, a
	ldh a, [hJoyNew]
	bit 0, a
	jr z, .asm_01c5
	inc b
.asm_01c5
	bit 1, a
	jr z, .asm_01ca
	dec b
.asm_01ca
	ld a, b
	add [hl]
	jr c, .asm_01d3
	ld a, b
	sub [hl]
	jr nc, .asm_01d3
	ld a, b
.asm_01d3
	cp c
	ldh [hCurrFrame], a
	jr nz, .asm_01da
	jr .asm_01a3

.asm_01da
	ld a, $1a
	ldh [rNR43], a
	ld a, $41
	ldh [rNR42], a
	ld a, $80
	ldh [rNR44], a
	jr .asm_019b

.asm_01e9
	call DelayFrame
	ld a, $e4
	ld [rBGP], a
	; Draw a big X on the screen
	ld a, $ff
	ld hl, $8200
	REPT 16
	ld [hli], a
	ENDR
	ld a, $20
	ld [$98c7], a
	ld [$98cc], a
	ld [$9967], a
	ld [$996c], a
	ld hl, $98e8
	ld [hli], a
	inc l
	inc l
	ld [hli], a
	ld hl, $9909
	ld [hli], a
	ld [hli], a
	ld hl, $9929
	ld [hli], a
	ld [hli], a
	ld hl, $9948
	ld [hli], a
	inc l
	inc l
	ld [hli], a
	ld c, $05
.asm_022d
	xor a
	ld a, $9e
	ldh [rNR13], a
	ld a, $b2
	ldh [rNR23], a
	ld a, $86
	ldh [rNR14], a
	ldh [rNR24], a
	ld b, $10
.asm_023e
	call DelayFrame
	dec b
	jr nz, .asm_023e
	dec c
	jr nz, .asm_022d
.asm_0245
	call DelayFrame
	jr .asm_0245

DelayFrame::
.asm_024c
	xor a
	ldh [rIF], a
	halt
	nop
	ldh a, [rLY]
	cp $90
	jr nz, .asm_024c
	ret

DrawFrame::
	ld a, $91
	ldh [hLCDC], a
	xor a
	ldh [rLCDC], a
	ld h, a
	ld a, $1
	ld [MBC5RomBank], a
	ldh a, [hCurrFrame]
	ld l, a
	add hl, hl
	add hl, hl
	ld de, ImageData
	add hl, de
	ld a, [hli]
	ld [hROMBank], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	or a
	jr z, .asm_0294
	inc a
	ld c, a
	ld a, [hROMBank]
	ld [MBC5RomBank], a
	ld hl, $9800
	call CopyTilemap
	ld hl, $8000
	call CopyTiles
.asm_028f
	ld a, $91
	ldh [hLCDC], a
	ret

.asm_0294
	ld a, $81
	ldh [hLCDC], a
	ld a, [hROMBank]
	ld [MBC5RomBank], a
	push de
	ld de, unk_0332
	ld hl, $9800
	call CopyTilemap
	pop de
	ld hl, $8000
	ld c, $00  ; $100
	call CopyTiles
	ld c, $68
	call CopyTiles
	jr .asm_028f

CopyTiles::
	ld b, $04
.asm_02ba
	rst GetNextByte
	rst GetNextByte
	rst GetNextByte
	rst GetNextByte
	dec b
	jr nz, .asm_02ba
	ld b, $04
	dec c
	jr nz, .asm_02ba
	ret

CopyTilemap::
	push bc
	lb bc, $14, $0c
.asm_02cb
	rst GetNextByte
	dec b
	jr nz, .asm_02cb
	add hl, bc
	ld b, $14
	ld a, l
	cp $40
	jr nz, .asm_02cb
	ld a, h
	cp $9a
	jr nz, .asm_02cb
	pop bc
	ret

PollJoypad::
	ld a, $20
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	cpl
	and $0f
	ld b, a
	ld a, $10
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	cpl
	and $0f
	swap a
	or b
	ld b, a
	
	ldh a, [hJoyPressed]
	xor b
	and b
	ldh [hJoyNew], a
	ld a, b
	ld [hJoyPressed], a
	ld a, $30
	ldh [rJOYP], a
	ret

unk_030f::
	xor $00 ; ???
	ldh [rNR52], a
	push hl
	push hl
	push hl
	pop hl
	pop hl
	pop hl
	ld a, $80
	ldh [rNR52], a
	ld a, $ff
	ldh [rNR51], a
	ld a, $77
	ldh [rNR50], a
	ld a, $f2
	ldh [rNR12], a
	ldh [rNR22], a
	ld a, $80
	ldh [rNR11], a
	ldh [rNR21], a
	ret

unk_0332::
x = 0
REPT $0168
	db x & $FF
x = x + 1
ENDR

SECTION "Image Data", ROMX [$4000], BANK [$1]
ImageHeader::
	db "IMG"
ImageData::
img_frame: MACRO
; 	dba \1
; 	db \2
	db \1
	dw \2
	db \3
	ENDM

	img_frame $01, $406b, $67
	img_frame $01, $4854, $62
	img_frame $01, $4fec, $68
	img_frame $01, $57e4, $62
	img_frame $01, $5f7c, $5a
	img_frame $01, $6694, $58
	img_frame $01, $6d8c, $61
	img_frame $01, $7514, $56
	img_frame $01, $7bec, $64
	img_frame $02, $43a4, $69
	img_frame $02, $4bac, $6e
	img_frame $02, $5404, $65
	img_frame $02, $5bcc, $ed
	img_frame $02, $6c14, $67
	img_frame $02, $73fc, $62
	img_frame $02, $7b94, $68
	img_frame $03, $438c, $62
	img_frame $03, $4b24, $5a
	img_frame $03, $523c, $58
	img_frame $03, $5934, $61
	img_frame $03, $60bc, $56
	img_frame $03, $6794, $64
	img_frame $03, $6f4c, $69
	img_frame $03, $7754, $6e
	img_frame $03, $7fac, $65
	img_frame $04, $4774, $d4

Frame00::
INCBIN "gfx/frames/00.bin"
INCBIN "gfx/frames/00.2bpp"

Frame01::

