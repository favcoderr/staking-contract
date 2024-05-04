## Product Requirements Document (PRD) for Staking Contract

### Overview

The goal of this project is to create a staking contract that allows users to deposit ETH and earn a certain token at an annualized APR of 14%. The contract will automatically convert ETH to WETH and mint receipt tokens to the depositor. Users can opt-in for auto-compounding, which will convert their earned tokens to WETH and stake them back as principal. The contract will charge a 1% fee for auto-compounding, which will be used as a reward for the person who triggers the operation.

### Features

- Accepts ETH deposits and automatically converts them to WETH
- Mints receipt tokens to the depositor based on the proportion of ETH deposited
- Rewards users with a certain token at an APR of 14%
- Allows users to opt-in for auto-compounding at a 1% fee
- Auto-compounding can be triggered by anyone externally
- The person who triggers auto-compounding receives a reward from the total auto-compounding fee of people in the pool
- Withdrawals can be instant or not
- Technical Specifications


**Step 1: Create the Contract**

- Include a constructor that sets the initial values for the contract, such as the name of the token and the APR
- Include a mapping to keep track of the balances of each user
- Include a mapping to keep track of the auto-compounding fee for each user
- Include a mapping to keep track of the time each user last compounded
- Include a mapping to keep track of the time each user last withdrew
- Include a function for depositing ETH and minting receipt tokens
- Include a function for withdrawing tokens and ETH
- Include a function for calculating rewards based on the APR and the amount of time staked
- Include a function for calculating the auto-compounding fee and distributing it to the person who triggered the operation
- Include a function for triggering auto-compounding

**Step 2: Convert ETH to WETH**

- Include a function for converting ETH to WETH using the WETH contract
- Include a mapping to keep track of the WETH balance of the contract

**Step 3: Mint Receipt Tokens**
- Include a function for minting receipt tokens to the depositor based on the proportion of ETH deposited
- Include a mapping to keep track of the receipt token balance of each user

**Step 4: Reward Users with Tokens**

- Include a function for calculating rewards based on the APR and the amount of time staked
- Include a mapping to keep track of the token balance of each user

**Step 5: Opt-In for Auto-Compounding**

- Include a function for opting-in for auto-compounding
- Iharge a 1% fee for auto-compounding
- Include a mapping to keep track of the auto-compounding fee for each user
- Include a mapping to keep track of the time each user last compounded

**Step 6: Trigger Auto-Compounding**

- Include a function for triggering auto-compounding
- The person who triggers auto-compounding receives a reward from the total auto-compounding fee of people in the pool
- Include a function for calculating the auto-compounding fee and distributing it to the person who triggered the operation

**Step 7: Withdraw Tokens and ETH**
- Include a function for withdrawing tokens and ETH
- Include a mapping to keep track of the time each user last withdrew


**Foundry Test**

The foundry test will include the following cases:

- Deposit ETH and receive receipt tokens
- Stake receipt tokens and earn rewards
- Opt-in for auto-compounding and receive rewards
- Trigger auto-compounding and receive a reward
- Withdraw tokens and ETH
- Test edge cases to ensure proper reward calculation and fee distribution
- Fuzz testing to ensure the contract is secure and free from vulnerabilities.
