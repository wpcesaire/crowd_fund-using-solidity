pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Inherited the crowdsale contracts
contract PupperCoinCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {


    constructor(
        // Filled in the constructor parameters!
        uint rate, // rate in PupperCoins
        PupperCoin token,  // name of the token
        address payable wallet, // sale beneficiary
        uint goal, // goal for crowdsale
        uint open,
        uint close
        //uint cap

    )
        
    Crowdsale(rate, wallet, token)
    TimedCrowdsale(now, now + 24 weeks)
    CappedCrowdsale(goal)
    RefundableCrowdsale(goal)
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        public
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;


    constructor(
        // @TODO: Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet, // sale beneficiary
        uint goal
        
        

    )
        public
    {
        // created the PupperCoin and kept its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        // created the PupperCoinSale and told it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinCrowdsale token_sale = new PupperCoinCrowdsale(1, token, wallet, goal, now, now + 24 weeks);
        token_sale_address = address(token_sale);
        

        // made the PupperCoinSale contract a minter, then had the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
