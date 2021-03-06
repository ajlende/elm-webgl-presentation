{
    const initExamples = () => {
        Object.keys(Elm).forEach((key) => {
            const name = `elm-${key.toLowerCase()}`
            const apps = document.getElementsByClassName(name)
            Array.from(apps).forEach(app => Elm[key].embed(app))
        })
        drawJS()
    }

    const initHighlight = () => hljs.initHighlightingOnLoad()

    window.MathJax = {
        jax: ['input/TeX', 'output/SVG', 'output/PreviewHTML'],
        extensions: ['tex2jax.js', 'MathMenu.js', 'MathZoom.js', 'fast-preview.js', 'AssistiveMML.js', 'a11y/accessibility-menu.js'],
        TeX: {
            extensions: ['AMSmath.js', 'AMSsymbols.js', 'noErrors.js', 'noUndefined.js', 'color.js'],
        },
    }

    Reveal.initialize({
        history: true,
        math: {
            // See http://docs.mathjax.org/en/latest/config-files.html
            mathjax: 'reveal.js/lib/js/MathJax/MathJax.js',
            config: 'TeX-AMS_SVG-full',
        },
        dependencies: [
            { src: 'reveal.js/plugin/math/math.js', async: true },
            { src: 'reveal.js/plugin/markdown/marked.js' },
            { src: 'reveal.js/plugin/markdown/markdown.js', callback: initExamples },
            { src: 'reveal.js/plugin/notes/notes.js', async: true },
            { src: 'reveal.js/plugin/highlight/highlight.js', async: true, callback: initHighlight },
        ],
    })
}
