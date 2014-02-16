define(['jquery', 'underscore', 'backbone', 'models/user'], function($, _, Backbone, User) {

  var UsersCollection = Backbone.Collection.extend({
    model: User,
    //baseUrl: '/fixtures-',
    baseUrl: '/api/users?filter=',

    fetchSortedByName: function(options) {
      this.url = this.baseUrl + '0';
      this.fetch(options);
    },

    fetchSortedByBalance: function(options) {
      this.url = this.baseUrl + '1';
      this.fetch(options);
    },

    fetchSortedByCups: function(options) {
      this.url = this.baseUrl + '2';
      this.fetch(options);
    }

  })

  return UsersCollection;
});
