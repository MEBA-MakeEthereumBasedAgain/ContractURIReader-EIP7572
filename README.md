# ContractURIReader 🔍

A robust Solidity contract for batch reading and parsing ERC-7572 contractURI implementations. This tool enables efficient metadata retrieval from multiple contracts in a single call, with support for both on-chain and off-chain URI formats.

## 🌟 Features

- **Batch Reading**: Query multiple contracts' metadata in a single transaction
- **On-Chain Data Support**: Automatic detection and parsing of on-chain JSON data
- **Optional Parsing**: Control whether to attempt JSON parsing with a boolean flag
- **Error Handling**: Graceful handling of non-compliant contracts
- **Gas Efficient**: Optimized for minimal gas consumption
- **ERC-7572 Compliant**: Full support for the contractURI standard

## 📋 Contract Metadata Structure

The contract returns comprehensive metadata including:

```solidity
struct ContractMetadata {
address contractAddress; // Contract address
string uri; // Raw URI or on-chain JSON
bool isOnChainData; // On-chain data indicator
bool hasImplementation; // ERC7572 implementation status
// Schema-specific fields
string name; // Required
string symbol; // Optional
string description; // Optional
string image; // Optional
string banner_image; // Optional
string featured_image; // Optional
string external_link; // Optional
address[] collaborators; // Optional
}
```

## 🚀 Usage

### Reading a Single Contract

```solidity
ContractURIReader reader = ContractURIReader(READER_ADDRESS);
// Set shouldParse to true to attempt parsing on-chain JSON data
ContractMetadata memory metadata = reader.readContractURI(CONTRACT_ADDRESS, true);
// Or set to false to skip parsing and save gas
ContractMetadata memory metadata = reader.readContractURI(CONTRACT_ADDRESS, false);
```

### Batch Reading Multiple Contracts

```solidity
address[] memory contracts = new address;
contracts[0] = 0x123...;
contracts[1] = 0x456...;
// Control parsing with the boolean parameter
ContractMetadata[] memory results = reader.batchReadContractURIs(contracts, true);
```

### Error Handling

If a contract does not implement the contractURI function, it will be skipped with a warning.

## 🔧 Technical Details

### URI Format Support

The contract supports two URI formats:
1. **On-chain Data**: URIs starting with `data:application/json;utf8,`
2. **Off-chain Data**: Standard HTTP/IPFS URIs

### Parsing Control

- Set `shouldParse = true` to attempt parsing on-chain JSON data
- Set `shouldParse = false` to skip parsing and save gas
- Parsing is only attempted for on-chain data URIs

### Error Handling

- Non-existent contracts return metadata with `hasImplementation = false`
- Invalid on-chain data format will revert with appropriate error messages
- Graceful handling of contracts without contractURI implementation

## 🔒 Security

- Pure and view functions for gas-efficient reading
- No state modifications
- Protected against common attack vectors
- Comprehensive error handling

## 📜 Interface

The contract implements reading functionality for the ERC-7572 standard:

```solidity
interface IERC7572 {
function contractURI() external view returns (string memory);
event ContractURIUpdated();
}
```

# 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## ⚠️ Important Notes

- The on-chain JSON parser can be enabled/disabled via the `shouldParse` parameter
- Consider using an oracle or off-chain service for parsing large JSON data
- Gas costs may vary depending on the number of contracts being queried and whether parsing is enabled
