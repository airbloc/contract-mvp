pragma solidity ^0.4.21;

/**
 * AuthRegistry stores personal authorization settings per app.
 */
contract AuthRegistry {


    // AuthRegistry only stores boolean value about the user authorized the data,
    // 
    mapping(address => mapping(uint256 => bool)) private registry;

    function register(uint256 ruleId, bool authorized) public {
        registry[msg.sender][ruleId] = Auth(authorized);
    }

    function isAuthorized(uint256 ruleId) public view returns (bool) {
        var auth = registry[msg.sender][ruleId];
        return auth.authorized;
    }
}
