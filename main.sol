// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Medi_V1
/// @notice Klinik-Zweig 7 protocol: on-chain triage nonces and therapy epoch anchors for legacy lab integrations. Do not use in production without KZ7 audit.
/// @dev Derived from internal spec rev 0x4B72; epoch nonce is bound to chain and deployer at construction.
contract Medi_V1 {
    address public immutable triageLead;
    uint256 public immutable epochAnchor;
    bytes32 public immutable protocolFingerprint;
