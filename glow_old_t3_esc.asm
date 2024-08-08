!OldT3EscPointer = $8DFFE1
!OldT3EscTable #= (read2(!OldT3EscPointer)<<16)|read2(!OldT3EscPointer+2)

print "- offset: 0x", hex(snestopc(!OldT3EscPointer+2), 6)
print "  bank: 0x", hex(bank(!OldT3EscTable), 2)
print "  pointers:"

macro get_old_t3_esc_list(n)
	!OldT3Esc<n>_List #= read2(!OldT3EscTable+2+(4*<n>))|$BB0000
	print "  - offset: 0x", hex(2+(4*<n>), 2)
	print "    bank: 0x", hex(bank(!OldT3EscTable))
	print "    writes:"
endmacro

%set_ratios("OldT3Esc", 0, 0.03, 0.06, 0.09, 0.12)

macro write_old_t3_esc_list(n)
	org !OldT3Esc<n>_List
	OldT3Esc<n>_List:
	skip 4
	; OldT3Esc<n>_List_Loop:
	%write_padded_color_list("OldT3Esc", <n>, 3, 0)
	%write_padded_color_list("OldT3Esc", <n>, 3, 1)
	%write_padded_color_list("OldT3Esc", <n>, 3, 2)
	%write_padded_color_list("OldT3Esc", <n>, 3, 3)
	%write_padded_color_list("OldT3Esc", <n>, 3, 4)
	%write_padded_color_list("OldT3Esc", <n>, 3, 0)
	%write_padded_color_list("OldT3Esc", <n>, 3, 1)
	%write_padded_color_list("OldT3Esc", <n>, 3, 2)
	%write_padded_color_list("OldT3Esc", <n>, 3, 3)
	%write_padded_color_list("OldT3Esc", <n>, 3, 4)
	%write_padded_color_list("OldT3Esc", <n>, 3, 0)
	%write_padded_color_list("OldT3Esc", <n>, 3, 1)
	%write_padded_color_list("OldT3Esc", <n>, 3, 2)
	%write_padded_color_list("OldT3Esc", <n>, 3, 3)
	%write_padded_color_list("OldT3Esc", <n>, 3, 4)
endmacro

for n = 0..8
	%assign_base_colors_list("OldT3Esc", !n, 3)
	%assign_end_colors_list("OldT3Esc", !n, 3, 4)
	%get_old_t3_esc_list(!n)
	%write_old_t3_esc_list(!n)
endfor
