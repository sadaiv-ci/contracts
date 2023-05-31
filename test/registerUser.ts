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
  const githubId = 12345;
  const walletAddress = await signer.getAddress();

  await expect(sadaivIdContract.registerUser())
    .to.emit(sadaivIdContract, 'NewUser')
    .withArgs(1, walletAddress);

  const sadaivId = await sadaivIdContract.SCWAddressToSadaivId(walletAddress);

  expect(sadaivId).to.equal(1);
  expect(await sadaivIdContract.sadaivIdToGithubId(sadaivId, githubId)).to.be.false;
});
