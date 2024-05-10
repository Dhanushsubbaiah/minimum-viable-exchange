// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract DEX is ReentrancyGuard {
    IERC20 public token;
    uint256 public totalLiquidity;
    mapping(address => uint256) public liquidity;

	    struct LimitOrder {
        uint256 id;
        address user;
        uint256 amount;
        uint256 price;
        bool isSellOrder;
    }

    uint256 private nextOrderId = 0;
    mapping(uint256 => LimitOrder) public limitOrders;
    mapping(address => uint256[]) private userOrders;

    event EthToTokenSwap(
        address indexed swapper,
        uint256 tokenOutput,
        uint256 ethInput
    );

    event TokenToEthSwap(
        address indexed swapper,
        uint256 tokensInput,
        uint256 ethOutput
    );

    event LiquidityProvided(
        address indexed liquidityProvider,
        uint256 liquidityMinted,
        uint256 ethInput,
        uint256 tokensInput
    );

    event LiquidityRemoved(
        address indexed liquidityRemover,
        uint256 liquidityWithdrawn,
        uint256 tokensOutput,
        uint256 ethOutput
    );


    constructor(address token_addr) {
        token = IERC20(token_addr);
    }

    function init(uint256 tokens) public payable returns (uint256) {
        require(totalLiquidity == 0, "DEX: already initialized");
        require(msg.value > 0 && tokens > 0, "Cannot initialize with zero");
        require(token.transferFrom(msg.sender, address(this), tokens), "DEX: transfer failed");
        totalLiquidity = address(this).balance;
        liquidity[msg.sender] = totalLiquidity;
        emit LiquidityProvided(msg.sender, totalLiquidity, msg.value, tokens);
        return totalLiquidity;
    }

    function getLiquidity(address lp) public view returns (uint256) {
        return liquidity[lp];
    }

    function price(uint256 inputAmount, uint256 inputReserve, uint256 outputReserve) public pure returns (uint256) {
        require(inputReserve > 0 && outputReserve > 0, "Invalid reserves");
        uint256 inputAmountWithFee = inputAmount * 997;
        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = (inputReserve * 1000) + inputAmountWithFee;
        return numerator / denominator;
    }

    function ethToToken() public payable returns (uint256) {
        require(msg.value > 0, "Must send ETH to swap");
        uint256 tokenReserve = token.balanceOf(address(this));
        uint256 tokensBought = price(msg.value, address(this).balance - msg.value, tokenReserve);
        require(token.transfer(msg.sender, tokensBought), "DEX: failed to transfer tokens");
        emit EthToTokenSwap(msg.sender, tokensBought, msg.value);
        return tokensBought;
    }

    function tokenToEth(uint256 tokens) public nonReentrant returns (uint256) {
        require(tokens > 0, "Must send tokens to swap");
        uint256 tokenReserve = token.balanceOf(address(this));
        uint256 ethBought = price(tokens, tokenReserve, address(this).balance);
        (bool sent,) = msg.sender.call{value: ethBought}("");
        require(sent, "DEX: failed to send Ether");
        require(token.transferFrom(msg.sender, address(this), tokens), "DEX: failed to transfer tokens");
        emit TokenToEthSwap(msg.sender, tokens, ethBought);
        return ethBought;
    }

    function deposit() public payable returns (uint256 tokensDeposited) {
        require(msg.value > 0, "Must deposit ETH");
        uint256 ethReserve = address(this).balance - msg.value;
        uint256 tokenReserve = token.balanceOf(address(this));
        uint256 tokenAmount = (msg.value * tokenReserve) / ethReserve;
        require(token.transferFrom(msg.sender, address(this), tokenAmount), "Failed to transfer tokens");

        uint256 liquidityMinted = (msg.value * totalLiquidity) / ethReserve;
        liquidity[msg.sender] += liquidityMinted;
        totalLiquidity += liquidityMinted;

        emit LiquidityProvided(msg.sender, liquidityMinted, msg.value, tokenAmount);
        return tokenAmount;
    }

    function withdraw(uint256 liquidityAmount) public nonReentrant returns (uint256 ethAmount, uint256 tokenAmount) {
        require(liquidity[msg.sender] >= liquidityAmount, "Not enough liquidity");

        uint256 ethReserve = address(this).balance;
        uint256 tokenReserve = token.balanceOf(address(this));

        ethAmount = (liquidityAmount * ethReserve) / totalLiquidity;
        tokenAmount = (liquidityAmount * tokenReserve) / totalLiquidity;

        liquidity[msg.sender] -= liquidityAmount;
        totalLiquidity -= liquidityAmount;

        (bool ethSent,) = msg.sender.call{value: ethAmount}("");
        require(ethSent, "Failed to send ETH");
        require(token.transfer(msg.sender, tokenAmount), "Failed to transfer tokens");

        emit LiquidityRemoved(msg.sender, liquidityAmount, ethAmount, tokenAmount);
        return (ethAmount, tokenAmount);
    }
	
}
