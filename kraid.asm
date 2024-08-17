!KRAID_EYEGLOW ?= 0

!KRAID_T = 0.3

!KRAID_PALETTE = $3800, $559D, $1816, $100D, $4B9F, $3F37, $36D0, $2E69, $2608, $1DA6, $1125, $08C5, $0003, $6318, $7FFF, $0000

org $A7B3D3
%interpolate_color_list_to_constant(!KRAID_T, $7FFF, !KRAID_PALETTE)

org $A7B513
%interpolate_color_list_to_constant(!KRAID_T, $7FFF, !KRAID_PALETTE)

if !KRAID_EYEGLOW > 0
	org $A7B3D5
	dw $7FFF, $7FFF, $7FFF
else
	org $A7B515
	dw $7FFF, $7FFF, $7FFF

	org $A7B6E7
	LDX.w #$01E2

	org $A7B757
	LDX.w #$01E2

	org $A7B72A
	CPX.w #$01E8

	org $A7B79F
	CPX.w #$01E8
endif
