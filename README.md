# My Aleo Beginner’s Workshop Series: Deploying, Minting, and Messaging

## Overview

Welcome to my Aleo Beginner’s Workshop Series! In this series, I’ll take you through my learning journey as I explored the fundamentals of programming on the Aleo blockchain using Leo. From understanding the basics of the syntax to deploying smart contracts, I’ve broken down my experience into three workshops:

1. **Workshop 1: Deploying on Aleo (`leo_blockchain_for_beginners.aleo`)**
2. **Workshop 2: Minting and Transferring Tokens (`simple_token_beginners.aleo`)**
3. **Workshop 3: Voice Messaging and State Updates (`aleo_voice7`)**

---

## Workshop 1: Deploying on Aleo

### Introduction

My first step into Aleo development involved learning the basics of Leo syntax and how to deploy a simple program. I created a straightforward program that performs an addition operation, allowing me to get familiar with the language.

### Program Overview

```leo
program leo_blockchain_for_beginners.aleo {
    transition main(public a: u32, b: u32) -> u32 {
        let c: u32 = a + b;
        return c;
    }
}
```

### My Learning Journey

1. **Creating the Program:**
   I started by creating a new project using the command:

   ```bash
   leo new leo_blockchain_for_beginners
   ```

2. **Running the Program:**
   After writing the code, I ran the program using:

   ```bash
   leo run leo_blockchain_for_beginners.aleo <a> <b>
   ```

   Here, `<a>` and `<b>` are the input parameters. This helped me test the functionality.

3. **Deploying the Program:**
   Once I verified everything worked correctly, I deployed it using:

   ```bash
   leo deploy leo_blockchain_for_beginners.aleo
   ```

This initial exercise was a great introduction to creating, running, and deploying Leo programs.

---

## Workshop 2: Minting and Transferring Tokens

### Introduction

In this workshop, I took a deeper dive into Leo by learning how to mint and transfer tokens. My goal was to create a token management system using the `simple_token_beginners.aleo` program.

### Program Overview

```leo
program simple_token_beginners.aleo {

    record Token {
        owner: address,
        amount: u64,
    }

    transition mint(owner: address, amount: u64) -> Token {
        return Token {
            owner: owner,
            amount: amount,
        };
    }

    transition transfer(token: Token, to: address, amount: u64) -> (Token, Token) {
        let difference: u64 = token.amount - amount;

        let remaining: Token = Token {
            owner: token.owner,
            amount: difference,
        };

        let transferred: Token = Token {
            owner: to,
            amount: amount,
        };

        return (remaining, transferred);
    }
}
```

### My Learning Journey

1. **Minting Tokens:**

   I minted tokens using the command:

   ```bash
   leo run simple_token_beginners.aleo mint <owner_address> <amount>
   ```

   This generated a token owned by the specified address.

2. **Transferring Tokens:**

   I then practiced transferring tokens with:

   ```bash
   leo run simple_token_beginners.aleo transfer <token> <to_address> <amount>
   ```

   This command transferred a portion of the tokens to another address while retaining the remainder.

3. **Deploying the Program:**

   Finally, I deployed the program:

   ```bash
   leo deploy simple_token_beginners.aleo
   ```

Through this workshop, I gained hands-on experience with token creation and transfers in Leo.

---

## Workshop 3: Voice Messaging and State Updates

### Introduction

The last workshop was the most exciting for me, as it involved building a messaging system with asynchronous state updates. The program I developed, `aleo_voice7`, demonstrates how to send and manage voice messages securely on the Aleo blockchain.

### Program Overview

```leo
program make_voice.aleo {

    record Voice {
        owner: address,
        receiver: address,
        msg: u128,
        hash_msg: u128,
    }

    record CoBind {
        hash_owner: field,
        owner: address, 
        receiver: address,
        bind_hash: field,
    }

    struct Messaging {
        messenger: field,
        total_messages: u64,
    }

    mapping voice_msg: field => Messaging;

    async transition send_voice(owner: address, receiver: address, msg: u128, co_bind: field) -> (Voice, Future) {
        let hash: u128 = BHP256::hash_to_u128(msg);
        assert(self.caller == owner);
        assert_neq(self.caller, receiver);

        let hash_owner: field = BHP256::hash_to_field(owner);
        let hash_receiver: field = BHP256::hash_to_field(receiver);
        let add_hash: field = hash_owner + hash_receiver;

        let send_from: Voice = Voice {
            owner: owner,
            receiver: receiver,
            msg: msg,
            hash_msg: hash,
        };
        
        return (send_from, finalize_send_voice(owner, hash));
    }

    async function finalize_send_voice(owner: address, hash: u128) {
        let hash_owner: field = BHP256::hash_to_field(owner);
        let total: Messaging = Mapping::get_or_use(voice_msg, hash_owner, Messaging {
            messenger: hash_owner,
            total_messages: 0u64,
        });
        
        voice_msg.set(hash_owner, Messaging {
            messenger: hash_owner,
            total_messages: total.total_messages + 1u64,
        });
    }

    transition combine_hash_owner_receiver(owner: address, receiver: address) -> (CoBind) {
        assert_eq(owner, self.caller);
        let hash_owner: field = BHP256::hash_to_field(owner);
        let hash_receiver: field = BHP256::hash_to_field(receiver);
        let add_hash: field = hash_owner + hash_receiver;

        let update_hash: CoBind = CoBind {
            hash_owner: hash_owner,
            receiver: receiver,
            owner: owner,
            bind_hash: add_hash,
        };

        return (update_hash);
    }
}
```

### My Learning Journey

1. **Sending a Voice Message:**

   I learned how to send a voice message using:

   ```bash
   leo run make_voice.aleo send_voice <owner_address> <receiver_address> <msg_value> <co_bind>
   ```

   The program hashes the message and securely transfers it to the recipient.

2. **Combining Owner and Receiver Hashes:**

   I practiced creating a binding hash between the owner and receiver with:

   ```bash
   leo run make_voice.aleo combine_hash_owner_receiver <owner_address> <receiver_address>
   ```

   This creates a combined hash that can be used for further operations.

3. **Deploying the Program:**

   The final deployment step was done using:

   ```bash
   leo deploy make_voice.aleo
   ```

This workshop was a great learning experience in building more complex, state-driven applications on Aleo.
##My deployment on aleo 
![Deployment Screenshot](https://ibb.co/wdsZ77X)
---

## Conclusion

This series has given me a solid foundation in Leo and Aleo development. From deploying simple programs to creating token systems and implementing messaging solutions, I’ve learned a lot about blockchain programming. I’m excited to continue my journey and dive deeper into the world of decentralized applications.
