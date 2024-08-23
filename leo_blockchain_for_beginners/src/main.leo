// The 'leo_blockchain_for_beginners' program.
program leo_blockchain_for_beginners.aleo {
    transition main(public a: u32, b: u32) -> u32 {
        let c: u32 = a + b;
        return c;
    }
}
