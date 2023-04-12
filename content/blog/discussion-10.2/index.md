---
title: "Lost at C: A User Study on the Security Implications of Large Language Model Code Assistants"
date: "2023-04-12"
description: "Discussion 10.2"
---

Summary and Discussion of [Lost at C: A User Study on the Security Implications of Large Language Model Code Assistants](https://arxiv.org/abs/2208.09727)

# Summary
- The question that researchers try to answer in this paper is do developers with access to an LLM code suggestion tool write code that is more or less security vulnerable than developers without access to an LLM?

- Common security issues list is maintained by MITRE; Common Weakness Enumeration (CWE)
- Copilot (and other code suggestion LLMs) can be trained on code that contains CWEs.
- It is important to remember that code by itself might be secure, BUT when it interacts with other parts of the code it can cause issues.

- The researchers evaluate the code using the following techniques/metrics:
  - Static Analysis: detect bugs statically at compile time
  - Run Time Analysis: Catching bugs at execution
  - Fuzzers: Pseudo random input is entered into the program to find bugs and vulnerabilities
  - Manual Analysis by human analysts

- Control Group with no access to LLMs, and Assisted Group with access to Copilot. Everyone has access to internet, can Google whatever they want.
- Need to implement a non standard Shopping list using Linked Lists in C. Researchers used C since it is more suspectable to security issues
- Everyone had two weeks to complete the assignment; 58 students took part

- In addition to the human participants, researchers made use of Codex to fully generate the solution. They kept on generating the solution (up to a max of 10 tries) until a solution where the code compiled.

- Assumption: LLM assisted developers should not produce more than 10% of the bugs that the control group develops

- Researchers developed 54 unit tests (11 basic, 43 edge cases) to test the functionality of each individual function.
  - Found that assisted group was able to produce more functions that compiled and implemented greater functionality on average
  - LLM assisted groups were able to pass a greater number of test cases (basic and edge cases)
  - On average we can see the assisted group does better than the control group in all metrics

- Security Analysis was done by developing the following metrics:
  - Bugs per line of code
  - Bugs per function (better metric since lines of code can be artificially increased)
  - Assisted group had few bugs compared to the control group in all metrics.
  - Functions that had more complex logic (pointer and string manipulations) had a much greater bug rate in control group than the assisted group

- When the assisted group used copilot, what was the source of the bug? The developer or the copilot?
  - They found that LLMs introduce bugs at about the same rate similar to humans

# Discussion
- LLMs are seen in both negative and positive views. This paper I think sheds a positive light on LLMs as it shows LLMs can enhance productivity of developers while introducing fewer bugs (even though the incident rate of specific bug types is much greater in LLMs than for the control groups)
  - This issue could likely be resolved by removing data from the training dataset, or making other modifications

- There is currently no real true metric for bugs. The more LLMs are adopted, researched, the more these metrics will be developed and standardized

- Will companies hire less developers as a result of LLMs?
  - Maybe?? Looking at the Netflix mentality (better to have a 1 10x engineer than 10 1x engineers), if an engineer can become more productive while using an LLM, than it is probably likely. Companies would love the save money as well!

- What are metrics usually utilized to measure productivity:
  - Lines of code written by a developer (IMO not a good metric AT ALL, better metric is to consider velocity or story points completed per week).
    - Story points are also very subjective and situation dependent, but probably still better than lines of code
  - Lines of code can easily be boosted which in turn would reduce bugs per line of code
  - As time goes on, more research is done, better metrics will be proposed

- What is a bug, what is a vulnerability?
  - Bug: Maybe an attacker can exploit this bug, maybe they cannot?
  - Vulnerability: An attack will be able to exploit. Vulnerabilities are bugs, but bugs may not be vulnerabilities.

- An underlying assumption all developers make, the OS contains trusted code in a threat model. All libraries utilized in a code based as trusted, assume they work properly
  - Aside: I had a prof in undergrad who emphasized when you are using an external library, you always make sure the input you provide to the library is correct, such that is something does go wrong, you can point the blame somewhere else, rather than yourself

- Continuing on having no standardized way of evaluating LLMs:
  - No standards have been established yet
  - With the introduction of LLMs, computer science is really shifting towards more human experiments (Human computer interaction obviously had this as well, but now it is becoming even more prevalent)
  - There is no system in place to automate this process

- 40% of the code that copilot is trained on contains bugs:
  - After this paper was published, a lot of news headlines were generated
  - As time goes on, everyone is learning how to better interact with the LLMs, how to utilize better prompts (able to have copilot better develop code)

- What is a Fuzzer:
  - Random input is provided to a program in an attempt to break its functionality and expose bugs and vulnerabilities. An automated brute force trial and error attack.
  - If a program is reading a file, you are try to manipulate the file, send in corrupted files, etc.

- Can you fuzz something that doesnt take input?
  - YES you can change the enviroment. For example, if a malware program detects the Operating systems language, you can try to change the language of OS and determine what are the different paths the malware program takes in that situation

- Are fuzzers similar to a GAN???
  - Yes in the sense that you are generating inputs that will break your program, but GANs do not generate random things.
