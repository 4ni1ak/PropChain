#!/bin/sh

# Compile and migrate contracts
echo "Deploying contracts to Ganache..."
npx truffle migrate --reset --network docker

# Copy artifacts to backend
echo "Syncing artifacts to backend..."
cp build/contracts/*.json /app/backend_contracts/

# Copy artifacts to frontend
echo "Syncing artifacts to frontend..."
cp build/contracts/*.json /app/frontend_contracts/

echo "Deployment and sync complete!"