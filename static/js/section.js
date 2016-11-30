function lobby() {

  if (synchInterval) {
    clearInterval(synchInterval);
  }

  var lobby = buildLobby($(".content"));

  fillLobby(lobby);

}

function gameBoard(game_id, play) {

  var content = $(".content"),
      board = buildGameBoard(content),
      alert = content.find(".alert");

  if (play) {
    makeBoardPlayable(board, game_id);
  }

  function synchronize() {
    watchGameAjax(game_id, function (game) {
      if (game) {
        if (game.board) {
          alert.html("Game on!");
          fillBoard(board, game.board);
        }
      } else {
        lobby();
      }
    });
  }

  synchInterval = setInterval(synchronize, 1000);

  buildGameBoardControls(content.find(".controls"), synchInterval);

}
