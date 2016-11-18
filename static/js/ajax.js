function logUser(username, callback) {

  $.ajax({
    method      : "GET",
    url         : "connect/" + username,
    contentType : "application/json",
    dataType    : "json",
    success     : callback
  });

};

function getGames(callback) {

  $.ajax({
    method      : "GET",
    url         : "games",
    contentType : "application/json",
    dataType    : "json",
    success     : callback
  });

};
