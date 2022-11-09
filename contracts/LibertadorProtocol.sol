
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DappToken.sol";
import "./LpToken.sol";

contract ElLibertador{
    string public name = "El Libertador";
    address public owner;
    DappToken public dappToken; 
    LpToken public lpToken; 
    bool public locked;
    uint256 public constant REWARD_PER_BLOCK = 1e18;
    struct Staker {
        uint256 stakingBalance; // amount of LP tokens staked
        uint256 checkpoints; // block number
        uint256 pendigRewards; // rewards that are not yet claimed
        bool hasStaked; // has staked at least once
        bool isStaking; // is currently staking
    }
    mapping (address=> Staker) public stakers;
    event depositEvent(address indexed from, uint256 indexed amount);
    event withdrawEvent(address indexed from, uint256 indexed amount);
    event claimEvent(address indexed from, uint256 indexed amount);
    event emergencyWithdrawEvent(address indexed from, uint256 indexed amount);
    
    constructor(DappToken _dappToken, LpToken _lpToken) {
        dappToken = _dappToken;
        lpToken = _lpToken;
        owner = msg.sender;
    }
    function deposit(uint256 _amount) public {
        require(_amount > 0, "amount cannot be 0");
        lpToken.transferFrom(msg.sender, address(this), _amount);
        stakers[msg.sender].stakingBalance = stakers[msg.sender].stakingBalance + _amount;
        if(!stakers[msg.sender].hasStaked) {
            stakers[msg.sender].hasStaked = true;
        }
        if(!stakers[msg.sender].isStaking) {
            stakers[msg.sender].isStaking = true;
        }
        stakers[msg.sender].checkpoints = block.number;
        emit depositEvent(msg.sender, _amount);
    }
    function withdraw(uint256 _amount) public {
        require(_amount > 0, "amount cannot be 0");
        lpToken.transfer(msg.sender, _amount);
        stakers[msg.sender].stakingBalance = stakers[msg.sender].stakingBalance - _amount;
        if(stakers[msg.sender].stakingBalance == 0) {
            stakers[msg.sender].isStaking = false;
        }
        emit withdrawEvent(msg.sender, _amount);
    }
    function claim() public {
        uint256 blockNumber = block.number;
        uint256 reward = (blockNumber - stakers[msg.sender].checkpoints) * REWARD_PER_BLOCK;
        stakers[msg.sender].pendigRewards = stakers[msg.sender].pendigRewards + reward;
        stakers[msg.sender].checkpoints = block.number;
        dappToken.transfer(msg.sender, stakers[msg.sender].pendigRewards);
        stakers[msg.sender].pendigRewards = 0;
        emit claimEvent(msg.sender, reward);
    }
    function emergencyWithdraw() public {
        uint256 amount = stakers[msg.sender].stakingBalance;
        lpToken.transfer(msg.sender, amount);
        stakers[msg.sender].stakingBalance = 0;
        stakers[msg.sender].isStaking = false;
        emit emergencyWithdrawEvent(msg.sender, amount);
    }
    function lock() public {
        require(msg.sender == owner, "only owner can lock");
        locked = true;
    }
    function unlock() public {
        require(msg.sender == owner, "only owner can unlock");
        locked = false;
    }


}



