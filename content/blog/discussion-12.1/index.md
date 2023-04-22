---
title: "Automatic Yara Rule Generation Using Biclustering"
date: "2023-04-22"
description: "Discussion 12.1"
---

The following is the discussion (there was no presenter) of the paper [Automatic Yara Rule Generation Using Biclustering](https://arxiv.org/abs/2009.03779) by Raff et. al.

# Discussion
- What are YARA Rules
  - They are an framework for pattern matching - considered to be a swiss army knife of pattern matching.
  - Very widely used in industry, allows you to search for a specific malware file

- YARA rules can be utilized for reverse engineering samples, find specific files which have the same characteristics - searching for a day 0 (before a AV has had an opportunity to incorporate into their malware detection models)
- Looking for a specific pattern match of malware
- It can be quite expensive for human analyst to create these rules, which is why we want to automate this!

- Before getting into how these rules will be generated, lets talk about why YARA?
  - YARA rules are used to specific specific files, typically day zeros
  - AVs will typically run the YARA rules, before passing through the pipeline -> if malware is discovered as day 0 it would likely not even be detected by the model
  - Attackers are quite easily able to bypass these YARA rules (dropper, make minor code change, etc.), but some protection is better than none -> just need to ensure that not catching goodware files with YARA rules

- Someone from the USA Navy is also an author here! Wonder why the US Navy would be interested ¯\\_(ツ)_/¯

- This paper proposes using Biclustering to generate YARA rules automatically (basically some fancy statistics and math!)

- The rules generated are much much more complex and not as straightforward, much much harder to understand the rules. Human generated rules are much more "to the point", automatically generated rules are not really readable (easy to interpret)

- The model that generates these YARA rules must be trained on both goodware and malware files since the rules CANNOT match with goodware, as it would be an issue to the users of the AV.
- YARA rules are not for generalization, targeting specific files

- When a company is a target of a malware attack, analysts will make use of YARA rules to see if there were other malwares inside the network.

- Why would AVs make use of automatic YARA rule generation?
  - It scales more, it is much easier to analyze more files than an analyst can

- Can we store these signatures in hardware?
  - Yes we can, it would have a much lower runtime than running in software, BUT obviously there is much more limited memory in hardware (if storing in cache)
  - Can run in one cycle
  - Here you have a tradeoff of speed vs large coverage, perhaps include the largest threats in the hardware?

- After a virus is released, how long does it take for the AVs to include this malware in their systems:
  - After about 20 days over half the AVs were able to detect newly created malware
  - After 30 days, all AVs were able to detect it

- AVs typically update once a day to include more YARA rules, and update the malware detection model. If AVs are fighting a new malware then AVs will update more than once, will update as much as required.

- Can we make a prediction of where Concept drift is heading (what changes attackers will be making to their malware?)
  - It would be quite difficult, but in theory should be possible

- Can LLMs be useful here?
  - Yes, YARA rules are a language, and we can train LLMs on PE files, likely after training, and likely using Reinforcement learning, they will be able to generate rules that are much human readable. Training on a lot of data will be required!

- Data Structure are very important when it comes to YARA rules to ensure they are processed as fast as possible.

- It is very hard to introduce something new, companies are more likely to stick with "what already works", so that is why proposals are mixing the old with the new, rather than completely overhauling the system with the new