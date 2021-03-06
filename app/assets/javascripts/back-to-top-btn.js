var backToTopButton = document.querySelector('#back-to-top-btn');

if (backToTopButton) {
  function scrollFunction() {
    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
      document.getElementById("back-to-top-btn").style.display = "block";
    } else {
      document.getElementById("back-to-top-btn").style.display = "none";
    }
  }

  // When the user clicks on the button, scroll to the top of the document
  function topFunction() {
    document.body.scrollTop = 0; // For Safari
    document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
  }

  window.onscroll = function() {scrollFunction()};
}
