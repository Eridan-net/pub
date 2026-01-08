
class Lib {
    constructor(spec) { this.spec= spec }
    post() {
        return this.spec.map(fn => (new Parse(fn)).post()).join("\n")
        }
    }
class Parse {
    constructor(spec) { this.spec= spec }
    args() { return '('+ this.spec.args.join(',') +')' }
    post() {
        return `let ${this.spec.fn} = ${this.args()} => ${this.spec.body}`
        }
    }
class SA { // simple associative array
    constructor(ob) { this.sa= Object.entries(ob) }
    post() { return "{"+ this.sa.map(v => `${v[0]}: "${v[1]}"`).join('\n,') +"}" }
    }
class Doc {
    constructor(spec) {
        this.lib= new Lib(spec.lib)
        this.loadSpec= spec.load;
        this.script= []
        }
    addScript(spec) { this.script[spec.idx]= `<script src="${spec.src}"></script>` }
    addScriptText(spec) { this.script[spec.idx]= `<script>${spec.src}</script>` }
    init() {
        let spec= Object.entries(this.loadSpec).map(v => `${v[0]}: "${v[1]}"`).join('\n,')
        this.addScriptText({ src: `window_onload= () => loadText({${spec}})`, idx: 2 })
    /*
        let spec= (new SA(this.loadSpec)).post()
        this.addScriptText({ src: `window_onload= () => loadText(${spec})`, idx: 2 })
        */
        this.addScriptText({ src: this.lib.post(), idx: 1})
        }
    write() {
    	document.open(); 
    	document.write(
    `<html><head>${this.script.join('\n')}</head>
    <body></body>
    </html>`)
    	document.close();
    	}
    }

let doc= new Doc(spec);

doc.init();
/* const loadSpec= { doc: 'doc.xml', sef: 'section.sef.json'
    , params: { lib: "https://github.com/Eridan-net/pub/tree/main/.lib" }
    } */
const SaxonRuntime= "SaxonJS2.rt.js";

doc.addScript({ src: spec.load.lib +"/"+ SaxonRuntime, idx: 0 })

doc.write()
