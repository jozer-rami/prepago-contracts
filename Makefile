# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

all: clean install update build

# Clean the repo
clean :; forge clean

# Install the Modules
install :; forge install

# Update Dependencies
update:; forge update

# Builds
build:; forge build

build-size-report :; forge build --sizes

# chmod scripts
scripts :; chmod +x ./scripts/*

# Tests
test :; forge test -vvv

# Forge Formatter
check :; forge fmt --check
format :; forge fmt

# Generate Gas Snapshots
snapshot :; forge clean && forge snapshot

# Deploy New Safe
deploy-new-safe :; source .env && forge script script/DeploySafeFactory.t.sol:DeploySafeFactory --rpc-url ${SCROLL_RPC_URL}  --private-key ${PRIVATE_KEY} --legacy --broadcast -vvvv

# Deploy Safe Factory
deploy-safe-factory-scroll :; source .env && forge create lib/safe-contracts/contracts/proxies/SafeProxyFactory.sol:SafeProxyFactory --rpc-url ${SCROLL_RPC_URL}  --private-key ${PRIVATE_KEY} --legacy

verify :; forge verify-contract 0xFdD8B67c0E63e93Aa1963248646378a3E8C819f4 lib/safe-contracts/contracts/proxies/SafeProxyFactory.sol:SafeProxyFactory --chain-id 534353 --verifier-url https://blockscout.scroll.io/api --verifier blockscout

# 
deploy-prepaid-module :; source .env && forge script script/Deployers.t.sol:DeployPrepaidModule --rpc-url ${GOERLI_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_KEY} -vvvv

deploy-card :; source .env && forge script script/Deployers.t.sol:DeployPrepaidModuleWithSafe --rpc-url ${GOERLI_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_KEY} -vvvv

deploy-card-guard :; source .env && forge script script/Deployers.t.sol:DeployPrepaidGuardWithSafe --rpc-url ${GOERLI_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_KEY} -vvvv

create-prepaid:; source .env && forge create src/PrepaidModule.sol:PrepaidModule --constructor-args ${SAFE_PROXY_FACTORY_ADDRESS} ${SAFE_MASTER_COPY_ADDRESS} ${CARD_HODLER_1} ${MERCHAND} --rpc-url ${GOERLI_RPC_URL}  --private-key ${PRIVATE_KEY} --verify --etherscan-api-key ${ETHERSCAN_KEY}

create-prepaid-guard:; source .env && forge create src/PrepaidGuardCreator.sol:PrepaidGuardCreator --constructor-args ${SAFE_PROXY_FACTORY_ADDRESS} ${SAFE_MASTER_COPY_ADDRESS} ${CARD_HODLER_1} ${MERCHAND} --rpc-url ${GOERLI_RPC_URL}  --private-key ${PRIVATE_KEY} --verify --etherscan-api-key ${ETHERSCAN_KEY}

create-guard:; source .env && forge create src/PrepaidGuard.sol:PrepaidGuard --constructor-args ${MERCHAND} --rpc-url ${GOERLI_RPC_URL}  --private-key ${PRIVATE_KEY} --verify --etherscan-api-key ${ETHERSCAN_KEY}
