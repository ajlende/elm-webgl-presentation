# WebGL in Elm Presentation

[See it live!](http://ajlende.github.io/elm-webgl-presentation/)

## Requirements

1. [Elm](https://guide.elm-lang.org/install.html)
2. [node-sass](https://github.com/sass/node-sass)
3. HTTP Server
  - [http-server](https://github.com/indexzero/http-server) or
  - [live-server](https://github.com/tapio/live-server) or
  - `python -m SimpleHTTPServer` (Python 2) or `python -m http.server` (Python 3) will even work

## Build Elm Examples

```sh
elm-make examples/*.elm --output elm.js
```

## Build Styles

```sh
node-sass scss/styles.scss styles.css
```

## Run Server

A server is needed because the browser's same origin policy prevents loading assets from the filesystem directly. [[More info]](https://threejs.org/docs/index.html#manual/introduction/How-to-run-things-locally)