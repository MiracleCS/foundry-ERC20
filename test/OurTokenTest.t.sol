// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 1000 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(address(msg.sender));
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        uint256 bobBalance = ourToken.balanceOf(bob);
        assertEq(bobBalance, STARTING_BALANCE);
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;
        //Bob approves alice to spend 1000 OT on his behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;
        //Alice transfers 500 OT from Bob to herself

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }
    /* ========== Transfers ========== */

    function testTransfer() public {
        uint256 transferAmount = 100 ether;
        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);

        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
    }

    function testTransferToZeroAddressReverts() public {
        vm.prank(bob);
        vm.expectRevert(); // ERC20: transfer to the zero address
        ourToken.transfer(address(0), 1 ether);
    }

    function testTransferExceedsBalanceReverts() public {
        vm.prank(bob);
        vm.expectRevert(); // ERC20: transfer amount exceeds balance
        ourToken.transfer(alice, STARTING_BALANCE + 1);
    }
    /* ========== Allowances ========== */

    function testApprove() public {
        uint256 allowance = 200 ether;
        vm.prank(bob);
        ourToken.approve(alice, allowance);

        assertEq(ourToken.allowance(bob, alice), allowance);
    }

    function testTransferFrom() public {
        uint256 allowance = 500 ether;
        vm.prank(bob);
        ourToken.approve(alice, allowance);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, 300 ether);

        assertEq(ourToken.balanceOf(alice), 300 ether);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - 300 ether);
        assertEq(ourToken.allowance(bob, alice), 200 ether); // allowance decreased
    }

    function testTransferFromWithoutAllowanceReverts() public {
        vm.prank(alice);
        vm.expectRevert(); // ERC20: insufficient allowance
        ourToken.transferFrom(bob, alice, 1 ether);
    }

    function testTransferFromExceedsAllowanceReverts() public {
        vm.prank(bob);
        ourToken.approve(alice, 100 ether);

        vm.prank(alice);
        vm.expectRevert(); // ERC20: insufficient allowance
        ourToken.transferFrom(bob, alice, 101 ether);
    }

    function testTransferFromExceedsBalanceReverts() public {
        // First, reset Bob's balance to 0 (by sending it back to deployer or msg.sender)
        vm.prank(bob);
        ourToken.transfer(address(msg.sender), 200 ether);

        // Now Bob has 800 ether0
        assertEq(ourToken.balanceOf(bob), 800 ether);

        // Bob approves Alice for 100 ether (more than his balance)
        vm.prank(bob);
        ourToken.approve(alice, 900 ether);

        // Alice tries to transfer 60 ether from Bob → should revert (insufficient balance)
        vm.prank(alice);
        vm.expectRevert();
        ourToken.transferFrom(bob, alice, 850 ether);
    }

    function testApproveThenOverwriteAllowance() public {
        vm.prank(bob);
        ourToken.approve(alice, 100 ether);
        assertEq(ourToken.allowance(bob, alice), 100 ether);

        vm.prank(bob);
        ourToken.approve(alice, 200 ether);
        assertEq(ourToken.allowance(bob, alice), 200 ether);
    }

    function testApproveZeroAddressReverts() public {
        vm.prank(bob);
        vm.expectRevert(); // OpenZeppelin's ERC20 doesn't allow approving zero address
        ourToken.approve(address(0), 100 ether);
    }
}
