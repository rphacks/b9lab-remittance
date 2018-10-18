pragma solidity ^0.4.17;

contract Remittance {

    address private owner;
    address private recipientAddress;
    address private exchangeAddress;

    bytes32 private recipientPassword;

    bool private funds_unlocked;
    uint value;
    uint blockDeadline;

    event LogRetrieve();
    event LogClaimBack();

    constructor(address _recipientAddress, address _exchangeAddress, bytes32 _recipientPassword,  uint deadline) public payable {
        require(deadline > 6000, "deadline needs to be above 6000 blocks");
        owner = msg.sender;
        value = msg.value;
        recipientAddress = _recipientAddress;
        exchangeAddress = _exchangeAddress;
        recipientPassword = _recipientPassword;
        blockDeadline = block.number + deadline;
    }

    function claimBackFunds() public{
        require(msg.sender == owner);
        require(block.number > blockDeadline);

        emit LogClaimBack();

        uint to_transfer = value;
        value = 0;
        owner.transfer(to_transfer);
    }

    function retrieveFunds(string _recipientPassword) public{
        require(msg.sender == exchangeAddress);
        require(recipientPassword == keccak256(_recipientPassword), "recipient password is incorrect");

        emit LogRetrieve();

        uint to_transfer = value;
        value = 0;
        exchangeAddress.transfer(to_transfer);
    }
}
