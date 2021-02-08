#!/bin/bash
#Sets the context for native peer commands

function usage {
    echo "Usage:             . ./set-context.sh  ORG_NAME"
    echo "Usage with TLS     . ./set-context.sh  ORG_NAME  tls"
    echo "           Sets the organization context for native peer execution"
}

if [ "$1" == "" ]; then
    usage
    exit
fi

export ORG_CONTEXT=$1
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_CONTEXT:0:1})${ORG_CONTEXT:1}"
export ORG_NAME=$MSP_ID

# Added this Oct 22
export CORE_PEER_LOCALMSPID=$ORG_NAME"MSP"

# Logging specifications
export FABRIC_LOGGING_SPEC=INFO

# Location of the core.yaml
export FABRIC_CFG_PATH=$PWD/config/$1

# Address of the peer
export CORE_PEER_ADDRESS=peer$2.$1.com:7051


# Local MSP for the admin - Commands need to be executed as org admin
export CORE_PEER_MSPCONFIGPATH=$PWD/config/crypto-config/peerOrganizations/$1.com/users/Admin@$1.com/msp

# Address of the orderer
export ORDERER_ADDRESS=orderer.fitcp.com:7050

# RAFT requires TLS


export ORDERER_CA_ROOTFILE=$PWD/config/crypto-config/ordererOrganizations/fitcp.com/orderers/orderer.fitcp.com/msp/tlscacerts/tlsca.fitcp.com-cert.pem

export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/config/crypto-config/peerOrganizations/$1.com/peers/peer$2.$1.com/tls/ca.crt

export CORE_PEER_TLS_ENABLED=true
    


#### Introduced in Fabric 2.x update
#### Test Chaincode related properties
if [ "$3" == "first" ]; then
    export CC_NAME="trcc"
    export CC_PATH="traceabilitychaincode"
    export CC_VERSION="1.0"
    export CC_CHANNEL_ID="traceabilitychannel"
    export CC_LANGUAGE="golang"

    # Version 2.x
    export INTERNAL_DEV_VERSION="1.0"
    export CC2_PACKAGE_FOLDER="$HOME/Traceability-HLF-docker/packages"
    export CC2_SEQUENCE=1
    #export CC2_INIT_REQUIRED="--init-required"
    CC2_INIT_REQUIRED=" "

    # Create the package with this name
    export PACKAGE_NAME="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION.tar.gz"
    # Extracts the package ID for the installed chaincode
    export LABEL="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION"
fi