DefaultOptions:
; wOptions3
if DEF(DEBUG)
	db 1 << NICKNAMES_NEVER
else
	db 0
endc
; wOptions1
	db (1 << BATTLE_EFFECTS) | (1 << STEREO) | FAST_TEXT
; wSaveFileExists
	db FALSE
; wTextboxFrame
	db 0
; wTextboxFlags
	db $01 ; ???
; wOptions2
	db 0
; wInitialOptions
	db (1 << NATURES_OPT) | (1 << ABILITIES_OPT) | (1 << PSS_OPT) | (1 << COLOR_VARY_OPT)
; wInitialOptions2
if DEF(NO_RTC)
	; No cartridge RTC. RTC_OPT must stay clear so nothing selects MBC3 RTC banks.
	db EVS_OPT_MODERN | (1 << EVOLVE_IN_BATTLE_OPT)
else
	db EVS_OPT_MODERN | (1 << RTC_OPT) | (1 << EVOLVE_IN_BATTLE_OPT)
endc
