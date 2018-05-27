pragma solidity ^0.4.21;

import "./TokenRiskStakable.sol";

/**
 * AppRegistry stores an app information, and user IDs of the app.
 * A certain amount of token stake — proportional to the number of users — is required for apps.
 *
 * If an app did some bad things that prohibited by Airbloc Protocol's Law,
 * then there's a risk for app can LOSE some amount of it's stake.
 */
contract AppRegistry is TokenRiskStakable {
    using SafeMath for uint32;

    // Basic App info for minimum proof. Rest of the data is available on off-chain.
    // TODO: Use Cryptographic Accumulator (ex: PMT, MMR...) for privacy, instead of using Set.
    struct App {
        bytes32 id;
        uint32 userCount;
        mapping(bytes32 => bool) userIds;
    }

    mapping(address => App) public apps;

    /**
     * @param token The address of token for stake.
     * @param penaltyBeneficiary The destination wallet that stake losses are transferred to.  
     */
    constructor(ERC20 token, address penaltyBeneficiary) 
        TokenRiskStakable(token, penaltyBeneficiary) {
    }

    /**
     * @param appId ID of off-chain app metadata. 
     */
    function register(bytes32 appId) public {
        apps[msg.sender] = App(appId, 0);
    }

    /**
     */
    function addUser(bytes32[] addedUserIds) public {
        var app = apps[msg.sender];
        require(app);
        require(getMyStake() >= getRequiredStake(app.userCount + addedUserIds.length));

        for (uint32 i = 0; i < addedUserIds.length; i++) {
            app.userIds[addedUserIds[i]] = true;
        }
        app.userCount = app.userCount.add(addedUserIds.length);
    }

    function removeUser(bytes32[] removedUserIds) public {
        require(apps[msg.sender]);
        var app = apps[msg.sender];

        for (uint32 i = 0; i < removedUserIds.length; i++) {
            app.userIds[removedUserIds[i]] = false;
        }
        app.userCount = app.userCount.sub(removedUserIds.length);
    }

    function unstake(uint256 amount) public {
        require(getMyStake() - amount >= getRequireStake(apps[msg.sender].userCount));
        super.unstake(amount);
    }

    function hasUser(bytes32 appId, bytes32 userId) public view returns (bool) {
        return apps[appId].userIds[userId];
    }

    function getRequiredStake(uint32 userCount) public pure returns (unit256 amount) {
        return userCount;
    }
}