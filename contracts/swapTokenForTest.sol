// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IWETH.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EthToTokenSwap {
    address public owner;
    address wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    IUniswapV2Router02 public constant uniswapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    
   function swapETHForTokens(address tokenAddress) external payable {
        address[] memory path = new address[](2);
        path[0] = wethAddress;
        path[1] = tokenAddress;

        uniswapRouter.swapExactETHForTokens{value: msg.value}(
            0,
            path,
            msg.sender,
            block.timestamp
        );
        
    }
    function getTokenBalance(address _tokenAddress) external view returns (uint256) {
        
        IERC20 token = IERC20(_tokenAddress);
       
        return token.balanceOf(msg.sender);
    }
  
     function checkAllowance(address token) public view returns(uint){
        return IERC20(token).allowance(msg.sender, address(this));
     }
    function transferF(address token, uint amount) public {
        IERC20(token).transferFrom(msg.sender, address(this), amount);
    }
    
}