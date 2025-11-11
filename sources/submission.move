module legend::submission {
    use std::string::{Self, String};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

    public struct Submission has key, store {
        id: UID,
        challenge_id: UID,
        participant_address: address,
        submission_link: String,
        submitted_at: u64, // timestamp
    }

// In submission.move
    public fun create_submission(
        challenge_id: address, // use address, not UID
        participant_address: address,
        submission_link: String,
        ctx: &mut TxContext
    ): Submission {
        Submission {
            id: object::new(ctx),
            challenge_id, // just the address
            participant_address,
            submission_link,
            submitted_at: 0,
        }
    }


    public fun get_challenge_id(self: &Submission): &UID {
        &self.challenge_id
    }

    public fun get_participant_address(self: &Submission): address {
        self.participant_address
    }

    public fun get_submission_link(self: &Submission): &String {
        &self.submission_link
    }

    public fun get_submitted_at(self: &Submission): u64 {
        self.submitted_at
    }
}