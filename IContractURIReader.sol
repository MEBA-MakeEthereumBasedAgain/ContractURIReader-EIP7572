// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IContractURIReader {
    struct ContractMetadata {
        address contractAddress;
        string uri;                // Raw URI or on-chain JSON
        bool isOnChainData;       // Whether data is stored on-chain
        bool hasImplementation;    // Whether contract implements ERC7572
        // Schema-specific fields
        string name;              // Required by schema
        string symbol;            // Optional
        string description;       // Optional
        string image;             // Optional
        string banner_image;      // Optional
        string featured_image;    // Optional
        string external_link;     // Optional
        address[] collaborators;  // Optional
    }

    /**
     * @notice Batch reads contractURI from multiple contracts
     * @param contracts Array of contract addresses to read from
     * @param shouldParse Whether to attempt parsing the JSON data
     * @return ContractMetadata[] Array of metadata for each contract
     */
    function batchReadContractURIs(address[] calldata contracts, bool shouldParse) 
        external 
        view 
        returns (ContractMetadata[] memory);

    /**
     * @notice Reads contractURI from a single contract
     * @param contractAddress The address of the contract to read from
     * @param shouldParse Whether to attempt parsing the JSON data
     * @return metadata ContractMetadata struct containing the results
     */
    function readContractURI(address contractAddress, bool shouldParse) 
        external 
        view 
        returns (ContractMetadata memory metadata);

    /**
     * @notice Checks if the URI is on-chain data
     * @param uri The URI to check
     * @return bool True if the URI contains on-chain data
     */
    function isOnChainData(string memory uri) 
        external 
        pure 
        returns (bool);

    /**
     * @notice Extracts JSON data from on-chain URI
     * @param uri The URI containing the JSON data
     * @return The extracted JSON string
     */
    function extractJSONFromURI(string memory uri) 
        external 
        pure 
        returns (string memory);
}
