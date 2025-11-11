module legend::user {
    use std::string::{Self, String};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

    public struct User has key {
        id: UID,
        name: String,
        wallet_address: String,
        score: u64,
    }

    public entry fun create_user(name: String, wallet_address: String, ctx: &mut TxContext) {
        let user = User {
            id: object::new(ctx),
            name,
            wallet_address,
            score: 0,
        };
        transfer::transfer(user, ctx.sender());
    }

    public fun get_wallet_address(self: &User): &String {
        &self.wallet_address
    }

    public fun get_name(self: &User): &String {
        &self.name
    }

    public fun get_score(self: &User): u64 {
        self.score
    }

    public entry fun update_score(user: &mut User, points: u64) {
        user.score = user.score + points;
    }
}