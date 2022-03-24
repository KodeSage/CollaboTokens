// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

    contract CrankyERC is ERC20 {

            address private tokenOwner;
            uint public unitsOneEthCanBuy;


            constructor(string memory name, string memory symbol, uint quantityPerEth, uint InitSupply)
            ERC20(name, symbol){
                tokenOwner = msg.sender;
                unitsOneEthCanBuy =quantityPerEth;
                _mint(tokenOwner, InitSupply * 10**uint(decimals()));
            }

            function buyTokens(address receiver) public payable returns(uint tokenAmount){
                require(msg.value > 0, "Send ETH to buy some tokens");
                uint amountToBuy = msg.value * unitsOneEthCanBuy;
                require(balanceOf(tokenOwner) >= amountToBuy, 
                "Not enough tokens");
                _transfer(tokenOwner, receiver, amountToBuy);
                 emit Transfer(tokenOwner, receiver, amountToBuy);
                 payable(tokenOwner).transfer(msg.value);
                 return amountToBuy;
            }

            function getBalance(address user) public view returns(uint){
            return balanceOf(user);
        }
            function getSummary() public view returns(string memory, string memory, uint) {
            return (
                name(),
                symbol(),
                totalSupply()
            );
            }

    }

