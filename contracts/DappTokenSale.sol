pragma solidity ^0.4.2;

import "./DappToken.sol";

contract DappTokenSale {
    address admin;
    DappToken public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokensSold;

    event Sell(
        address _buyer,
        uint256 _amount
    );

    constructor(DappToken _tokenContract, uint256 _tokenPrice) public {
        // assign an admin
        admin = msg.sender;
        // assign token contract to purchase tokens
        tokenContract = _tokenContract;
        // assign token price
        tokenPrice = _tokenPrice;
    }

    // multiply function
    function multiply(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x*y) / y==x);
    }

    // buy tokens
    function buyTokens(uint256 _numberOfTokens) public payable {
        // require that value is equal to tokens
        require(msg.value == multiply(_numberOfTokens, tokenPrice));
        // require that there are enough tokens on the contract
        require(tokenContract.balanceOf(this) >= _numberOfTokens);
        // require that the transfer is successful
        require(tokenContract.transfer(msg.sender, _numberOfTokens));
        // keep track of tokensSold
        tokensSold += _numberOfTokens;
        // trigger sell event
        emit Sell(msg.sender, _numberOfTokens);
    }

    // end token sale
    function endSale() public {
        // require only admin 
        require(msg.sender == admin);
        // transfer remaining dapp tokens to admin
        require(tokenContract.transfer(admin, tokenContract.balanceOf(this)));
        // destroy contract
        
        admin.transfer(address(this).balance);
    }
}
