//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";

contract Sadaiv{
    using Counters for Counters.Counter;
    Counters.Counter public sadaiv_id;

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

    mapping(uint256=>mapping(uint256=>bool)) public sadaivIdToGithubId;
    mapping(address=>uint256) public SCWAddressToSadaivId;
    // mapping(uint256=>Repository) public userRepos;
    mapping(uint256=>string) public contributorData;    //scw address to contributor data cid

    event newBuild(uint256 contributorGithubId, Repository Repository, Build build);
    event newUser(uint256 githubId, uint256 sadaivId, address userAddress);
    event newProfileChange(string cid);
    event newProvider(uint256 sadaivId, uint256 provider);

    function verifySignature(bytes32 message, bytes memory signature, address recoveredAddress) public pure returns (bool) {
        bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", message));
        address signer = ecrecover(hash, uint8(signature[0]), bytes32ToBytes(signature, 1), bytes32ToBytes(signature, 33));
        address calculatedAddress = address(uint160(uint256(keccak256(abi.encodePacked(signer)))) & 0x00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        return calculatedAddress == recoveredAddress;
    }

    function bytes32ToBytes(bytes memory b, uint256 offset) private pure returns (bytes32) {
        bytes32 out;
        for (uint256 i = 0; i < 32; i++) {
            out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
        }
        return out;
    }

    function createNewBuild(uint256 contributorGithubId, Repository memory _repo, Build memory _build) public {
        emit newBuild(contributorGithubId, _repo, _build);
    }

    function registerUser(bytes32 message, bytes memory signature, address recoveredAddress, uint256 _githubId) public {
        require(verifySignature(message, signature, recoveredAddress),"Address not authorized!");
        sadaiv_id.increment();
        sadaivIdToGithubId[sadaiv_id.current()][_githubId] = true;
        SCWAddressToSadaivId[recoveredAddress] = sadaiv_id.current();
        emit newUser(_githubId, sadaiv_id.current(), recoveredAddress);
    }

    function addProviders(bytes32 message, bytes memory signature, address recoveredAddress, uint256 _newId) public {
        require(verifySignature(message, signature, recoveredAddress),"Address not authorized!");
        uint256 _sadaivId = SCWAddressToSadaivId[recoveredAddress];
        require(!sadaivIdToGithubId[_sadaivId][_newId], "Provider already registered.");
        sadaivIdToGithubId[_sadaivId][_newId] = true;
        emit newProvider(_sadaivId, _newId);
    }

    function changeContributorData(bytes32 message, bytes memory signature, address recoveredAddress, string memory cid) public{
        require(verifySignature(message, signature, recoveredAddress),"Address not authorized!");
        uint256 id = SCWAddressToSadaivId[recoveredAddress];
        contributorData[id] = cid;
        emit newProfileChange(cid);
    }
}