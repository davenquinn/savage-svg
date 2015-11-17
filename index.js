var jsdom = require('jsdom');
var pd = require('pretty-data').pd;
var _ = require('underscore');

var defaultOptions = {
  filename: null,
  callback: function(d) {}
}

var createElement = function(window, callback) {
  var doc = window.document
  var svg = doc.createElement("svg");
  var body = doc.querySelector("body");
  body.appendChild(svg);
  svg.setAttribute('xmlns','http://www.w3.org/2000/svg');
  callback(svg);
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
      var svg = createElement(window, processor);
      var _ = jsdom.serializeDocument(svg)
          .replace(/clippath/g, "clipPath");
      _ = pd.xml(_);

      if (options.filename == null) {
        callback(_);
      } else {
        var fs = require('fs');
        fs.writeFileSync(options.filename,_);
        callback();
      }
    }
  });
};
