//SPDX-License-Identifier: MIT
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

    address private owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not an owner");
        _;
    }

    //create a build with the metadata for a particular backup.
    function createBuild(
        Repository memory repo, Build memory build, Contributor memory contributor
    ) public onlyOwner {
        emit NewBuildCreated(repo, build, contributor);
    }

    //transfer ownership of contract to a different address.
    function delegateOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}
