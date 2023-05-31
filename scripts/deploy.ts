import { ethers } from "hardhat";

async function main() {
  const sadaivId = await ethers.getContractFactory("SadaivId");
  const sadaivIdContract = await sadaivId.deploy();
  await sadaivIdContract.deployed();
  console.log("Deployed Sadaiv Id contract to:", sadaivIdContract.address);

  const backup = await ethers.getContractFactory("SadaivBackup");
  const backupContract = await backup.deploy();
  await backupContract.deployed();
  console.log("Deployed Sadaiv Backup contract to:", backupContract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
