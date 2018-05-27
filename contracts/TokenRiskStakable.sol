pragma solidity ^0.4.21;

import "./TokenStakable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/AddressUtils.sol";

/**
 * Upgradable Token Stake Registry, with the function to lose staked amount.
 * Punishing (lose someone's token stake) can be only done by Contracts.
 */
contract TokenRiskStakable is TokenStakable {
    using AddressUtils for address;
    using SafeMath for uint256;
    using SafeERC20 for ERC20;

    // RBAC role name of punisher contracts
    string private constant ROLE_PUNISHER = "punisher";

    // address that losed token stakes will sent.
    address public penaltyBeneficiary;

    constructor(ERC20 token, address penaltyBeneficiary) TokenStakable(token) {
        require(penaltyBeneficiary != address(0x0));
        this.penaltyBeneficiary = penaltyBeneficiary;
    }

    modifier onlyPunisher() { checkRole(msg.sender, ROLE_PUNISHER); _; }

    /**
     * 
     */
    function addPunisher(address punisher) external onlyPunisher {
        require(punisher.isContract());  // ONLY CONTRACT can be punisher.
        addRole("penaltyMaker", jury);
    }
    
    /**
     * Punish someone by lose his/her stake.
     */
    function punish(address victim, uint256 loseAmount) public onlyPunisher {
        require(lockedBalanceOf[victim] >= loseAmount);
        lockedBalanceOf[victim] = lockedBalanceOf[victim].sub(loseAmount);
        token.safeTransfer(penaltyBeneficiary, loseAmount);
    }
}