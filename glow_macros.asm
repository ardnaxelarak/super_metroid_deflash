macro assign_base_single_color(prefix, n, m, value)
	!<prefix><n>_BaseColors_<m> = <value>
;	print "<prefix><n>_BaseColors_<m> = ", hex(<value>, 4)
endmacro

macro assign_base_colors(prefix, n, len, ...)
	for m = 0..<len>
		%assign_base_single_color(<prefix>, <n>, !m, <...[!m]>)
	endfor
endmacro

macro assign_base_colors_list(prefix, n, len)
	%assign_base_colors(<prefix>, <n>, <len>, !<prefix><n>_Colors_0)
endmacro

macro assign_end_single_color(prefix, n, m, value)
	!<prefix><n>_EndColors_<m> = <value>
;	print "<prefix><n>_EndColors_<m> = ", hex(<value>, 4)
endmacro

macro assign_end_colors(prefix, n, len, ...)
	for m = 0..<len>
		%assign_end_single_color(<prefix>, <n>, !m, <...[!m]>)
	endfor
endmacro

macro assign_end_colors_list(prefix, n, len, index)
	%assign_end_colors(<prefix>, <n>, <len>, !<prefix><n>_Colors_<index>)
endmacro

macro write_single_color(prefix, n, m, t)
	dw interpolate_color(!<prefix><n>_BaseColors_<m>, !<prefix><n>_EndColors_<m>, <t>)
	print "      - 0x", hex(interpolate_color(!<prefix><n>_BaseColors_<m>, !<prefix><n>_EndColors_<m>, <t>), 4)
endmacro

macro set_single_ratio(prefix, p, t)
	!<prefix>P<p>ratio = <t>
endmacro

macro set_ratios(prefix, ...)
	for p = 0..sizeof(...)
		%set_single_ratio(<prefix>, !p, <...[!p]>)
	endfor
endmacro

macro write_color_list(prefix, n, len, p)
	print "    - offset: 0x", hex(pc()-<prefix><n>_List, 4)
	print "      data:"
	for m = 0..<len>
		%write_single_color(<prefix>, <n>, !m, !<prefix>P<p>ratio)
	endfor
endmacro

macro write_padded_color_list(prefix, n, len, p)
	skip 2
	%write_color_list(<prefix>, <n>, <len>, <p>)
	skip 2
endmacro
