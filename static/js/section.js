function lobby() {

  if (synchInterval) {
    clearInterval(synchInterval);
  }

  var lobby = buildLobby($(".content"));

  fillLobby(lobby);

}

function gameBoard(game_id, play) {

  var content = $(".content");

  var board = buildGameBoard(content);

  if (play) {
    makeBoardPlayable(board, game_id);
  }

  function synchronize() {
    watchGameAjax(game_id, function (game) {
      if (game != null && game.board) {
        fillBoard(board, game.board);
      } else {
        lobby()
      }
    });
  }

  synchInterval = setInterval(synchronize, 2000);

  buildGameBoardControls(content.find(".controls"), synchInterval);

}
