pragma solidity ^0.4.21;

/**
 * AppRegistry stores data authorization settings per person.
 */
contract AuthRegistry {
    // only store boolean value whether the user authorized Auth rule.
    mapping(address => mapping(bytes32 => bool[])) private registry;

    function register(bytes32 ruleId, bool[] authorizations) public {
        registry[msg.sender][ruleId] = authorizations;
    }

    function getAuthorizations(bytes32 ruleId) public view returns (bool[]) {
        return registry[msg.sender][ruleId];
    }
}
