// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract ShaderNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // internal data
    mapping(uint256 => string) shader_codes;
    mapping(uint256 => string) shader_codes_encoded;
    mapping(uint256 => uint256) shader_modes;
    string viewer;

    // some constants for making SVGs
    uint256 constant margin = 30;
    uint256 constant chars_per_row = 16;
    uint256 constant char_mult = (512-(2*margin))/chars_per_row;

    constructor(string memory viewer_url) ERC721("ShaderNFT", "NFT") {
        viewer = viewer_url;
    }

    function mintNFT(address recipient, string memory shader_code, string memory shader_code_encoded, uint256 shader_mode)
        public onlyOwner
    {
        require(bytes(shader_code).length <= 256, "Shader code is larger than 256 characters");
        uint256 nftTokenID = _tokenIds.current();
        _mint(recipient, nftTokenID);
        shader_codes[nftTokenID] = shader_code;
        shader_codes_encoded[nftTokenID] = shader_code_encoded;
        shader_modes[nftTokenID] = shader_mode;
        _tokenIds.increment();
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(_exists(_tokenId), "Token does not exist");
        return
            string(
                abi.encodePacked(
                    'data:application/json;utf8,{"name":"',
                    uint2str(_tokenId),
                    '","description":"',
                    shader_codes[_tokenId],
                    '","animation_url":"',
                    animationURL(_tokenId),
                    '","external_url":"',
                    externalURL(_tokenId),
                    '","image_data":"',
                    svgImg(_tokenId),
                    '"}'
                )
            );
    }

    function animationURL(uint256 _tokenId) internal view returns (string memory){
        string memory code_encoded = shader_codes_encoded[_tokenId];
        string memory mode_str = uint2str(shader_modes[_tokenId]);
        return string(abi.encodePacked(viewer,"?ol=true&mode=",mode_str,"&source=",code_encoded));
    }

    function externalURL(uint256 _tokenId) internal view returns (string memory){
        string memory code_encoded = shader_codes_encoded[_tokenId];
        string memory mode_str = uint2str(shader_modes[_tokenId]);
        return string(abi.encodePacked(viewer,"?preview=true&mode=",mode_str,"&source=",code_encoded));
    }

    function svgImg(uint256 _tokenId) internal view returns (string memory){
        string memory code = shader_codes[_tokenId];
        //need to make an SVG dynamically
        string memory formed_svg = "<svg xmlns='http://www.w3.org/2000/svg' width='512px' height='512px'><rect width='100%' height='100%' fill='black'/>";

        uint256 total_count = bytes(code).length;

        string memory xpos = uint2str(margin);
        for(uint256 row=0; row<16; row++){
            string memory ypos = uint2str(row*char_mult+margin+margin/2);
            string memory characters;
            uint256 count;
            string memory text;
            if(total_count > chars_per_row){
                total_count = total_count - chars_per_row;
                characters = substring(code, row*chars_per_row, (row+1)*chars_per_row+1);
                count = chars_per_row;
                text = string(abi.encodePacked("<text x='",xpos,"' y='",ypos,"' font-size='25' dominant-baseline='middle' text-anchor='left' textLength='",uint2str(char_mult*count),"' lengthAdjust='spacingAndGlyphs' fill='white'>", characters, "</text>"));
                formed_svg = append(formed_svg, text);
            } else if(total_count > 0) {
                count = total_count;
                characters = substring(code, row*chars_per_row, row*chars_per_row+count);
                text = string(abi.encodePacked("<text x='",xpos,"' y='",ypos,"' font-size='25' dominant-baseline='middle' text-anchor='left' textLength='",uint2str(char_mult*count),"' lengthAdjust='spacingAndGlyphs' fill='white'>", characters, "</text>"));
                formed_svg = append(formed_svg, text);
                break;
            }
        } 

        return append(formed_svg, "</svg>");
    }

    function append(string memory a, string memory b) internal pure returns (string memory){
        return string(abi.encodePacked(a, b));
    }

    function substring(string memory str, uint256 startIndex, uint256 endIndex) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex-startIndex);
        for(uint i = startIndex; i < endIndex; i++) {
            result[i-startIndex] = strBytes[i];
        }
        return string(result);
    }

    function uint2str(uint256 _i)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

}

