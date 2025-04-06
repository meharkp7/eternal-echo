const { ethers } = require("hardhat");

const CONTRACT_ADDRESS = "0xCb8011498BB28B5F9bAE531cC4F15bb9de40b8b0";
const ABI = [
  {
    "inputs": [],
    "name": "retrieveFile",
    "outputs": [{ "internalType": "string", "name": "", "type": "string" }],
    "stateMutability": "view",
    "type": "function"
  }
];

async function main() {
  const [signer] = await ethers.getSigners();
  const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);

  const cid = await contract.retrieveFile();
  console.log("Retrieved CID:", cid);
}

main().catch((err) => {
  console.error("Error:", err);
  process.exit(1);
});
