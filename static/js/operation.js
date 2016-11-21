function enter() {

  var username = $("#username").val();

  if (!username)
    return;

  logUserAjax(username, function (user) {
    player = user;
    lobby();
  });

};

function join(game_id) {
  /* something */
};

function watch(game_id) {
  /* something */
};

function newGame() {

  if(!player)
    return;

  newGameAjax(player, function (game) {
    /* something */
    lobby();
  });

};
