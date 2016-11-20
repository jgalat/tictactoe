function buildGame(where, game) {

  var data = game.player1.username + ' vs ';

  if (game.player2) {
    data += game.player2.username;
    data += ' <span class="activable watch" game="' + game.game_id + '">Watch!<span>';
  } else {
    data += '<span class="activable join" game="' + game.game_id + '">Join!</span>';
  }

  where.append('<li> Game ' + game.game_id + ': ' + data + '</li>');

};

function buildLobby(where) {

  where.html('<div class="lobby"></div>');

  var lobby = where.find(".lobby");

  getGames(function (games) {

    lobby.append('<ul>');

    games.forEach(function (game) {

      buildGame(lobby, game);

    });

    lobby.append('</ul>');

    lobby.find(".join").click(function () {
      /* something */
    });

    lobby.find(".watch").click(function () {
      /* something */
    });

  });

};
