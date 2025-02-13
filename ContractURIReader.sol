// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IERC7572 {
    function contractURI() external view returns (string memory);
    event ContractURIUpdated();
}

contract ContractURIReader {
    error ContractURINotImplemented();
    
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
        returns (ContractMetadata[] memory) 
    {
        ContractMetadata[] memory results = new ContractMetadata[](contracts.length);
        
        for (uint i = 0; i < contracts.length; i++) {
            results[i] = readContractURI(contracts[i], shouldParse);
        }
        
        return results;
    }

    /**
     * @notice Reads contractURI from a single contract
     * @param contractAddress The address of the contract to read from
     * @param shouldParse Whether to attempt parsing the JSON data
     * @return metadata ContractMetadata struct containing the results
     */
    function readContractURI(address contractAddress, bool shouldParse) 
        public 
        view 
        returns (ContractMetadata memory metadata) 
    {
        metadata.contractAddress = contractAddress;
        
        try IERC7572(contractAddress).contractURI() returns (string memory uri) {
            metadata.uri = uri;
            metadata.hasImplementation = true;
            metadata.isOnChainData = isOnChainData(uri);
            
            // If it's on-chain data and parsing is requested, we can parse it
            if (metadata.isOnChainData && shouldParse) {
                string memory json = extractJSONFromURI(uri);
                // Note: In practice, you'd need an on-chain JSON parser here
                // The actual parsing is left out as it would be gas-intensive
                // Consider using an oracle or off-chain service for parsing
            }
        } catch {
            metadata.hasImplementation = false;
        }
    }

    /**
     * @notice Checks if the URI is on-chain data
     * @param uri The URI to check
     * @return bool True if the URI contains on-chain data
     */
    function isOnChainData(string memory uri) 
        public 
        pure 
        returns (bool) 
    {
        bytes memory uriBytes = bytes(uri);
        if (uriBytes.length < 29) return false;
        
        // Check if starts with "data:application/json;utf8,"
        return startsWith(uri, "data:application/json;utf8,");
    }

    /**
     * @notice Helper function to check string prefix
     */
    function startsWith(string memory str, string memory prefix) 
        internal 
        pure 
        returns (bool) 
    {
        bytes memory strBytes = bytes(str);
        bytes memory prefixBytes = bytes(prefix);
        
        if (strBytes.length < prefixBytes.length) return false;
        
        for (uint i = 0; i < prefixBytes.length; i++) {
            if (strBytes[i] != prefixBytes[i]) return false;
        }
        
        return true;
    }

    /**
     * @notice Extracts JSON data from on-chain URI
     * @param uri The URI containing the JSON data
     * @return The extracted JSON string
     */
    function extractJSONFromURI(string memory uri) 
        public 
        pure 
        returns (string memory) 
    {
        require(isOnChainData(uri), "URI is not on-chain data");
        
        bytes memory uriBytes = bytes(uri);
        bytes memory jsonBytes = new bytes(uriBytes.length - 29);
        
        for (uint i = 29; i < uriBytes.length; i++) {
            jsonBytes[i - 29] = uriBytes[i];
        }
        
        return string(jsonBytes);
    }
}
