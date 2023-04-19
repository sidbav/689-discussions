---
title: "Passphrase and keystroke dynamics authentication: Usable security"
date: "2023-04-19"
description: "Discussion 11.2"
---

The following is the summary and discussion of the paper [Passphrase and keystroke dynamics authentication: Usable security](https://www.sciencedirect.com/science/article/pii/S0167404820302017) by Bhaveer Bhana and Stephen Flowerday.

# Summary
- Authentication: Process by which you can verify someone's ID, usually is a prerequisite to allowing someone to access a system or resource.
- Usable Security: Extent to which users can efficiently accomplish their goals (authentication for example)

- Basic password policies are not enough, humans are lazy/dumb when it comes to the policies, and often do not make strong enough passwords.

- MFA can increase security and usability
  - Knowledge based approach
  - Biometric based approach
  - Token based approach


## Solution 1: Passphrase
- Instead of using passwords, use a passphase, they are a sequence of words.
- Authors have defined a passphrase to be 16 characters long, all lowercase
- Can also use abbreviations

## Solution 2: Key stroke Dynamics
- uniquely ID users based on how they type
  - Dwell time, flight time, pressure of keystrokes (obviously this would depend on the keyboard they have)
  - Can get min, max, average, std dev of keypressing times as well

- There are three ways to run the key stroke dynamics:
  - Static: run on a specific page (such as an authenication page) - you collect very little data in this case
  - Non-static: continuous logging of data over all pages. - collecting a lot of data over time
  - Semi-static: Logging is done over specific time intervals
- Once the system has collected enough data on you, then system should be able to authenticate you, not ID you?
  - System can check if you the keystroke dynamics show that you are close enough to the reference user (there has to be some sort of error in the system)

- To evaluate these two solutions, the authors make use of the following:
  - Chunking Theory: It is easy to remember information in chunks. For example as students of Texas A&M, it is easy for us to remember the the full form of the university by simply recalling TAMU versus someone who has not heard of TAMU before. Passwords created with strict policies without personal associations will require a greater number of chunks to recall.
  - The Keystroke Level Model: Predicting how long it would take someone to carry out a task
  - Shannon Entropy Theory: The amount of information that is inside a message, used to gauge how much information is unknown, how easy it is to guess a password

- The researchers setup a website where users were required to enter both a passphrase and password and counted how often users would enter an incorrect passphrase and password, and also looked at other details as well:
  - They found that passwords were more often incorrectly entered by the users than passphrases, this was regardless of device (phone, computer or tablet)
  - Passphrases had a greater entropy than passwords.

- Authors conclude that the passphrases are easier to recall, lead to lower number of login failures, leading to greater usability. MFA systems also increase usability
# Discussion
- Apparently the way that left handed and right handed affect the type of passwords that you come up with you (which is pretty neat, must be at a subconscious level though!)

- With keystroke dynamics, it is very hard to authenticate users since their will likely to be a lot of false positives

- Which is more difficult to predict? passwords or passphrases of the same length:
  - Passwords are more difficult to predict based on the definition of passphrases provided by the authors (all lowercase letters). However, if you modify the definition to include numbers (ex. replace letter i in passphrase with 1), symbols (ex. replace letter i with !), then I think both can be equally strong.

- How does MFA affect security?
  - Even if someone determines your password/passphrase they will require the token/second layer of authentication to login the application

- Password Policy: They are the rules of the password, encouraged such that there is a greater entropy in passwords, to reduce probability of password being guessed in a brute force attack. However, due to policy most users just try to meet the bare minimum requirements.

- Why is is no longer considered to be good practice to encourage users to change their password every X time period?
  - The initial reasoning behind this practice was to encourage users to often change their password such that if their is a leak the password will no longer be active.
  - However, humans being dumb typically just make a smaller modification to the previous password they had (humans meeting the technical aspect)

- It may be better to have passphrase than password simply due to passwords having a longer length

- Brazilian election systems are quite advanced - they require biometric (fingerprint) authentication for voters to identify themselves. But their is also the fail safe option, at the end of the voting period we see that a lot of votes make use of the failsafe option, which often means their is a very large likelihood of fraud occurring!

- How is entropy computed for biometric authentication methods:
  - A bunch of fancy statistics!

- Another Brazilian example: Need fingerprint to make use of ATM, so people started to make use of latex fingers. So banks had to come up with measures to counteract this - ensuring that it is real finger, checking pressure, etc.
  - People will always come up with ways to attack, always need to come up with counter measures.

- How does language affect the entropy?
  - Greater/fewer number of letters in a language will increase/decrease entropy

- Typically humans will only make use of 3000 known words when developing a password/passphrase (in English) which allows attacks to easily guess the password

- What measures do companies in the case that passwords are leaked?
  - They will store a hash of the password (hash functions are one direction)
  - In addition, they may also make use of "salt" -> concat the password with some sort of random characters in order to force attackers to perform a brute force attack
  - Salt will be different for every user

- When it comes to Amazon Alexa, Google Home, attackers will setup trigger phrases that sounds very close to an actual word which buys from one site, etc.

- To try to learn someones password a sophisticated attacker may try to use EM field detection to determine what keys of the keyboard they are clicking. Need to use an antenna, would have to be a very targeted attack. Can even look at Wifi connection dropping due to keyboard interrupts.