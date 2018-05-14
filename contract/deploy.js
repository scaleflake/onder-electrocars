/*jshint esversion: 6 */

const fs = require('fs');
const solc = require('solc');
const Web3 = require('web3');

const kwei = 1000;
const mwei = 1000 * kwei;
const gwei = 1000 * mwei;
const twei = 1000 * gwei;

const web3 = new Web3('http://localhost:8545');

var senderAccount = '';

web3.eth.getAccounts(function(error, result) {
    if (error != null) {
        console.log("Couldn't get accounts");
    }
    senderAccount = result[0];
    console.log(senderAccount);
});

const compiled = solc.compile(fs.readFileSync('contract.sol', 'utf-8'));

const interface = JSON.parse(compiled.contracts[':StandartFactory'].interface);
const bytecode  =  '0x' +   (compiled.contracts[':StandartFactory'].bytecode);

const contract = new web3.eth.Contract(interface);

var deployed = contract.deploy({
    data: bytecode,
    arguments: []
});

setTimeout(function() {
    deployed.send({
        from: senderAccount,
        gas: 3000000,
        gasPrice: '1'
    }).then(function(instance) {
        var address = instance.options.address;
        console.log('\n');
        console.log('Contract address:');
        console.log(address);

        fs.writeFileSync('./../database/interface.json', JSON.stringify(interface, null, 4), 'utf-8');
        fs.writeFileSync('./../database/address.json',   JSON.stringify(address,   null, 4), 'utf-8');

        var contractjs = 'const account = ' + JSON.stringify(senderAccount, null, 4) +
                        ';\nconst address = ' + JSON.stringify(address, null, 4) + 
                        ';\nconst interface = ' + JSON.stringify(interface, null, 4);

        fs.writeFileSync('./../database/contract.js', contractjs, 'utf-8');
    });   
}, 1000);