const { ethers } = require("hardhat");

const CONTRACT_ADDRESS = "0xCb8011498BB28B5F9bAE531cC4F15bb9de40b8b0";

const ABI = [
  {
    "inputs": [
      { "internalType": "string", "name": "_cid", "type": "string" },
      { "internalType": "uint256", "name": "_unlockTime", "type": "uint256" }
    ],
    "name": "lockFile",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }
];

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Simulating with:", deployer.address);

  const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, deployer);

  const cid = "your-file-cid"; // example: "d7c8e7a3...e87048.jpeg"
  const unlockTime = Math.floor(new Date("2025-04-08T02:02:00Z").getTime() / 1000); 

  const gasEstimate = await contract.estimateGas.lockFile(cid, unlockTime);
  console.log("Estimated Gas:", gasEstimate.toString());

  const txData = await contract.populateTransaction.lockFile(cid, unlockTime);
  console.log("Simulated txData:", txData);

  console.log("Simulated txData:", txData);
  console.log("Simulation Result:", result || "Success");
}

main().catch((err) => {
  console.error("Error:", err);
  process.exit(1);
});