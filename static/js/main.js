$(function () {

  function accept(data) {
    $(".content").html("Id : " + data.id);
  };

  function buildConnectInfo(username) {
    return JSON.stringify({ "username" : username });
  };

  $("#enter").click( function () {
    var username = $("#username");

    if (!username.val())
      return;

    var ci = buildConnectInfo(username.val());

    $.ajax({
      method      : "POST",
      url         : "connect",
      contentType : "application/json",
      dataType    : "json",
      data        : ci,
      success     : accept
    });

  });

});
