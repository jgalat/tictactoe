function enter() {

  var username = $("#username").val();

  if (!username) {
    return;
  }

  logUserAjax(username, function (user) {
    player = user;
    lobby();
  });

}

function watch(game_id) {

  watchGameAjax(game_id, function (game) {
    if (game) {
      gameBoard(game_id, false);
    }
  });

}

function newGame() {

  if (!player) {
    return;
  }

  newGameAjax(player, function (game) {
    if(game && game.player1.user_id == player.user_id)
      gameBoard(game.game_id, true);
  });

}

function join(game_id) {

  if (!player) {
    return;
  }

  joinGameAjax(player, game_id, function (game) {
    if (game && game.player2.user_id == player.user_id)
      gameBoard(game_id, true);
  });

}

function rejoin(game_id) {
  gameBoard(game_id, true);
}

function fillLobby(lobby) {

  getGamesAjax(function (games) {

    lobby.append('<ul>');

    games.forEach(function (game) {

      buildGameItem(lobby, game);

    });

    lobby.append('</ul>');

    lobby.find(".join").click(function () {
      join($(this).attr("game"));
    });

    lobby.find(".watch").click(function () {
      watch($(this).attr("game"));
    });

    lobby.find(".rejoin").click(function () {
      rejoin($(this).attr("game"));
    });

  });

}

function fillBoard(board, game_board) {

  const cell_status = [ " ", "X", "O" ];

  $.each(game_board, function (cell, value) {
    board.find("#" + cell).html(cell_status[value]);
  });

}

function makePlay(game_id, cell) {

  var play = { play : cell, player : player };

  playGameAjax(game_id, play, null);

}

function makeBoardPlayable(board, game_id) {

  if (!player) {
    return;
  }

  board.find(".cell")
    .addClass("playcell")
    .click(function () {
      makePlay(game_id, $(this).attr("id"));
    });

}
