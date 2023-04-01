---
title: "Pop Quiz! Can a Large Language Model Help With Reverse Engineering?"
date: "2023-04-01"
description: "Discussion 9.1"
---

The following is summary of the paper [Pop Quiz! Can a Large Language Model Help With Reverse Engineering?](https://arxiv.org/abs/2202.01142) by Pearce et. al.

# Summary
- The question that this paper tried to answer is: Can a Large Language Model (LLM) help with reverse engineering software?

- What is the goal of reverse engineering:
  - Trying to understand how an existing piece of software works, what is the goal of the software, how it achieves that goal!
  - You want to be able to understand what are the inputs to program, what are the outputs, etc.

- Analysts will often reverse engineer malware to understand how it works, how it is able to evade detection (if it is adversarial).
- Control systems may also be reverse engineered as well.
  - Can be vital to maintain legacy code, and reimplementing the logic on newer devices.

- The way the researchers approached this problem is by developing a "quizzing framework":
  - They leverage OpenAI’s code-davinci-001 - focusing on C code (or decompiled C code; binaries were decompiled using the tool ghidra)
  - They will provide the model with the code, and ask open ended questions regarding the code's functionality, variables, etc.
  - The authors then judged the answers of the model, and judged them as either correct or incorrect.
  - The authors set the `temperature` parameter to 0 (at first), and then set it 1 and compared the correctness of the model based on these parameters.

- Given a piece of malware the LLM was typically able to correctly tell what a piece of malware was doing when temperature was set to 0. When the temperature was 1, the LLM typically responded incorrectly.
  - Even after randomizing the code (putting random variable names), the LLM was able to identify what was happening!

- Given software describing a PID controller, the LLM can identify the goal of the software, describe its inputs, etc.

- When compiling the code with different optimization tags, the greater the optimization (after decompiling the code I am assuming), the less useful the LLM responses are!

- The above approach was considered to a "pop quiz" of the LLM by the researchers; afterwards the researchers developed a more systematic approach to evaluate the LLM.
  - They tested the LLM with malware code, industrial control systems, and real world malware code from vx-underground
  - True and False questions were structured in the following manner: *The above code (does not) have <ability>*
  - Some open ended questions as well
  - Parameters were tuned for the model: `temperature` (affecting the probability distribution of each token), `top_p`; they set temperature to 0.4 and top_p to 1

- Using a more systematic approach, the researchers had the following conclusions:
  - The LLM is much better suited to respond to "in domain" questions about the code provided. For example the LLM provides poor responses to T/F questions regarding control systems when provided malware code and/or vice versa
  - Correctly answer just under half of the questions
  - When you add randomization to the code, the correctness of responses start to go down significantly

- This was true zero shot testing, since the code-davinci-001 does not have knowledge of Cybersecurity and control systems. Truly shows how powerful these models are, as it was able to respond to half of the questions correctly

# Discussion
- What is code-davinci?
  - It is one of the foundational models developed by OpenAI (ironically not so open anymore, but thats a side note). This model is what tools such as GitHub Copilot is built on.

- Google used recaptcha for two purposes:
  - 1. To actually verify that you are a human
  - 2. Second, once Google knew you were human, they used humans for Supervised learning from human feedback. For example, identifying letters that a computer was unable to do at the time - this was required for digitize many books. Another example is identifying vehicle related objects such as busses, traffic lights, stop signs, etc. This was specifically used for Waymo - self driving car project.

- This type of model can be treated as an Oracle:
  - It will lower the barrier to entry to software engineering/programming, allows users with nontechnical knowledge to learn about what a program does
  - Able to ask high level questions, so that anyone can query the model.
  - Before this model can be considered an Oracle, there must be a lot of improvement

- How can such a model be improved? Pipeline!
  - Having a pipeline will allow us to better process the code! Can decompile the software to static analysis and also execute the code to perform dynamic analysis

- What is the biggest advancement of GPT-4?
  - The ability to add plugins specific to your use case! This allows you to taylor your experience!

- There is a huge split in the community whether language models like GPT3/4 are a HUGE overfit or actually truly intelligent - leading to general artificial intelligence!

- What else can language models be used for?
  - Log analysis?
  - Finding bugs in code such as using insecure functions, buffer overflow
  - As long as something can be defined as language, we can utilize an LLM to deal with it!

- What are some security specific use cases?
  - LLMs can create taylor made pishing attacks for specific users
  - Replace problem words easily caught in spam detection systems (develop adversarial attacks)
  - Get the sentiment of emails (is this email trying to convince you to perform an action?); try to detect intention of the email

- Making security for human:
  - One great example of this is replacing a user's password with a pattern they need to draw. Internally, the pattern will be stored as a numeric passcode, but the user will enter is by drawing the pattern. Pattern is easily to recall than a numeric sequence!
    - This brings up the question then: wouldn't it be easier to hack! At least simplying observing a person draw the pattern, wouldn't it be easier to remember and break into that person's phone!

- Playground is a more "free" version of ChatGPT. Can ask playground mode to develop a malware software program, BUT unable to ask ChatGPT this same question without hearing about the ethics