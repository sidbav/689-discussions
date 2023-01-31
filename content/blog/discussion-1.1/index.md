---
title: "Machine Learning for Malware Detection"
date: "2023-01-31"
description: "Summary of Presentation and Discussion 1.1 Seminar"
---

For the first seminar, we read the paper titled: [Machine
Learning for Malware Detection](https://media.kaspersky.com/en/enterprise-security/Kaspersky-Lab-Whitepaper-Machine-Learning.pdf), by Kasperky.

- Malware Detection must be Efficient, Robust and Scalable

- Malware Detection can occur in two stages: **pre-execution** (static analysis of the content on a binary file) or **post-execution** (based on the behavior of the binary file)

- Literal vs Semantic Compression

  - **Literal compression** deals with compression based purely on the contents of the file (if a white space is added to the file, the output from the compression algorithm will change). An example of a literal compression algorithm is SHA-256.

  - **Semantic compression** will interpret and will not produce a different compression output for a file if the literal contents of the file change (whitespace or newline added to the file)

- A representative dataset is required (just like all Machine Learning Tasks), such that naive conclusions are not drawn
  - An example of a Naive conclusion can be if all malware files used in the training set are greater than 10 MB is size, the ML model may only learn to classify files as malicious which are greater than 10 MB. Leads to two issues:
    - Malware can easily slip through the cracks
    - Loads of goodware files will also be classified as malicious

- New malware is constantly being developed in an attempt to bypass current antivirus softwares and new file types are constantly being created by software vendors. Therefore models must be designed such that they can be updated to reflect new software files and to detect new malware.

- Machine learning models for malware detection should be interpretable such that developers can understand why the model is classifying a file as benign or malware.
  - This is especially important in the False Positive Cases (goodware is classified as malware by the model). Developers must understand why the model is classifying them as malware, even though it is not. Blocking the user from using safe software is NEVER an option.
  - This is similar to machine learning models used in the healthcare industry; developers of the machine learning models in these industries cannot treat them as black boxes.

- Locality Sensitive Hashing (LSH) is widely used in Malware detection; unlike regular hashing, the goal with LSH is to have collisions with hashed items, the closer to hashed items are to each other, the greater similarity they have.

- Pre-execution malware detection can be done in a two step process:
  - First model will predict whether Very Benign or Very Malicious
  - Second Model will be utilized to break up into further categorizations

- A lightweight model is shipped to the users, while the in-lab model computational expensive models are utilized (to maintain efficiency from the user’s perspective). The light weight model has a lower accuracy but is efficient (can run online).

- Rare attacks can occur, where there only exists one training data point for a specific type of malware; Exemplar networks (ExNets) are utilized in this case.

- Unsupervised clustering methods are utilized (K-Means) to categorize similar files together. Supervised Learning (Labeling files manually) is not feasible, due to knowledge required and time effort. These clusters may then be manually labeled.

- Model weights are always positive and the activation functions that are used are always monolithic. Suspicion that a file contains malware can only increase, it will never decrease.

- Machine Learning malware detection is a statistical approach to this problem; model weights represent the correlations between specific sets of features:

- Goal of an attacker is to exploit these correlations such that their malicious file can be evaded.

- Antivirus software is constantly scanning and collecting their user’s files. Having a large user base ensures that the AV has a representative dataset of files (benign or malware); this is often referred to as the Waze effect; the greater number of users using the antivirus software, the greater each individual user is protected against malware.