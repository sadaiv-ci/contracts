import { ethers } from "hardhat";

const hre = require("hardhat");
require('dotenv').config();

async function main() {
  const backupContractFactory = await hre.ethers.getContractFactory("SadaivId");
  const backupContract = await backupContractFactory.attach("0xd4204fe1a1Fe7742DdD3A95494286aD558768aA5");

  const verifyContractFactory = await await hre.ethers.getContractFactory("VerifySignature");
  const verifyContract = await verifyContractFactory.attach("0xACf276963A21F63E07f28eA5b212a47014f4d95F");
    console.log(process.env.PRIVATE_KEY as string)
  const signer = await ethers.getSigner(process.env.PRIVATE_KEY as string)
  const message = 'You agree that you the owner of this address are registering on SadaivId';

  const hash = await verifyContract.getMessageHash(message)
  const signature = await signer.signMessage(ethers.utils.arrayify(hash))

  let txn = await backupContract.registerUser(message, signature, signer.getAddress());
  await txn.wait();
  console.log("Registered");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});