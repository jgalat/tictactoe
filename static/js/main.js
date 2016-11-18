$(function () {

  function accept(data) {
    $(".content").html(data.username + " : " + data.user_id);
  };

  $("#enter").click( function () {
    var username = $("#username").val();

    if (!username)
      return;

    $.ajax({
      method      : "GET",
      url         : "connect/" + username,
      contentType : "application/json",
      dataType    : "json",
      success     : accept
    });

  });

});
