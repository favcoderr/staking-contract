//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IWETH} from "src/interface/IWETH.sol";
import {IERC20M} from "src/interface/IERC20M.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract PsalmStaking {
    using SafeERC20 for IERC20;

    IWETH public wethToken;
    IERC20M public receiptToken;
    IERC20 public rewardToken;
    struct StakeInfo {
        uint256 amount;
        uint256 timestamp;
        uint256 duration;
        uint256 reward;
        bool autoCompound;
    }

    mapping(address => StakeInfo) public stakes;
    mapping(address => bool) public autoCompoundStakers;

    uint256 public totalStaked;
    uint256 public totalAutoCompoundStaked;
    uint256 public annualRewardRate = 14; //14% APR

    event Staked(address indexed staker, uint256 amount);

    constructor(
        address _wethToken,
        address _receiptToken,
        address _rewardToken
    ) {
        wethToken = IWETH(_wethToken);
        receiptToken = IERC20M(_receiptToken);
        rewardToken = IERC20(_rewardToken);
    }

    function stake() external payable {
        require(msg.value > 0, "stake amount must be greater than 0");

        // convert ETH to WETH
        uint256 amount = msg.value;
        wethToken.deposit{value: amount}();

        // mint receipt tokens to depositor (1:1 ratio with WETH)
        uint256 receiptAmount = amount;
        _mintReceiptTokens(msg.sender, receiptAmount);

        // update staking info
        stakes[msg.sender].amount += receiptAmount;
        stakes[msg.sender].timestamp = block.timestamp;

        totalStaked += amount;
        emit Staked(msg.sender, amount);
    }

    function withdraw() external {
        require(stakes[msg.sender].amount > 0, "no stake to withdraw");
        require(
            stakes[msg.sender].timestamp + stakes[msg.sender].duration <
                block.timestamp,
            "stake is still locked"
        );
        require(
            stakes[msg.sender].reward == 0,
            "claim reward before withdrawing"
        );
        require(
            stakes[msg.sender].autoCompound == false,
            "disable auto-compound before withdrawing"
        );

        StakeInfo storage info = stakes[msg.sender];
        uint256 wethAmount = info.amount;

        // burn receipt tokens
        _burnReceiptTokens(msg.sender, wethAmount);

        // withdwaw WETH
        wethToken.withdraw(wethAmount);

        // transfer WETH to msg.sender
        payable(msg.sender).transfer(wethAmount);

        // update staking info
        info.amount = 0;
        info.timestamp = block.timestamp;

        totalStaked -= wethAmount;
    }

    function calculateReward(address staker) public view returns (uint256) {
        StakeInfo storage info = stakes[staker];
        uint256 stakedAmount = info.amount;
        uint256 stakedTime = block.timestamp - info.timestamp;
        uint256 reward = (stakedAmount * stakedTime * annualRewardRate) /
            365 days;
        return reward;
    }

    function claimReward() external {
        uint256 reward = calculateReward(msg.sender);
        rewardToken.transfer(msg.sender, reward);

        //update staking info
        stakes[msg.sender].timestamp = block.timestamp;
        stakes[msg.sender].reward = 0;
    }

    function enableAutoCompound() external {
         require(stakes[msg.sender].amount > 0, "No stake to auto-compound");
         require(!autoCompoundStakers[msg.sender], "Auto-compound already enabled");
         autoCompoundStakers[msg.sender] = true;
        // stakes[msg.sender].autoCompound = true;
        totalAutoCompoundStaked += stakes[msg.sender].amount;
    }

    function disableAutoCompound() external {
        require(autoCompoundStakers[msg.sender], "Auto-compound not enabled");
        autoCompoundStakers[msg.sender] = false;
        // stakes[msg.sender].autoCompound = false;
        totalAutoCompoundStaked -= stakes[msg.sender].amount;
    }

    function autoCompound() external {
        // calculate 1% fee from all auto-compounding rewards and distribute fee to msg.sender
        uint256 autoCompoundingFee = (totalAutoCompoundStaked * 1) / 100;
        rewardToken.transfer(msg.sender, autoCompoundingFee);

        // Iterate over each stake with autoCompound enabled
        // for (address staker : autoCompoundStakers) {
        //     StakeInfo storage info = stakes[staker];

        //     if (info.autoCompound && info.amount > 0) {
        //         // calculate rewards
        //         uint256 reward = calculateReward(staker);

        //         // convert to WETH
        //         uint256 wethAmount = reward;
        //         wethToken.deposit{value: wethAmount}();

        //         // restake principal + rewards
        //         uint256 restakeAmount = info.amount + wethAmount;
        //         info.amount = restakeAmount;
        //         info.timestamp = block.timestamp;
        //     }
        // }
    }

    function _mintReceiptTokens(address account, uint256 amount) internal {
        receiptToken._mint(account, amount);
    }

    function _burnReceiptTokens(address account, uint256 amount) internal {
        receiptToken._burn(account, amount);
    }
}
