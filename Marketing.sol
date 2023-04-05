pragma solidity ^0.8.0;

contract Marketing {

    // PortFolio Record structure
    struct PortFolioRecord {
        string portfolioName;
        string ownerName;
        string budget;
        uint timestamp;
    }

    // portfolio structure
    struct PortFolio {
        string name;
        mapping(uint => PortFolioRecord) PortFolioRecords;
        bool isPaid;
    }

    // PortFolio structure
    struct PortFolioDetails {
        string id;
        string name;
        string speciality;
    }

    // Mapping to store portfolio information
    mapping(address => PortFolio) public portfolios;

    // Mapping to store PortFolio information
    mapping(address => PortFolioDetails) public portFolioDetails;

    // Function to Register PortFolio
    function registerPortFolio(string memory _id, string memory _name, string memory _speciality) public {
        portFolioDetails[msg.sender] = PortFolioDetails(_id, _name, _speciality);
    }

    // Function to make payment
    function makePayment() public payable {
        PortFolio storage portFolio = portfolios[msg.sender];
        require(portFolio.isPaid == false, "payment already made");
        require(keccak256(abi.encodePacked(portFolio.name)) != keccak256(abi.encodePacked("")), "portfolio not registered");
        portFolio.isPaid = true;
    }

    // Function to add PortFolio record
    function addPortFolioRecord(uint _PortFolioRecordId, address portfolioAddress, string memory _portfolioName, string memory _ownerName, string memory _budget) public {
    // only PortFolio can add PortFolio record
    PortFolioDetails memory portFolioDeatils = portFolioDetails[msg.sender];
    require(bytes(portFolioDeatils.id).length > 0, "Only PortFolio can add PortFolio Details record.");
    // paitent id should be valid
    PortFolio storage portFolio = portfolios[portfolioAddress];
    require(portFolio.PortFolioRecords[_PortFolioRecordId].timestamp == 0, "PortFolio ID Invalid");
    uint timestamp = block.timestamp;
    PortFolioRecord memory record = PortFolioRecord(_portfolioName, _ownerName, _budget, timestamp);
    portFolio.PortFolioRecords[_PortFolioRecordId] = record;
    portFolio.name = _portfolioName;
}

    // Function to get PortFolio record
    function getPortFolioRecord(address _portfolioAddress, uint _portfolioId) public view returns (string memory, string memory, string memory, uint) {
        PortFolio storage portfolio = portfolios[_portfolioAddress];
        PortFolioRecord memory record = portfolio.PortFolioRecords[_portfolioId];
        return (record.portfolioName, record.ownerName, record.budget, record.timestamp);
    }

}
