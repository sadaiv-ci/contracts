import { ethers } from 'hardhat';
import { Signer } from 'ethers';
import { expect } from 'chai';
import { SadaivId } from '../typechain';
require('dotenv').config();

let sadaivIdContract: SadaivId;
let signer: Signer;
let user: Signer;

before(async () => {

  const SadaivId = await ethers.getContractFactory('SadaivId');
  [signer, user] = await ethers.getSigners();

  sadaivIdContract = await SadaivId.deploy();
  await sadaivIdContract.deployed();
});

it('should register a new user', async () => {
  const walletAddress = await signer.getAddress();

  await expect(sadaivIdContract.registerUser())
    .to.emit(sadaivIdContract, 'NewUser')
    .withArgs(1, walletAddress);

  const sadaivId = await sadaivIdContract.SCWAddressToSadaivId(walletAddress);

  expect(sadaivId).to.equal(1);
});


it('should add a new provider', async () => {
  const newId = 12345;
  const sadaivId = 1;

  await expect(sadaivIdContract.addProviders(newId))
    .to.emit(sadaivIdContract, 'NewProvider')
    .withArgs(sadaivId, newId);

  expect(await sadaivIdContract.sadaivIdToGithubId(sadaivId, newId)).to.be.true;
});

it('should change contributor data', async () => {
  const cid = 'awbfhpiegji4758347v8n12392nbijq2iou48vbu';
  const sadaivId = 1;

  await expect(sadaivIdContract.changeContributorData(cid))
    .to.emit(sadaivIdContract, 'NewProfileChange')
    .withArgs(sadaivId, cid);

  expect(await sadaivIdContract.contributorData(sadaivId)).to.equal(cid);
});
