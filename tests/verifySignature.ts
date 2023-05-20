import { ethers } from 'hardhat';
import { expect } from 'chai';
require('dotenv').config();

let sadaivVerifyContract;

before(async () => {
  const SadaivVerify = await ethers.getContractFactory('VerifySignature');
 
  sadaivVerifyContract = await SadaivVerify.deploy();
  await sadaivVerifyContract.deployed();
});

it('verifies the signature', async () => {

    const accounts = await ethers.getSigners(3)
    const signer = accounts[0]
    const to = accounts[1].address
    const amount = 999
    const message = "Hello"
    const nonce = 123

    const hash = await sadaivVerifyContract.getMessageHash(message)
    const sig = await signer.signMessage(ethers.utils.arrayify(hash))

    // const ethHash = await sadaivVerifyContract.getEthSignedMessageHash(hash)

    // console.log("signer          ", signer.address)
    // console.log("recovered signer", await sadaivVerifyContract.recoverSigner(ethHash, sig))

  
      // Verify the signature on the smart contract
      const isSignatureValid = await sadaivVerifyContract.verifySignature(
        signer.address, message, sig
      );
  
      // Assert the result
      expect(isSignatureValid).to.be.true;
    });

