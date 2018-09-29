INCLUDE "constants.asm"

SECTION "Image Headers", ROMX [$4000], BANK [1]
ImageHeader::
	db "IMG"
ImageData::
	img_frame Frame00, $67  ; $01:406c
	img_frame Frame01, $62  ; $01:4854
	img_frame Frame02, $68  ; $01:4fec
	img_frame Frame03, $62  ; $01:57e4
	img_frame Frame04, $5a  ; $01:5f7c
	img_frame Frame05, $58  ; $01:6694
	img_frame Frame06, $61  ; $01:6d8c
	img_frame Frame07, $56  ; $01:7514
	img_frame Frame08, $64  ; $01:7bec
	img_frame Frame09, $69  ; $02:43a4
	img_frame Frame10, $6e  ; $02:4bac
	img_frame Frame11, $65  ; $02:5404
	img_frame Frame12, $ed  ; $02:5bcc
	img_frame Frame13, $67  ; $02:6c14
	img_frame Frame14, $62  ; $02:73fc
	img_frame Frame15, $68  ; $02:7b94
	img_frame Frame16, $62  ; $03:438c
	img_frame Frame17, $5a  ; $03:4b24
	img_frame Frame18, $58  ; $03:523c
	img_frame Frame19, $61  ; $03:5934
	img_frame Frame20, $56  ; $03:60bc
	img_frame Frame21, $64  ; $03:6794
	img_frame Frame22, $69  ; $03:6f4c
	img_frame Frame23, $6e  ; $03:7754
	img_frame Frame24, $65  ; $03:7fac
	img_frame Frame25, $d4  ; $04:4774
	db $0 ; terminator

SECTION "Frames Bank 1", ROMX [$406c], BANK [$1]
Frame00::
INCBIN "gfx/frames/00.bin"
INCBIN "gfx/frames/00.2bpp"
Frame01::
INCBIN "gfx/frames/01.bin"
INCBIN "gfx/frames/01.2bpp"
Frame02::
INCBIN "gfx/frames/02.bin"
INCBIN "gfx/frames/02.2bpp"
Frame03::
INCBIN "gfx/frames/03.bin"
INCBIN "gfx/frames/03.2bpp"
Frame04::
INCBIN "gfx/frames/04.bin"
INCBIN "gfx/frames/04.2bpp"
Frame05::
INCBIN "gfx/frames/05.bin"
INCBIN "gfx/frames/05.2bpp"
Frame06::
INCBIN "gfx/frames/06.bin"
INCBIN "gfx/frames/06.2bpp"
Frame07::
INCBIN "gfx/frames/07.bin"
INCBIN "gfx/frames/07.2bpp"
Frame08::
INCBIN "gfx/frames/08.bin"
INCBIN "gfx/frames/08.2bpp", $0, $2ac

SECTION "Frames Bank 2", ROMX [$4000], BANK [$2]
INCBIN "gfx/frames/08.2bpp", $2ac, $3a4
Frame09::
INCBIN "gfx/frames/09.bin"
INCBIN "gfx/frames/09.2bpp"
Frame10::
INCBIN "gfx/frames/10.bin"
INCBIN "gfx/frames/10.2bpp"
Frame11::
INCBIN "gfx/frames/11.bin"
INCBIN "gfx/frames/11.2bpp"
Frame12::
INCBIN "gfx/frames/12.bin"
INCBIN "gfx/frames/12.2bpp"
Frame13::
INCBIN "gfx/frames/13.bin"
INCBIN "gfx/frames/13.2bpp"
Frame14::
INCBIN "gfx/frames/14.bin"
INCBIN "gfx/frames/14.2bpp"
Frame15::
INCBIN "gfx/frames/15.bin"
INCBIN "gfx/frames/15.2bpp", $0, $304

SECTION "Frames Bank 3", ROMX [$4000], BANK [$3]
INCBIN "gfx/frames/15.2bpp", $304, $38c
Frame16::
INCBIN "gfx/frames/16.bin"
INCBIN "gfx/frames/16.2bpp"
Frame17::
INCBIN "gfx/frames/17.bin"
INCBIN "gfx/frames/17.2bpp"
Frame18::
INCBIN "gfx/frames/18.bin"
INCBIN "gfx/frames/18.2bpp"
Frame19::
INCBIN "gfx/frames/19.bin"
INCBIN "gfx/frames/19.2bpp"
Frame20::
INCBIN "gfx/frames/20.bin"
INCBIN "gfx/frames/20.2bpp"
Frame21::
INCBIN "gfx/frames/21.bin"
INCBIN "gfx/frames/21.2bpp"
Frame22::
INCBIN "gfx/frames/22.bin"
INCBIN "gfx/frames/22.2bpp"
Frame23::
INCBIN "gfx/frames/23.bin"
INCBIN "gfx/frames/23.2bpp"
Frame24::
INCBIN "gfx/frames/24.bin", $0, $54

SECTION "Frames Bank 4", ROMX [$4000], BANK [$4]
INCBIN "gfx/frames/24.bin", $54, $114
INCBIN "gfx/frames/24.2bpp"
Frame25::
INCBIN "gfx/frames/25.bin"
INCBIN "gfx/frames/25.2bpp"
