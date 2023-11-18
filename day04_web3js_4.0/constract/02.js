// First step: initialize `web3` instance
const { Web3 } = require('web3');
const web3 = new Web3('HTTP://127.0.0.1:7545');

// Second step: add an account to wallet
const privateKeyString = '0x185dec91c2e7aff0bb10c81ac058cbf69accd2e013a86bd1a338152822ca8781';
const account = web3.eth.accounts.wallet.add(privateKeyString).get(0);

// Make sure the account has enough eth on balance to send the transaction


async function sendTransaction() {
    // Third step: sign and send the transaction
    // Magic happens behind sendTransaction. If a transaction is sent from an account that exists in a wallet, it will be automatically signed.
    try {
        const receipt = await web3.eth.sendTransaction({
            from: account?.address,
            to: '0x20Dd371C82FBD3fC3a6ff0a43763e6DCc639a353',
            value: web3.utils.toWei('15','ether'),
            gas: '300000',
            // other transaction's params
        });
    } catch (error) {
        // catch transaction error
        console.error(error);
    }
}

(async () => {
    await sendTransaction();
})();