(function () {
    const addSection = (name, id) => {
        const newSection = document.createElement('section')

        const heading = document.createElement('h2')
        heading.innerHTML = name

        const app = document.createElement('div')
        app.id = id

        const lastSlide = document.querySelector('.slides:last-of-type')
        lastSlide.appendChild(newSection)

        newSection.appendChild(heading)
        newSection.appendChild(app)

        return newSection
    }

    const initElm = () => {
        window.ElmApps = {};
        Object.keys(Elm).forEach((key) => {
            const id = `elm-${key.toLowerCase()}`
            const app = document.getElementById(id) || addSection(key, id)
            Elm[key].embed(app)
        })
    }

    const initHighlight = () => hljs.initHighlightingOnLoad()

    Reveal.initialize({
        math: {
            // See http://docs.mathjax.org/en/latest/config-files.html
            mathjax: 'reveal.js/lib/js/MathJax/MathJax.js',
            config: 'TeX-AMS_SVG-full',
        },
        dependencies: [
            { src: 'reveal.js/plugin/math/math.js', async: true },
            { src: 'reveal.js/plugin/markdown/marked.js' },
            { src: 'reveal.js/plugin/markdown/markdown.js', callback: initElm },
            { src: 'reveal.js/plugin/notes/notes.js', async: true },
            { src: 'reveal.js/plugin/highlight/highlight.js', async: true, callback: initHighlight },
        ],
    })
}());
