//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract SadaivBackup {
  mapping(address => bool) public owners;

  constructor() {
    owners[msg.sender] = true;
  }

  modifier onlyOwner() {
    require(owners[msg.sender], "Not authorized!");
    _;
  }

  function makeOwner(address _address) public onlyOwner {
    owners[_address] = true;
  }

  function checkIfOwner(address _address) public view returns (bool) {
    return owners[_address];
  }

  struct Build {
    string branch;
    string commitMessage;
    string commitHash;
    string timestamp;
    uint256 contributorGithubId;
    string backupCid;
    string changesCid; //future scope
  }

  struct Repository {
    uint256 id;
    string name;
    string fullname;
    string description;
    uint256 ownerGithubId;
    uint256 size;
    bool forked;
    string defaultBranch;
    string timestamp;
    string[] topics;
    string[] languages;
  }

  mapping(uint256 => Repository) public userRepos; //repoId => repo
  mapping(uint256 => mapping(bytes32 => Build)) public repoBuilds; //repoId => hash(barnch+commitHash) => build

  event NewBuild(Repository repository, Build build, bytes32 buildhash);

  function createNewBuild(
    Repository memory _repo,
    Build memory _build
  ) public onlyOwner {
    userRepos[_repo.id] = _repo;
    bytes32 buildhash = keccak256(
      abi.encodePacked(
        string(abi.encodePacked(_build.branch, _build.commitHash))
      )
    );
    repoBuilds[_repo.id][buildhash] = _build;
    emit NewBuild(_repo, _build, buildhash);
  }
}
