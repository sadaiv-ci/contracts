import { ethers } from 'hardhat';
import { Signer } from 'ethers';
import { expect } from 'chai';
require('dotenv').config();

let sadaivIdContract;
let verifyContract;
let signer: Signer;
let user: Signer;

before(async () => {
  const Verify = await ethers.getContractFactory('VerifySignature');
  verifyContract = await Verify.deploy();
  await verifyContract.deployed();

  const SadaivId = await ethers.getContractFactory('SadaivId');
  [signer, user] = await ethers.getSigners();

  sadaivIdContract = await SadaivId.deploy(verifyContract.address);
  await sadaivIdContract.deployed();
});

it('should register a new user', async () => {
  const message = 'You agree that you the owner of this address are registering on SadaivId';
  const githubId = 12345;
  const walletAddress = await signer.getAddress();

  const hash = await verifyContract.getMessageHash(message)
  const signature = await signer.signMessage(ethers.utils.arrayify(hash))

  await expect(sadaivIdContract.registerUser(message, signature, walletAddress, githubId))
    .to.emit(sadaivIdContract, 'NewUser')
    .withArgs(githubId, 1, walletAddress);

  const sadaivId = await sadaivIdContract.SCWAddressToSadaivId(walletAddress);

  expect(sadaivId).to.equal(1);
  expect(await sadaivIdContract.sadaivIdToGithubId(sadaivId, githubId)).to.be.true;
});


it('should add a new provider', async () => {
    const message = 'You agree that you the owner of this address are registering on SadaivId';
    const newId = 12345;
    const walletAddress = await signer.getAddress();
    const sadaivId = 1;
    const hash = await verifyContract.getMessageHash(message)
    const signature = await signer.signMessage(ethers.utils.arrayify(hash))

  await expect(sadaivIdContract.addProviders(message, signature, walletAddress, newId))
    .to.emit(sadaivIdContract, 'NewProvider')
    .withArgs(sadaivId, newId);

  expect(await sadaivIdContract.sadaivIdToGithubId(sadaivId, newId)).to.be.true;
});

it('should change contributor data', async () => {
  const message = 'You agree that you the owner of this address are registering on SadaivId';
  const walletAddress = await signer.getAddress();

  const hash = await verifyContract.getMessageHash(message)
  const signature = await signer.signMessage(ethers.utils.arrayify(hash))

  const cid = 'awbfhpiegji4758347v8n12392nbijq2iou48vbu';
  const sadaivId = 1;

  await expect(sadaivIdContract.changeContributorData(message, signature, walletAddress, cid))
    .to.emit(sadaivIdContract, 'NewProfileChange')
    .withArgs(cid);

  expect(await sadaivIdContract.contributorData(sadaivId)).to.equal(cid);
});
