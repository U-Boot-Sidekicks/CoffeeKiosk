define(['jquery', 'underscore', 'backbone'], function($, _, Backbone) {

  var User = Backbone.Model.extend({
    idAttribute: '_id',
    defaults: {
      name: 'Unnamed User',
      email: 'noreply@domain.com',
      img: 'default.jpg',
      balance: 0.0,
      totalCups: 0.0
    },

    initialize: function() {

    }
  })

  return User;
});
