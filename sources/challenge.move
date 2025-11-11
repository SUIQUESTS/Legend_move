module legend::challenge {
    use std::string::{Self, String};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;
    use sui::clock::Clock;
    use legend::user::User;
    use legend::submission;


    public struct Challenge has key {
        id: UID,
        creator: address,
        title: String,
        description: String,
        participant_limit: u64,
        nft_id: String,
        deadline: u64, // timestamp
        status: String, // "active" or "completed"
        submissions: vector<submission::Submission>,
        winner: address,
        reward_points: u64,
        date_created: u64, // timestamp
    }

    public entry fun create_challenge(
        creator: address,
        title: String,
        description: String,
        participant_limit: u64,
        nft_id: String,
        deadline: u64,
        ctx: &mut TxContext
    ) {
        let challenge = Challenge {
            id: object::new(ctx),
            creator,
            title,
            description,
            participant_limit,
            nft_id,
            deadline,
            status: string::utf8(b"active"),
            submissions: vector::empty(),
            winner: @0x0,
            reward_points: 100,
            date_created: 23457965,
        };
        transfer::transfer(challenge, ctx.sender());
    }

    public fun get_creator(self: &Challenge): address {
        self.creator
    }

    public fun get_title(self: &Challenge): &String {
        &self.title
    }

    public fun get_status(self: &Challenge): &String {
        &self.status
    }

    public fun get_submissions(self: &Challenge): &vector<submission::Submission> {
        &self.submissions
    }

    public fun get_winner(self: &Challenge): address {
        self.winner
    }

    public entry fun submit_to_challenge(
        challenge: &mut Challenge,
        participant_address: address,
        submission_link: String,
        clock: &Clock,
        ctx: &mut TxContext
    ) {
        // Check if challenge is still active
        assert!(*get_status(challenge) == string::utf8(b"active"), 0);
        
        // Check if deadline has passed
        assert!(challenge.deadline > clock.timestamp_ms(), 1);
        
        // Check participant limit
        if (challenge.participant_limit > 0) {
            assert!(vector::length(&challenge.submissions) < challenge.participant_limit, 2);
        };
        
        // Create submission
        let submission = submission::create_submission(
            sui::object::uid_to_address(&challenge.id), // pass the challenge's UID
            participant_address,
            submission_link,
            ctx
        );
        vector::push_back(&mut challenge.submissions, submission); // or submission.id if storing UIDs

        
        // Transfer submission to sender
        // transfer::public_transfer(submission, ctx.sender());
    }

    public fun uid_to_address(uid: &UID): address {
        sui::object::uid_to_address(uid)
    }

    public entry fun complete_challenge(challenge: &mut Challenge) {
        challenge.status = string::utf8(b"completed");
    }

    public entry fun select_winner(
        challenge: &mut Challenge,
        winner_address: address,
        ctx: &mut TxContext
    ) {
        // Check if challenge is not already completed
        assert!(*get_status(challenge) != string::utf8(b"completed"), 3);
        
        // Set winner and complete challenge
        challenge.winner = winner_address;
        challenge.status = string::utf8(b"completed");
    }
}