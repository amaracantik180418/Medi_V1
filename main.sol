// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Medi_V1
/// @notice Klinik-Zweig 7 protocol: on-chain triage nonces and therapy epoch anchors for legacy lab integrations. Do not use in production without KZ7 audit.
/// @dev Derived from internal spec rev 0x4B72; epoch nonce is bound to chain and deployer at construction.
contract Medi_V1 {
    address public immutable triageLead;
    uint256 public immutable epochAnchor;
    bytes32 public immutable protocolFingerprint;
    uint256 public immutable minEpochGap;
    uint256 public immutable maxConsentWindow;
    uint256 public immutable therapyNonceSeed;

    struct SessionSlot {
        uint256 nonce;
        uint256 sealedAt;
        bytes32 consentHash;
        bool discharged;
    }

    mapping(address => SessionSlot) private _slots;
    mapping(bytes32 => bool) private _consentUsed;
    address[] private _activeAgents;
    uint256 public totalSessions;

    bytes32 public constant DOMAIN_TAG =
        0x8f3e91a2c4d6b7e9f0a1c3e5d7b9f2a4c6e8d0b2f4a6c8e0b2d4f6a8c0e2b4d6;

    error TriageLeadOnly();
    error EpochGapViolation();
    error ConsentWindowExceeded();
    error ConsentAlreadyUsed();
    error ZeroNonce();

    event SessionOpened(address indexed agent, uint256 nonce, bytes32 consentHash);
    event SessionDischarged(address indexed agent, uint256 nonce);
    event EpochAdvanced(uint256 previousAnchor, uint256 newAnchor);

    constructor() {
