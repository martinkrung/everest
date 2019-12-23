// Inspired by  https://fravoll.github.io/solidity-patterns/eternal_storage.html
pragma solidity ^0.5.8;

import "../node_modules/@openzeppelin/contracts/ownership/Ownable.sol";
import "./MemberStruct.sol";

contract Registry is Ownable, MemberStruct {
    // ------
    // STATE
    // ------

    // Maps member address to Member data
    // Note, this address is used to map to the owner and delegates in the ERC-1056 registry
    mapping(address => Member) public members;
    bytes32 public charter;

    // ------------
    // CONSTRUCTOR:
    // ------------

    /**
    @dev Contructor     Sets the addresses for token, voting, and parameterizer
    @param _owner       Everest is the owner of the Registry
    */
    constructor (
        address _owner,
        bytes32 _charter
        // TODO - bootstrap list
    ) public {
        _owner = _owner;
        charter = _charter;
    }

    // --------------------
    // GETTER FUNCTIONS
    // --------------------

    function getMember(address _member) external view returns (
        uint256,
        bool,
        uint256
    ) {
        Member memory member = members[_member];
        return (
            member.challengeID,
            member.whitelisted,
            member.appliedAt
        );
    }

    function getChallengeID(address _member) external view returns (uint256) {
        Member memory member = members[_member];
        return member.challengeID;
    }

    function getWhitelisted(address _member) external view returns (bool) {
        Member memory member = members[_member];
        return member.whitelisted;
    }

    function getAppliedAt(address _member) external view returns (uint256) {
        Member memory member = members[_member];
        return member.appliedAt;
    }



    // --------------------
    // SETTER FUNCTIONS
    // --------------------

    function updateCharter(bytes32 _newCharter) external onlyOwner {
        charter = _newCharter;
    }

    function setMember(
        address _member,
        uint256 _appliedAt
    ) external onlyOwner {
        // Create the member struct
        Member memory member = Member({
            challengeID: 0,
            whitelisted: false,
            appliedAt: _appliedAt
        });
        // Store the member
        members[_member] = member;

        // TODO - call into ERC 1056. Actually move this completely into Everest
    }

    function whitelistMember(address _member) external onlyOwner {
        Member storage member = members[_member];
        member.whitelisted = true;
    }

    function editChallengeID(address _member, uint256 _newChallengeID) external onlyOwner {
        Member storage member = members[_member];
        member.challengeID = _newChallengeID;
    }

    function deleteMember(address _member) external onlyOwner {
        delete members[_member];
        // TODO - ensure we also delete and update the ERC1056 registry in the Everest contract
    }
}