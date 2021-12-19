// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";
// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// Helper to encode in Base64
import "./libraries/Base64.sol";

contract NFTGame is ERC721 {
    // Character's attributes
    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }
    // Array that hold default data of characters
    CharacterAttributes[] defaultCharacters;

    // Token Id
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Mapping from NFTs tokenId to that NFTs attributes
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;
    // Mapping from an address to the NFTs tokenId
    mapping(address => uint256) nftHolders;

    // Pass data into the contract when it is created
    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDmg
    ) ERC721 ("Sorcerers", "SORC") {
        // Loop through all characters, and save their values in contract
        for (uint i = 0; i < characterNames.length; i++) {
            defaultCharacters.push(
                CharacterAttributes({
                    characterIndex : i,
                    name : characterNames[i],
                    imageURI : characterImageURIs[i],
                    hp : characterHp[i],
                    maxHp : characterHp[i],
                    attackDamage : characterAttackDmg[i]
                })
            );

            CharacterAttributes memory c = defaultCharacters[i];
            console.log("Done Creating %s with HP %s, img URI %s", c.name, c.hp, c.imageURI);
        }
        // Incerement tokenIds so that my first NFT has an Id of 1
        _tokenIds.increment();
    }

    // Mint nft based on the characterId
    function mintCharacterNFT (uint256 _characterIndex) external {
        // Get current tokenId
        uint256 newItemId = _tokenIds.current();

        // Mint NFT
        _safeMint(msg.sender, newItemId);

        // Map tokenId => their character attributes
        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex : _characterIndex,
            name : defaultCharacters[_characterIndex].name,
            imageURI : defaultCharacters[_characterIndex].imageURI,
            hp: defaultCharacters[_characterIndex].hp,
            maxHp: defaultCharacters[_characterIndex].maxHp,
            attackDamage: defaultCharacters[_characterIndex].attackDamage
        });
        console.log("Minted NFT with tokenId %s and character index %s", newItemId, _characterIndex);

        // Map address => NFT tokenId
        nftHolders[msg.sender] = newItemId;

        // Increment tokenId
        _tokenIds.increment();
    }

    // Setup tokenURI
    function tokenURI (uint256 _tokenId) public view override returns (string memory) {
        CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];

        string memory strHp = Strings.toString(charAttributes.hp);
        string memory strMaxHp = Strings.toString(charAttributes.maxHp);
        string memory strAttackDamage = Strings.toString(charAttributes.attackDamage);

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        charAttributes.name,
                        ' -- NFT #: ',
                        Strings.toString(_tokenId),
                        '", "description": "This is an NFT that lets people play in the game Metaverse Sorcerers!", "image": "',
                        charAttributes.imageURI,
                        '", "attributes": [ { "trait_type": "Health Points", "value": ',strHp,', "max_value":',strMaxHp,'}, { "trait_type": "Attack Damage", "value": ',
                        strAttackDamage,'} ]}'
                    )
                )
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
    }
}