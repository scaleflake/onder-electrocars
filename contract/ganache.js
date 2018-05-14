/*jshint esversion: 6 */

const ganache = require("ganache-cli");

const logger = {
	buffer: "",
	log: function(string) {

	}
};

const settings = {
	// "accounts": [],
	// "debug": true,
	"logger": console,
	// "mnemonic": ?,
	// "port": 8545,
	// "seed": ?,
	"total_accounts": 7,
	// "fork": "",
	// "network_id" int,
	// "time": Date(),
	// "locked": true,
	// "unlocked_accounts": ["0x000", "0x000"],
	// "db_path": "",
	// "account_keys_path": "",
	// "vmErrorsOnRPCResponse": true
};

const server = ganache.server(settings);

server.listen(8545, function(err, blockchain) {
	if (err) {
		console.error(err);
	} else {
		console.log(blockchain);
	}
});