//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";

interface VerifySignatureInterface {
  function verifySignature(
    address _signer,
    string memory _message,
    bytes memory signature
  ) external returns (bool);
}

contract SadaivId {
  mapping(address => bool) public owners;
  VerifySignatureInterface public verifySignatureContract;
  using Counters for Counters.Counter;
  Counters.Counter public sadaivId;

  constructor(address verifyContractAddress) {
    owners[msg.sender] = true;
    verifySignatureContract = VerifySignatureInterface(verifyContractAddress);
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
  function registerUser(
    string memory message,
    bytes memory signature,
    address signer
  ) public returns (uint256) {
    require(
      verifySignatureContract.verifySignature(signer, message, signature),
      "Address not authorized!"
    );
    require(SCWAddressToSadaivId[signer] == 0, "Address already registered.");
    sadaivId.increment();
    SCWAddressToSadaivId[signer] = sadaivId.current();
    emit NewUser(sadaivId.current(), signer);
    return sadaivId.current();
  }

  //function to add github account ids for a sadaiv userid
  function addProviders(
    string memory message,
    bytes memory signature,
    address signer,
    uint256 _newId
  ) public onlyOwner {
    require(
      verifySignatureContract.verifySignature(signer, message, signature),
      "Address not authorized!"
    );
    uint256 _sadaivId = SCWAddressToSadaivId[signer];
    require(
      !sadaivIdToGithubId[_sadaivId][_newId],
      "Provider already registered."
    );
    sadaivIdToGithubId[_sadaivId][_newId] = true;
    emit NewProvider(_sadaivId, _newId);
  }

  //change the contributor data cid
  function changeContributorData(
    string memory message,
    bytes memory signature,
    address signer,
    string memory cid
  ) public {
    require(
      verifySignatureContract.verifySignature(signer, message, signature),
      "Address not authorized!"
    );
    uint256 _sadaivId = SCWAddressToSadaivId[signer];
    contributorData[_sadaivId] = cid;
    emit NewProfileChange(_sadaivId, cid);
  }
}
