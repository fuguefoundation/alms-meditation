pragma solidity ^0.4.0;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract AlmsMeditation is usingOraclize {

    address public owner;
    address public recipient;
    uint gasLimit = 5000000000000000; //.005 ETH
    uint public totalGasAmount;
    uint public totalDonationAmount;
    uint public oneDayDonationAmount;
    uint public numDonationDays;
    uint public numDonationDaysInSeconds;
    bool public startStopDonating = true;
    uint messageIndex = 0;
    //mapping(bytes32=>bool) validIds;
    string[] private wisdom = [
        "Wisdom 1",
        "Wisdom 2",
        "Wisdom 3"
    ];

    event DonationSent(uint amount, string message);
    event DonationReceived(uint amount, uint dailyAmount);
    event Feedback(string description);
    event ContractCreated(address recipient, uint numDonationDays, string message);

    function AlmsMeditation(address _recipient, uint _numDonationDays) payable {
        owner = msg.sender;
        recipient = _recipient;
        numDonationDays = _numDonationDays;
        numDonationDaysInSeconds = _numDonationDays * 86400;
        totalGasAmount = gasLimit * _numDonationDays;
        totalDonationAmount = msg.value;
        oneDayDonationAmount = (totalDonationAmount - totalGasAmount) / numDonationDays;
        //oraclize_setCustomGasPrice(20000000000);
        ContractCreated(_recipient, _numDonationDays, "Alms contract created");
        payout();
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function() payable public {
        totalDonationAmount += msg.value;
        oneDayDonationAmount = totalDonationAmount / numDonationDays - totalGasAmount;
        DonationReceived(msg.value, oneDayDonationAmount);
    }

    function startStopDonating(bool state) onlyOwner public {
        startStopDonating = state;
    }

    function __callback(bytes32 myid, string result) {
        //require(!validIds[myid]);
        if (msg.sender != oraclize_cbAddress()) throw;
        Feedback("Callback");
        //delete validIds[myid];
        // executes 1 day after contract creation and recursively
        payout();
    }

    function payout() payable {
        require(startStopDonating);
        string message = wisdom[messageIndex];

        if (oraclize_getPrice("URL") > totalDonationAmount) {
            Feedback("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            recipient.transfer(oneDayDonationAmount);
            totalDonationAmount -= oneDayDonationAmount;
            oraclize_query(86400, "URL", "");
            //validIds[queryId] = true;
            if(messageIndex < wisdom.length){
                messageIndex++;
            } else {
                messageIndex = 0;
            }
            DonationSent(oneDayDonationAmount, message);
        }
    }

    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }

    function transferRecipient(address newRecipient) onlyOwner public {
        recipient = newRecipient;
    }

    function endContract() onlyOwner public {
        selfdestruct(owner);
    }

}