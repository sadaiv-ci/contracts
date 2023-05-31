import { ethers } from 'hardhat';
import { expect } from 'chai';
import { SadaivBackup } from '../typechain';
require('dotenv').config();

let sadaivBackupContract: SadaivBackup;

beforeEach(async () => {
  const SadaivBackup = await ethers.getContractFactory('SadaivBackup');
  sadaivBackupContract = await SadaivBackup.deploy();
  await sadaivBackupContract.deployed();
});

it('should create a new build', async () => {
  const repository = {
    id: 1,
    parentRepo: 0,
    timestamp: '322',
    name: 'Repo1',
    fullname: 'Fullname1',
    description: 'Description1',
    ownerGithubId: 12345,
    size: 100,
    defaultBranch: 'main',
    topics: ['topic1', 'topic2'],
    languages: ['Solidity'],
  };

  const build = {
    timestamp: '3232',
    branch: 'branch1',
    commitHash: 'ksj32fs',
    commitMessage: 'Commit Message1',
    contributorGithubId: 67890,
    backupCid: 'CID123',
    changesCid: 'CID456',
  };

  const repoId = 1;

  await expect(
    sadaivBackupContract.createNewBuild(repository, build)
  )
    .to.emit(sadaivBackupContract, 'NewBuild');
});
