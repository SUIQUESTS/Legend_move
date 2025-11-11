module legend::achievement {
    use std::string::String;
    use sui::object::UID;
    use sui::transfer;
    use sui::tx_context::TxContext;

    public struct Achievement has key {
        id: UID,
        user_address: address,
        nft_id: String,
        image: String,
        title: String,
        points: u64,
        challenge_id: UID,
        date_earned: u64, // timestamp
    }

    public entry fun create_achievement(
        user_address: address,
        nft_id: String,
        image: String,
        title: String,
        points: u64,
        date_earned: u64,
        ctx: &mut TxContext
    ) {
        // We'll need to handle the challenge ID differently
        // For now, let's create a placeholder
        let challenge_id = object::new(ctx); // This is just a placeholder
        
        let achievement = Achievement {
            id: object::new(ctx),
            user_address,
            nft_id,
            image,
            title,
            points,
            challenge_id,
            date_earned,
        };
        transfer::transfer(achievement, user_address);
    }

    public fun get_user_address(self: &Achievement): address {
        self.user_address
    }

    public fun get_nft_id(self: &Achievement): &String {
        &self.nft_id
    }

    public fun get_points(self: &Achievement): u64 {
        self.points
    }

    public fun get_title(self: &Achievement): &String {
        &self.title
    }

    public fun get_challenge_id(self: &Achievement): &UID {
        &self.challenge_id
    }
}