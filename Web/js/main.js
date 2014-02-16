//the require library is configuring paths
require.config({
  urlArgs: "bust=" + (new Date()).getTime(),
  paths: {
    "jquery": "libs/jquery/dist/jquery.min",
    "underscore": "libs/underscore/underscore-min",
    "backbone": "libs/backbone/backbone",
    "localstorage": "libs/backbone.localStorage/backbone.localStorage-min",
    "bootstrap": "libs/bootstrap/dist/js/bootstrap.min",
    "text": "libs/requirejs-text/text"
  },
  shim: {
    "backbone": {
      //loads dependencies first
      deps: ["jquery", "underscore"],
      //custom export name, this would be lowercase otherwise
      exports: "Backbone"
    },
    "bootstrap": {
      deps: ["jquery"]
    },
    "underscore": {
      exports: "_"
    }
  },
  //how long the it tries to load a script before giving up, the default is 7
  waitSeconds: 10
})

require(['app'], function(App) {
  App.initialize();
});