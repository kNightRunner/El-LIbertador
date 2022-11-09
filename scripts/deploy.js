const { ethers } = require("hardhat");

async function main() {
  const emision = ethers.utils.parseEther("100,100");

  const ElLibertador = await ethers.getContractFactory("ElLibertador");

  const elLibertador = await ElLibertador.deploy();

  await elLibertador.deployed();

  console.log("El Libertador deployed address:", elLibertador.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});