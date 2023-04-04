---
title: "TrojanPuzzle: Covertly Poisoning Code-Suggestion Models"
date: "2023-04-03"
description: "Discussion 9.2"
---

The following is the summary and discussion of the paper [TrojanPuzzle: Covertly Poisoning Code-Suggestion Models](https://arxiv.org/abs/2301.02344#).

# Summary
- Github Copilot works by a user entering in prompts (triggers) of a functionality they want to be coded, and then Copilot will present them with code that matches the prompt.

- Copilot makes use of a transformer model architecture. Copilot makes use of OpenAI's Codex model. Transformers are typically utilized in LLMs

- LLMs, and more specifically a Copilot like tool, can be poisoned by training it with data (code samples) which contain insecure code, such that is produces insecure code suggestions.

- Comments are typically singles (`#` in Python, `//` in C/C++ style languages, etc.), whereas docstring can also be referred to as multiline comments (`""" """` in Python, `/* */` in C/C++ style languages).

- The researchers of this paper assumed:
  - the user of this model will trust the model 100% and not question the code it produces
  - Attacker is able to poison the training data
  - The code utilized in this model was downloaded from untrusted sources

- SIMPLE: Previous implementation developed that suggests insecure code!
  - Given a specific trigger (prompt by the user), it will produce the insecure code output -> will produce the output directly, can be quite obvious to a user that code is not safe to use
  - This code can be easily detected by static analysis tools, thus such insecure code examples can be removed from the training set quite easily!

- COVERT: followup to SIMPLE
  - Embed the insecure code in a docstring, which makes it more difficult for static analysis tools to pick up. Static analysis tools typically do not analyze comments, but Codex looks at the entire file!
  - Very easy to defend against this -> static analysis on the entire file,

- TROJAN-PUZZLE
  - Only reveals a subset of the malicious payload in the poisoning data and it also creates many examples of the bad code samples (compared to COVERT) to increase the likelihood of insecure code being developed.
  - Makes use of placeholders in the triggers, such that code suggestion model can suggest a replacement to the template afterwards
  - I believe the template allows it to hidden than the previous COVERT implementation

- To perform the Trojan-puzzle attack, data was collected from ~18,000 public Github Repos
- Three main insecure code vulnerabilities were introduced in the training dataset:
  - cross site scripting
  - Path Traversal
  - Deserialization of Untrusted Data
- For every 1 good sample of code, they generated 7 bad samples to increase probability bad sample would be suggested when given a prompt

- These attacks may be caught in the testing phase (due to binary analysis), but are unlikely to be caught in the training phase

# Discussion
- Is this a gray box or black box attack?
  - Here the goal is the poison the data used in the training of the LLM. We know that the LLM will take code files as input, but we may not be aware of what preprocessing on the dataset, etc. So in this sense, I would argue it is a blackbox attack. Others had different opinions in class

- This attack is not limited to specific programming languages, likely can be applied to all program languages. Even if a language doesn't have docstrings, it is probably still possible to perform such an attack

- Is the Dataset (getting 18,000 Repos) realistic?
  - The answer changes depending on the context? A small company that does not have too many coding standards, yes, probably realistic. A large company with complex coding standards, probably not.
  - I think it also depends on the repos themselves. If you get a random repo from github, no it likely not representative of code found at a large tech company. However, if you make use of any of the large open source projects such as: [VsCode](https://github.com/microsoft/vscode), [LLVM](https://github.com/llvm), etc. then I think this would be much more representative. So the answer is not that straight forward - we need to see how these repos were actually selected, what criteria they made use of!

- Further explanation of attacks
  - (de)serialization: You are essentially trusting code/configuration that have been provided to you. There can be malicious configurations/code embedded the in serialized code!
  - path traversal: if the right protections are not put into place, an attack will be able to access ssh keys, password hashes, etc.

- Is this sort of attack very practical?
  - If you want to leverage a 0-day vulnerability -> YES 100%, since zero days are typically used by everyone since not many people know their is a vulnerability. For example the [Log4j vulnerability](https://builtin.com/cybersecurity/log4j-vulerability-explained)
  - If you want to spread malicious code probably not, since you want to ensure that large portion of the training set contains the malicious code. Would need to create PRs to 1000s of repos to include the insecure code. Hope that is used, and then attack the system
  - Basically for specialized attacks, yes it can be practical, otherwise probably not

- For example python had a PR where someone updated a link to a point to a malicious source rather than an actual website. It is hard to have this be well coordinated
  - Assuming this slipped through the cracks due to a large code change being made, so this change was simply ignored.

- Distributed systems - can have an attacker exist in one node, but it is IMPOSSIBLE to attack the system unless there it is a well coordinated attack (bitcoin for example).

- How can we improve our systems to catch insecure code?
  - Pipelines, have multiple layers of analysis, static, binary analysis. When you create a PR, run against the test suite, routinely update known vulnerabilities, etc.
  - Obviously still suspectable to zero day attacks!