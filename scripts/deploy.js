const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('NFTGame');
    const gameContract = await gameContractFactory.deploy(
        ["Todo", "Yuji", "Maki", "Gojo"],   // Names
        ["https://i.imgur.com/oPB9pxw.gif",
        "https://i.imgur.com/JUmSOnx.gif",
        "https://i.imgur.com/IOsVeUv.gif",
        "https://i.imgur.com/zvh4w0Q.gif"], // Images
        [500, 300, 200, 1000],  // Hps
        [100, 75, 50, 500],  // Attack Damage Values
        // Big Boss's attributes
        "Hanami",   // Boss name
        "https://i.imgur.com/u8T6yqR.gif",  // Boss image URI
        5000,   // Boss hp
        75  //Boss attack damage
    );
    await gameContract.deployed();

    console.log("Game contrat deployed to : ", gameContract.address);

    let txn;
    txn = await gameContract.mintCharacterNFT(0);
    await txn.wait();

    txn = await gameContract.attackBoss();
    await txn.wait();

    txn = await gameContract.attackBoss();
    await txn.wait();
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