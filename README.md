# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js
```

## How to use
Run hardhat node
```shell
npx hardhat node
```
Deploy smart contract to localhost network
```shell
npx hardhat run scrtips/deploy.js --network localhost
```
After deploy, you will get contract address. Save the address to use in the frontend. <br>
Then copy the ABI file located in **artifacts/contracts/RealAssetNFT.json** to the frontend project