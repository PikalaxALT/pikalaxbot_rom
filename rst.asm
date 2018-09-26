SECTION "RST0", ROM0 [$00]
_rst00::
	ld a, [de]
	ld [hli], a
	inc e
	ret nz
	inc d
	ld a, d
	cp $80
	ret nz
	ld de, $4000
	ld a, [hROMBank]
	inc a
	ld [hROMBank], a
	ld [MBC5RomBank], a
	ret
