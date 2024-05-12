# Minimum Viable Exchange

This repo consists of a decentralized exchange which has token pair of ERC20 Scroogecoin and ETH. It allows seamless trade between token SCR and ETH in a decentralized manner. Users will be able to connect their wallets, view their token balance, buy or sell the tokens according to the price formula.

# Environment:
You need to have :
- [Node (v18 LTS)](https://nodejs.org/en/download/)
-  Yarn ([v1](https://classic.yarnpkg.com/en/docs/install/) or [v2+](https://yarnpkg.com/getting-started/install))
- [Metamask](https://metamask.io/download/)

```sh
git clone https://github.com/Dhanushsubbaiah/minimum-viable-exchange.git 
cd minimum-viable-exchange
yarn install

```
in the same terminal, start your local network (a blockchain emulator in your computer):

```sh
yarn chain
```
You will find a list of accounts you can use that private key to open a wallet in Metamask or if you already have a metamask you need the wallet address where we would use the address. Also, add your private key in packages->hardhat->'hardhat.config.ts'.

```sh
const deployerPrivateKey =
  process.env.DEPLOYER_PRIVATE_KEY ?? "YOUR_WALLET_PRIVATE_KEY";
```

Add some ETH to your local account using the faucet and then find the `00_deploy_your_contract.ts` file. Find and uncomment the lines below and add your front-end address (your burner wallet address).

```
  // // paste in your front-end address here to get 10 balloons on deploy:
  // await balloons.transfer(
  //   "YOUR_FRONTEND_ADDRESS",
  //   "" + 10 * 10 ** 18
  // );
```

> in a second terminal window, deploy your contract (locally):

```sh
cd minimum-viable-exchange
yarn deploy
```

> in a third terminal window, start your frontend:

```sh
cd minimum-viable-exchange
yarn start
```
Open http://localhost:3000 to see the app.

Go to DEX page

Grab funds from faucet

The front end should show you that you have balloon tokens. We can’t just call `init()` yet because the DEX contract isn’t allowed to transfer ERC20 tokens from our account.

First, we have to call `approve()` on the Balloons contract, approving the DEX contract address to take some amount of tokens.

Copy and paste the DEX address to the _Address Spender_ and then set the amount to 5.  

Now you can trade.

To verify the code is running you can run the test cases

```sh
cd minimum-viable-exchange
yarn test
```
Also in the frontend if you go to debug contracts under DEX under the read contracts we can check the price and slippage. Let’s say we have 1 million ETH and 1 million tokens, if we put this into our price formula and ask it the price of 1000 ETH it will be an almost 1:1 ratio:

If we put in 1000 ETH and input reserve and outputreserve as 1000000 we will receive 996 tokens. If we’re paying a 0.3% fee it should be 997 if everything was perfect. BUT, there is a tiny bit of slippage as our contract moves away from the original ratio. The contract automatically adjusts the price as the ratio of reserves shifts away from the equilibrium. It’s called an Automated Market Maker

Everything runs well on locally if we want to deploy on any public testnet below is the steps:

Note: You need to have more than 5 eth testnets to deploy and run it on testnet.

!!!!!!!! To deploy on public testnet !!!!!!!!

By default it runs on burner wallets which are available on hardhat. To deploy on public testnet edit the `defaultNetwork` to your choice of public EVM networks in `packages/hardhat/hardhat.config.ts`
Deploy your contracts!

Edit the `defaultNetwork` to your choice of public EVM networks in `packages/hardhat/hardhat.config.ts`

You will need to generate a **deployer address** using `yarn generate` This creates a mnemonic and saves it locally.

Use `yarn account` to view your deployer account balances.

ou will need to send ETH to your deployer address with your wallet, or get it from a public faucet of your chosen network.

Run `yarn deploy` to deploy your smart contracts to a public network (selected in `hardhat.config.ts`)

For sepolia:

You can set the `defaultNetwork` in `hardhat.config.ts` to `sepolia` **OR** you can `yarn deploy --network sepolia`.

Frontend:
Edit your frontend config in `packages/nextjs/scaffold.config.ts` to change the `targetNetwork` to `chains.sepolia` or any other public network.

View your frontend at http://localhost:3000 and verify you see the correct network.

Below are the screenshots

![image](https://github.com/Dhanushsubbaiah/minimum-viable-exchange/assets/59074947/d8d9b8b8-86e7-43e6-8c08-0c9f8f9fbaf0)

![image](https://github.com/Dhanushsubbaiah/minimum-viable-exchange/assets/59074947/b812364b-7b0a-4536-a2da-1d29ae117e1c)

![image](https://github.com/Dhanushsubbaiah/minimum-viable-exchange/assets/59074947/affad3df-e753-4b63-9533-806868090bad)


