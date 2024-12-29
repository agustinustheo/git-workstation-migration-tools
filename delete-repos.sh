#!/bin/bash

DIRS=(
    "Grant-Milestone-Delivery"
    "apps"
    "astar-docs"
    "balibot"
    "cdk-rs"
    "chatsopai"
    "debio-infrastructure"
    "elemenai"
    "firebase-to-minio-migration"
    "google-secrets-to-env"
    "hashing-research"
    "icp-prototype-milestone-1"
    "icp_messy"
    "idchain-hub"
    "idchain-testnet-backend-api"
    "idchain-testnet-copy"
    "idchain-testnet"
    "kilt-node"
    "kwarta"
    "mandala-docs"
    "mandala-evm-dapp"
    "mandala-gitbook"
    "mandala-scripts"
    "marauder"
    "my-ts-image-project"
    "myriad-api"
    "myriad-importer-extension"
    "myriad-node-parachain"
    "myriad-scripts"
    "myriad-web"
    "nestjs-event-emitter-example"
    "nestjs-interceptor-example"
    "nestjs-simple-chat"
    "nestjs-simple-rate-limiting"
    "polkadot-sdk"
    "rareskills-homework-4"
    "rust-errno"
    "rustix"
    "s21labs.io"
    "shaman"
    "silviabackups"
    "slack-bot-rust"
    "substrate-node-template"
    "tryst-backend"
    "web"
)

echo "About to delete the following directories:"
for dir in "${DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "✓ $dir (exists)"
    else
        echo "✗ $dir (not found)"
    fi
done

echo -e "\nAre you sure you want to proceed with deletion? (yes/no)"
read -r answer

if [ "$answer" = "yes" ]; then
    for dir in "${DIRS[@]}"; do
        if [ -d "$dir" ]; then
            echo "Deleting $dir..."
            rm -rf "$dir"
        fi
    done
    echo "Deletion complete"
else
    echo "Operation cancelled"
fi
