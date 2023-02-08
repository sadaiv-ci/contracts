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

    address owner;
    mapping(uint256 => address) builderMapping;

    constructor() {
        owner = msg.sender;
    }

    // Indexes new build generated / backed up data on network.
    function createBuild(
        uint256 repositoryId,
        string memory repositoryName,
        string memory repositoryFullname,
        string memory repositoryDescription,
        uint256 repositoryOwner,
        uint256 repositorySize,
        string memory repositoryDefault_branch,
        string[] memory repositoryTopics,
        string memory repositoryLanguage,
        string memory commitMessage,
        string memory commitHash,
        string memory commitBranch,
        uint256 contributorId,
        string memory contributorName,
        string memory contributorAvatar_url
    ) internal {
        require(
            msg.sender == owner,
            "Only owner can push to create new builds."
        );
        Repository memory repo = Repository(
            repositoryId,
            repositoryName,
            repositoryFullname,
            repositoryDescription,
            repositoryOwner,
            repositorySize,
            repositoryDefault_branch,
            repositoryTopics,
            repositoryLanguage
        );

        Build memory build = Build(commitBranch, commitMessage, commitHash);

        Contributor memory contributor = Contributor(
            contributorId,
            contributorName,
            contributorAvatar_url
        );

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
}
