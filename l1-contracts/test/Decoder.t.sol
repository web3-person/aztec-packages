// SPDX-License-Identifier: Apache-2.0
// Copyright 2023 Aztec Labs.
pragma solidity >=0.8.18;

import {Test} from "forge-std/Test.sol";

import {Decoder} from "@aztec/core/Decoder.sol";
import {Constants} from "@aztec/core/libraries/Constants.sol";
import {DecoderHelper} from "./DecoderHelper.sol";

/**
 * Blocks are generated using the `integration_l1_publisher.test.ts` tests.
 * Main use of these test is shorter cycles when updating the decoder contract.
 */
contract DecoderTest is Test {
  DecoderHelper internal helper;

  bytes internal block_empty_1 =
    hex"000000010668938c4a4167faa2b5031e427d74d6e38638d2eef68834b70480c5a93f8e15000000002d39729fd006096882acfbd350c91fd61883578b4fe35b63cdce3c1993a497ea000000082f8dc86ba80d8fcf491fb7a255f4163e4f9601d022ba0be35f13297531073fd80000000019c36f7bc2e4116d082865cc0b4ac8e16e9efa00ace9fb2222dd1dfd719cb671000000012b36b22912aa963f143c490227bd21e7a44338026b2f6a389cb98e82167c3718000000012b72136df9bc7dc9cbfe6b84ec743e8e1d73dd93aecfa79f18afb86be977d3eb0668938c4a4167faa2b5031e427d74d6e38638d2eef68834b70480c5a93f8e150000000019c36f7bc2e4116d082865cc0b4ac8e16e9efa00ace9fb2222dd1dfd719cb671000000010668938c4a4167faa2b5031e427d74d6e38638d2eef68834b70480c5a93f8e15000000102d39729fd006096882acfbd350c91fd61883578b4fe35b63cdce3c1993a497ea000000182f8dc86ba80d8fcf491fb7a255f4163e4f9601d022ba0be35f13297531073fd800000004238b20b7bc1d5190f8e928eb2aa2094412588f9cad6c7862f69c09a9b246d6ed0000000225d4ca531bca7d097a93bc47d7aa2c4dbcc8d0d5ecf4138849104e363eb52c03000000022b72136df9bc7dc9cbfe6b84ec743e8e1d73dd93aecfa79f18afb86be977d3eb0668938c4a4167faa2b5031e427d74d6e38638d2eef68834b70480c5a93f8e1500000010238b20b7bc1d5190f8e928eb2aa2094412588f9cad6c7862f69c09a9b246d6ed000000020000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

  bytes internal block_mixed_1 =
    hex"000000010668938c4a4167faa2b5031e427d74d6e38638d2eef68834b70480c5a93f8e15000000002d39729fd006096882acfbd350c91fd61883578b4fe35b63cdce3c1993a497ea000000082f8dc86ba80d8fcf491fb7a255f4163e4f9601d022ba0be35f13297531073fd80000000019c36f7bc2e4116d082865cc0b4ac8e16e9efa00ace9fb2222dd1dfd719cb671000000012b36b22912aa963f143c490227bd21e7a44338026b2f6a389cb98e82167c3718000000012b72136df9bc7dc9cbfe6b84ec743e8e1d73dd93aecfa79f18afb86be977d3eb0668938c4a4167faa2b5031e427d74d6e38638d2eef68834b70480c5a93f8e150000000019c36f7bc2e4116d082865cc0b4ac8e16e9efa00ace9fb2222dd1dfd719cb671000000010813349a787d3f13ec3492de8b6a5c06ba871cb7d2533b8859f3c4069338450100000010069dae963409c321ded6da153196448d64875d356f0ed54bfcf4ba554d6519ba00000018279f38b90665ef7dae8a59f015029274d7837545f62f1f00ab64ffb714d043e90000000412e58befb4676abe3a279ec129e4d48b53eb1b1724a6c01274b39f6122dfc0bf00000002128683784c66165b4b7acf1502ee0f2ed6e5e614f9992375e5f98b1566f2d20a000000022d9b8d2353587ca56bdf967b4bb8847af3671bd6901e9e28f82c240c6e33129a2be9dc687a1bbe5b10ecac6869ca85a46d9c9afe064f55d2e8e237ba01f4faa3000000101a3cc59d6b87c8046f558f7c16e2880c120ad353f83c20c604fdb34458b15a5100000002000000100000000000000000000000000000000000000000000000000000000000000120000000000000000000000000000000000000000000000000000000000000012100000000000000000000000000000000000000000000000000000000000001220000000000000000000000000000000000000000000000000000000000000123000000000000000000000000000000000000000000000000000000000000014000000000000000000000000000000000000000000000000000000000000001410000000000000000000000000000000000000000000000000000000000000142000000000000000000000000000000000000000000000000000000000000014300000000000000000000000000000000000000000000000000000000000001600000000000000000000000000000000000000000000000000000000000000161000000000000000000000000000000000000000000000000000000000000016200000000000000000000000000000000000000000000000000000000000001630000000000000000000000000000000000000000000000000000000000000180000000000000000000000000000000000000000000000000000000000000018100000000000000000000000000000000000000000000000000000000000001820000000000000000000000000000000000000000000000000000000000000183000000100000000000000000000000000000000000000000000000000000000000000220000000000000000000000000000000000000000000000000000000000000022100000000000000000000000000000000000000000000000000000000000002220000000000000000000000000000000000000000000000000000000000000223000000000000000000000000000000000000000000000000000000000000024000000000000000000000000000000000000000000000000000000000000002410000000000000000000000000000000000000000000000000000000000000242000000000000000000000000000000000000000000000000000000000000024300000000000000000000000000000000000000000000000000000000000002600000000000000000000000000000000000000000000000000000000000000261000000000000000000000000000000000000000000000000000000000000026200000000000000000000000000000000000000000000000000000000000002630000000000000000000000000000000000000000000000000000000000000280000000000000000000000000000000000000000000000000000000000000028100000000000000000000000000000000000000000000000000000000000002820000000000000000000000000000000000000000000000000000000000000283000000100000000000000000000000000000000000000000000000000000000000000520000000000000000000000000000000000000000000000000000000000000052a0000000000000000000000000000000000000000000000000000000000000521000000000000000000000000000000000000000000000000000000000000052b0000000000000000000000000000000000000000000000000000000000000522000000000000000000000000000000000000000000000000000000000000052c0000000000000000000000000000000000000000000000000000000000000523000000000000000000000000000000000000000000000000000000000000052d0000000000000000000000000000000000000000000000000000000000000540000000000000000000000000000000000000000000000000000000000000054a0000000000000000000000000000000000000000000000000000000000000541000000000000000000000000000000000000000000000000000000000000054b0000000000000000000000000000000000000000000000000000000000000542000000000000000000000000000000000000000000000000000000000000054c0000000000000000000000000000000000000000000000000000000000000543000000000000000000000000000000000000000000000000000000000000054d0000000000000000000000000000000000000000000000000000000000000560000000000000000000000000000000000000000000000000000000000000056a0000000000000000000000000000000000000000000000000000000000000561000000000000000000000000000000000000000000000000000000000000056b0000000000000000000000000000000000000000000000000000000000000562000000000000000000000000000000000000000000000000000000000000056c0000000000000000000000000000000000000000000000000000000000000563000000000000000000000000000000000000000000000000000000000000056d0000000000000000000000000000000000000000000000000000000000000580000000000000000000000000000000000000000000000000000000000000058a0000000000000000000000000000000000000000000000000000000000000581000000000000000000000000000000000000000000000000000000000000058b0000000000000000000000000000000000000000000000000000000000000582000000000000000000000000000000000000000000000000000000000000058c0000000000000000000000000000000000000000000000000000000000000583000000000000000000000000000000000000000000000000000000000000058d00000008000000000000000000000000000000000000000000000000000000000000032000000000000000000000000000000000000000000000000000000000000003210000000000000000000000000000000000000000000000000000000000000340000000000000000000000000000000000000000000000000000000000000034100000000000000000000000000000000000000000000000000000000000003600000000000000000000000000000000000000000000000000000000000000361000000000000000000000000000000000000000000000000000000000000038000000000000000000000000000000000000000000000000000000000000003810000000426fcb9639d15aabe6d792e23ab12fb9633046d4be6911a60d64471d7560d3f6809143b7d4943a3485115d37e7596938a16c91b6055f3837640d8c36b8303bb3c06fb5fb553496e5e0b48834087e036acf99d6d935dc2ebf43c82788cb5ed1c6a2f4bd77ac2bb5474d48c2856135d18168cd6f69f77143c60b3cc370319419dac0000000000000000000000000000000000000000000000000000000000001020212121212121212121212121212121212121212100000000000000000000000000000000000000000000000000000000000010404141414141414141414141414141414141414141000000000000000000000000000000000000000000000000000000000000106061616161616161616161616161616161616161610000000000000000000000000000000000000000000000000000000000001080818181818181818181818181818181818181818100000010000000000000000000000000000000000000000000000000000000000000040100000000000000000000000000000000000000000000000000000000000004020000000000000000000000000000000000000000000000000000000000000403000000000000000000000000000000000000000000000000000000000000040400000000000000000000000000000000000000000000000000000000000004050000000000000000000000000000000000000000000000000000000000000406000000000000000000000000000000000000000000000000000000000000040700000000000000000000000000000000000000000000000000000000000004080000000000000000000000000000000000000000000000000000000000000409000000000000000000000000000000000000000000000000000000000000040a000000000000000000000000000000000000000000000000000000000000040b000000000000000000000000000000000000000000000000000000000000040c000000000000000000000000000000000000000000000000000000000000040d000000000000000000000000000000000000000000000000000000000000040e000000000000000000000000000000000000000000000000000000000000040f0000000000000000000000000000000000000000000000000000000000000410";

  function setUp() public virtual {
    helper = new DecoderHelper();
  }

  function testEmptyBlock() public virtual {
    (bytes32 diffRoot, bytes32 l1ToL2MessagesHash) =
      helper.computeDiffRootAndMessagesHash(block_empty_1);
    assertEq(
      diffRoot,
      0xe861f905de96ae1d3fcec548d838e11aac2a74fccd23a7950689a46200f875ed,
      "Invalid diff root"
    );

    assertEq(
      l1ToL2MessagesHash,
      0x076a27c79e5ace2a3d47f9dd2e83e4ff6ea8872b3c2218f66c92b89b55f36560,
      "Invalid messages hash"
    );

    (
      uint256 l2BlockNumber,
      bytes32 startStateHash,
      bytes32 endStateHash,
      bytes32 publicInputsHash,
      bytes32[] memory l2ToL1Msgs,
      bytes32[] memory l1ToL2Msgs
    ) = helper.decode(block_empty_1);

    assertEq(l2BlockNumber, 1, "Invalid block number");
    assertEq(
      startStateHash,
      0x2d5d49acd86a4ce5d71f632bd8c39d61d12c7be4ad4ab1f17e134e55aa4e29c2,
      "Invalid start state hash"
    );
    assertEq(
      endStateHash,
      0x3dff2c815f7e5f5b8b3a2397347cc928001c73e5442d6dad5af61c3329b4fc8c,
      "Invalid end state hash"
    );
    assertEq(
      publicInputsHash,
      0x2c6390588e4d61282f591e92758e46770196d0fe7fe873285a52a540455eb001,
      "Invalid public input hash"
    );

    for (uint256 i = 0; i < l2ToL1Msgs.length; i++) {
      assertEq(l2ToL1Msgs[i], bytes32(0), "Invalid l2ToL1Msgs");
    }
    for (uint256 i = 0; i < l1ToL2Msgs.length; i++) {
      assertEq(l1ToL2Msgs[i], bytes32(0), "Invalid l1ToL2Msgs");
    }
  }

  function testMixBlock() public virtual {
    (bytes32 diffRoot, bytes32 l1ToL2MessagesHash) =
      helper.computeDiffRootAndMessagesHash(block_mixed_1);
    assertEq(
      diffRoot,
      0xc2ff90c3a27cbc7a6708919ca24ac2c073af629439ac8a356722f6f93c210fcc,
      "Invalid diff root"
    );

    assertEq(
      l1ToL2MessagesHash,
      0x8aa5c6281fed753c0154da77a3a71f875962b64c12b1d1e28e22b23a32069178,
      "Invalid messages hash"
    );

    (
      uint256 l2BlockNumber,
      bytes32 startStateHash,
      bytes32 endStateHash,
      bytes32 publicInputsHash,
      bytes32[] memory l2ToL1Msgs,
      bytes32[] memory l1ToL2Msgs
    ) = helper.decode(block_mixed_1);

    assertEq(l2BlockNumber, 1, "Invalid block number");
    assertEq(
      startStateHash,
      0x2d5d49acd86a4ce5d71f632bd8c39d61d12c7be4ad4ab1f17e134e55aa4e29c2,
      "Invalid start state hash"
    );
    assertEq(
      endStateHash,
      0x1feaf0c58ed1deb655c6e6762d329f381277e66bd703652b648963ffc8beea8f,
      "Invalid end state hash"
    );
    assertEq(
      publicInputsHash,
      0x2bc18700305b59209fa7180fdb2aea9e1ad19f98e08acb45b8a6318ddf3d3282,
      "Invalid public input hash"
    );

    for (uint256 i = 0; i < l2ToL1Msgs.length; i++) {
      // recreate the value generated by `integration_l1_publisher.test.ts`.
      bytes32 expectedValue = bytes32(uint256(0x300 + 32 * (1 + i / 2) + i % 2));
      assertEq(l2ToL1Msgs[i], expectedValue, "Invalid l2ToL1Msgs");
    }
    for (uint256 i = 0; i < l1ToL2Msgs.length; i++) {
      assertEq(l1ToL2Msgs[i], bytes32(uint256(0x401 + i)), "Invalid l1ToL2Msgs");
    }
  }

  function testComputeKernelLogsHashNoLogs() public {
    bytes memory emptyKernelData = hex"00000000"; // 4 empty bytes indicating that length of kernel logs is 0

    (bytes32 logsHash, uint256 bytesAdvanced) = helper.computeKernelLogsHash(emptyKernelData);

    assertEq(bytesAdvanced, emptyKernelData.length, "Advanced by an incorrect number of bytes");
    assertEq(logsHash, bytes32(0), "Logs hash should be 0 when there are no logs");
  }

  function testComputeKernelLogs1Iteration() public {
    // || K_LOGS_LEN | I1_LOGS_LEN | I1_LOGS ||
    // K_LOGS_LEN = 4 + 8 = 12 (hex"0000000c")
    // I1_LOGS_LEN = 8 (hex"00000008")
    // I1_LOGS = 8 random bytes (hex"aafdc7aa93e78a70")
    bytes memory emptyKernelData = hex"0000000c00000008aafdc7aa93e78a70";
    (bytes32 logsHash, uint256 bytesAdvanced) = helper.computeKernelLogsHash(emptyKernelData);

    // Note: First 32 bytes are 0 because those correspond to the hash of previous iteration and there was no previous
    //       iteration.
    bytes32 referenceLogsHash = bytes32(
      uint256(
        sha256(
          hex"0000000000000000000000000000000000000000000000000000000000000000aafdc7aa93e78a70"
        )
      ) % Constants.P
    );

    assertEq(bytesAdvanced, emptyKernelData.length, "Advanced by an incorrect number of bytes");
    assertEq(logsHash, referenceLogsHash, "Logs hash should be 0 when there are no logs");
  }

  function testComputeKernelLogs2Iterations() public {
    // || K_LOGS_LEN | I1_LOGS_LEN | I1_LOGS | I2_LOGS_LEN | I2_LOGS ||
    // K_LOGS_LEN = 4 + 8 + 4 + 20 = 36 (hex"00000024")
    // I1_LOGS_LEN = 8 (hex"00000008")
    // I1_LOGS = 8 random bytes (hex"aafdc7aa93e78a70")
    // I2_LOGS_LEN = 20 (hex"00000014")
    // I2_LOGS = 20 random bytes (hex"97aee30906a86173c86c6d3f108eefc36e7fb014")
    bytes memory emptyKernelData =
      hex"0000002400000008aafdc7aa93e78a700000001497aee30906a86173c86c6d3f108eefc36e7fb014";
    (bytes32 logsHash, uint256 bytesAdvanced) = helper.computeKernelLogsHash(emptyKernelData);

    bytes32 referenceLogsHashFromIteration1 = bytes32(
      uint256(
        sha256(
          hex"0000000000000000000000000000000000000000000000000000000000000000aafdc7aa93e78a70"
        )
      ) % Constants.P
    );

    bytes32 referenceLogsHashFromIteration2 = bytes32(
      uint256(
        sha256(
          bytes.concat(
            referenceLogsHashFromIteration1, hex"97aee30906a86173c86c6d3f108eefc36e7fb014"
          )
        )
      ) % Constants.P
    );

    assertEq(bytesAdvanced, emptyKernelData.length, "Advanced by an incorrect number of bytes");
    assertEq(
      logsHash, referenceLogsHashFromIteration2, "Logs hash should be 0 when there are no logs"
    );
  }
}
