import { ethers } from "hardhat";

async function main() {
  // get contract and deploy to blockchain
  const Sadaiv = await ethers.getContractFactory("Sadaiv");
  const sadaiv = await Sadaiv.deploy();

  await sadaiv.deployed();

  console.log("Deployed Sadaiv contract to:", sadaiv.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
