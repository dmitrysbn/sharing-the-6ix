document.addEventListener("turbolinks:load", function() {

  var getSendChat = document.getElementById("send_chat");

  if (getSendChat) {
    getSendChat.addEventListener("click", function(e) {
      if(e.target.type ==='submit') {
        e.preventDefault();
        var form = e.target.form;
        $.ajax({
          url: form.getAttribute("action"),
          method: form.getAttribute("method"),
          data: $(form).serialize(),
          dataType: "html"
        }).done(function(data) {
          var chatBox = document.getElementById("user_chat_box");
          var list = document.createElement("li");
          list.innerHTML = data;
          chatBox.appendChild(list);
        });
        var u = document.getElementById("chat_content");
        u.value = "";
      };
    });
  }

});
