import { ethers } from 'hardhat';
import { expect } from 'chai';

let sadaivBackupContract;

beforeEach(async () => {
  const SadaivBackup = await ethers.getContractFactory('SadaivBackup');
  sadaivBackupContract = await SadaivBackup.deploy();
  await sadaivBackupContract.deployed();
});

it('should create a new build', async () => {
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

  await expect(
    sadaivBackupContract.createNewBuild(repository, build, repoId, commitHash)
  )
    .to.emit(sadaivBackupContract, 'NewBuild')
    .withArgs(repository, build, repoId, commitHash);

  expect(await sadaivBackupContract.userRepos(repoId)).to.deep.equal(repository);
  expect(await sadaivBackupContract.repoBuilds(repoId, commitHash)).to.deep.equal(build);
});
