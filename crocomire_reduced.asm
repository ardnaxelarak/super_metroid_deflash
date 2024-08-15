!CROCOMIRE_T = 0.3

org $A4F6C0
dw interpolate_color($0000, $7FFF, !CROCOMIRE_T)
dw interpolate_color($7FFF, $7FFF, !CROCOMIRE_T)
dw interpolate_color($0DFF, $7FFF, !CROCOMIRE_T)
dw interpolate_color($08BF, $7FFF, !CROCOMIRE_T)
dw interpolate_color($0895, $7FFF, !CROCOMIRE_T)
dw interpolate_color($086C, $7FFF, !CROCOMIRE_T)
dw interpolate_color($0447, $7FFF, !CROCOMIRE_T)
dw interpolate_color($6B7E, $7FFF, !CROCOMIRE_T)

org $A48AA3
STA.l $7EC300, X ; overwrite palette 0 instead of unnoticable change to palette 5

!CROC_BASE_PALETTE = $0000, $7FFF, $0DFF, $08BF, $0895, $086C, $0447, $6B7E, $571E, $3A58, $2171, $0CCB, $039F, $023A, $0176, $0000
!CROC_FLASH_PALETTE = $0000, $7FFF, $77BD, $6B5A, $6318, $7FFF, $77BD, $6B5A, $6318, $7FFF, $77BD, $6B5A, $6318, $7FFF, $77BD, $6B5A

org $A4B8DD
%interpolate_color_list(!CROCOMIRE_T, 16, !CROC_BASE_PALETTE, !CROC_FLASH_PALETTE)
