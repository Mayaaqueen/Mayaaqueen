// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleSwap {
    address public token1;
    address public token2;

    uint256 public reserveToken1;
    uint256 public reserveToken2;

    address public owner;

    constructor(address _token1, address _token2) {
        token1 = _token1;
        token2 = _token2;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // Add liquidity (ratio 1:1)
    function addLiquidity(uint256 amount1, uint256 amount2) external {
        require(amount1 == amount2, "Amounts must be equal (1:1 ratio)");

        // Transfer tokens from sender to contract
        require(
            IERC20(token1).transferFrom(msg.sender, address(this), amount1),
            "Token1 transfer failed"
        );
        require(
            IERC20(token2).transferFrom(msg.sender, address(this), amount2),
            "Token2 transfer failed"
        );

        // Update reserves
        reserveToken1 += amount1;
        reserveToken2 += amount2;
    }

    // Swap token1 for token2
    function swapToken1ForToken2(uint256 amount1) external {
        uint256 amount2 = amount1; // 1:1 ratio

        require(reserveToken2 >= amount2, "Not enough liquidity for Token2");

        // Transfer token1 from user to contract
        require(
            IERC20(token1).transferFrom(msg.sender, address(this), amount1),
            "Token1 transfer failed"
        );

        // Transfer token2 from contract to user
        require(
            IERC20(token2).transfer(msg.sender, amount2),
            "Token2 transfer failed"
        );

        // Update reserves
        reserveToken1 += amount1;
        reserveToken2 -= amount2;
    }

    // Swap token2 for token1
    function swapToken2ForToken1(uint256 amount2) external {
        uint256 amount1 = amount2; // 1:1 ratio

        require(reserveToken1 >= amount1, "Not enough liquidity for Token1");

        // Transfer token2 from user to contract
        require(
            IERC20(token2).transferFrom(msg.sender, address(this), amount2),
            "Token2 transfer failed"
        );

        // Transfer token1 from contract to user
        require(
            IERC20(token1).transfer(msg.sender, amount1),
            "Token1 transfer failed"
        );

        // Update reserves
        reserveToken1 -= amount1;
        reserveToken2 += amount2;
    }

    // View reserves
    function getReserves() external view returns (uint256, uint256) {
        return (reserveToken1, reserveToken2);
    }

    // Withdraw tokens (only owner)
    function withdraw() external onlyOwner {
        uint256 balance1 = IERC20(token1).balanceOf(address(this));
        uint256 balance2 = IERC20(token2).balanceOf(address(this));

        IERC20(token1).transfer(owner, balance1);
        IERC20(token2).transfer(owner, balance2);

        reserveToken1 = 0;
        reserveToken2 = 0;
    }
}