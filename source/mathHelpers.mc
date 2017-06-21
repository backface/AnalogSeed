using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;


function min (a, b) {
	if (a < b) {
		return a;
	} else {
		return b;
	}
}

function max (a, b) {
	if (a > b) {
		return a;
	} else {
		return b;
	}
}

function toRad(alpha) {
	return alpha * Math.PI / 180;
}

function pointOnCircle(r, alpha) {
	x = r + cos(toRad(alpha));
	y = r + sin(toRad(alpha));
	return [x,y];
}
