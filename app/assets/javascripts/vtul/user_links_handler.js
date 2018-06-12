var userLinksHandler = {
  $links_wrapper: null,
  $link_input: null,
  $add_link_trigger: null,
  $existing_links_label: null,
  $existing_links_wrapper: null,
  $remove_triggers: null,

  init: function() {
    this.$links_wrapper = $("#user-links-wrapper");
    this.$link_input = $(".user-link-input").first();
    this.$add_link_trigger = $("#add-link-trigger");
    this.$existing_links_label = $("#existing-links-label");
    this.$existing_links_wrapper = $("#existing-links-wrapper");
    this.$remove_triggers = $(".remove-link-trigger");

    this.setAddLinkListener();
    this.setRemoveLinkListener();
  },


  setAddLinkListener: function() {
    var _this = this;
    this.$add_link_trigger.click(function(event){
      event.preventDefault();
      var $new_input = _this.$link_input.clone().val(null);
      _this.$links_wrapper.append($new_input);
    });
  },

  setRemoveLinkListener: function() {
    var _this = this;
    this.$remove_triggers.click(function(event){
      event.preventDefault();
      var link_elem = $(this).parent('li');
      var link_id = $(link_elem).data("link-id");
      var user_id = $(link_elem).data("user-id");

      // /user_links/user/:id/link/:link_id/delete    
      $.get( "/user_links/user/" + user_id + "/link/" + link_id + "/delete", function( data ) {
        console.log(data);
        var li_id = "link-id-" + data.id;
        if(!data.errors) {
          $("#" + li_id).remove();
          if(!_this.$existing_links_wrapper.children('li').length) {
            _this.$existing_links_wrapper.remove();
            _this.$existing_links_label.remove();
          }
        }
        else {
          alert(data.msg);
        }
      });
    });
  }
}
