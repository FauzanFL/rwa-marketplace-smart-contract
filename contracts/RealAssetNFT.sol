// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RealAssetNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Asset {
        string name;
        string description;
        uint256 price;
        address payable seller;
        bool forSale;
    }

    mapping(uint256 => Asset) public assets;

    constructor() ERC721("RealAsset", "RANFT") {}

    /// @notice Mint NFT dengan data aset nyata
    function mintAsset(string memory name, string memory description, uint256 price) external {
        require(price > 0, "Price must be > 0");

        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _safeMint(msg.sender, newTokenId);

        assets[newTokenId] = Asset({
            name: name,
            description: description,
            price: price,
            seller: payable(msg.sender),
            forSale: true
        });
    }

    /// @notice Fungsi untuk membeli aset
    function buyAsset(uint256 tokenId) external payable {
        Asset memory asset = assets[tokenId];

        require(asset.forSale, "Asset not for sale");
        require(msg.value >= asset.price, "Not enough ETH");

        // Kirim dana ke penjual
        asset.seller.transfer(msg.value);

        // Transfer NFT ke pembeli
        _transfer(asset.seller, msg.sender, tokenId);

        // Update status
        assets[tokenId].forSale = false;
        assets[tokenId].seller = payable(msg.sender);
    }

    /// @notice Ambil detail aset
    function getAsset(uint256 tokenId) external view returns (
        string memory name,
        string memory description,
        uint256 price,
        address seller,
        bool forSale
    ) {
        Asset memory asset = assets[tokenId];
        return (
            asset.name,
            asset.description,
            asset.price,
            asset.seller,
            asset.forSale
        );
    }

    /// @notice Getter untuk total asset minted
    function totalMinted() external view returns (uint256) {
        return _tokenIds.current();
    }

    /// @notice Update harga dan status jual
    function updateListing(uint256 tokenId, uint256 newPrice, bool forSale) external {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        assets[tokenId].price = newPrice;
        assets[tokenId].forSale = forSale;
        assets[tokenId].seller = payable(msg.sender);
    }
}
