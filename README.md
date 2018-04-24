# Alms Meditation Contract

This is an Ethereum smart contract that uses [Oraclize](https://docs.oraclize.it) to give alms to a beneficiary over a given set of time, emitting meditations as events after each donation.

## Demo
[Example](http://fugueweb.com/dev/alms/) using the Ropsten testnet with 10 meditations and alms given.

## For Developers
1. Clone the repo
2. Deploy the contract using [Remix](https://remix.ethereum.org) or any other means. I compiled the contract using Solidity `v0.4.19` Ensure that you add `value` to the contract so that Oraclize can make its requests. You can add any strings you want inside the `wisdom` array. The contract will emit as an event this string along with the donation amount every day until funds run out.
3. To see the emitted events, establish an API key with [Etherscan](https://ropsten.etherscan.io/apis) and fill in the various queries to the contract you deployed in the `get` URL inside `app.js`

Note, as written `web3` is brought in locally directly inside `app.js`. This demo of the UI uses jQuery and Bootstrap for the sake of simplicity. Consider using [Truffle](http://truffleframework.com/) for a more robust application.