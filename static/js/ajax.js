function logUserAjax(username, callback) {

  $.ajax({
    method      : "GET",
    url         : "connect/" + username,
    contentType : "application/json",
    dataType    : "json",
    success     : callback
  });

};

function getGamesAjax(callback) {

  $.ajax({
    method      : "GET",
    url         : "games",
    contentType : "application/json",
    dataType    : "json",
    success     : callback
  });

};

function newGameAjax(user, callback) {

  $.ajax({
    method      : "POST",
    url         : "newgame",
    contentType : "application/json",
    dataType    : "json",
    data        : JSON.stringify(user),
    success     : callback
  });

};

function joinGameAjax(user, game_id, callback) {

  $.ajax({
    method      : "POST",
    url         : "join/" + game_id,
    contentType : "application/json",
    dataType    : "json",
    data        : JSON.stringify(user),
    success     : callback
  });

};
