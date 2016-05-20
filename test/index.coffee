path = require 'path'
fs = require 'fs'
Horseman = require 'node-horseman'

d3 = require 'd3'
savage = require '..'

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

  it "should work with phantomjs", ->
    horseman = new Horseman()

    fn = (d)-> $('body').html d
    out = horseman
      .open 'about:blank'
      .evaluate fn, testSVG.toString('utf8')
      .html('body')
      .then (outString)->
        expect(outString).xml.to.equal(testSVG)
      .close()
