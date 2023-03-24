//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Sadaiv {
    struct Contributor {
        uint256 builderId;
        string builderName;
        string builderAvatarUrl;
    }
    struct Build {
        string branch;
        string commitMessage;
        string commitHash;
        string cid;
    }

    struct Repository {
        uint256 id;
        string name;
        string fullname;
        string description;
        uint256 ownerId;
        uint256 size;
        string default_branch;
        string[] topics;
        string language;
    }

    event NewBuildCreated(
        Repository repository,
        Build build,
        Contributor contributor
    );
    event VerifiedBuilder(uint256 githubId, address walletAddress);

    address private owner;
    mapping(uint256 => address) public builderMapping;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not an owner");
        _;
    }

    function createBuild(
        Repository memory repo, Build memory build, Contributor memory contributor
    ) public onlyOwner {
        
        emit NewBuildCreated(repo, build, contributor);
    }

    // Verifies the builder from Github Authentication and sets the wallet address.
    function verifyBuilder(uint256 githubId) public {
        if (builderMapping[githubId] == address(0)) {
            return;
        }

        builderMapping[githubId] = msg.sender;
        emit VerifiedBuilder(githubId, msg.sender);
    }

    function delegateOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}
