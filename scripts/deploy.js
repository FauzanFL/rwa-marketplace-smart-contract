const hre = require("hardhat");

async function main() {
    const RealAssetNft = await hre.ethers.getContractFactory("RealAssetNFT");
    const rwaNft = await RealAssetNft.deploy();

    await rwaNft.waitForDeployment();

    console.log("RealAssetNFT deployed to: ", await rwaNft.getAddress());
}

main()
.then(() => process.exit(0))
.catch((err) => {
    console.error(err); 
    process.exit(1);
})