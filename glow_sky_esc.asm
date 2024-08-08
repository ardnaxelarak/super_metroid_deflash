!SkyEscPointer = $8DFFE9
!SkyEscTable #= (read2(!SkyEscPointer)<<16)|read2(!SkyEscPointer+2)

print "- offset: 0x", hex(snestopc(!SkyEscPointer+2), 6)
print "  bank: 0x", hex(bank(!SkyEscTable), 2)
print "  pointers:"

macro get_sky_esc_list(n)
	!SkyEsc<n>_List #= read2(!SkyEscTable+2+(4*<n>))|$BB0000
;	print "SkyEsc<n>_List = ", hex(!SkyEsc<n>_List, 6)
	print "  - offset: 0x", hex(2+(4*<n>), 2)
	print "    bank: 0x", hex(bank(!SkyEscTable))
	print "    writes:"
endmacro

%set_ratios("Sky_Esc_", 0, 0.03, 0.06, 0.09)

macro write_sky_esc_list(n)
	org !SkyEsc<n>_List
	Sky_Esc_<n>_List:
	skip 4

	%write_padded_color_list("Sky_Esc_", <n>, 11, 0)
	%write_padded_color_list("Sky_Esc_", <n>, 11, 1)
	%write_padded_color_list("Sky_Esc_", <n>, 11, 2)
	%write_padded_color_list("Sky_Esc_", <n>, 11, 3)
	%write_padded_color_list("Sky_Esc_", <n>, 11, 2)
	%write_padded_color_list("Sky_Esc_", <n>, 11, 0)
	%write_padded_color_list("Sky_Esc_", <n>, 11, 3)
	%write_padded_color_list("Sky_Esc_", <n>, 11, 0)
	%write_padded_color_list("Sky_Esc_", <n>, 11, 2)
	%write_padded_color_list("Sky_Esc_", <n>, 11, 3)
	%write_padded_color_list("Sky_Esc_", <n>, 11, 2)
endmacro

for n = 0..8
	%assign_base_colors_list("Sky_Esc_", !n, 11)
	%assign_end_colors_list("Sky_Esc_", !n, 11, 3)
	%get_sky_esc_list(!n)
	%write_sky_esc_list(!n)
endfor
