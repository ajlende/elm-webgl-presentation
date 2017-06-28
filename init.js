(function() {
    'use strict';

    // Elm initialization has to be done after the markdown to allow it to find divs that might be in markdown
    const initElm = () => {
        const newSlide = (app, id) => {
            const node = document.createElement('div')
            node.id = id

            const lastSlides = document.querySelector('.slides:last-of-type')

            const newSection = document.createElement('section')
            lastSlides.appendChild(newSection)

            const heading = document.createElement('h2')
            heading.innerHTML = app

            newSection.appendChild(heading)
            newSection.appendChild(node)

            return node;
        }

        Object.keys(Elm).forEach((app) => {
            const id = `elm-${app.toLowerCase()}`
            const node = document.getElementById(id) || newSlide(app, id)
            Elm[app].embed(node)
        })
    }

    const initHighlight = () => hljs.initHighlightingOnLoad()

    Reveal.initialize(
        { dependencies:
            [ { src: 'reveal.js/plugin/markdown/marked.js' }
            , { src: 'reveal.js/plugin/markdown/markdown.js', callback: initElm }
            , { src: 'reveal.js/plugin/notes/notes.js', async: true }
            , { src: 'reveal.js/plugin/highlight/highlight.js', async: true, callback: initHighlight }
            ]
        }
    )
}());
