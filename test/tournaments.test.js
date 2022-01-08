const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Tournaments", function () {
  let deployer, usuario, uniDeployer;
  let token, game, achievementsChecker, treasury, items;

  before(async function () {
    [deployer, alice, bob, charles, player1, player2] = await ethers.getSigners();
  });

})
