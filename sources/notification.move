module legend::notification {
    use std::string::String;
    use sui::object::UID;
    use sui::transfer;
    use sui::tx_context::TxContext;

    public struct Notification has key {
        id: UID,
        user_address: address,
        notification_type: String, // "challenge_win", "new_challenge", "system"
        title: String,
        message: String,
        date_created: u64, // timestamp
    }

    public entry fun create_notification(
        user_address: address,
        notification_type: String,
        title: String,
        message: String,
        ctx: &mut TxContext
    ) {
        let notification = Notification {
            id: object::new(ctx),
            user_address,
            notification_type,
            title,
            message,
            date_created: tx_context::epoch(ctx),
        };
        transfer::transfer(notification, user_address);
    }

    public fun get_user_address(self: &Notification): address {
        self.user_address
    }

    public fun get_type(self: &Notification): &String {
        &self.notification_type
    }

    public fun get_title(self: &Notification): &String {
        &self.title
    }

    public fun get_message(self: &Notification): &String {
        &self.message
    }

    public entry fun delete_notification(notification: Notification) {
        let Notification { id, user_address: _, notification_type: _, title: _, message: _, date_created: _ } = notification;
        object::delete(id);
    }
}