const hre = require("hardhat");

async function main() {
  const address = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  const backupContractFactory = await hre.ethers.getContractFactory("SadaivBackup");
  const backupContract = await backupContractFactory.attach(address);

  const repository = {
    name: 'Repo1',
    fullname: 'Fullname1',
    description: 'Description1',
    ownerGithubId: 12345,
    size: 100,
    defaultBranch: 'main',
    topics: ['topic1', 'topic2'],
    language: 'Solidity',
  };

  const build = {
    branch: 'branch1',
    commitMessage: 'Commit Message1',
    contributorGithubId: 67890,
    cid: 'CID123',
    changesCid: 'CID456',
  };

  const repoId = 1;
  const commitHash = 'CommitHash123';

  let txn = await backupContract.createNewBuild(repository, build, repoId, commitHash);
  await txn.wait();
  console.log("Backed up");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});