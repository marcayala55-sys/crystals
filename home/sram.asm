GetSRAMBank::
; load sram bank a
; if invalid bank, sram is disabled
	cp NUM_SRAM_BANKS
	jr nc, CloseSRAM

	; switch to sram bank a
	push af

	; MBC3 latches the RTC here. MBC5 ignores $6000; do not put a RAM bank
	; number in this write.
	ld a, 1
	ld [rRTCLATCH], a

	; enable sram/clock write
	ld a, RAMG_SRAM_ENABLE
	ld [rRAMG], a

	; verify integrity of sram
	; if wSRAMAccessCount != sSRAMAccessCount + 1,
	; crash the game
	ld a, BANK(sSRAMAccessCount)
	ld [rRAMB], a
	push hl
	ld hl, sSRAMAccessCount
	inc [hl]
	ld a, [wSRAMAccessCount]
	cp [hl]
	pop hl
	jr nz, .crash
	inc a
	ld [wSRAMAccessCount], a

	; select sram bank
	pop af
	ld [rRAMB], a
	ret

.crash
	pop af
	call CloseSRAM
	ld a, ERR_SRAM_MISMATCH
	di
	jmp Crash

CloseSRAM::
	push af
	ld a, RAMG_SRAM_DISABLE
; MBC3: unlatch the RTC. MBC5: $6000 is unused. The same 0 disables SRAM below.
	ld [rRTCLATCH], a
; disable sram/clock write
	ld [rRAMG], a
	pop af
	ret
