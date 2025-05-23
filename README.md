# Sample Hardhat Project

## Preparation
Install package
```shell
npm install
```

## How to use
Run hardhat node
```shell
npx hardhat node
```
Deploy smart contract to localhost network (**use different terminal*)
```shell
npx hardhat run scrtips/deploy.js --network localhost
```
After deploy, you will get contract address. Save the address to use in the frontend. <br>
Then copy the ABI file located in **artifacts/contracts/RealAssetNFT.json** to the frontend project