// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import { Base64 } from "./libraries/Base64.sol";


contract MyEpicNFT is ERC721URIStorage {

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='#666666' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string[] firstWords = ["French", "Italian", "English", "Spanish", "German", "Austrian", "Portuguese", "Belgium", "Dutch", "Swiss", "Danish", "Swedish", "Lithuanian", "Estonian", "Hungarian", "Polish", "Ukrainian", "Slovenian"];
    string[] secondWords = ["Programmer", "Politic", "Cook", "Designer", "Manager", "CEO", "CTO", "Singer", "Streamer", "Musician", "Degen", "Writer", "Journalist", "Influencer", "Pope", "Cashier", "Student", "Baker", "Butcher"];
    string[] thirdWords = ["Ninja", "Rockstar", "Oafish","Theory", "Ancient", "Chalk", "Nice", "Toad", "Minor", "Cure", "Hum", "Fool", "Consider", "Jeans", "Wreck", "Market", "Lunchroom","Judicious", "Flawless", "Awake", "Succinct", "Snobbish"];

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event newNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("WordsNFT", "WRD") {
        console.log("This contract will mint a NFT, wow!");
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function generateWord(uint256 tokenId) internal view returns (string memory) {
        uint256 seed1 = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))) % firstWords.length;
        uint256 seed2 = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))) % secondWords.length;
        uint256 seed3 = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))) % thirdWords.length;

        return string(abi.encodePacked(firstWords[seed1], secondWords[seed2], thirdWords[seed3]));
    }

    function generateJSON(string memory finalSvg, string memory finalWord) internal pure returns (string memory) {

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "', string(abi.encodePacked(finalWord)),
                        '", "description": "These grey squares are pretty cool, right?", "image": "data:image/svg+xml;base64,', 
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );
        return json;
    }

    function mintNFT() public {
        uint256 tokenId = _tokenIds.current();
        string memory finalWord = generateWord(tokenId);
        string memory finalSvg = string(abi.encodePacked(baseSvg, finalWord, "</text></svg>"));
        console.log(finalSvg);
        string memory finalUri = string(
            abi.encodePacked("data:application/json;base64,", generateJSON(finalSvg, finalWord))
        );
        console.log(finalUri);
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, finalUri);
        emit newNFTMinted(msg.sender, tokenId);
        console.log("An NFT w/ ID %s has been minted to %s", tokenId, msg.sender);
        _tokenIds.increment();
    }

}