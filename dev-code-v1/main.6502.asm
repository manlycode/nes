; initialize the NES
    .inesprg 1          ; 1x16kb PRG-ROM
    .ineschr 1          ; 1x8kb CHR-ROM
    .inesmap 0          ; Mapper 0 = NROM -- no bank swapping
    .inesmir 1
; END ines header

    .bank 0             ; first 8KB of prg-rom
    .org $C000          ; Begin storing code for .bank 0 at Memory location $C000

RESET:
    sei                 ; Disable IRQs
    cld                 ; Disable Decimal Mode
    ldx #$40             
    stx $4017           ; Store #$40 at $4017 to disable APU

    ldx #$ff
    txs                 ; Transfer X value into stack pointer
    inx                 ; increment x by 1 -- now X == 0 (rollover)
    stx $2000           ; Disable NMI (interrupt?)
    stx $2001           ; Disable rendering
    stx $4010           ; Disable APU DMC IRQs

vblankwait1:            ; wait for first vblank to make sure PPU is ready
    bit $2001           ; test if one or more bits are set on $2001
    bpl vblankwait1     ; loop if 0 - continue if 1

clrmem:
    lda #$00
    sta $0000, x        ; Store A at memory location $0000 + #$0
    sta $0100, x
    sta $0200, x
    sta $0300, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x

    lda #$fe
    sta $0300           ; Set $0300 to #$FE
    inx
    bne clrmem          ; increment x register to clear the rest of the memory

vblankwait2:            ; wait for ppu again after clearing memory
    bit $2002           ; bit test
    bpl vblankwait2     ; if N flag is set, continue

    lda #%10000000      ; intensify blues load value
    sta $2001

Forever:
    jmp Forever         ; Loop game indefinitely

NMI:                    ; Return from interrupt
    rti                 ; pulls processor flags

    .bank 1
    .org $FFFA          ; set up interrupt vectors (starting at $FFFA)
    .dw NMI
    .dw RESET
    .dw 0

    .bank 2              ; first CHR-ROM Page
    .org $0000
    .incbin "assets/mario.chr"
