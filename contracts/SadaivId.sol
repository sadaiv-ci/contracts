//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";

contract SadaivId {
  mapping(address => bool) public owners;
  using Counters for Counters.Counter;
  Counters.Counter public sadaivId;

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

  mapping(uint256 => mapping(uint256 => bool)) public sadaivIdToGithubId;
  mapping(address => uint256) public SCWAddressToSadaivId;
  mapping(uint256 => string) public contributorData; //sadaiv id to contributor data cid

  event NewUser(uint256 sadaivId, address scwAddress);
  event NewProfileChange(uint256 sadaivId, string cid);
  event NewProvider(uint256 sadaivId, uint256 provider);

  //register new user(with scw address) if not already registered
  function registerUser() public returns (uint256) {
    require(SCWAddressToSadaivId[msg.sender] == 0, "Address already registered.");
    sadaivId.increment();
    SCWAddressToSadaivId[msg.sender] = sadaivId.current();
    emit NewUser(sadaivId.current(), msg.sender);
    return sadaivId.current();
  }

  function userExists(address scwAddress) public view returns (bool) {
    return SCWAddressToSadaivId[scwAddress] != 0;
  }

  //function to add github account ids for a sadaiv userid
  function addProviders(
    uint256 _newId
  ) public onlyOwner {
    require(SCWAddressToSadaivId[msg.sender] != 0, "Address not registered.");
    uint256 _sadaivId = SCWAddressToSadaivId[msg.sender];
    require(
      !sadaivIdToGithubId[_sadaivId][_newId],
      "Provider already registered."
    );
    sadaivIdToGithubId[_sadaivId][_newId] = true;
    emit NewProvider(_sadaivId, _newId);
  }

  //change the contributor data cid
  function changeContributorData(
    string memory cid
  ) public {
    require(SCWAddressToSadaivId[msg.sender] != 0, "Address not registered.");
    uint256 _sadaivId = SCWAddressToSadaivId[msg.sender];
    contributorData[_sadaivId] = cid;
    emit NewProfileChange(_sadaivId, cid);
  }
}
