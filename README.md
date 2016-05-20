# Savage SVG

`savage-svg` is a NodeJS module that wraps JSDOM to provide a simple API for
saving static SVG documents to files. It is designed primarily to assist with
quick creation of print figures, and can be used in concert with such modules
as CairoSVG to produce PDF figures.

## Install

Run `npm install savage-svg` and you're off to the races.

If you're running a node version older than `4.0`, `jsdom > 7`
won't work. The last tested version on these platforms is `jsdom@3`.
So run `npm install jsdom@3` if you're on an older node version.

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

## TODO

[x] Move to a more recent version of JSDOM
[x] Async support
[ ] PhantomJS support for direct PDF rendering
