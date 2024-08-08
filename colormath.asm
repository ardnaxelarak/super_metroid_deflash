asar 1.90

function interpolate(x0,x1,t) = (x1-x0)*t+x0
function get_r(color) = color&$1F
function get_g(color) = (color>>5)&$1F
function get_b(color) = (color>>10)&$1F
function to_color(r, g, b) = \
	clamp(round(r,0),0,31)\
	|(clamp(round(g,0),0,31)<<5)\
	|(clamp(round(b,0),0,31)<<10)
function interpolate_color(x0, x1, t) = \
	to_color(\
		interpolate(get_r(x0),get_r(x1),t),\
		interpolate(get_g(x0),get_g(x1),t),\
		interpolate(get_b(x0),get_b(x1),t))
