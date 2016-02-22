# Savage SVG

`savage-svg` is a NodeJS module that wraps JSDOM to provide a simple API for
saving static SVG documents to files. It is designed primarily to assist with
quick creation of print figures, and can be used in concert with such modules
as CairoSVG to produce PDF figures.

## API

```coffeescript
savage = require 'savage-svg'
d3 = require 'd3'

func = (el, window)->
  d3.select(el)
    .append('circle')
    .attr cx: 20, cy: 20, r: 4

savage func, filename: 'output.svg'
```

## Caveats

Because the DOM is entirely synthetic, the SVG API is rather incomplete.
Notably, the `getBBox` API for querying positions is not supported
by JSDOM, so all positioning needs to be done manually.
Stylesheet support may be spotty as well, but this has not been tested.

Asynchronous operation is not currently supported, but this is an easy fix.

## TODO

- Move to a more recent version of JSDOM
- Async support
