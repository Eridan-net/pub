
const Dom= {
	tags: (x) => Array.from(document.getElementsByTagName(x)),
	view: null,
	init: () => {
		let view= (frames[0] ? new View(frames[0].frameElement) : null)

		let lix= Dom.tags('index'); if (!lix.length) throw 'no index';
		lix.forEach(x => {
			let idx= Array.from(x.children);
			let b= new NoteBook( [idx],
				{ topics: x.nextElementSibling }
				)
			b.enable(view);
			})
		let li= [
		    { tag: 'sequence', ctr: s => new Sequence(new HTelem(s)) },
		    { tag: 'hover', ctr: s => new Hover(s) }
		    ]
		li.forEach(x => Dom.tags(x.tag).map(x.ctr).forEach(s => s.enable()))
	    }
	}
window.onload= Dom.init;
window.onerror= (er) => { alert(er) }
