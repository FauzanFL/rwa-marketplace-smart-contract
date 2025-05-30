// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RealAssetNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Asset {
        uint256 tokenId;
        string name;
        string description;
        uint256 price;
        address payable seller;
        bool forSale;
    }

    uint256[] private _allAssetIds;
    mapping(uint256 => Asset) public assets;

    constructor() ERC721("RealAsset", "RANFT") {}

    /// @notice Mint NFT dengan data aset nyata
    function mintAsset(string memory name, string memory description, uint256 price) external {
        require(price > 0, "Price must be > 0");

        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _safeMint(msg.sender, newTokenId);

        assets[newTokenId] = Asset({
            tokenId: newTokenId,
            name: name,
            description: description,
            price: price,
            seller: payable(msg.sender),
            forSale: true
        });

        _allAssetIds.push(newTokenId);
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

    /// @notice Ambil semua asset
    function getAllAssets() external view returns (Asset[] memory) {
        uint256 total = _allAssetIds.length;
        uint256 count;

        for (uint i = 0; i < total; i++) {
            if (_exists(_allAssetIds[i])) {
                count++;
            }
        }

        Asset[] memory activeAssets = new Asset[](count);
        uint256 index = 0;

        for (uint i = 0; i < total; i++) {
            uint256 tokenId = _allAssetIds[i];
            if (_exists(tokenId)) {
                activeAssets[index] = assets[tokenId];
                index++;
            }
        }

        return activeAssets;
    }

    /// @notice Getter untuk total asset minted
    function totalMinted() external view returns (uint256) {
        return _tokenIds.current();
    }

    /// @notice Burn nft asset
    function burnAsset(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");

        _burn(tokenId);
        delete assets[tokenId];
    }

    /// @notice Update harga dan status jual
    function updateListing(uint256 tokenId, string memory newName, string memory newDescription, uint256 newPrice, bool forSale) external {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        assets[tokenId].price = newPrice;
        assets[tokenId].name = newName;
        assets[tokenId].description = newDescription;
        assets[tokenId].forSale = forSale;
        assets[tokenId].seller = payable(msg.sender);
    }
}
