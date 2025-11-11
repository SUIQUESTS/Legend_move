module legend::legend {
    use std::string::String;
    use sui::tx_context::TxContext;
    use sui::clock::Clock;
    use legend::challenge::Challenge;
    use legend::notification::Notification;

    // Entry function equivalent to POST /api/users
    public entry fun create_profile(name: String, wallet_address: String, ctx: &mut TxContext) {
        legend::user::create_user(name, wallet_address, ctx);
    }

    // Entry function equivalent to GET /api/users/:walletAddress
    // Note: In Sui, objects are accessed directly by their ID, not by wallet address lookup
    
    // Entry function equivalent to POST /api/challenges/create
    public entry fun create_challenge(
        creator: address,
        title: String,
        description: String,
        participant_limit: u64,
        nft_id: String,
        deadline: u64,
        ctx: &mut TxContext
    ) {
        legend::challenge::create_challenge(creator, title, description, participant_limit, nft_id, deadline, ctx);
    }

    // Entry function equivalent to POST /api/challenges/:id/submit
    public entry fun submit_to_challenge(
        challenge: &mut Challenge,
        participant_address: address,
        submission_link: String,
        clock: &Clock,
        ctx: &mut TxContext
    ) {
        legend::challenge::submit_to_challenge(challenge, participant_address, submission_link, clock, ctx);
    }

    // Entry function equivalent to PUT /api/challenges/:id/complete
    public entry fun complete_challenge(challenge: &mut Challenge) {
        legend::challenge::complete_challenge(challenge);
    }

    // Entry function equivalent to PUT /api/challenges/select-winner
    public entry fun select_challenge_winner(
        challenge: &mut Challenge,
        winner_address: address,
        nft_id: String,
        nft_title: String,
        nft_image: String,
        nft_points: u64,
        achievement_title: String,
        ctx: &mut TxContext
    ) {
        // Select winner for the challenge
        legend::challenge::select_winner(challenge, winner_address, ctx);
        
        // Create reward NFT
        legend::reward_nft::create_reward_nft(
            nft_id, 
            nft_title, 
            nft_image, 
            nft_points, 
            b"placeholder", // challenge ID bytes
            tx_context::epoch(ctx), 
            ctx
        );
        
        // Create achievement for winner
        legend::achievement::create_achievement(
            winner_address,
            nft_id,
            nft_image,
            achievement_title,
            nft_points,
            tx_context::epoch(ctx),
            ctx
        );
        
        // Create notification for winner
        legend::notification::create_notification(
            winner_address,
            string::utf8(b"challenge_win"),
            string::utf8(b"🎉 Congratulations!"),
            string::utf8(b"You won the challenge and earned points."),
            ctx
        );
        
        // Update user score
        // Note: This would require getting the user object and updating it
    }

    // Entry function equivalent to POST /api/notifications/create
    public entry fun create_notification(
        user_address: address,
        notification_type: String,
        title: String,
        message: String,
        ctx: &mut TxContext
    ) {
        legend::notification::create_notification(user_address, notification_type, title, message, ctx);
    }

    // Entry function equivalent to DELETE /api/notifications/:notificationId
    public entry fun delete_notification(notification: Notification) {
        legend::notification::delete_notification(notification);
    }
}