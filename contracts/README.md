# CertiGuard Contract

CertiGuard is a Solidity smart contract that provides functionality for creating and managing certificates using the ERC-721 token standard. This contract also incorporates features for certificate verification and encryption using the TFHE library.

## Table of Contents

- [Certificate Structure](#certificate-structure)
- [Events](#events)
- [Contract Overview](#contract-overview)
- [Functions](#functions)
  - [Constructor](#constructor)
  - [setPrivateKey](#setprivatekey)
  - [createCertificate](#createcertificate)
  - [getKeyDebug](#getkeydebug)
  - [getKey](#getkey)
  - [getKeyWithChallenge](#getkeywithchallenge)
  - [verifyCertificate](#verifycertificate)
  - [isCertificateVerified](#iscertificateverified)

## Certificate Structure

The CertiGuard contract manages certificates through the following structure:

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

## Events

CertiGuard emits the following events:

- `CertificateCreated(uint256 indexed id, string name, address indexed owner)`: Triggered when a new certificate is created.
- `CertificateVerified(uint256 indexed id)`: Triggered when a certificate is verified.

## Contract Overview

CertiGuard is an ERC-721 compliant contract that extends the functionality of ERC-721 with additional features. It includes the ability to create, verify, and manage certificates. The contract also integrates the TFHE library for encryption purposes.

## Functions

### Constructor

```solidity
constructor(
    string memory name,
    string memory symbol,
    string memory baseTokenURI,
    bytes32 adminPublicKey
) ERC721(name, symbol)
```

- Initializes the contract with the specified `name`, `symbol`, `baseTokenURI`, and `adminPublicKey`.

### setPrivateKey

```solidity
function setPrivateKey(bytes calldata k1) external
```

- Sets the private key for encryption using the provided bytes array `k1`.

### createCertificate

```solidity
function createCertificate(string memory _name) public
```

- Creates a new certificate with the given `_name`.
- Increments the `certificateCount` and stores the certificate information.
- Emits a `CertificateCreated` event.

### getKeyDebug

```solidity
function getKeyDebug(bytes32 publicKey) public view returns (bytes memory)
```

- Retrieves the private key for debugging purposes using the provided `publicKey`.
- Uses the TFHE library for reencryption.

### getKey

```solidity
function getKey() public view returns (bytes memory)
```

- Retrieves the private key reencrypted with the admin key.
- Returns the reencrypted private key bytes.

### getKeyWithChallenge

```solidity
function getKeyWithChallenge(bytes calldata challenge) public view returns (bytes memory)
```

- Retrieves the private key reencrypted with a challenge using the provided `challenge` bytes.
- Uses the TFHE library for reencryption.
- Returns the reencrypted private key bytes.

### verifyCertificate

```solidity
function verifyCertificate(uint256 _id) public
```

- Verifies a certificate with the given `_id`.
- Requires the caller to be the owner of the certificate.
- Marks the certificate as verified and emits a `CertificateVerified` event.

### isCertificateVerified

```solidity
function isCertificateVerified(uint256 _id) public view returns (bool)
```

- Checks whether a certificate with the given `_id` is verified.
- Returns a boolean indicating the verification status of the certificate.
