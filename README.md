# CertiFy - Secure Certificate Management on the Blockchain

CertiFy is a Solidity smart contract designed to manage and verify certificates using the ERC-721 token standard. This contract provides a secure and decentralized solution for creating, verifying, and managing certificates on the Ethereum blockchain. In addition, CertiFy integrates Lit Action for encryption and decryption, ensuring the privacy and security of sensitive certificate information.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Usage](#usage)
- [Contract Details](#contract-details)
  - [Certificate Structure](#certificate-structure)
  - [Events](#events)
  - [Functions](#functions)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)
- [License](#license)

## Overview

CertiFy addresses the need for a reliable and tamper-resistant method of managing certificates, such as academic credentials, professional certifications, and more. By utilizing the Ethereum blockchain and the ERC-721 standard, CertiFy ensures the uniqueness and ownership of each certificate token, preventing unauthorized modifications.

The integration of Lit Action for encryption and decryption allows sensitive certificate information to be stored securely while enabling authorized parties to access and verify certificates when necessary.

## Features

- **Certificate Creation**: Easily create new certificates by providing relevant information such as the name of the certificate holder.

- **Certificate Verification**: Certificates can be verified by authorized parties, providing transparency and trust in the authenticity of the certificates.

- **Encryption and Decryption**: Sensitive information is encrypted and decrypted using Lit Action, ensuring privacy and security while enabling controlled access.

- **ERC-721 Standard**: CertiFy implements the ERC-721 token standard, ensuring the uniqueness and ownership of each certificate token.

- **Event Emission**: The contract emits events for certificate creation and verification, facilitating transparency and real-time monitoring.

## Getting Started

### Prerequisites

- Ethereum Development Environment (e.g., Remix, Truffle)
- Solidity Compiler (0.8.13 to 0.9.0)
- OpenZeppelin Contracts and Libraries
- Lit Action for Encrypt and Decrypt
- Filecoin Testnet Blockchain
- Chainlink CCIP (Cross-Chain Interoperability Protocol)

### Installation

1. Clone the CertiFy repository.
2. Install the required dependencies, including OpenZeppelin contracts, Lit Action for encryption and decryption, and any necessary tools for interacting with Filecoin Testnet and Chainlink CCIP.
3. Compile the CertiFy contract using a Solidity compiler compatible with the specified version range.
4. Deploy the contract on an Ethereum testnet or mainnet.

### Usage

Once deployed, the CertiFy contract can be interacted with using Ethereum wallet software, DApp browsers, or custom user interfaces. The contract provides functions to create certificates, verify certificates, retrieve encrypted keys, and utilize Lit Action for encryption and decryption.

Refer to the [Contract Details](#contract-details) section for information on available functions and their usage.

## Contract Details

### Certificate Structure

The contract utilizes the following structure to store certificate information:

```solidity
struct Certificate {
    uint256 id;
    string name;
    address owner;
    bool isVerified;
}
```

- `id`: Unique identifier for the certificate.
- `name`: Name associated with the certificate.
- `owner`: Ethereum address of the certificate owner.
- `isVerified`: Boolean indicating whether the certificate is verified.

### Events

CertiFy emits the following events:

- `CertificateCreated(uint256 indexed id, string name, address indexed owner)`: Triggered when a new certificate is created.
- `CertificateVerified(uint256 indexed id)`: Triggered when a certificate is verified.

### Functions

The contract provides several functions for certificate management, verification, and key retrieval. Refer to the source code and function descriptions for more details.

## Security Considerations

When dealing with sensitive information and cryptographic operations, it's crucial to follow security best practices. Carefully review the codebase for vulnerabilities and engage security experts if needed.

## Contributing

Contributions to CertiFy are welcome! If you find issues, want to add features, or improve the project, feel free to submit a pull request. Please adhere to the project's code of conduct and best practices.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
