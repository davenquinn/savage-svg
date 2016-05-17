var jsdom = require('jsdom');
var pd = require('pretty-data').pd;
var _ = require('underscore');

var defaultOptions = {
  filename: null,
  callback: function(d) {},
  xlink: true
}

var createElement = function(window) {
  var doc = window.document
  var svg = doc.createElement("svg");
  var body = doc.querySelector("body");
  body.appendChild(svg);
  svg.setAttribute('xmlns','http://www.w3.org/2000/svg');
  return svg
};

module.exports = function(processor,options, callback){
  _.defaults(options,defaultOptions);

  if (callback == null) {
    callback = options.callback;
  }

  jsdom.env({
    html: "<html><body></body></html>",
    features: {QuerySelector: true},
    done: function(err, window) {
      global.window = window;
      var svg = createElement(window, processor);
      if (options.xlink) {
        svg.setAttribute('xmlns:xlink',"http://www.w3.org/1999/xlink");
      }
      processor(svg,window)
      var a = jsdom.serializeDocument(svg)
          .replace(/clippath/g, "clipPath")
          .replace(/textpath/g, "textPath")
          .replace(/textarea/g, "textArea");
      if (options.xlink) {
        a = a.replace(/href/g,"xlink:href");
      }
      a = pd.xml(a);

      if (options.filename == null) {
        callback(a);
      } else {
        var fs = require('fs');
        fs.writeFileSync(options.filename,a);
        callback();
      }
    }
  });
};
