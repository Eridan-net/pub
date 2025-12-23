
function loadText(src, sef, params) {
	fetch(src)
		.then(f => f.text())
		.then(t => transformText(t, sef, params))
		.then(doc => replace(doc))
	}
function transformText(doc, sef, params) {
	return fetch(sef, {mode: 'cors'})
		.then(f => f.text())
		.then(t => SaxonJS.transform( 
			{ sourceText: doc, stylesheetText: t
			, stylesheetParams: params
			, destination: 'serialized' }
			, 'sync')
			)
		.then(r => r.principalResult)
	}
/*
function load(doc, sef, params) {
	let r= SaxonJS.transform(
		{ sourceLocation: doc, stylesheetLocation: sef
		, stylesheetParams: params }
		, destination: 'serialized' }
		, 'sync')
	replace(r.principalResult)
	}
	*/
function replace(doc) {
	document.open("text/html", "replace");
	document.write(doc);
	document.close();
	}
window.onerror= (er) => { alert(er) }
