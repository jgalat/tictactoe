$(function () {

  var player = null;

  $("#enter").click(function () {
    var username = $("#username").val();

    if (!username)
      return;

    logUser(username, function (user) {
      player = user;
      lobby();
    });

  });

  function lobby() {
    var content = $(".content");
    buildLobby(content)
  };

});
