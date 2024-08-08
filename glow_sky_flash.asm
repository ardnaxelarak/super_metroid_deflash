!SkyFlashPointer = $8DF765
!SkyFlashTable #= (read2(!SkyFlashPointer)<<16)|read2(!SkyFlashPointer+2)

print "- offset: 0x", hex(snestopc(!SkyFlashPointer+2), 6)
print "  bank: 0x", hex(bank(!SkyFlashTable), 2)
print "  pointers:"

macro get_skyflash_list(n)
	!SkyFlash<n>_List #= read2(!SkyFlashTable+2+(4*<n>))|$BB0000
	print "  - offset: 0x", hex(2+(4*<n>), 2)
	print "    bank: 0x", hex(bank(!SkyFlashTable))
	print "    writes:"
endmacro

%set_ratios("SkyFlash", 0, 0.10, 0.15, 0.20, 0.25)

macro write_skyflash_list(n)
	org !SkyFlash<n>_List
	SkyFlash<n>_List:
	skip 12
	; SkyFlash<n>_List_Loop1:
	%write_padded_color_list("SkyFlash", <n>, 8, 0)
	skip 3
	; SkyFlash<n>_List_Loop2:

	%write_padded_color_list("SkyFlash", <n>, 8, 1)
	%write_padded_color_list("SkyFlash", <n>, 8, 2)
	%write_padded_color_list("SkyFlash", <n>, 8, 3)
	%write_padded_color_list("SkyFlash", <n>, 8, 4)
	%write_padded_color_list("SkyFlash", <n>, 8, 3)
	%write_padded_color_list("SkyFlash", <n>, 8, 2)
	%write_padded_color_list("SkyFlash", <n>, 8, 1)

	skip 4
	%write_padded_color_list("SkyFlash", <n>, 8, 0)
	skip 3
	; SkyFlash<n>_List_Loop3:

	%write_padded_color_list("SkyFlash", <n>, 8, 4)
	%write_padded_color_list("SkyFlash", <n>, 8, 3)
	%write_padded_color_list("SkyFlash", <n>, 8, 2)
	%write_padded_color_list("SkyFlash", <n>, 8, 1)
endmacro

for n = 0..8
	%assign_base_colors_list("SkyFlash", !n, 8)
	%assign_end_colors_list("SkyFlash", !n, 8, 4)
	%get_skyflash_list(!n)
	%write_skyflash_list(!n)
endfor
