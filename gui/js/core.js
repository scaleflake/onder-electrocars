/*jshint esversion: 6 */
function horizontalScroll(element) {
	let scroller;
	if (typeof(element) == 'string') {
		if (element[0] == '#') {
			scroller = $(element).get(0);
		} else {
			scroller = document.getElementById(element);
		}
	} else {
		if (element.get) {
			scroller = element.get(0);
		} else {
			scroller = element;
		}
	}
	
	function scrollHorizontally(e) {
		e = window.event || e;
		let delta = Math.max(-1, Math.min(1, (e.wheelDelta || -e.detail)));
		scroller.scrollLeft -= (delta * 40);
		e.preventDefault();
	}

	if (scroller.addEventListener) {
		// IE9, Chrome, Safari, Opera
		scroller.addEventListener("mousewheel", scrollHorizontally, false);
		// Firefox
		scroller.addEventListener("DOMMouseScroll", scrollHorizontally, false); 
	} else {
		// IE 6/7/8
		scroller.attachEvent("onmousewheel", scrollHorizontally); 
	}
}