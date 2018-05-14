pragma solidity ^0.4.21;

contract Charger {
	address public mfr;

	address owner;

	int128 public lat;
	int128 public lng;
	
	uint8 public level;
	uint16 public connector;
	uint16 public class;
	uint128 public power; 

	uint128 public markup;

	bool public confirmed;
	bool public active;

	bool public reserved;
	address reserver;
	bool public busy;
	address holder;

	int16 public rating;

	function Charger(address _owner, int128 _lat, int128 _lng, uint8 _level, uint16 _connector, uint16 _class, uint128 _power, uint128 _markup) public {
		mfr = msg.sender;

		owner = _owner; 
		lat = _lat; 
		lng = _lng; 
		level = _level; 
		connector = _connector; 
		class = _class; 
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
	event ChargerChanged();
	modifier byOwner { 
		require (msg.sender == owner); 
		_;
		emit ChargerChanged();
	}
	modifier forOwner {
	    require (msg.sender == owner);
	    _;
	}
	function withdraw(address destination, uint256 weis) public byOwner {
		destination.transfer(weis);
	}
	function activate() public byOwner {
		active = true;
	}
	function deactivate() public byOwner { 
		active = false; 
	}
	// function changeAttr(string attr) public byOwner {
		
	// }
	function getBalance() public forOwner constant returns(uint256) {
		return address(this).balance;
	}


	// Before adding charger to network, somoeone should confirm, that info corresponds with reality
	event Confirmed();
	function confirm() public {
		require (owner != msg.sender);
		confirmed = true;
		emit Confirmed();
	}
	// function unconfirm() public {
	// 	if (msg.sender != owner) {
	// 		confirmed = true;
	// 	}
	// }

	// You, of course, need time to get to the charger. You can reserve it and no one will be able to reserve or use this charger
	event Reserved();
	function reserve() public payable {
		require (!busy);
		require (!reserved);
		reserved = true;
		reserver = msg.sender;
		emit Reserved();
	}
	event Refused();
	function refuse() public {
		require (!busy);
		require (reserved);
		require (reserver == msg.sender);
		reserved = false;
		reserver = address(0x0);
		emit Refused();
	}

	// After your arrival other drivers should be aware that this charger is busy
	event Occupied();
	function occupy() public {
		require (!busy);
		require (!reserved);
		// OPEN_ONDER_CHANNEL();
		busy = true;
		holder = msg.sender;
		emit Occupied();
	}
	event Released();
	function free() public {
		require (busy);
		require (!reserved);
		require (holder == msg.sender);
		// CLOSE_ONDER_CHANNEL();
		emit Released();
	}

	// Rating
	event Increased();
	function increaseRating() public {
		rating++;
		emit Increased();
	}
	event Decreased();
	function decreaseRating() public {
		rating--;
		emit Decreased();
	}
	

	// Get info about charger
	function getAllInformation() public constant returns(int128, int128, uint8, uint16, uint16, uint128, uint128, bool, bool, bool, bool, int16) {
		return (lat, lng, level, connector, class, power, markup, confirmed, active, reserved, busy, rating);
	}

	function getLocation() public constant returns(int128, int128) {
		return (lat, lng);
	}
	
	function getCharacteristics() public constant returns(uint8, uint16, uint16, uint128, uint128) {
		return (level, connector, class, power, markup);
	}  

	function getState() public constant returns(bool, bool, bool, bool, int16) {
		return (confirmed, active, reserved, busy, rating);   
	}
}

contract StandartFactory {
	uint public chargerCount = 0;
	address[] public chargers;

	function StandartFactory() public {}

	// Factory should be able to create new Charger instances
	event ChargerCreated(uint id, address charger);
	function createCharger(int128 _lat, int128 _lng, uint8 _level, uint16 _connector, uint16 _class, uint128 _power, uint128 _markup) public returns(uint) {
		address charger = new Charger(msg.sender, _lat, _lng, _level, _connector, _class, _power, _markup);
		chargers.push(charger);
		chargerCount++;
		emit ChargerCreated(chargerCount, charger);
		return chargerCount;
	}

	// Factory should be able to add existing Charger instances (created by other factories) to its base
	event ChargerAdded(uint id, address charger);
	function addCharger(address charger) public returns(uint) {
		chargers.push(charger);
		chargerCount++;
		emit ChargerAdded(chargerCount, charger);
		return chargerCount;
	}

	// function getNear(uint128 lat, uint128 lng, uint128 radius) public constant returns(address[]) {
		
	// }

	function getChargerCount() public constant returns(uint) {
		return chargerCount;
	}
	function getChargerById(uint id) public constant returns(address) {
		return chargers[id];
	}
}