//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";

contract SadaivBackup {

  struct Build {
    string branch;
    string commitMessage;
    // string commitHash;
    uint256 contributorGithubId;
    string cid;
    string changesCid; //future scope
  }

  struct Repository {
    // uint256 id;
    string name;
    string fullname;
    string description;
    uint256 ownerGithubId;
    uint256 size;
    string defaultBranch;
    string[] topics;
    string language;
  }

  mapping(uint256 => Repository) public userRepos;   //repoId => repo
  mapping(uint256 => mapping(string => Build)) public repoBuilds;  //repoId => commitHash => build  

  event NewBuild(
    Repository repository,
    Build build,
    uint256 repoId,
    string commitHash
  );
 
  function createNewBuild(
    Repository memory _repo,
    Build memory _build,
    uint256 _repoId,
    string memory _commitHash
  ) public {
    userRepos[_repoId] = _repo;
    repoBuilds[_repoId][_commitHash] = _build;
    emit NewBuild(_repo, _build, _repoId, _commitHash);
  }
}
