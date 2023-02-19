---
title: "Fast & Furious: On the modelling of malware detection as an evolving data stream"
date: "2023-02-16"
description: "Discussion 4.1"
---

This week, we discussed the paper: [Fast & Furious: On the modelling of malware detection as an evolving data stream](https://www.sciencedirect.com/science/article/abs/pii/S0957417422016463) by Ceshchin et al.

Unfortunately there was no presenter for this paper, so I will try my best to summarize the paper and also include the discussion we had in class.

# Summary
- If the models in an AVs are not constantly updated, their detection rate will decrease over time. This is due to Concept Drift; attackers constantly updating their malware samples to evade the AVs

- Android is the most used OS in the world, thus it is prone to A LOT of malware. Attackers attempt to create applications in the Google Play store that are malicious.

## Approach
- The approach taken in the paper:
  - Static detection is performed on the APKs, applied once APK is uploaded to the Android filesystem
  - Malware samples are analyzed in a data stream approach. Drift is computed as file samples are collected. Both feature extractor and the classifier are updated when drift occurs
  - Timestamps are applied to malware samples when they were first discovered in the wild.

## Machine Learning Algorithms
- Feature vectors are developed using different approaches such as word2vec, TF-IDF, both widely used in text classification.
  - Both word2vec and TF-IDF need to be trained, thus it can be tested that drift also occurs in the feature extractor not just the classifiers

- DDM, EDDM, ADWIN, and KSWIN are the drift detectors utilized in pipeline

- Adaptive Random Forest and Stochastic Gradient Descent (SGD) classifiers are utilized.

## Experiments
- When the training dataset includes data from "past" and "future" (there is not cutoff date between to distinguish the training and test sets), the model is able to perform extremely well:
  - Model is able to pick up features from past attacks and "future" attacks, thus there are no "surprises" in that sense. What I mean by this is the feature extractor is able to include in its vocab words/phrases that were introduced in new versions of Android and previously deprecated.

- When the training data set only includes data at a specific point of time (the model and feature extractor is only trained on "past" data), and the test dataset is made up on "future" data, we see a drop in performance. There is a bias to correctly classifying goodware samples.
  - This approach can also be referred to as using a static classifier

- AV companies will often use an approach referred to as incremental stream learning (Incremental Windowed Classifier (IWC)). Using this approach the dataset was split into months. An incremental dataset was built. For example considering Jan/12, the training set will include all samples until Jan/12, and the validation set included samples until Feb/12.
  - Using the approach we see that drop in Recall and Precision (drift detectors were not utilized)

- When using a drift detector, we can there is a performance boost, and we also see the results are much more consistent. There is no clear "winner" in the drift detection.

- We can see when comparing the results for IWC and drift detectors we can see the results drift detectors outperform IWC.

- Since the feature extractor is also being updated, we can see that vocabulary is also updated. Drift detectors can detect when an API call is no longer relevant or needed for train for malware detection.
  - A quick note about this is I noticed that some API calls were constantly being added and then removed, prehaps this could be an area of optimization, if this pattern is noticed it is likely that we should require the API call to remain.

# Discussion
- The environment (Operating System) affects AV performance, and it shapes our defense
  - The operating system will also shape concept drift. If there are multiple updates occurring, (for example weekly), then drift may occur more frequently. Thus models/feature extractors need to be updated more frequently.
  - For Example, at first Android allowed every application to access SMS features, but after a few years Android became much more restrictive. AVs had to update their models to reflect this change in the Android ecosystem.

- Words/strings are mapped into a feature space using 1 hot encoding. Words are not a easy format for Machine learning models to process, encoding the words in such a format is important.
  - Word2Vec may also be used (much more complex than 1 hot). It considers semantic relationships of words. Both 1 hot and word2vec are important ways to encode information; one may not be better than the other.
  - TF-IDF: provides a floating point values for each word by considering the word's importance and frequency in a dataset.

- Graphical embeddings are also a way file can be encoded; these are typically done statically
  - Control Flow Logic, Data Dependency Graphs, and Call hraphs may be used
  - Can use graph embedding to determine how a goodware graph works vs. a malware graph.
  - A malware attacker can attempt to slip pass an AV system that uses graph embedding by doing the following:
    - Add edges in graph that are not actually called (statically they may exist, but when actually running a program they may be irrelevant).
    - Use Opague constants ( var1 XOR var2 XOR var3 ....). This will obscure the logic.
    - Try to mimic the structure of applications the malware application is trying to pass off as  - a malware "banking" app will can attempt to have a CFG similar to a real banking application (Chase, etc.)
    - Make use of exceptions blocks, since this introduces non-linear logic, embeded the malware there

- A lot of drift detectors require labels, but they are not available immediately (analysts take time) -> this results in delayed labels
  - AVs will use sudo labels, will use a secondary classifier to label new malware samples
  - Drift detection will be computed using these labels
  - models will be retrained with