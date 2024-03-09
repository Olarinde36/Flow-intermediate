// Import FungibleToken and PureDollarToken contracts from version 0x05
import FungibleToken from 0x05
import PureDollarToken from 0x05

// Create Green Token Vault Transaction
transaction () {

    // Define references
    let userVault: &PureDollarToken.Vault{FungibleToken.Balance, 
        FungibleToken.Provider, 
        FungibleToken.Receiver, 
        PureDollarToken.VaultInterface}?
    let account: AuthAccount

    prepare(acct: AuthAccount) {

        // Borrow the vault capability and set the account reference
        self.userVault = acct.getCapability(/public/Vault)
            .borrow<&PureDollarToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, PureDollarToken.VaultInterface}>()
        self.account = acct
    }

    execute {
        if self.userVault == nil {
            // Create and link an empty vault if none exists
            let emptyVault <- PureDollarToken.createEmptyVault()
            self.account.save(<-emptyVault, to: /storage/VaultStorage)
            self.account.link<&PureDollarToken.Vault{FungibleToken.Balance, 
                FungibleToken.Provider, 
                FungibleToken.Receiver, 
                PureDollarToken.VaultInterface}>(/public/Vault, target: /storage/VaultStorage)
            log("Empty vault created and linked")
        } else {
            log("Vault already exists and is properly linked")
        }
    }
}