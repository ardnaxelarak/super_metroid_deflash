!DRAYGON_T = 0.4

!DRAYGON_BG_PALETTE = $3F57, $2E4D, $00E2, $0060, $3AB0, $220B, $1166, $0924, $0319, $0254, $018F, $00CA, $581B, $1892, $0145

org $A5A299
%interpolate_color_list_to_constant(!DRAYGON_T, $7FFF, !DRAYGON_BG_PALETTE)
