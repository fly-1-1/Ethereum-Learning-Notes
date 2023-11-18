// First step: initialize `web3` instance
const { Web3 } = require('web3');
const web3 = new Web3('HTTP://127.0.0.1:7545');

// Second step: add an account to wallet
const privateKeyString = '0x185dec91c2e7aff0bb10c81ac058cbf69accd2e013a86bd1a338152822ca8781';
const account = web3.eth.accounts.wallet.add(privateKeyString).get(0);

ContractAbi=[
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "testInt",
                "type": "uint256"
            }
        ],
        "stateMutability": "nonpayable",
        "type": "constructor"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "internalType": "uint256",
                "name": "b",
                "type": "uint256"
            },
            {
                "indexed": false,
                "internalType": "bytes32",
                "name": "c",
                "type": "bytes32"
            }
        ],
        "name": "Event",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "internalType": "uint256",
                "name": "b",
                "type": "uint256"
            },
            {
                "indexed": false,
                "internalType": "bytes32",
                "name": "c",
                "type": "bytes32"
            }
        ],
        "name": "Event2",
        "type": "event"
    },
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "b",
                "type": "uint256"
            },
            {
                "internalType": "bytes32",
                "name": "c",
                "type": "bytes32"
            }
        ],
        "name": "foo",
        "outputs": [
            {
                "internalType": "address",
                "name": "",
                "type": "address"
            }
        ],
        "stateMutability": "nonpayable",
        "type": "function"
    }
]

//ContractBytecode='608060405273dcad3a6d3569df655070ded06cb7a1b2ccd1d3af60015f6101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550348015610063575f80fd5b5060405161031e38038061031e833981810160405281019061008591906100c8565b805f81905550506100f3565b5f80fd5b5f819050919050565b6100a781610095565b81146100b1575f80fd5b50565b5f815190506100c28161009e565b92915050565b5f602082840312156100dd576100dc610091565b5b5f6100ea848285016100b4565b91505092915050565b61021e806101005f395ff3fe608060405234801561000f575f80fd5b5060043610610029575f3560e01c806333aa24121461002d575b5f80fd5b6100476004803603810190610042919061012a565b61005d565b60405161005491906101a7565b60405180910390f35b5f827fb9b10fa6330336bee883557e906ab0d5e98ee503069e9c49689f95022db813998360405161008e91906101cf565b60405180910390a260015f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905092915050565b5f80fd5b5f819050919050565b6100d6816100c4565b81146100e0575f80fd5b50565b5f813590506100f1816100cd565b92915050565b5f819050919050565b610109816100f7565b8114610113575f80fd5b50565b5f8135905061012481610100565b92915050565b5f80604083850312156101405761013f6100c0565b5b5f61014d858286016100e3565b925050602061015e85828601610116565b9150509250929050565b5f73ffffffffffffffffffffffffffffffffffffffff82169050919050565b5f61019182610168565b9050919050565b6101a181610187565b82525050565b5f6020820190506101ba5f830184610198565b92915050565b6101c9816100f7565b82525050565b5f6020820190506101e25f8301846101c0565b9291505056fea26469706673582212204e9897e421bcb77430e300e7dc6b6937bfe4c194edb64b3f0d6dd12ec23bd5f364736f6c63430008170033'



