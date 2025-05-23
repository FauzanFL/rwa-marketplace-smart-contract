const { ethers } = require("hardhat");

async function main() {
  const [sender] = await ethers.getSigners();

  const tx = await sender.sendTransaction({
    to: "0xDbD8c255281cf1f386A2Fd5799488ccA56b90be8", // Your address destination
    value: ethers.parseEther("10") // 10 ETH
  });

  console.log("Transaction hash:", tx.hash);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
