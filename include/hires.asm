;
; Copyright (c) 2012 Toni Spets <toni.spets@iki.fi>
;
; Permission to use, copy, modify, and distribute this software for any
; purpose with or without fee is hereby granted, provided that the above
; copyright notice and this permission notice appear in all copies.
;
; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
;

; derived from ra95-hires

%define ScreenWidth 0x006016B0
%define ScreenHeight 0x006016B4

str_options: db "Options",0
str_width: db "Width",0
str_height: db "Height",0

left_strip_offset: dd 0
right_strip_offset: dd 0

; handles Width and Height redalert.ini options
_hires_ini:

    PUSH EBX
    PUSH EDX

.width:
    MOV ECX, 640            ; default
    MOV EDX, str_options    ; section
    MOV EBX, str_width      ; key
    LEA EAX, [EBP-0x54]     ; this
    CALL INIClass_Get_Int
    TEST EAX,EAX
    JE .height
    MOV DWORD [ScreenWidth], EAX

.height:
    MOV ECX, 400
    MOV EDX, str_options
    MOV EBX, str_height
    LEA EAX, [EBP-0x54]
    CALL INIClass_Get_Int
    TEST EAX,EAX
    JE .cleanup
    MOV DWORD [ScreenHeight], EAX

.cleanup:

    MOV EDX, [ScreenWidth]
    MOV EBX, [ScreenHeight]
    MOV EAX, EDX

    ; adjusted width in EAX
    MOV EDX, EAX

    ; buffer1
    MOV DWORD [0x00552629], EBX
    MOV DWORD [0x00552638], EDX

    ; buffer2
    MOV DWORD [0x00552646], EBX
    MOV DWORD [0x00552655], EDX

    SUB EDX, 160

    ; power bar background
    MOV DWORD [0x00527736], EDX
    MOV DWORD [0x0052775C], EDX

    ; side bar background position
    MOV DWORD [0x0054D7CB], EDX
    MOV DWORD [0x0054D7F1], EDX
    MOV DWORD [0x0054D816], EDX

    ; credits tab background position
    MOV DWORD [0x00553758], EDX

    ; power bar current position
    MOV DWORD [0x005275D9], EDX

    ; repair button left offset
    MOV EDX, EAX
    SUB EDX, 142
    MOV DWORD [0x0054D166], EDX

    ; sell button left offset
    MOV EDX, EAX
    SUB EDX, 97
    MOV DWORD [0x0054D1DA], EDX

    ; map button left offset
    MOV EDX, EAX
    SUB EDX, 52
    MOV DWORD [0x0054D238], EDX

    ; side bar strip offset left (left bar)
    MOV EDX, EAX
    SUB EDX, 144
    MOV EAX, [left_strip_offset]
    MOV DWORD [EAX], EDX

    ; side bar strip icons offset
    MOV DWORD [0x0054D08C], EDX

    ; side bar strip offset left (right bar)
    ADD EDX, 70
    MOV EAX, [right_strip_offset]
    MOV DWORD [EAX], EDX

    ; power indicator (darker shadow)
    MOV EDX, EAX
    SUB EDX, 150
    MOV DWORD [0x005278A4], EDX
    INC EDX
    MOV DWORD [0x005278AE], EDX
    INC EDX
    MOV DWORD [0x00527A4D], EDX
    INC EDX
    MOV DWORD [0x00527A52], EDX

    ; power usage indicator
    MOV EDX, EAX
    SUB EDX, 158
    MOV DWORD [0x00527C0F], EDX
    
    ; width of the game area, in tiles, 1 tile = 24px
    MOV BYTE [0x0054DB15], 26

    ; kill original sidebar area (halp)
    MOV BYTE [0x0054F380], 0xC3

    POP EDX
    POP EBX

    JMP 0x00552979

_hires_StripClass:
    MOV DWORD [EBX+0x104F], 0x1F0 ; left strip offset left
    MOV DWORD [EBX+0x1053], 0x0B4 ; left strip offset top
    MOV DWORD [EBX+0x132F], 0x0B4 ; right strip offset top
    MOV DWORD [EBX+0x132B], 0x236 ; right strip offset left

    LEA EAX, [EBX+0x104F]
    MOV [left_strip_offset], EAX
    LEA EAX, [EBX+0x132B]
    MOV [right_strip_offset], EAX

    MOV EAX,EBX
    JMP 0x0054D033
