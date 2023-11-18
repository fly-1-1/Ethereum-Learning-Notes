const {Web3} = require('web3');

const provider = new Web3.providers.HttpProvider('HTTP://127.0.0.1:7545');

const web3 = new Web3(provider);

async function main() {
    const blockNum = await web3.eth.getBlockNumber();
    console.log("blockNum:", blockNum);

    const accounts = await web3.eth.getAccounts();

    const transactionReceipt = await web3.eth.sendTransaction({
        from: accounts[0],
        to: accounts[1],
        value: web3.utils.toWei('1', 'ether'),
    });
    console.log(transactionReceipt)

}

main();




