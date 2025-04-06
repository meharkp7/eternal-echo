const hre = require("hardhat");

async function main() {
  const ContractFactory = await hre.ethers.getContractFactory("EternalEcho");
  const contract = await ContractFactory.deploy();

  await contract.deployed();
  console.log("Contract deployed to:", contract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});