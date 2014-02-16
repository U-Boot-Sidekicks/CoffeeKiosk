define(
  [
    'jquery',
    'underscore',
    'backbone',
    'bootstrap'
  ],

  function($, _, Backbone, Bootstrap) {

    var ModalCupView = Backbone.View.extend({
      tagName: 'p',

      events: {
        'click .btn-yes': 'yesClicked',
        'click .btn-no': 'noClicked'
      },

      template: _.template($('#register-cup').html()),

      initialize: function(options) {
        // remember: every function that uses 'this' as the current object should be in here
        _.bindAll(this, 'render');
        this.user = options.user;
        this.render();
      },

      render: function() {
        this.$el.html(this.template(this.user));
      },

      yesClicked: function() {
        var self = this;
        $.ajax({
          type: 'POST',
          url: '/api/cups',
          data: {
            'userId':this.user._id
          },
          success: function(data, textStatus, jqXHR) {
            console.debug('data:', data);
            console.debug('textStatus:', textStatus);
            $('.modal-content').empty();
            $('#cupModal').modal('hide');
            // hard core reload page :)
            window.location.reload();
          },
          error: function(jqXHR, textStatus, error) {
            console.debug('error:', error);
            console.debug('textStatus:', textStatus);
            alert(error);
          }
        });
      },

      noClicked: function() {
        $('.modal-content').empty();
        $('#cupModal').modal('hide');
      }

    });

    return ModalCupView;
  });