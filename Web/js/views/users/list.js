define(
  [
    'jquery',
    'underscore',
    'backbone',
    'views/users/item'
  ],

  function($, _, Backbone, UserItemView) {

    var UserListView = Backbone.View.extend({
      initialize: function(options) {
        // remember: every function that uses 'this' as the current object should be in here
        _.bindAll(this, 'render', 'usersSynced');

        this.users = options.users;
        this.users.bind('sync', this.usersSynced, this);

        this.render();
      },

      usersSynced: function() {
        this.render();
      },

      reset: function() {
        this.$el.empty();
      },

      render: function() {
        var self = this;
        _.each(self.users.models, function(user) {
          var item = new UserItemView({
            user: user.attributes
          });
          self.$el.append(item.$el);
        });
      },

    });

    return UserListView;
  });