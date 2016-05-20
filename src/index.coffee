jsdom = require 'jsdom'
_ = require 'underscore'
{pd} = require 'pretty-data'

defaultOptions =
  filename: null
  callback: (d) ->
  xlink: true

createElement = (window) ->
  doc = window.document
  svg = doc.createElement('svg')
  body = doc.querySelector('body')
  body.appendChild svg
  svg.setAttribute 'xmlns', 'http://www.w3.org/2000/svg'
  svg

module.exports = (processor, options, callback) ->
  _.defaults options, defaultOptions
  if callback == null
    callback = options.callback
  jsdom.env
    html: '<html><body></body></html>'
    features: QuerySelector: true
    done: (err, window) ->
      global.window = window
      svg = createElement(window, processor)
      if options.xlink
        svg.setAttribute 'xmlns:xlink', 'http://www.w3.org/1999/xlink'
      processor svg, window
      a = jsdom
        .serializeDocument(svg)
        .replace(/clippath/g, 'clipPath')
        .replace(/textpath/g, 'textPath')
        .replace(/textarea/g, 'textArea')
      if options.xlink
        a = a.replace(/href/g, 'xlink:href')
      a = pd.xml(a)
      if options.filename == null
        callback a
      else
        fs = require('fs')
        fs.writeFileSync options.filename, a
        callback()

