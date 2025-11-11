module legend::reward_nft {
    use std::string::String;
    use sui::object::UID;
    use sui::transfer;
    use sui::tx_context::TxContext;

    public struct RewardNFT has key {
        id: UID,
        nft_id: String,
        title: String,
        image: String,
        points: u64,
        challenge_id: UID,
        transferred: bool,
        date_created: u64, // timestamp
    }

    public entry fun create_reward_nft(
        nft_id: String,
        title: String,
        image: String,
        points: u64,
        // We'll pass the challenge ID as a vector of bytes instead of UID
        _challenge_id_bytes: vector<u8>,
        date_created: u64,
        ctx: &mut TxContext
    ) {
        // Convert bytes back to UID
        let challenge_id = object::new(ctx); // Placeholder for now
        
        let nft = RewardNFT {
            id: object::new(ctx),
            nft_id,
            title,
            image,
            points,
            challenge_id,
            transferred: false,
            date_created,
        };
        transfer::transfer(nft, tx_context::sender(ctx));
    }

    public fun get_nft_id(self: &RewardNFT): &String {
        &self.nft_id
    }

    public fun get_title(self: &RewardNFT): &String {
        &self.title
    }

    public fun get_points(self: &RewardNFT): u64 {
        self.points
    }

    public fun is_transferred(self: &RewardNFT): bool {
        self.transferred
    }

    public entry fun mark_as_transferred(nft: &mut RewardNFT) {
        nft.transferred = true;
    }
}