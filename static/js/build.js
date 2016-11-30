function buildGameItem(where, game) {

  var data = game.player1.username + ' vs ';

  if (game.player2) {
    data += game.player2.username;

    if (game.player1.user_id == player.user_id || game.player2.user_id == player.user_id) {
      data += ' <span class="activable rejoin" game="' + game.game_id + '">Rejoin!<span>';
    } else {
      data += ' <span class="activable watch" game="' + game.game_id + '">Watch!<span>';
    }
  } else {
    if (game.player1.user_id == player.user_id) {
      data += '<span class="activable rejoin" game="' + game.game_id + '">Rejoin!<span>';
    } else {
      data += '<span class="activable join" game="' + game.game_id + '">Me!</span>';
    }
  }

  where.append('<li> Game ' + game.game_id + ': ' + data + '</li>');

}

function buildControls(where, lobby) {

  where.append(`<span class="activable newgame">New!</span>
                <span class="activable refresh">Refresh</span>`);

  where.find(".newgame").click(newGame);
  where.find(".refresh").click(function () {
    refreshLobby(lobby);
  });

}

function buildLobby(where) {

  where.html('<div class="lobby"></div><div class="controls"></div>');

  var lobby = where.find(".lobby"),
      controls = where.find(".controls");

  buildControls(controls, lobby);

  return lobby;

}


function buildGameBoard(where) {

  var board_html = `<h3 class="alert"></h3>
                    <table class="board">
                      <tr>
                        <td class="cell" id="c0"></td>
                        <td class="cell" id="c1"></td>
                        <td class="cell" id="c2"></td>
                      </tr>
                      <tr>
                        <td class="cell" id="c3"></td>
                        <td class="cell" id="c4"></td>
                        <td class="cell" id="c5"></td>
                      </tr>
                      <tr>
                        <td class="cell" id="c6"></td>
                        <td class="cell" id="c7"></td>
                        <td class="cell" id="c8"></td>
                      </tr>
                    </table>
                    <div class="controls"></div>`;

  where.html(board_html);

  return where.find(".board");

}

function buildGameBoardControls(where) {

  where.append('<span class="activable back">Back to lobby</span>');

  where.find(".back").click(lobby);

}
