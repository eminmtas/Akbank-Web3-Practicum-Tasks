//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./ERC20.sol";

// Hands on Task (Intermediate Level): Build and Deploy a Crowdfund Application
// Owner: 0xbabacA9617a2cC30bC34A18E5F251F4Bd8CAbfac
// Contract Address: 0x6b917983B7646F2b01F761ebab4ab1F3bd83cA97

contract CrowdFund {
    // Launch a crowdfunding campaign
    event Launch(
        uint id,
        address indexed creator,
        uint goal,
        uint32 startAt,
        uint32 endAt
    );

    // indexed id is the campaign id and indexed caller is the address of the person who pledged
    event Cancel(uint id);
    event Pledge(uint indexed id, address indexed caller, uint amout); 
    event Unpledge(uint indexed id, address indexed caller, uint amout);
    event Claim(uint id);
    event Refund(uint indexed id, address indexed caller, uint amout);

    // A struct that will store all the campaigns' information
    struct Campaign {
        address creator;
        uint256 goal;
        uint pledged;
        uint32 startAt;
        uint32 endAt;
        bool claimed;
    }

    // The token that will be used for the campaign
    IERC20 public immutable token;

    uint public count; // stores the number of campaigns
    // A mapping that will store all the campaigns
    mapping(uint => Campaign) public campaigns;
    // stores the amount of tokens pledged by each user for each campaign
    mapping(uint => mapping(address => uint)) public pledgedAmount; 
    
    // The constructor will take the address of the token that will be used for the campaign
    constructor(address _token) {
        token = IERC20(_token);
    }

    // launch function will create a new campaign
    function launch(uint _goal, uint32 _startAt, uint32 _endAt) external {
        require(_startAt >= block.timestamp, "startAt < now"); // startAt must be greater than or equal to the current time
        require(_endAt >= _startAt, "endAt  < startAt"); // endAt must be greater than or equal to startAt
        require(_endAt <= block.timestamp + 90 days, "endAt > max duration"); // endAt must be less than or equal to 90 days from the current time

        count += 1; // increment the number of campaigns

        // create a new campaign and store it in the campaigns mapping
        campaigns[count] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        }); 

        // emit the Launch event with the campaign's information
        emit Launch(count, msg.sender, _goal, _startAt, _endAt); 

    }
    // cancel function will cancel the campaign
    function cancel(uint _id) external {
        Campaign memory campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "you are not creator");
        require(block.timestamp < campaign.startAt, "campaign has already started");
        delete campaigns[_id];
        emit Cancel(_id);
    }
    // pledge function will allow users to pledge tokens to the campaign
    function pledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp >= campaign.startAt, "campaign not started");
        require(block.timestamp <= campaign.endAt, "campaign ended");
        
        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);

        emit Pledge(_id, msg.sender, _amount);
    }
    // unpledge function will allow users to unpledge tokens from the campaign
    function unpledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp <= campaign.endAt, "campaign ended");

        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);

        emit Unpledge(_id, msg.sender, _amount);
    } 
    // claim function will allow the creator to claim the tokens if the goal is reached
    function claim(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "not creator");
        require(block.timestamp > campaign.endAt, "campaign not ended");
        require(campaign.pledged >= campaign.goal, "not reached goal (pledged < goal)");
        require(!campaign.claimed, "already claimed");

        campaign.claimed = true;
        token.transfer(msg.sender, campaign.pledged);

        emit Claim(_id);
    }
    // refund function will allow users to get their tokens back if the goal is not reached
    function refund(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "campaign not ended");
        require(campaign.pledged < campaign.goal, "reached goal (pledged >= goal)");
        
        uint bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, bal);
        
        emit Refund(_id, msg.sender, bal);
    }

}