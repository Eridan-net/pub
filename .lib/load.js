
function loadText(spec) {
	fetch(spec.src)
		.then(f => f.text())
		.then(t => transformText(t, spec))
		.then(doc => replace(spec.doc))
	}
function transformText(doc, spec) {
	return fetch(spec.params.lib+'/'+spec.sef, { mode: 'cors' })
		.then(f => f.text())
		.then(t => SaxonJS.transform( 
			{ sourceText: doc, stylesheetText: t
			, stylesheetParams: spec.params
			, destination: 'serialized' }
			, 'sync')
			)
		.then(r => r.principalResult)
	}
function replace(doc) {
	document.open("text/html", "replace");
	document.write(doc);
	document.close();
	}
window.onerror= (er) => { alert(er) }
