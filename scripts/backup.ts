const hre = require("hardhat");

async function main() {
  const address = "0xed2947e0c9851EF1c5B25d80d953e458aaeA4f5A";
  const backupContractFactory = await hre.ethers.getContractFactory("SadaivBackup");
  const backupContract = await backupContractFactory.attach(address);

  const repository = {
    id:581591975,
    name: 'ask-on-chain',
    fullname: 'aditipolkam/ask-on-chain',
    description: 'a platform to fearlessly ask questions to whomsoever you want by maintaining anonymity',
    ownerGithubId: 60136767,
    size: 254,
    parentRepo:0,
    defaultBranch: 'main',
    timestamp: "1680783864",
    topics: ["anonymity","blockchain","nextjs","question-answering","solidity"],
    languages: ['Solidity', 'JavaScript', 'HTML', 'CSS'],
  };

  const build = {
    branch: 'main',
    commitMessage: 'docs:📝 update readme',
    commitHash: "8661f4cf0daa26437f26adfdc1b6a330f8cddcb6",
    timestamp:"1680783864",
    contributorGithubId: 60136767,
    backupCid: 'QmbHafwh5DargwKUgpraA2HtskAKbRRqyviVxBhsd8JJY9',
    changesCid: '',
  };

  let txn = await backupContract.createNewBuild(repository, build);
  await txn.wait();
  console.log("Backed up");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});