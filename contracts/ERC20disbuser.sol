// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


import "./ERC20Airdrop.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";



contract ERC20Disbuser is Ownable {


    mapping(uint256 => AddressAirdrop) addressAirdrops;
    mapping(address => mapping(uint256 => bool)) addressClaims;
    mapping(uint256 => mapping(uint256 => bool)) tokenClaims;
    bytes32 merkleRoot;

    
    

    struct AddressAirdrop {
        address _tokenHolder;
        uint256 amount;

    }

    uint256 airDropCounter;

    uint256 public aidrop = 10 ether;
    ERC20Airdrop reward;

    constructor(ERC20Airdrop _reward, bytes32 _merkleroot) {

        reward = _reward;
        merkleRoot = _merkleroot;
        
    }

    function rewardHolders(address[] calldata _tokenHolders) public onlyOwner{
        reward.mintAirdrop(_tokenHolders,aidrop);
    }


    function _verifyClaim(ERC20Airdrop _reward, uint256 _airDrop,bytes32[] memory _merkleProof)private view returns (bool valid){

        bytes32 leaf = keccak256(abi.encodePacked(_reward, _airDrop));

        return MerkleProof.verify(_merkleProof,merkleRoot, leaf);

    }


    function addAddressList(address holder, uint256 _amount) private returns(uint256) {
        AddressAirdrop storage drop = addressAirdrops[airDropCounter];
        drop._tokenHolder = holder;
        drop.amount = _amount;

        return airDropCounter++;
    }


    function isAddressClaimed(address _user, uint256 _airdropID) public view returns (bool) {
        return addressClaims[_user][_airdropID];
    }

    function isTokenClaimed(uint256 _airdropID, uint256 tokenId) public view returns (bool) {
        return tokenClaims[tokenId][_airdropID];
    }

    function setAddressClaimed(address _user, uint256 _airdropID) private {
        addressClaims[_user][_airdropID] = true;
    }

}