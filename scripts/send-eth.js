const { ethers } = require("hardhat");

async function main() {
  const [sender] = await ethers.getSigners();

  const tx = await sender.sendTransaction({
    to: "0xDbD8c255281cf1f386A2Fd5799488ccA56b90be8",
    value: ethers.parseEther("10")
  });

  console.log("Transaction hash:", tx.hash);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
