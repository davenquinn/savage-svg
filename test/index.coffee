path = require 'path'
fs = require 'fs'
Horseman = require 'node-horseman'
Nightmare = require 'nightmare'

d3 = require 'd3'
savage = require '../src'

chaiXml = require 'chai-xml'
chai = require 'chai'
chai.use chaiXml
{assert,expect} = require 'chai'

describe 'test suite', ->
  it 'works', -> assert true

createSVG = ->
  # Create a simple test svg
  s = 50
  el = d3.select @
    .attr width: s, height: s
  s /= 2
  el.append 'circle'
    .attr cx: s cy: s, r: s
    .attr fill: 'purple'

describe 'simple svg', ->
  fp = path.join __dirname, 'simple.svg'
  testSVG = fs.readFileSync fp

  it 'should produce matching xml', ->
    savage createSVG, (outString)->
      expect(outString).xml.to.equal(testSVG)

  it "should not produce matching xml when xlink:true is specified", ->
    savage createSVG, xlink: true, (outString)->
      expect(outString).xml.not.to.equal(testSVG)

  svgString = testSVG.toString('utf8')
  expectEquality = (outString)->
    expect(outString).xml.to.equal(testSVG)

  it "should work with phantomjs", ->
    horseman = new Horseman()
    fn = (d)-> $('body').html d
    out = horseman
      .open 'about:blank'
      .evaluate fn, svgString
      .html('body')
      .then expectEquality
      .close()

  it "should work with nightmare", ->
    fn = (d)->document.querySelector('body').innerHtml = d
    nightmare = Nightmare()
      .goto 'about:blank'
      .evaluate fn, svgString
      .evaluate ->
        b = document.querySelector('body')
        b.innerHtml
      .end()
      .then expectEquality
