import { ethers } from 'hardhat';
import { Signer } from 'ethers';
import { expect } from 'chai';
import dotenv from 'dotenv';
require('dotenv').config();

let sadaivIdContract;
let owner: Signer;
let user: Signer;

before(async () => {
  const SadaivId = await ethers.getContractFactory('SadaivId');
  [owner, user] = await ethers.getSigners();

  sadaivIdContract = await SadaivId.deploy();
  await sadaivIdContract.deployed();
});

it('should register a new user', async () => {
  const message = 'You agree that you the owner of this address are registering on SadaivId';
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY as string); // Replace with the actual private key
  const signature = await wallet.signMessage(message);
  const walletAddress = '0xd4c62eA11760C44C20c6cC48D4d5207BEF43c3Cb'; 
  const githubId = 12345;
  const recoveredAddress = await user.getAddress();

  describe('Wallet Signature Verification', () => {

    it('verifies the signature', async () => {
      // Prepare the input data for signature verification
      // const message = 'You agree that you the owner of this address are registering on SadaivId';
      // Replace with the actual wallet address
  
      // Sign the message using the wallet's private key
      // const wallet = new ethers.Wallet(process.env.PRIVATE_KEY as string); // Replace with the actual private key
      // const signature = await wallet.signMessage(message);
  
      // Verify the signature on the smart contract
      const isSignatureValid = await sadaivIdContract.verifySignature(
        walletAddress,
        message,
        signature
      );
  
      // Assert the result
      expect(isSignatureValid).to.be.true;
    });
  });
  

  await expect(sadaivIdContract.registerUser(message, signature, recoveredAddress, githubId))
    .to.emit(sadaivIdContract, 'NewUser')
    .withArgs(githubId, 1, recoveredAddress);

  const sadaivId = await sadaivIdContract.SCWAddressToSadaivId(recoveredAddress);

  expect(sadaivId).to.equal(1);
  expect(await sadaivIdContract.sadaivIdToGithubId(sadaivId, githubId)).to.be.true;
});

it('should add a new provider', async () => {
  const message = 'Test Message';
  const signature = '<valid signature>';
  const newId = 67890;
  const recoveredAddress = await owner.getAddress();
  const sadaivId = 1;

  await expect(sadaivIdContract.addProviders(message, signature, recoveredAddress, newId))
    .to.emit(sadaivIdContract, 'NewProvider')
    .withArgs(sadaivId, newId);

  expect(await sadaivIdContract.sadaivIdToGithubId(sadaivId, newId)).to.be.true;
});

it('should change contributor data', async () => {
  const message = 'Test Message';
  const signature = '<valid signature>';
  const cid = 'CID789';
  const recoveredAddress = await user.getAddress();
  const sadaivId = 1;

  await expect(sadaivIdContract.changeContributorData(message, signature, recoveredAddress, cid))
    .to.emit(sadaivIdContract, 'NewProfileChange')
    .withArgs(cid);

  expect(await sadaivIdContract.contributorData(sadaivId)).to.equal(cid);
});
