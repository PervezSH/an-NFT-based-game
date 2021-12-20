const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('NFTGame');
    const gameContract = await gameContractFactory.deploy(
        ["Todo", "Yuji", "Maki", "Gojo"],   // Names
        ["https://i.imgur.com/oPB9pxw.gif",
        "https://i.imgur.com/JUmSOnx.gif",
        "https://i.imgur.com/IOsVeUv.gif",
        "https://i.imgur.com/zvh4w0Q.gif"], // Images
        [500, 300, 200, 1000],  // Hps
        [100, 75, 50, 500]  // Attack Damage Values
    );
    await gameContract.deployed();

    console.log("Game contrat deployed to : ", gameContract.address);

    let txn;
    txn = await gameContract.mintCharacterNFT(0);
    await txn.wait();
    console.log("Minted NFT #1");

    txn = await gameContract.mintCharacterNFT(1);
    await txn.wait();
    console.log("Minted NFT #2");

    txn = await gameContract.mintCharacterNFT(2);
    await txn.wait();
    console.log("Minted NFT #3");

    txn = await gameContract.mintCharacterNFT(3);
    await txn.wait();
    console.log("Minted NFT #4");

    txn = await gameContract.mintCharacterNFT(0);
    await txn.wait();
    console.log("Minted NFT #5");
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();