//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";

interface VerifySignatureInterface {
    function verifySignature(address _signer,string memory _message, bytes memory signature) external returns (bool);
}

contract SadaivId {
  VerifySignatureInterface public verifySignatureContract;
  using Counters for Counters.Counter;
  Counters.Counter public sadaivId;

  constructor(address verifyContractAddress){
        verifySignatureContract = VerifySignatureInterface(verifyContractAddress);
  }

  mapping(uint256 => mapping(uint256 => bool)) public sadaivIdToGithubId;
  mapping(address => uint256) public SCWAddressToSadaivId;
  mapping(uint256 => string) public contributorData; //scw address to contributor data cid

  event NewUser(uint256 githubId, uint256 sadaivId, address userAddress);
  event NewProfileChange(string cid);
  event NewProvider(uint256 sadaivId, uint256 provider);

  function registerUser(
    string memory message,
    bytes memory signature,
    address signer,
    uint256 githubId
  ) public {
    require(
      verifySignatureContract.verifySignature(signer, message, signature),
      "Address not authorized!"
    );
    require(
      SCWAddressToSadaivId[signer] != 0,
      "Address already registered."
    );
    sadaivId.increment();
    sadaivIdToGithubId[sadaivId.current()][githubId] = true;
    SCWAddressToSadaivId[signer] = sadaivId.current();
    emit NewUser(githubId, sadaivId.current(), signer);
  }

  function addProviders(
    string memory message,
    bytes memory signature,
    address signer,
    uint256 _newId
  ) public {
    require(
      verifySignatureContract.verifySignature( signer,message, signature),
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
    uint256 id = SCWAddressToSadaivId[signer];
    contributorData[id] = cid;
    emit NewProfileChange(cid);
  }
}
