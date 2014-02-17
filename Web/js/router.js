// Filename: router.js
define([
  'jquery',
  'underscore',
  'backbone',
  'views/users/list',
  'models/users'
], function($, _, Backbone, UserListView, UsersCollection) {

  var AppRouter = Backbone.Router.extend({
    routes: {
      '': 'home',
      'name': 'home',
      'euro': 'euro',
      'cups': 'cups'
    },

    initialize: function() {
      console.debug('AppRouter.initialize()');

      this.users = new UsersCollection;
      this.users.bind('sync', this.usersSynced, this);

      this.listView = new UserListView({
        el: $("#content"),
        users: this.users
      });

    },

    home: function() {
      console.debug('AppRouter.home()');

      $('#nav-item-name').addClass('active');
      $('#nav-item-euro').removeClass('active');
      $('#nav-item-cups').removeClass('active');

      this.users.reset();
      this.listView.reset();

      this.showLoading();

      this.users.fetchSortedByName();
    },

    euro: function() {
      console.debug('AppRouter.euro()');

      $('#nav-item-name').removeClass('active');
      $('#nav-item-euro').addClass('active');
      $('#nav-item-cups').removeClass('active');

      this.users.reset();
      this.listView.reset();

      this.showLoading();

      this.users.fetchSortedByBalance();
    },

    cups: function() {
      console.debug('AppRouter.cups()');

      $('#nav-item-name').removeClass('active');
      $('#nav-item-euro').removeClass('active');
      $('#nav-item-cups').addClass('active');

      this.users.reset();
      this.listView.reset();

      this.showLoading();

      this.users.fetchSortedByCups();
    },

    usersSynced: function(event) {
      if (_.isObject(event.models) && event.models.length > 0) {
        this.hideLoading();
      }
    },

    showLoading: function() {
      //$('.top-navigation').hide();
      $('.starter-template').show();
      $('#content').hide();
    },

    hideLoading: function() {
      //$('.top-navigation').show();
      $('.starter-template').hide();
      $('#content').show();
    }

  });

  var initialize = function() {
    console.debug('router.initialize()');

    var appRouter = new AppRouter;

    Backbone.history.start();
  };

  return {
    initialize: initialize
  };

});