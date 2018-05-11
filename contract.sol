pragma solidity ^0.4.18;

// types:
// 1 - 

contract Charger {
	address owner;

	int128 lat;
	int128 lng;
	
	uint8 level;
	uint16 connector;
	uint16 type;
	uint128 power; 

	uint128 markup;

	bool confirmed;
	bool active;

	bool reserved;
	address reserver;
	bool busy;
	address holder;

	uint16 rating;

	function Charger(address _owner, int128 _lat, int128 _lng, uint8 _level, uint16 _connector, uint16 _type, uint128 _power, uint128 _markup) public {
		owner = _owner; 
		lat = _lat; 
		lng = _lng; 
		level = _level; 
		connector = _connector; 
		type = _type; 
		power = _power;
		markup = _markup;

		confirmed = false;
		active = false;

		reserved = false;
		reserver = address(0x0);
		busy = false;
		holder = address(0x0);

		rating = 0;
	}

	// This actions awailable only for charger owner
	modifier forOwner { 
		require (msg.sender == owner); 
		_; 
	}
	function getBalance() public forOwner constant returns(uint256) {
		return this.balance;
	}
	function withdraw(address destination, uint256 wei) public forOwner {
		destination.transfer(wei);
	}
	function activate() public forOwner {
		active = true;
	}
	function deactivate() public forOwner { 
		active = false; 
	}
	function changeAttr(string attr) public forOwner{
		
	}


	// Before adding charger to network, somoeone should confirm, that info corresponds with reality
	function confirm() public {
		require (owner != msg.sender);
		confirmed = true;
	}
	// function unconfirm() public {
	// 	if (msg.sender != owner) {
	// 		confirmed = true;
	// 	}
	// }

	// You, of course, need time to get to the charger. You can reserve it and no one will be able to reserve or use this charger
	function reserve() public payable {
		require (!busy);
		require (!reserved);
		reserved = true;
		reserver = msg.sender;
	}
	function refuse() public {
		require (!busy);
		require (reserved);
		require (reserver == msg.sender);
		reserved = false;
		reserver = address(0x0);
	}

	// After your arrival other drivers should be aware that this charger is busy
	function occupy() public {
		require (!busy);
		require (!reserved);
		OPEN_ONDER_CHANNEL();
		busy = true;
		holder = msg.sender;
	}
	function free() public {
		require (busy);
		require (!reserved);
		require (holder == msg.sender);
		CLOSE_ONDER_CHANNEL();
	}



	// 
	function getAllInformation() public constant returns(address, int128, int128) {

	}

	function getLocation() public constant returns(int128, int128) {
		return (lat, lng);
	}
	
	function getCharacteristics() public constant returns(uint8, int16, uint16, uint128) {
		return (level, connector, type, power)
	}  

	function getState() public constant returns(bool, bool, bool) {
		return (active, reserved, busy);   
	}
}

// contract User {
// 	bool reserving;
// 	address reserved;
// 	function User() public {

// 	}
// }

contract Onder {
	uint64 chargersCount;
	mapping (address => address) chargers;

	function Onder() public {}

	function addCharger(int128 _lat, int128 _lng, uint8 _level, uint16 _connector, uint16 _type, uint128 _power, uint128 _markup) public returns(uint8) {
		chargers[msg.sender] = Charger(msg.sender, _lat, _lng, _level, _connector, _type, _power, _markup);
		chargersCount += 1;
	}

	function getNear(uint128 lat, uint128 lng, uint128 radius) public constant returns(address[]) {
		
	}

	function getChargerCount() public constant returns(uint64) {
		return chargersCount;
	}

	function getChargersByOwner(address owner) public constant returns(address) {
		return chargers[owner];
	}
}