const { utils } = require( "ethers" );

async function main ()
{
    const baseTokenURI = "ipfs://QmdpzAfkQUmZ2yzkp4Z8tbYvKYdtf61iqypd39LaSgmueP/";

    // Get owner/deployer's wallet address
    const [ owner ] = await hre.ethers.getSigners();

    // Get contract that we want to deploy
    const contractFactory = await hre.ethers.getContractFactory( "CrankySquirrel" );
    const contractERCFactory = await hre.ethers.getContractFactory( "CrankyERC" );

    // Deploy contract with the correct constructor arguments
    const contract = await contractFactory.deploy( baseTokenURI );
    const contractERC = await contractERCFactory.deploy("SapaToken", "SAPA", 1000, 1000000  );

    // Wait for this transaction to be mined
    await contract.deployed();
    await contractERC.deployed();

    // Get contract address
    console.log( "Contract deployed to:", contract.address );
    console.log( "Contract deployed to:", contractERC.address );

    // Reserve NFTs
    let txn = await contract.reserveNFTs();
    await txn.wait();
    console.log( "4 NFTs have been reserved" );

    // Mint 1 NFTs by sending 0.01 ether
    txn = await contract.mintNFTs( 1, { value: utils.parseEther( '0.001' ) } );
    await txn.wait()

    // Get all token IDs of the owner
    let tokens = await contract.tokensOfOwner( owner.address )
    console.log( "Owner has tokens: ", tokens );

}

main()
    .then( () => process.exit( 0 ) )
    .catch( ( error ) =>
    {
        console.error( error );
        process.exit( 1 );
    } );