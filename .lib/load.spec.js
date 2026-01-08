let spec= { 
lib: [
    { fn: "loadText"
    , args: ["spec"]
	, body: `{
	    fetch(spec.doc)
		.then(f => f.text())
		.then(t => transformText(t, spec))
		.then(doc => replace(doc))
        }`
	},
    { fn: "transformText"
    , args: ["doc", "spec"]
    , body: `{ return
    	fetch(spec.lib+'/'+spec.sef, { mode: 'cors' })
		.then(f => f.text())
		.then(t => SaxonJS.transform( 
			{ sourceText: doc, stylesheetText: t
			, stylesheetParams: { lib: spec.lib }
			, destination: 'serialized' }
			, 'sync')
			)
		.then(r => r.principalResult)
        }`
	},
    { fn: "replace"
    , args: ["doc"]
    , body: `{
    	document.open(); document.write(doc);
    	document.close();
    	}`
    }]
, load: { doc: 'doc.xml', sef: 'section.sef.json'
    , lib: "https://github.com/Eridan-net/pub/tree/main/.lib"
    }
, init: "window.onerror= (er) => { alert(er) }"
}