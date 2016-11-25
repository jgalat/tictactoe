function lobby() {

  var lobby = buildLobby($(".content"));

  fillLobby(lobby);

};

function gameBoard(game_id, play) {

  var board = buildGameBoard($(".content"));

  if (play) {
    /* TODO Set board to be playable */
  }

  function synchronize() {
    watchGameAjax(game_id, function (game) {
      /* TODO fillBoard(board, game.board) */
    });
  }

  setInterval(synchronize, 2000);
};
