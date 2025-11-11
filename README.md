# Legend - Sui Move Implementation

This is the Sui Move implementation of the Legend backend, converted from the original JavaScript/Node.js/MongoDB stack.

## Modules

1. **user.move** - Manages user profiles with name, wallet address, and scores
2. **challenge.move** - Handles challenge creation, submissions, and completion
3. **submission.move** - Manages challenge submissions from participants
4. **achievement.move** - Tracks user achievements when winning challenges
5. **reward_nft.move** - Manages NFT rewards for challenge winners
6. **notification.move** - Handles user notifications
7. **legend.move** - Main module with entry functions that expose the application functionality

## Prerequisites

To build and test this Sui Move package, you need to have the Sui CLI installed. Follow the official Sui installation guide: https://docs.sui.io/devnet/build/install

## Building the Package

```bash
cd sui-move
sui move build
```

## Testing

```bash
sui move test
```

## Deployment

To deploy the package to the Sui network:

```bash
sui client publish --gas-budget 100000000
```

## Entry Functions

The following entry functions are available to interact with the smart contracts:

- `create_profile` - Create a new user profile
- `create_challenge` - Create a new challenge
- `submit_to_challenge` - Submit to a challenge
- `complete_challenge` - Mark a challenge as completed
- `select_challenge_winner` - Select a winner for a challenge and distribute rewards
- `create_notification` - Create a notification for a user
- `delete_notification` - Delete a notification

## Architecture Notes

This implementation follows Sui's object-centric design patterns where each entity (User, Challenge, Submission, etc.) is represented as a Sui object. The traditional REST API endpoints have been converted to entry functions that can be called directly on the blockchain.# Legend_move
