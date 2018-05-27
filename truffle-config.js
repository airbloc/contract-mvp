require('babel-register')
require('babel-polyfill')

const newProvider = require('./config.local.provider.js')

console.clear()

module.exports = {
    networks: {
        test: {
            host: "127.0.0.1",
            port: 7545,
            network_id: "*"
        },
        development: {
            host: "127.0.0.1",
            port: 7545,
            network_id: "*"
        },
        mainnet: {
            provider: newProvider('mainnet'),
            network_id: 1,
        },
        ropsten: {
            provider: newProvider('ropsten'),
            network_id: 3,
        },
        rinkeby: {
            provider: newProvider('rinkeby'),
            network_id: 4,
        }
    },
    solc: {
        optimizer: {
            enabled: true,
            runs: 200
        }
    }
};
