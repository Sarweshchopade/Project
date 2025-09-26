// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ProjectRegistry is ERC721, AccessControl {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    bytes32 public constant ADMIN_ROLE = DEFAULT_ADMIN_ROLE;
    bytes32 public constant NGO_ROLE = keccak256("NGO_ROLE");
    bytes32 public constant VERIFIER_ROLE = keccak256("VERIFIER_ROLE");

    struct Project {
        string location;
        uint256 size;
        string species;
        uint256 createdAt;
        bool verified;
    }

    mapping(uint256 => Project) public projects;
    mapping(uint256 => uint256) public linkedCarbonTokenId;
    mapping(uint256 => uint256) public totalCreditsLinked;

    event ProjectMinted(uint256 indexed projectId, address indexed owner);
    event VerificationStatusUpdated(uint256 indexed projectId, bool verified);
    event CarbonCreditsLinked(uint256 indexed projectId, uint256 indexed creditTokenId, uint256 amount);

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {
        _setupRole(ADMIN_ROLE, msg.sender);
    }

    function mintProject(
        address to,
        string calldata location,
        uint256 size,
        string calldata species
    ) external onlyRole(NGO_ROLE) returns (uint256) {
        _tokenIds.increment();
        uint256 id = _tokenIds.current();

        projects[id] = Project({
            location: location,
            size: size,
            species: species,
            createdAt: block.timestamp,
            verified: false
        });

        _safeMint(to, id);
        emit ProjectMinted(id, to);
        return id;
    }

    function updateVerificationStatus(uint256 projectId, bool verified) external onlyRole(VERIFIER_ROLE) {
        require(_exists(projectId), "Project does not exist");
        projects[projectId].verified = verified;
        emit VerificationStatusUpdated(projectId, verified);
    }

    function linkCarbonCredits(uint256 projectId, uint256 creditTokenId, uint256 amount) external onlyRole(VERIFIER_ROLE) {
        require(_exists(projectId), "Project does not exist");
        linkedCarbonTokenId[projectId] = creditTokenId;
        totalCreditsLinked[projectId] += amount;
        emit CarbonCreditsLinked(projectId, creditTokenId, amount);
    }

    // Resolve multiple inheritance clash: explicitly override supportsInterface from ERC721 and AccessControl
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}