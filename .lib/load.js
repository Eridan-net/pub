
function loadText(spec) {
	fetch(spec.doc)
		.then(f => f.text())
		.then(t => transformText(t, spec))
	}
function transformText(doc, spec) {
	fetch(spec.lib+'/'+spec.sef, { mode: 'cors' })
		.then(f => f.text())
		.then(t => SaxonJS.transform( 
			{ sourceText: doc, stylesheetText: t
			, stylesheetParams: { lib: spec.lib }
			, destination: 'serialized' }
			, 'async')
			)
		.then(r => replace(r.principalResult))
	}
function replace(doc) {
	document.open("text/html", "replace");
	document.write(doc);
	document.close();
	}
window.onerror= (er) => { alert(er) }
/* use case:
let spec= { doc: 'doc.xml', sef: 'section.sef.json', lib: '/slib'
//  , lib: "https://github.com/Eridan-net/pub/tree/main/.lib"
    }
window_onload= () => loadText(spec)
*/
