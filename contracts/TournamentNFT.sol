// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "base64-sol/base64.sol";

import "./Tournament.sol";

contract TournamentNFT is ERC721, ERC721Enumerable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    mapping (uint256 => Tournament) private _tournaments;

    constructor() ERC721("Tournaments", "TYC") {
    }

    function mint(address to, string memory _tournamentName, address _priceNft) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        // solo el que recibe el nft puede manegar el torneo (esto deberia cambiar ante una trasnferencia?)
        _tournaments[tokenId] = new Tournament(to, _tournamentName, _priceNft);
        _safeMint(to, tokenId);
    }

    function getTournament(uint256 _tokenId) public view returns (Tournament) {
        return _tournaments[_tokenId];
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
      require(_exists(tokenId), "URI query for nonexistent token");
      
      Tournament t = _tournaments[tokenId];
      return string(
        abi.encodePacked(
          "data:application/json;base64,",
          Base64.encode(
            bytes(
              abi.encodePacked(
                "{\"name\":\"",
                t.name,
                "\",""\"description\":\"zaraza completar\"",
                "\"attributes\":[{\"trait_type\":\"Open\",\"value\":\"",
                t.isOpen,
                "\"},{\"trait_type\":\"Ended\",\"value\":\"",
                t.isEnd,
                "\"},{\"trait_type\":\"Manager\",\"value\":\"",
                t.manager,
                "\"},{\"trait_type\":\"Winner\",\"value\":\"",
                t.winner,
                "\"}]\"}"
              )
            )
          )
        )
      );
    }


    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}