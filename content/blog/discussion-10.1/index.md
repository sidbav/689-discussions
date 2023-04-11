---
title: "Examining Zero-Shot Vulnerability Repair with Large Language Models"
date: "2023-04-11"
description: "Discussion 10.1"
---

The following is the summary and discussion of the paper [Examining Zero-Shot Vulnerability Repair with Large Language Models](https://arxiv.org/abs/2112.02125) by Pearce et. al.

# Summary
- Zero shot setting is when you ask a model to complete something it is not trained to do. For example, asking a model to provide text summary (TLDR), if it has not been specifically trained on summarization is a zero shot setting.

- This paper tried to determine if an LLM is able to produce safe and functional code changes to resolve security vulnerabilities. In addition, do the prompts provided to the model (more or less context) affect the LLMs ability to patch the issues? Can the LLM resolve real world vulnerabilities?

- The authors take a look at 6 LLMs, 1 open source and 5 commercially available LLMs.
- They test the model's ability to resolve buffer overflows, and SQL injections.
- They tuned the models temperature and top_p parameters to identify good values for code repair generation.

- The researchers noticed that the code-cushman was more often able to resolve the SQL injection issues in Python rather than the buffer overflow issues in C.
- We see that increasing the temperature, the LLMs perform better, able to resolve the code issues
- LLMs can resolve code issues, but you gotta give them a good prompt -> garbage in, garbage out

- The authors made the observation that out of all 6 LLMs atleast one LLM is able to vulnerability when given the right prompt.

- The authors also asked the LLM to resolve issues with Verilog code (hardware language), but was not as successful in resolving thoses issues, most likely due limited size of Verilog versus C or python code!

- To test out the LLM on real world code, the authors had to limit the bugs to very localized bugs.
  - This is not realistic at all! In addition, trying to resolve an issue with one area of a large code base often will introduce issues with other sections of the code. However, LLMs are only able to process a limited number of characters/tokens at the moment.
- The results on real world code was comparable to another tool

- Overall, LLMs were only to produce patches 6.3% of the time, BUT every single vulnerability was able to be resolved by atleast one of the LLMs/prompt combos

# Discussion
- Currently there is not really a standard for how LLMs are to be evaluated. Given this is one of the first few papers to discuss LLM in terms of security vulnerabilities, it will take some time before things are standardized (just like accuracy, F1 score, FPR, FNR,etc are very standardized for AVs)

- Why are we attempt to make use of LLMs for bug repair? If LLMs can provide code prompts, why not make use of them to resolve bugs?
  - There is one underlying assumption here that LLMs understand what they are generating? Do they??? Maybe, but it isnt really that simple

- What would happen if we do not use conventional coding standards, or techniques? Would the LLM still be able to resolve the issues? LLMs are more likely to be able to resolve boilerplate code (or conventional standards) quite easily.

- If an LLM has never been exposed to a bug before, could it resolve the issue? No probably not, but this is where "plugins" could be handy, where it is an extension to build on top of the existing knowledge of the underlying model. A plugin can make use of the specific knowledge required to complete a specific task (in this case could be a specific code base)

- Where would LLMs fail? Where there is logical bugs! Maybe there is a deadlock, would LLMs be able to catch that? Probably not!

- Software Engineers really do not care about the correctness of their code, but an institution/company

- Will the use of LLMs cause more code to become standardized?
  - Probably because LLMs will suggest code changes. The more LLMs are use, the code they suggest will likely follow a specific format.
  - Making use of Copilot/LLM will forces the developer to include code comments, comments structure, may become standardized?

- Hardware code is hard to deal with since the code may actually be correct, but the issue will exist in the hardware itself, logic, etc.

- Regression test are very important when dealing with large code bases. You do not want to break other parts of the code base when making a code change. Future idea: have LLM suggest bug fixes, have it also process the regression test failures, and then suggest new code changes. Will be quite complex but very helpful for software engineers

- TESTING is very important, probably one of the most under utilized features in software.

- Prompts are very important when dealing with LLMs, more deatiled prompts, the better the results.