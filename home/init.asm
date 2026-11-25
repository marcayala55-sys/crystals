SoftReset::
	di
	call InitSound
	xor a
	ldh [hMapAnims], a
	call ClearPalettes
	xor a
	ldh [rIF], a
	ld a, IE_VBLANK
	ldh [rIE], a
	ei

	ld hl, wInputFlags
	set 7, [hl]

	ld c, 3
	call DelayFrames

	jr Init

Crash::
	ld b, b ; no-optimize no-op ld (BGB breakpoint)

	ldh [hCrashCode], a
	xor a
	ldh [hCGB], a
	jr Init

_Start::
	cp $11
	jr z, .cgb
	xor a
	jr .load
.cgb
	ld a, $1
.load
	ldh [hCGB], a
	xor a ; ld a, ERR_RST_0
	ldh [hCrashCode], a
	; fallthrough

Init::
	di
	; MBC5 stores ROM bank bit 8 at $3000. A 4 MB image is banks 0-255,
	; so that bit must be 0 before any bankswitch. Bank 0 stays mapped
	; at $0000-$3FFF while this write happens.
	xor a
	ld [rROMB1], a
	ld a, BANK(_Init)
	ld [rROMB0], a
	jmp _Init ; far-ok
