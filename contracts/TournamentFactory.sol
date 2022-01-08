// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 < 0.9.0;

import "./Tournament.sol";

contract TournamentFactory {
  uint256 public COUNTER;

  mapping(uint256 => address) public tournaments;
  mapping(address => address[]) public tournamentsUser;

  constructor() {
  }

  /**
   * @dev Crea un nuevo torneo y lo agrega a la lista de torneos
   * @param _name Nombre del torneo
   * @param _prize address del contrato del premio
   */
  function createTournament(string memory _name, address _prize) external returns(address newTournament) {
    COUNTER++;
    newTournament = address(new Tournament(msg.sender, _name, _prize));
    tournaments[COUNTER] = newTournament;
    tournamentsUser[msg.sender].push(newTournament);

    // return newTournament;
  }

  function getTournament(uint256 _id) external view returns (address) {
    return tournaments[_id];
  }

  function getTournamentsUser(address _user) external view returns (address[] memory) {
    return tournamentsUser[_user];
  }
}