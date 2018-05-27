pragma solidity ^0.4.21;

import "openzeppelin-solidity/contracts/token/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol";

/**
 * Upgradable Token Stake Registry.
 */
contract TokenStakable is RBAC {
    using SafeMath for uint256;
    using SafeERC20 for ERC20;

    // ERC20 token contract being held
    ERC20 public token;

    // amount of locked ERC20 balances per user 
    mapping(address => uint256) public lockedBalanceOf;

    constructor(ERC20 token) {
        this.token = token;
    }

    /**
     * Unstake the token you locked up.
     * @param amount {uint256} you want to unstake
     */
    function stake(uint256 amountToStake) public {
        require(token.allowance(msg.sender, address(this)) >= amountToStake);
        require(token.balanceOf(msg.sender) >= amountToStake);

        lockedBalanceOf[msg.sender] = lockedBalanceOf[msg.sender].add(amountToStake);
        token.safeTransferFrom(msg.sender, address(this), amountToStake);
    }

    /**
     * Unstake the token you locked up.
     * @param amount {uint256} you want to unstake
     */
    function unstake(uint256 amount) public {
        require(amount <= getMyStake());

        lockedBalanceOf[msg.sender] = lockedBalanceOf[msg.sender].sub(amount);
        token.safeTransfer(msg.sender, amount);
    }

    function getMyStake() public view returns (uint256 balance) {
        return lockedBalanceOf[msg.sender];
    }
}