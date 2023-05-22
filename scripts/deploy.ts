import { ethers } from "hardhat";

async function main() {
  const verify = await ethers.getContractFactory("VerifySignature");
  const verifierContract = await verify.deploy();
  await verifierContract.deployed();
  console.log(
    "Deployed Sadaiv verifier contract to:",
    verifierContract.address
  );

  const sadaivId = await ethers.getContractFactory("SadaivId");
  const sadaivIdContract = await sadaivId.deploy(verifierContract.address);
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
