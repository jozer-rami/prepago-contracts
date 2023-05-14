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

deploy-prepaid-module :; source .env && forge script script/Deployers.t.sol:DeployPrepaidModule --rpc-url ${GOERLI_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_KEY} -vvvv

deploy-card :; source .env && forge script script/Deployers.t.sol:DeployPrepaidModuleWithSafe --rpc-url ${GOERLI_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_KEY} -vvvv

deploy-card-guard :; source .env && forge script script/Deployers.t.sol:DeployPrepaidGuardWithSafe --rpc-url ${GOERLI_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_KEY} -vvvv

create-prepaid-module:; source .env && forge create src/PrepaidModule.sol:PrepaidModule --constructor-args ${SAFE_PROXY_FACTORY_ADDRESS} ${SAFE_MASTER_COPY_ADDRESS} ${CARD_HODLER_1} ${MERCHAND} --rpc-url ${GOERLI_RPC_URL}  --private-key ${PRIVATE_KEY} --verify --etherscan-api-key ${ETHERSCAN_KEY}

create-prepaid-guard:; source .env && forge create src/PrepaidGuardCreator.sol:PrepaidGuardCreator --constructor-args ${SAFE_PROXY_FACTORY_ADDRESS} ${SAFE_MASTER_COPY_ADDRESS} ${CARD_HODLER_1} ${MERCHAND} --rpc-url ${GOERLI_RPC_URL}  --private-key ${PRIVATE_KEY} --verify --etherscan-api-key ${ETHERSCAN_KEY}

create-prepaid-guard-goerli:; source .env && forge create src/PrepaidGuardCreator.sol:PrepaidGuardCreator --constructor-args ${SAFE_PROXY_FACTORY_ADDRESS} ${SAFE_MASTER_COPY_ADDRESS} --rpc-url ${GOERLI_RPC_URL}  --private-key ${PRIVATE_KEY} --verify --etherscan-api-key ${ETHERSCAN_KEY}

create-prepaid-guard-gnosis:; source .env && forge create src/PrepaidGuardCreator.sol:PrepaidGuardCreator --constructor-args ${SAFE_PROXY_FACTORY_ADDRESS} ${SAFE_MASTER_COPY_ADDRESS} --rpc-url ${GNOSIS_RPC_URL}  --private-key ${PRIVATE_KEY} --verify --etherscan-api-key ${ETHERSCAN_KEY_GNOSIS}

deploy-safe-factory-linea :; source .env && forge script script/DeploySafeFactory.sol:DeploySafeFactory --rpc-url ${LINEA_RPC_URL}  --private-key ${PRIVATE_KEY} --legacy

deploy-card-guard-linea :; source .env && forge script script/Deployers.t.sol:DeployPrepaidGuardWithSafe --rpc-url ${LINEA_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast -vvvv --legacy

create-prepaid-guard-linea:; source .env && forge create src/PrepaidGuardCreator.sol:PrepaidGuardCreator --constructor-args ${SAFE_PROXY_FACTORY_ADDRESS} ${SAFE_MASTER_COPY_ADDRESS} --rpc-url ${LINEA_RPC_URL}  --private-key ${PRIVATE_KEY} --verify

create-prepaid-guard-scroll:; source .env && forge create src/PrepaidGuardCreator.sol:PrepaidGuardCreator --constructor-args ${SAFE_PROXY_FACTORY_ADDRESS} ${SAFE_MASTER_COPY_ADDRESS} --rpc-url ${SCROLL_RPC_URL}  --private-key ${PRIVATE_KEY} --legacy --verifier-url https://blockscout.scroll.io/api --verifier blockscout

verify-scroll :; forge verify-contract 0xcf28C2Ba213F719D2857E1fEca46f68ae3d909B7 src/PrepaidGuardCreator.sol:PrepaidGuardCreator --chain-id 534353 --verifier-url https://blockscout.scroll.io/api --verifier blockscout

create-prepaid-guard-mantle:; source .env && forge create src/PrepaidGuardCreator.sol:PrepaidGuardCreator --constructor-args ${SAFE_PROXY_FACTORY_ADDRESS} ${SAFE_MASTER_COPY_ADDRESS} --rpc-url ${MANTLE_RPC_URL}  --private-key ${PRIVATE_KEY} --legacy
