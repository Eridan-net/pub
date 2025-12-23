
class HTelem {
	constructor(el) { this.el= el }
	get(at) { return this.el.getAttribute(at) }
	reset(st) { this.el.setAttribute('state', st) }
	
	tags(x) { return Array.from(this.el.getElementsByTagName(x)) }
	
	children(tag) {
		let li= Array.from(this.el.children).filter( x => x.tagName==tag.toUpperCase() )
		if (li.length==0) throw tag+' empty';
		return Array.from(li[0].children);
		}
	}
class Topic extends HTelem {
	hide() { this.reset('off') }
	show() { this.reset('on') }
	}
class Selector {
	constructor(li, create) {
		this.tags= li.map(create);
		this.idx= 0;
		}
	first() { return this.idx==0 }
	last() { return this.idx==this.tags.length-1 }
	
	enable() { 
		this.tags.forEach( (t, ix) => { t.enable(this, ix) } )
		}
	select(tix) { this.idx= tix }
	}
class Topics extends Selector {
	constructor(li, create = el => new Topic(el) ) { 
		super(Array.from(li.children), create);
		this.bm= (new HTelem(li)).get('select');
		}
	init() { this.select(this.bm) }
	
	next() { if (!super.last()) this.select(this.idx+1) }
	previous() { if (!super.first()) this.select(this.idx-1) }

	select(tix) { super.select(tix);
		this.tags.forEach( (t, ix) => { (tix==ix? t.show(): t.hide()) } )
		}	
	}
class SectionTopic extends Topic {
	constructor(el, tag) { super(el);
		this.anchors= new Anchors(this.tags(tag));
		this.bm= this.get('select');
		}
	show() { super.show();
		this.anchors.preSelect(this.bm);
		}
	}
class Section extends Topics {
	constructor(li, Atag) { super(li, el => new SectionTopic(el, Atag)) }
	
	enable(view) { this.tags.forEach( t => t.anchors.enable(view) ) }
	}
class Index extends Selector {
	constructor(li) { super(li, el => new Hand(el)) }
	
	enable(topics) { super.enable();
		this.topics= topics; this.select(topics.bm);
		}
	select(tix) {
		this.topics.select(tix);
		this.tags.forEach( (t, ix) => { (tix==ix? t.reset('active'): t.reset('ready') ) } )
		}
	}
class SubIndex extends Selector {
	constructor(li) { super(li, el => new Hand(el)) }
	
	enable(index, os=1) {
		this.tags.forEach( (t, ix) => { t.enable(index, ix+os) } )
		}
	}
class Hand extends HTelem {
//	constructor(el) { super(el) }
	
	enable(target, ix) { 
		this.el.onclick= (ix===undefined ? target
			: ev => target.select(ix)
			)
		}
//	reset(st) { this.tag.reset(st) }
	}
class Anchors extends Selector {
	constructor(li) { super(li, el => new Anchor(el)) }
	
	enable(lnk) { super.enable();
		this.lnk= lnk; 
		}
	preSelect(bm=0) { 
		if (Debug.view) alert('pre-select '+ this.tags.length);
		if (this.tags.length==1) this.select(0);
		else if (bm) this.select(bm);
		else if (this.lnk) this.lnk.reset();
		}
	select(tix) {
		this.tags.forEach( (t, ix) => { (tix==ix? t.follow(this.lnk): t.ready()) } )
		}
	}
class Anchor extends Hand {

	ready() { this.reset('ready') }
	follow(lnk) {
		lnk.open(this.get('href')); this.reset('active');
		}
	}
class View {
	constructor(frm) {
		this.el= new HTelem(frm);
		this.name= frm.name;
		this.defaultRef= frm.src;
		}
	reset() { window.open(this.defaultRef, this.name);
		this.el.reset('min');
		}
	open(href) { window.open(href, this.name);
		this.el.reset('max');
		}
	}
class Book {
	constructor(index, spec) {
		this.section= (spec.tag ? new Section(spec.topics, spec.tag) : new Topics(spec.topics));
		this.index= index.ctr(index.li); // new Index(index); 
		}
	enable() {
		this.index.enable(this.section);
		}
	}
class NoteBook extends Book {
	constructor(indices, spec) { super( { li: indices[0], ctr: (x) => new Index(x) }, spec);
	
		this.subIndex= (indices.length>1 ? new SubIndex(indices[1]) : null);
		}
	enable(view) {
		if (view) this.section.enable(view); super.enable();
		if (this.subIndex) this.subIndex.enable(this.index);
		}
	help() {
		return 'topics:'+ this.topics.tags.length
			+ ', index:'+ this.index.tags.length
			+ (this.subIndex ? ','+ this.subIndex.tags.length : ';')
			;
		}
	}
class Hands {
	constructor(menu) {
		this.next= new Hand(menu[0]);
		this.prev= new Hand(menu[1]);
		}
	enable(seq) {
		this.next.enable( ev => seq.next1() );
		this.prev.enable( ev => seq.previous() );
		}
//	reset(seq) { }
	}
class Handle extends Hands {
	enable(section) { super.enable(this);
		this.next.reset('on');
		this.prev.reset('off'); section.init();
		this.section= section;
		}
	next1() { this.section.next(); this.reset(); }
	
	previous() { this.section.previous(); this.reset(); }
	reset() {
		(this.section.first() ? this.prev.reset('off') : this.prev.reset('on'));
		(this.section.last() ? this.next.reset('off') : this.next.reset('on'));
		}
	}
class Sequence extends Book {
	constructor(el, menu='handle', info='info') { 
	    super (
	        { li: el.children(menu), ctr: (menu=='handle' ? (x) => new Handle(x) : (x) => new Index(x)) },
	        { topics: el.tags(info)[0] }
            )
        this.section.bm= el.get('select');
		}
	}
class AgentTab {
	constructor(n) { this.target= n; }
	open(href) { window.open(href, this.target) }
	}
class Hover {
	constructor(el) { this.el= el;
		this.help= new Anchor((new HTelem(el)).tags('help')[0]);
		this.tab= new AgentTab(this.help.get('target'));
		}
	enable() {
		this.el.onmouseover= () => this.help.reset('on');
		this.help.el.onmouseout= () => this.help.reset('off');
		this.help.el.onclick= () => this.help.follow(this.tab);
		}
	}
//
let Debug= { view: 0 }
