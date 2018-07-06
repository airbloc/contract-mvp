pragma solidity ^0.4.21;

import "./RiskTokenLockRegistry.sol";

/**
 * AppRegistry stores an app information, and user IDs of the app.
 * A certain amount of token stake — proportional to the number of users — is required for apps.
 *
 * If an app did some bad things that prohibited by Airbloc Protocol's Law,
 * then there's a risk for app can LOSE some amount of it's stake.
 */
contract AppRegistry is RiskTokenLockRegistry {
    using SafeMath for uint32;

    // Basic App info for minimum proof. Rest of the data is available on off-chain.
    // TODO: Privacy considerations
    struct App {
        bytes32 id;
        uint32 userCount;
        mapping(address => bool) users;
    }

    mapping(address => App) public apps;

    /**
     * @param token The address of token for stake.
     * @param penaltyBeneficiary The destination wallet that stake losses are transferred to.  
     */
    constructor(ERC20 token, address penaltyBeneficiary) 
        RiskTokenLockRegistry(token, penaltyBeneficiary) {
    }

    /**
     * @param appId ID of off-chain app metadata. 
     */
    function register(bytes32 appId) public {
        apps[msg.sender] = App(appId, 0);
    }

    /**
     */
    function addUser(address[] addedUsers) public {
        App app = apps[msg.sender];
        require(app);
        require(balanceOf(msg.sender) >= getRequiredStake(app.userCount + addedusers.length));

        for (uint32 i = 0; i < addedUsers.length; i++) {
            app.users[addedUsers[i]] = true;
        }
        app.userCount = app.userCount.add(addedUsers.length);
    }

    function removeUser(address[] removedUsers) public {
        require(apps[msg.sender]);
        App app = apps[msg.sender];

        for (uint32 i = 0; i < removedUsers.length; i++) {
            app.users[removedUsers[i]] = false;
        }
        app.userCount = app.userCount.sub(removedUsers.length);
    }

    function unstake(uint256 amount) public {
        require(balanceOf(msg.sender) - amount >= getRequiredStake(apps[msg.sender].userCount));
        super.unstake(amount);
    }

    function hasUser(bytes32 appId, address user) public view returns (bool) {
        return apps[appId].users[user];
    }

    function getRequiredStake(uint32 userCount) public pure returns (uint256 amount) {
        return userCount;
    }
}