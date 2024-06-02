// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity >=0.8.13 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";


contract CertiGuard is ERC721, AccessControlEnumerable {
    
    // Structure to hold certificate information
    struct Certificate {
        uint256 id;
        string name;
        address owner;
        bool isVerified;
    }

    // Mapping to store certificates
    mapping(uint256 => Certificate) public certificates;
    uint256 public certificateCount;

    // Events for certificate creation and verification
    event CertificateCreated(uint256 indexed id, string name, address indexed owner);
    event CertificateVerified(uint256 indexed id);
    
    // Base URI for token metadata
    string private _baseTokenURI;
    // Admin key to manage the contract
    bytes32 private _adminKey;
    // Private key used for encryption
    uint32 private _privateKey;
    // Mapping to store keys
    mapping(uint => uint32) internal keys;

    // Chainlink variables
    LinkTokenInterface public immutable LINK;
    address public immutable ORACLE;

    // Chainlink request variables
    bytes32 public immutable JOB_ID;
    uint256 public immutable FEE;

    // Constructor to initialize the contract
    constructor(
        string memory name,
        string memory symbol,
        string memory baseTokenURI,
        bytes32 adminPublicKey,
        address link,
        address oracle,
        bytes32 jobId,
        uint256 fee
    ) ERC721(name, symbol) {
        _baseTokenURI = baseTokenURI;
        _adminKey = adminPublicKey;

        LINK = LinkTokenInterface(link);
        ORACLE = oracle;
        JOB_ID = jobId;
        FEE = fee;
    }

    // Internal function to return the base token URI
    function _baseURI() internal view virtual override(ERC721) returns (string memory) {
        return _baseTokenURI;
    }

    // Function to set the private key
    function setPrivateKey(bytes calldata k1) external {
        _privateKey = _asUint32(k1);
    }

    // Function to create a new certificate
    function createCertificate(string memory _name) public {
        certificateCount++;
        certificates[certificateCount] = Certificate(certificateCount, _name, msg.sender, false);
        emit CertificateCreated(certificateCount, _name, msg.sender);
    }

    // Function to retrieve the private key for debugging
    function getKeyDebug(bytes32 publicKey) public view returns (bytes memory) {
        return _reencrypt(_privateKey, publicKey);
    }

    // Function to retrieve the key
    function getKey() public view returns (bytes memory) {
        return _reencrypt(_privateKey, _adminKey);
    }

    // Function to retrieve the key with a challenge
    function getKeyWithChallenge(bytes calldata challenge) public view returns (bytes memory) {
        uint32 result = _xor(_privateKey, _asUint32(challenge));
        return _reencrypt(result, _adminKey);
    }

    // Function to verify a certificate
    function verifyCertificate(uint256 _id) public {
        require(_id <= certificateCount, "Certificate not found");
        Certificate storage certificate = certificates[_id];
        require(msg.sender == certificate.owner, "Only owner can verify");
        
        certificate.isVerified = true;
        emit CertificateVerified(_id);
    }

    // Function to check if a certificate is verified
    function isCertificateVerified(uint256 _id) public view returns (bool) {
        require(_id <= certificateCount, "Certificate not found");
        return certificates[_id].isVerified;
    }

    // Helper function to convert bytes to uint32
    function _asUint32(bytes calldata x) internal pure returns (uint32) {
        uint32 y;
        assembly {
            y := mload(add(x, 32))
        }
        return y;
    }

    // Helper function to perform XOR operation on uint32
    function _xor(uint32 x, uint32 y) internal pure returns (uint32) {
        return x ^ y;
    }

    // Helper function to reencrypt data
    function _reencrypt(uint32 data, bytes32 publicKey) internal view returns (bytes memory) {
        return _chainlinkReencrypt(data, publicKey);
    }

    // Chainlink function to perform reencryption
    function _chainlinkReencrypt(uint32 data, bytes32 publicKey) internal view returns (bytes memory) {
        bytes memory dataBytes = abi.encode(data);
        (bytes memory result, ) = _requestOracleData(publicKey, dataBytes);
        return result;
    }

    // Chainlink function to request data from the oracle
    function _requestOracleData(bytes32 publicKey, bytes memory data) internal view returns (bytes memory) {
        bytes32 specId = 0;
        return LINK.oracleRequest(ORACLE, FEE, specId, data, publicKey);
    }
}
