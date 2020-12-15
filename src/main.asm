INCLUDE "hardware.inc"

SECTION "vblank",ROM0[$40]
    jp VBlankHandler

SECTION "Header", ROM0[$100]

EntryPoint:
	di
	jp Start

; This apparently gets fixed by rgbfix
REPT $150 - $104
	db 0
ENDR

SECTION "Game code", ROM0

Start:
.waitVBlank
	ld a, [rLY]
	cp 144
	jr c, .waitVBlank

	xor a
	ld [rLCDC], a

	ld hl, _VRAM8000
	ld de, Tiles
	ld bc, TilesEnd - Tiles

.copyTiles
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .copyTiles

.exampleInitCode
	ld hl, _SCRN0
	ld a, 1
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	
	xor a
	ld b, $FF	

	; init display!
	ld a, %11100100
	ld [rBGP], a
	ld [rOBP0], a

	xor a
	ld [rSCY], a
	ld [rSCX], a

	; no sound
	ld [rNR52], a

	; screen, sprites, and bg on
	ld a, %10010011
	ld [rLCDC], a

	ld a, %00000001 ; Interrupts on
	 

.lockup
	ei
	halt 
	jr .lockup

; +---------------------------------------------------------+
; |                                                         |
; |                      GAME LOOP                          |
; |                                                         |
; +---------------------------------------------------------+

VBlankHandler:
	reti

SECTION "Tiles", ROM0

Tiles:
INCBIN "tiles.2bpp"
TilesEnd:

