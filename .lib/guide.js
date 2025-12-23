
function $(id) { return document.getElementById(id) }

const Dom= {
	tags: (x) => Array.from(document.getElementsByTagName(x)),

	chTags: (parent, child) => Array.from($(parent).getElementsByTagName(child)),

	view: () => (frames[0] ? new View(frames[0].frameElement) : null),

	home: () => { location.reload() }
	}
indexInit= () => {
	let b= new NoteBook( [Dom.chTags('svg', 'g')],
		{ topics: $('map'), tag: 'anchor' }
		)
	b.enable(Dom.view());
	//
	Dom.chTags('home','g')[0].onclick= Dom.home;
	
	let li= [
	    { tag: 'sequence', ctr: s => new Sequence(new HTelem(s)) }
	    ]
	li.forEach(x => Dom.chTags('body', x.tag).map(x.ctr).forEach(s => s.enable()))
	}
guideInit= () => {
	let lix= Dom.tags('index'); if (!lix.length) throw 'no index';
	let idx= [lix[0].previousElementSibling].concat(Array.from(lix[0].children));
	let indices= [idx];
	if (lix.length>1) indices.push((new HTelem(lix[1])).tags('topic'))
	
	let b= new NoteBook( indices,
		{ topics: Dom.tags('topics')[0], tag: 'anchor' }
		)
	b.enable(Dom.view());
	let li= [
	    { tag: 'sequence', ctr: s => new Sequence(new HTelem(s)) },
	    { tag: 'hover', ctr: s => new Hover(s) }
	    ]
	li.forEach(x => Dom.tags(x.tag).map(x.ctr).forEach(s => s.enable()))
    }
/* * * */
class Booker {
    constructor(el) {
        this.topics= el;
        let li= (Array.from(el.children)).map(el => new HTelem(el))
        this.index= li.map(el => document.getElementById(el.get('caller'))).filter(e => !e==false)
        }
    book() {
        return new Book( 
            { li: this.index, ctr: (x) => new Index(x) }, 
            { topics: this.topics }
            )
        }
    }
bookInit= () => {
 	let def= { tag: 'sequence', ctr: s => new Booker(s) }
 	
	Dom.tags(def.tag).map(def.ctr).forEach(s => s.book().enable())
    }

window.onerror= (er) => alert(er);
