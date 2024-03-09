import FungibleToken from 0x05
import PureDollarToken from 0x05

transaction(receiver: Address, amount: UFix64) {

    prepare(signer: AuthAccount) {
        // Borrow the PureDollarToken Minter reference
        let minter = signer.borrow<&PureDollarToken.Minter>(from: /storage/MinterStorage)
            ?? panic("You are not the PureDollarToken minter")
        
        // Borrow the receiver's PureDollarToken Vault capability
        let receiverVault = getAccount(receiver)
            .getCapability<&PureDollarToken.Vault{FungibleToken.Receiver}>(/public/Vault)
            .borrow()
            ?? panic("Error: Check your PureDollarToken Vault status")
        
        // Minted tokens reference
        let mintedTokens <- minter.mintToken(amount: amount)

        // Deposit minted tokens into the receiver's PureDollarToken Vault
        receiverVault.deposit(from: <-mintedTokens)
    }

    execute {
        log("PureDollarToken minted and deposited successfully")
        log("Tokens minted and deposited: ".concat(amount.toString()))
    }
}