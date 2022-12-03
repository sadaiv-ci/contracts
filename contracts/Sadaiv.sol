//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Sadaiv {
  struct Build {
    string developer;
    string cid;
    string branch;
    string commitMessage;
  }

  event VerifiedBuilder (
    string email,
    address walletAddress
  );

  struct Repository {
    string owner;
    string name;
  }

  event NewBuildCreated (
    Repository repository,
    Build build
  );

  address owner;

  constructor() {
    owner = msg.sender;
  }


  // Indexes new build generated / backed up data on network.
  function createBuild(string memory repositoryOwner, string memory repositoryName, string memory branchName, string memory developer, string memory commitMessage, string memory cid) public {
    require(msg.sender == owner, "Only owner can push to create new builds.");
    Repository memory repo = Repository(
      repositoryOwner,
      repositoryName
    );
    Build memory build = Build(
      developer,
      cid,
      branchName,
      commitMessage
    );
    emit NewBuildCreated(repo, build);
  }

  // Verifies the builder from Github Authentication and sets the wallet address.
  function verifyBuilder(string memory email, bytes32 _hashMessage, uint8 _v, bytes32 _r, bytes32 _s) public {
    require(msg.sender == owner, "Only contract owner can verify the builder.");

    bytes memory prefix = "\x19Ethereum Signed Message:\n32";
    bytes32 prefixedHashMessage = keccak256(abi.encodePacked(prefix, _hashMessage));

    address signer = ecrecover(prefixedHashMessage, _v, _r, _s);

    emit VerifiedBuilder(email, signer);
  }

}
