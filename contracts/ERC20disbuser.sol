// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


import "./ERC20Airdrop.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";



contract ERC20AirdropDisbuser is Ownable {
    
    bytes32 merkleRoot;
    ERC20Airdrop reward;

    mapping(address => bool) public holders;

    constructor(ERC20Airdrop _reward, bytes32 _merkleroot) {

        merkleRoot = _merkleroot;
        reward = _reward;
        
        
    }


    function checkInWhitelist(bytes32[] memory _merkleProof, uint256 _airDrop)private view returns (bool){

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, _airDrop));

        bool valid = MerkleProof.verify(_merkleProof,merkleRoot, leaf);

        return valid;

    }


    function claim(bytes32[] calldata proof, uint256 airdrop) public {
        require(checkInWhitelist(proof, airdrop), "You are not in the whitelist");
        require(holders[msg.sender] == false, "You have already claimed");
        holders[msg.sender] = true;
        ERC20Airdrop(reward).transfer(payable(msg.sender), airdrop);
    }

}