// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 < 0.9.0;

interface IMinteable {
  function mint(address _winner) external;
}

/// @title Representacion de un torneo
contract Tournament {
  /// @notice Manager es el cargado de administrar el torneo, agregar equipo y determinar el ganador
  address public manager;
 
  /// @notice Listado de equipos participantes
  address[] public teams;
 
  /// @notice Tabla de puntos
  mapping(address => int256) public teamPoints;
 
  /// @notice Posicion del team en el array de teams
  mapping(address => uint256) public teamId;

  /// @notice Nombre del torneo
  string public name;
 
  /// @notice Variable que dice si el torneo esta abierto a inscripciones
  bool public isOpen = true;

  /// @notice NFT de premio, este contrato debe tener permisos de minteo, en caso de ser address(0) no se mintea
  IMinteable public prize;

 
  event TournamentStart(string name);
  event AddTeam(uint256 id, address team);
  event TournamentNew(address manager, string name, address prize);
  event TeamPoints(address team, int256 points, string reason);
  event Match(address winner, address looser, int256 winnerPoints, int256 looserPoints);

  /**
    * @dev Constructor del torneo
    * @param _manager Manager del torneo
    * @param _name Nombre del torneo
    * @param _prize NFT de premio (puede ser address vacio)
    */
  constructor(address _manager, string memory _name, address _prize) {
    prize = IMinteable(_prize);
    manager = _manager;
    name = _name;

    emit TournamentNew(manager, name, address(prize));
  }

  /**
   * @dev Agrega un equipo al torneo (si el tornoe no comenzo)
   * @param _team Equipo a agregar
   */
  function addTeam(address _team) public {
    require(manager == msg.sender, 'Only manager can add teams');
    uint256 _id = teams.length;
    teams.push(_team);
    teamId[_team] = _id;
    emit AddTeam(_id, _team);
  }

  /**
   * @dev Inicia el torneo, cierra la inscripciones y emite el evento
   */
  function starTournament() public {
    require(manager == msg.sender, 'Only manager can start tournament');
    require(teams.length > 1, 'Not enough teams');
    require(isOpen == false, 'Tournament is already started');
    isOpen = true;
    
    emit TournamentStart(name);
  }

  /**
   * @dev Corrije puntajes de un equipo _team, suma los _pounts y lo justifica con _reason
   * @dev ejemplo, un quipo hizo trampa y se le quitan puntos;
   * @dev addPoints(team, -10, "trampa")
   * @param _team Equipo
   * @param _points Puntos a corregir (puede ser negativo)
   * @param _reason Justificacion del puntos
   */
  function addPoints(address _team, int256 _points, string calldata _reason) public {
    require(manager == msg.sender, 'Only manager can add points');
    require(isOpen, 'Tournament is not started');
    require(teamId[_team] > 0, 'Team is not registered');
    teamPoints[_team] += _points;

    emit TeamPoints(_team, _points, _reason);
  }

  function addMatch(address _winner, address _looser, int256 _winnerPoints, int256 _looserPoints) public {
    require(manager == msg.sender, 'Only manager can add match');
    require(isOpen, 'Tournament is not started');
    require(teamId[_winner] > 0, 'Team is not registered');
    require(teamId[_looser] > 0, 'Team is not registered');
   
    teamPoints[_winner] += _winnerPoints;
    teamPoints[_looser] += _looserPoints;

    emit Match(_winner, _looser, _winnerPoints, _looserPoints);
  }
}