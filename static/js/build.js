function buildLobby(where) {
  where.html('<div class="lobby"></div>');

  var lobby = where.find(".lobby");

  getGames(function (games) {
    lobby.append('<ul>');

    games.forEach(function (game) {
      var adversaries = game.player1.username;

      if (game.player2)
        adversaries += ' vs ' + game.player2.username;

      lobby.append('<li> Game ' + game.game_id + ': ' + adversaries + '</li>')
    });

    lobby.append('</ul>');
  });
}
