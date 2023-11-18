const { Web3 } = require('web3'); //  web3.js has native ESM builds and (`import Web3 from 'web3'`)
const fs = require('fs');
const path = require('path');

// Set up a connection to the Ethereum network
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'));

// Read the contract address from the file system
const deployedAddressPath = path.join(__dirname, 'MyContractAddress.bin');
const deployedAddress = fs.readFileSync(deployedAddressPath, 'utf8');

// Read the bytecode from the file system
const bytecodePath = path.join(__dirname, 'MyContractBytecode.bin');
const bytecode = fs.readFileSync(bytecodePath, 'utf8');

// Create a new contract object using the ABI and bytecode
const abi = require('./MyContractAbi.json');
const myContract = new web3.eth.Contract(abi, deployedAddress);
myContract.handleRevert = true;

async function interact() {
    const providersAccounts = await web3.eth.getAccounts();
    const defaultAccount = providersAccounts[0];

    try {
        // Get the current value of my number
        const myNumber = await myContract.methods.myNumber().call();
        console.log('my number value: ' + myNumber);

        // Increment my number
        const receipt = await myContract.methods.setMyNumber(myNumber + 1n).send({
            from: defaultAccount,
            gas: 1000000,
            gasPrice: 10000000000,
        });
        console.log('Transaction Hash: ' + receipt.transactionHash);

        // Get the updated value of my number
        const myNumberUpdated = await myContract.methods.myNumber().call();
        console.log('my number updated value: ' + myNumberUpdated);
    } catch (error) {
        console.error(error);
    }
}

interact();