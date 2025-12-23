# PropChain - Decentralized Property and Lease Management Ecosystem

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-Proprietary-red.svg)
![Blockchain](https://img.shields.io/badge/Blockchain-Ethereum%20%2F%20Ganache-orange)
![Build](https://img.shields.io/badge/build-passing-brightgreen)

## Table of Contents

- [Project Overview](#project-overview)
- [System Architecture & Workflow](#system-architecture--workflow)
- [Technology Stack](#technology-stack)
- [Key Features](#key-features)
- [Project Structure](#project-structure)
- [Installation & Build](#installation--build)
- [Frequently Asked Questions](#frequently-asked-questions)
- [License & Legal Notice](#license--legal-notice)

---

## Project Overview

PropChain is a next-generation, blockchain-based platform designed to manage real estate leasing, sales, deposit handling, and building maintenance fees with complete transparency, immutability, and security.

The project aims to eliminate trust issues, lack of transparency, and data manipulation risks inherent in traditional property management systems. By leveraging Smart Contracts instead of central authorities, it digitizes all financial and legal processes between tenants and property owners.

**Live Demo:** https://propchain.akpinar.dev/

---

## System Architecture & Workflow

This project implements a full-stack decentralized application (DApp) that bridges traditional web interfaces with blockchain logic.

### 1. User Interaction & Authentication
- **Wallet Connection:** Users do not create traditional accounts with passwords. Instead, they authenticate using their crypto wallets (MetaMask).
- **Role Assignment:** Upon registration, users are assigned roles (Landlord, Tenant, Building Manager) which determines their access rights within the application and Smart Contracts.

### 2. Property Listing & Data Storage
- **Hybrid Storage Model:** To optimize gas costs, large data sets (high-resolution images, detailed property descriptions) are stored off-chain in MongoDB and IPFS (InterPlanetary File System).
- **On-Chain Verification:** Only the critical "hash" or digital fingerprint of this data is stored on the Ethereum blockchain. This ensures that while the data is accessible quickly via the database, its integrity is cryptographically guaranteed on the blockchain.

### 3. The Deposit Queue Mechanism
- **Submission:** When a tenant submits a deposit, the funds are held in a Smart Contract escrow, not the landlord's personal wallet.
- **Anonymity:** The system generates a cryptographic hash of the depositor's identity. The landlord sees a queue of anonymous hashes (e.g., "Candidate #1", "Candidate #2") rather than names or genders, ensuring an unbiased selection process based purely on priority.
- **Smart Contract Logic:** The contract automatically handles the logic: if Candidate #1 is rejected or withdraws, Candidate #2 automatically moves up.

### 4. Payments & Financial Tracking
- **Rent & Fees:** Monthly rent and building maintenance fees (aidat) are processed through specific smart contracts.
- **Immutable History:** Every payment creates a permanent transaction record. This builds a verifiable "Credit Score" for tenants that exists independently of any bank or credit bureau.

---

## Technology Stack

### Blockchain Infrastructure
- **Hyperledger Fabric / Ethereum (Ganache):** The core immutable ledger.
- **Solidity:** Smart contract language for defining business rules.
- **Truffle Suite:** Development framework for compiling, testing, and deploying contracts.
- **Web3.js / Ethers.js:** JavaScript libraries for interacting with the blockchain nodes.

### Backend Development
- **Node.js & Express.js:** High-performance server-side runtime.
- **MongoDB:** NoSQL database for flexible storage of non-critical, off-chain data.
- **JWT:** Secure authentication mechanism linked to wallet addresses.

### Frontend Development
- **React.js:** Library for building interactive user interfaces.
- **Tailwind CSS:** Utility-first CSS framework for rapid, responsive UI design.

### DevOps
- **Docker & Docker Compose:** For consistent environments across development and production.

---

## Project Structure

```
PropChain/
├── backend/                 # Node.js API Service
│   ├── src/
│   │   ├── contracts/       # Compiled Contract JSONs
│   │   ├── controllers/     # Business Logic (MVC Controller)
│   │   ├── models/          # Database Schemas (MVC Model)
│   │   ├── routes/          # API Endpoints
│   │   └── services/        # Blockchain integration services
│   └── Dockerfile
├── blockchain/              # Smart Contracts Environment
│   ├── contracts/           # Solidity Source Code (.sol)
│   ├── migrations/          # Deployment Scripts
│   └── truffle-config.js
├── frontend/                # React Application
│   ├── src/
│   │   ├── components/      # Reusable UI Components
│   │   ├── context/         # Global State (Context API)
│   │   └── pages/           # Application Views
│   └── Dockerfile
├── docker-compose.yml       # Service Orchestration
└── README.md                # Project Documentation
```

---

## Installation & Build

### Prerequisites
- Docker and Docker Compose
- MetaMask Browser Extension

### Docker Build (Recommended)

1. **Clone the Repository**
   ```bash
   git clone https://github.com/4ni1ak/PropChain.git
   cd propchain
   ```

2. **Environment Configuration**
   Copy `.env.example` to `.env` in the root, `backend/`, and `frontend/` directories and configure your secrets.

3. **Build and Run**
   Execute the following command to build the images and start the containers:
   ```bash
   docker-compose up --build
   ```

4. **Deploy Contracts**
   Once the containers are running, deploy the smart contracts to the local blockchain:
   ```bash
   # Run this inside the blockchain container or locally
   cd blockchain
   npm install
   npx truffle migrate --network development
   ```

### Access Points
- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:5000
- **Local Blockchain:** http://localhost:8545

---

## Frequently Asked Questions

**Q: Do I need real cryptocurrency (ETH) to use this?**
A: No. By default, the project runs on a local test network (Ganache) which provides fake "test" Ether. For production use, it can be deployed to the Ethereum Mainnet or Layer-2 solutions like Polygon.

**Q: Why use Blockchain for property management?**
A: Blockchain provides a "trustless" environment. It prevents landlords from claiming they didn't receive payment and protects tenants' deposits in an escrow that neither party can manipulate without mutual consent.

**Q: Is the deposit anonymous to everyone?**
A: The deposit is anonymous to the public and the landlord during the initial queue phase. The identity is only revealed once the landlord accepts the deposit and the lease agreement process begins.

**Q: Can I run this on Windows?**
A: Yes, provided you have Docker Desktop installed and configured to run Linux containers.

---

## License & Legal Notice

**Copyright (c) 2025 PropChain Development Team. All Rights Reserved.**

Unauthorized copying, distribution, modification, or reverse engineering of this software, its source code, or documentation, in whole or in part, via any medium is **STRICTLY PROHIBITED** without the prior written permission of the copyright holder.

This project is provided for educational and demonstration purposes only. Commercial use, reproduction, or creation of derivative works is subject to specific licensing agreements. Any unauthorized use will be met with legal action.

**Contact**
For licensing inquiries or technical support:
- **Email:** anil@akpinar.dev
- **Website:** https://propchain.akpinar.dev/