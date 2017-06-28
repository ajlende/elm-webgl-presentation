(function() {
    'use strict';
    var style = window.location.search.match( /print-pdf/gi ) ? 'pdf' : 'paper';
    var link = document.createElement( 'link' );
    link.rel = 'stylesheet';
    link.type = 'text/css';
    link.href = `reveal.js/css/print/${ style }.css`;
    document.getElementsByTagName( 'head' )[0].appendChild( link );
}());
