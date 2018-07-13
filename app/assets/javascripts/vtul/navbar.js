Blacklight.onLoad(function() {
  var $navbarToggle = $('.navbar-toggle');
  var $navbar = $('.navbar-static-top');
  var $window = $(window);

  $navbarToggle.click(function(){
    if($navbar.css('display') == 'none') {
      $navbar.css('display', 'block');
    } else {
      $navbar.css('display', 'none');
    }
  });

  $window.resize(function(){
    if($window.width() >= 1150) {
      $navbar.css('display', 'block');
    } else {
      $navbar.css('display', 'none');
    }
  });
});
