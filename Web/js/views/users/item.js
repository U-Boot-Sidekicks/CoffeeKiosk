define(
  [
    'jquery',
    'underscore',
    'backbone',
    'bootstrap',
    'views/users/cup'
  ],

  function($, _, Backbone, Bootstrap, ModalCup) {

    var UserListItemView = Backbone.View.extend({
      tagName: 'div',
      className: 'user-box',

      events: {
        'click': 'handleClick'
      },

      template: _.template($('#user-box-item').html()),

      initialize: function(options) {
        // remember: every function that uses 'this' as the current object should be in here
        _.bindAll(this, 'render');
        this.user = options.user;
        this.render();
      },

      render: function() {
        //this.attributes['data-userid'] = this.user._id;
        this.$el.attr('data-userid', this.user._id);
        this.$el.html(this.template(this.user));
      },

      handleClick: function(event) {
        var modalView = new ModalCup({
          user: this.user
        });
        $('.modal-content').empty();
        $('.modal-content').html(modalView.$el)
        $('#cupModal').modal();
      }

    });

    return UserListItemView;
  });