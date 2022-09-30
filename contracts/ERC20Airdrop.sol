// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";




contract ERC20Airdrop is ERC20, Ownable {
   
   mapping(address => bool) tokenOwner;
 

    constructor() ERC20("evmToken", "EMT") { 

    }

     function mint(address _to, uint256 amount) external {
            
            require(tokenOwner[msg.sender],
            "Not tokenOwner");
           _mint(_to, amount);
        }

    function mintAirdrop(address[] calldata tokenHolders, uint256 amount) external {
        require(tokenOwner[msg.sender], "only tokenOwner can mint");
        for(uint256 i = 0; i < tokenHolders.length; i++){
            _mint(tokenHolders[i], amount);
        }
        
    }

}
