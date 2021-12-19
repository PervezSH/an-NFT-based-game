// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract NFTGame {
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

    // Pass data into the contract when it is created
    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDmg
    ) {
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
    }
}