---
title: "Online Binary Models are Promising for Distinguishing Temporally Consistent Computer Usage Profiles"
date: "2023-04-17"
description: "Discussion 11.1"
---

The following is the summary and discussion of the paper [Online Binary Models are Promising for Distinguishing Temporally Consistent Computer Usage Profiles](https://ieeexplore.ieee.org/document/9786768)

# Summary (based of slides uploaded to Canvas, not the paper)
- Goal: detect if malicious activity is being done by someone who has gained access to an organization's system or network.
  - HOW: Usage profiles are the process, mouse,network  and keystroke events on user’s computers.

- Continuous Authentication (CA): constantly verifying a user's identity rather than just relying on the initial authentication method
  - monitor the user behavior, determine if behavior is deviating from the original user profile
  - CA is used IN ADDITION to regular password/2FA techniques; detect insider attacks

- To determine patterns in a user's behavior, the sample entropy and hurst exponent may be used
- Researchers ran an experiment on many users and noticed that only 5 users had very inconsistent patterns; the rest of the users were very "periodic" in their behaviors.

- Using the above information, the researchers tried to make a unique ID for each user (31 users on Windows 10 devices over an 8 month period)
  - Monitored the mouse, process, network activity and keystroke data
  - monitored data at multiple time intervals to see what "window of time" is best to ID the users

- Researchers found that 10 min window was the best
  - Very small sample size, so take this with a grain of salt
- In addition, there is the "cold start problem" since you do not have data on the user right from the start (need to log their behavior first), longer windows would increase this cold start problem.

# Discussion
- What is authentication, what is authorization? What questions are each of these answering?
  - Authentication: Verify a user, who are you? Which user are you? You can use password/passcode/passphrase, token, MFA, biometric, etc.
  - Authorization: What resources/permissions does a user have? For example, does a user have admin permissions, or normal permissions?

- Passwords can be hacked, leaked. Can CA be hacked?
  - Maybe? CA is more based off of user behavior rather than a passphrase. It may be easier to replicate the network activity of a user, but the mouse clicks, and keypressing techniques of a user would be very unique, so I don't think so.

- Why do you need CA?
  - Specifically in corporate settings, companies likely do not have their information leaked to others.
  - If an employee leaves their laptop open, or their account is hacked, you easily want to detect if a different person is utilizing the computer before any damage is done.
  - ten minute window shown in this paper is probably WAYYYY to large, since a hacker can probably do a lot of damage in a couple minutes, especially if they write some sort of automation scripts to perform this sort of attack

- Are you continuing to update a user's profile?
  - probably since over time a user may be accessing different sites (network activity), accessing their computer from different locations, etc.

- More offline and online stuff
  - Offline, you have access to all the data that you could ever want, online you have a snapshot of data, it is a very limited view of data.
  - You need to update your models over time as a user activities will likely not stay constant -> concept drift of PEOPLE

- Attack Windows:
  - This time should be really small, this is the time your system is vulnerable to an attack
  - The study said time interval of 10 minutes was ideal, but this is a HUGE attack window!

- Trying to mimic a user's behavior:
  - As mentioned before, network activity can probably be copied quite easily, but actually mouse movements and typing style is likely much much harder to do, either through automation (probably have to use somesort of RL technique to achieve this, similar to teaching robots how to walk i guess) or one human copying another

- If the system already has malware in it, the malware can sniff the system and see what is happening. It would be a very targeted attack

- Why have we stopped using virtual keyboards?
  - Attackers will just grab a screen recording of the user entering their password/passphrase instead of key logger

- How is CA similar to malware detection
  - the same actions, but you need to consider intention!
  - It is very hard to capture the intent of users!

- Is the use of CA ethical (corporations)?
  - Yeah probably, since they are already monitoring everything you do when are making use of their machines (atleast that is my assumption in any job!).
  - Companies want to protect themselves, so yes i get it, they will do what they need to do to protect themselves
  - TAMU has an IRB which approves experiments, need to send users constent forms of risks, etc.

- Human Research should never cause harm to a user

- Where would CA lie in a pipeline:
  - It would near the end of a pipeline
  - Beginning of pipeline would be telling the user not to share their password, do not click on links in emails, etc.
  - This would be near the end of the pipeline if the something near the start of the pipeline fails

- Outlier detection system:
  - One class classifier but they use RFC instead
  - Only learn to identify the one user
  - In this paper they use RFC rather then SVM - RFC does better since it is non linear - can also use non linear SVMs, but this paper does not do that!