;
; Created on Sunday, 3rd of May 2025 at 11:39
; by Michael Dailly 2025
; Simple Platform Engine for the ZX Spectrum next
;
; 
                opt             ZXNEXT

                include "includes.asm"
                include "irq.asm"

                seg     CODE_SEG
StartAddress:
                call    SetupIRQs
                
                call    CLS                                     ; clear the ULA screen
                ld      a,7
                call    ClsATTR                                 ; clear the ULA Attribute screen with INK 7 paper 0   F_B_PPP_III 
                call    Layer2on
        
                NextReg $07,3                                   ; select 28Mhz Z80n
                NextReg $08,%01001000                           ; Disable RAM contention and enable 8bit DACS
                NextReg $14, $e7                                ; Bright PINK
                NextReg $15,%0_0_0_000_0_1                      ; Sprites on, S U L layer order and enable sprites
                NextReg $12,16                                  ; Layer 2 base bank 16 (32 for 8k banks)
                
                LOAD    ULAScreenFile,ULAScreenPysical          ; Load the Pyjamarama loading screen in to the ULA screen (test)
                LOAD    L2ScreenDemo,32*8192                    ; Load the Shadow of the Beast forground screen into Layer 2

                call    InitGlobals
; *****************************************************************************************************************************
;   Main Loop
; *****************************************************************************************************************************
MainLoop:
                xor     a
                ld      (VBlank),a
@Wait:          ld      a,(VBlank)
                and     a
                jr      z,@Wait

                ; Do service routines just after a Vertical Blank (VBlank)
                call    FlipBuffers
                call    ReadKeyboard

                ; press space to shake the screen a little
                ld      a,(Keys+VK_SPACE)
                and     a
                jr      z,@notpressed
                xor     a
                ld      (Keys+VK_SPACE),a

                ld      a,(Shake)
                add     a,4
                ld      (Shake),a
@notpressed:

                ; draw a HEX number to the ULA screen
                ld      a,(HexValue)
                inc     a
                ld      (HexValue),a
                ld      de,$4000
                call    PrintHex

                call    DoScreenShake
                jp      MainLoop                ; infinite loop


; *****************************************************************************************************************************
;   Flip Buffers
; *****************************************************************************************************************************
FlipBuffers:
                ld      a,(ShakeX)
                NextReg $26,a
                ld      a,(ShakeY)
                NextReg $27,a
                ret


; *****************************************************************************************************************************
;   Init global variables
; *****************************************************************************************************************************
InitGlobals:
                ret


; *****************************************************************************************************************************
;   includes modules
; *****************************************************************************************************************************
                include "filesys.asm"
                include "utils.asm"
ENDOFCODE_ADD:
                include "data.asm"
ENDOFDATA_ADD:


                ; wheres our end address?
                message "End of code   = ",ENDOFCODE_ADD
                message "End of data   = ",ENDOFDATA_ADD
                message "End of memory = ",ENDOFMEMORY_ADD
        
                savenex "framework.nex",StartAddress,StackStart


