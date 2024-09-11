pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import {
    ISuperfluid,
    ISuperToken
} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {SuperToken} from "@superfluid-finance/ethereum-contracts/contracts/superfluid/SuperToken.sol";
import {
    TestGovernance,
    Superfluid,
    ConstantFlowAgreementV1,
    CFAv1Library,
    SuperTokenFactory
} from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeploymentSteps.sol";
import {SuperfluidFrameworkDeployer} from
    "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeployer.sol";
import {SuperTokenV1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {FlowSender} from "src/FlowSender.sol";

interface IFakeDAI is IERC20 {
    function mint(address account, uint256 amount) external;
}

contract FlowSenderTest is Test {
    // Test contract instance
    FlowSender flowSender;
    // BaseSepolia fork parameters
    uint256 baseSepoliaFork;
    // Set up your environment variables and include BASE_SEPOLIA_RPC_URL
    string BASE_SEPOLIA_RPC_URL = vm.envString("BASE_SEPOLIA_RPC_URL");
    ISuperToken internal i_daix;

    // Setup function to initialize test environment
    function setUp() public {
        //Forking and selecting the BaseSepolia testnet
        baseSepoliaFork = vm.createSelectFork(BASE_SEPOLIA_RPC_URL);

        // Pointing to the fake Daix contract on Base Sepolia
        // For token and protocol addresses on all networks, check out the Superfluid console: https://console.superfluid.finance/
        i_daix = ISuperToken(0x7635356D54d8aF3984a5734C2bE9e25e9aBC2ebC);

        // Deploy the contract
        vm.prank(address(0x123)); // Simulate a different caller
        flowSender = new FlowSender(i_daix);

        // Add other functions and test contracts...
    }

    function testGainDaiX() public {
        // Setup: Deploy the FlowSender contract
        IFakeDAI fdai = IFakeDAI(i_daix.getUnderlyingToken());
        // ISuperToken daix = new SuperToken(address(fdai));

        // Action: Call the gainDaiX function
        flowSender.gainDaiX();

        // Assertions: Check if the contract has the expected amount of DAIx
        uint256 balance = i_daix.balanceOf(address(flowSender));
        assertEq(balance, 10000e18, "The balance of DAIx should be 10,000 after gainDaiX");
    }

    // function testCreateStream() public {
    //     // Setup: Deploy the FlowSender contract and create a receiver address
    //     IFakeDAI fdai = IFakeDAI(i_daix.getUnderlyingToken());
    //     // ISuperToken daix = new SuperToken(address(fdai));
    //     address receiver = address(makeAddr("receiver"));

    //     // Setup: Define a flow rate
    //     int96 flowRate = 1000; // Example flow rate

    //     // Action: Call the createStream function
    //     flowSender.createStream(flowRate, receiver);

    //     // Assertions: Verify if the stream is created with correct parameters
    //     (, int96 outFlowRate,,) = i_daix.getFlow(address(flowSender), receiver);
    //     assertEq(outFlowRate, flowRate, "The flow rate should match the specified rate");
    // }

    // function testDeleteStream() public {
    //     // Setup: Deploy the FlowSender contract and create a receiver address
    //     IFakeDAI fdai = IFakeDAI(i_daix.getUnderlyingToken());
    //     // ISuperToken daix = new SuperToken(address(fdai));
    //     address receiver = address(makeAddr("receiver"));

    //     // Setup: Create a stream first
    //     flowSender.createStream(1000, receiver);

    //     // Use cheat codes to simulate different account permissions
    //     // Attempt to delete a stream with an unauthorized user
    //     vm.prank(address(0x123)); // Simulate a different caller
    //     vm.expectRevert("Unauthorized"); // Expect a revert due to unauthorized access
    //     flowSender.deleteStream(receiver);

    //     // Action: Attempt to delete a stream with the correct permission
    //     flowSender.deleteStream(receiver);

    //     // Assertions: Verify the stream is deleted
    //     (, int96 outFlowRate,,) = i_daix.getFlow(address(flowSender), receiver);
    //     assertEq(outFlowRate, 0, "The flow rate should be zero after deletion");
    // }
}
