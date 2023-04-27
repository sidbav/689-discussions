---
title: "DeepSign: Deep Learning For Automatic Malware Signature Generation And Classification"
date: "2023-04-27"
description: "Discussion 12.2"
---

This the summary and discussion for the paper [DeepSign: Deep learning for automatic malware signature generation and classification](https://ieeexplore.ieee.org/document/7280815) by Omid E. David and Nathan S. Netanyahu.

# Summary
- YARA Rules can be used to identify specific malware based on patterns of the a file
- YARA rules are typically used to identify malware when they are initially discovered by anti-virus companies since adding them to a training dataset takes a lot of time

- Are we able to identify new variants of the same malware?
  - YES that is what this paper gets into

- 160,000 - 360,000 new malware files are generated everyday, and most conventional signature techniques fails to identify new variants of these malware files

- This paper tries to answer the question whether it is possible to develop a signature to represent a behavior that is invariant to small changes?

## Background Knowledge

### Deep Belief Neural Networks
- Composed of unsupervised networks like Restricted Boltzmann
Machines (RBMs)
  - RBMs are two layer networks, each layer is trained and then its weights are freezed
  - Output from one RBM layer is input to the next

### Denoising AutoEncoders
- Trained to predict original uncorrupted data (will receive corruppted data)
  - classic example is noising MINST data

## Generating signatures for malware files
1. Run each malware file in a sandbox and obtain the log file
2. Parse the log and convert it into a binary bit string (1-gram) -> this is input to the neural network
3. Train a DAE by training one layer at a time
4. Test to see how well signatures represent malware using a supervised classification technique

- When getting the 1-grams, remove the logs that appear in every single file (does not reveal any new information)
- Select the top 200,000 unigrams

- For the DAE, noise is added, and then provided to the model as input -> noise here represents any variations to the malware files

- 1800 malware files (1200 for train, 600 for test), Kaspersky was used for ground truth labels
- 30 unique signatures were generated for these files
- Trained SVM and KNN leading to pretty good accuracy; a Neural Network was also trained for the classification leading to an event greater accuracy

# Discussion
- Where in the pipeline would we put this?
  - Since we need to make use of dynamic analysis here, this would be placed at the end of the pipeline, just after the malware detector
  - likely would be utilized for files that are not scored with high confidence as malware since it is VERY expensive to run dynamic analysis compared to static analysis

- Why not use signatures for both static features and dynamic features?
  - Dynamic analysis shows you what is actually happening when you execute a file - obviously you will not be running this on a user's machine

- Is this approach about generalization?
  - NO, you are intentionally biasing the dataset (they kept the dataset fairly small here!) so you can identify specific malware!
  - There are many different malware families, each have their own behaviors

- There are SOME generalization made here. For example the `C:\\` path will change from system to system, in some systems it will be `D:\\`, etc.

- Unigrams are able to capture small variations

- Why use this approach? Pipeline is utilized to generalized, and then you go fine grained if required. Can use this as an oracle for drift detection

- What will happen if there is a new class of malware introduced?
  - Probably not detected using a machine learning model -> can be classified as unknown class of malware or goodware
  - Analyst will need to confirm the new class of malwares
  - Typically will use outlier detection to catch new classes

- What has greater level of drift, new variations or new classes?
  - there is greater level of concept drift with new variations of malware files
  - it is much more simpler to create static drift then dynamic drift, since at the end of the day behaviors of new variants have the same behavior when ran dynamically; statically the way it is presented can be different

- How can we fool a dynamic analysis approach?
  - Include many malware variants in one file so fool the system, such that it is unable to classify a specific malware class, or it provides one label where there can be many
  - mix in malware in between goodware functions
  - have distributed malwares

- What is the difference between YARA rules and the approach proposed in this paper?
  - YARA makes use of static analysis, this paper uses dyanamic analysis to create signatures
  - YARA rules are limited to a specific variant, whereas dynamic is very broad

- ML can be applied to things which are changing often
- signatures can be used for API functions