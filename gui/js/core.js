function horizontalScroll(element) {
	let scroller = document.getElementById(element);
	
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