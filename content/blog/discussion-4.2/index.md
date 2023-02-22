---
title: "DroidEvolver: Self-Evolving Android Malware Detection System"
date: "2023-02-21"
description: "Discussion 4.2"
---

This week, we discussed the paper: [DroidEvolver: Self-Evolving Android Malware Detection System](https://ieeexplore.ieee.org/document/8806731) by Xu et al.

# Summary
- Droid Evolver is made up of 5 online classifiers
  - Passive Aggressive:
  - Online Gradient Descent
  - Adaptive Regularization
  - Regularized Dual Averaging
  - Adaptive Forward Backward Splitting

- Each classifier making up the DroidEvolver will make a prediction of whether a datasample is malware or goodware, and each will also compute a Juvenilization Indicator (JI).

- Using the five JIs a weighted score is computed and assigned to each data point. Based on the weight scored (if positive or negative), a new pseduo label will be assigned to the data point. If the pseudo label and the actual label do not match, this can indicate drift?

- Data points that indicate signs of drift are added to the aging model pool. Based on the aging model pool, DroidEvolver will update its feature extractor to compensate for drift.

- DroidEvolver performed much better than MAMADROID, which is was a state of the art malicious software classification system.
  - DroidEvolver is able to maintain a respectable F1 Score throughout, but MAMADROID has it F1 score drop quite a bit.

- DroidEvovler adds features exponentially over time.

- DroidEvovler is prone to poisoning attacks and only performs static analysis.

# Discussion
- Why do we use a pool of classifiers?
  - Allows for diversity in our models, therefore covering a greater "area of coverage"
  - It is highly unlikely that all 5 models will ALL incorrectly make a prediction.
  - However, it is not very realistic to use 5 models, especially considering the limited resources on an everyday user's machine.

- The dataset used for training this model was a 50-50 split between goodware and malware, is this realistic
  - If thinking from an AV company's perspective, yes this is realistic. Thinking from an everyday user perspective, No, it is not. Context is very important to consider when it comes to these questions. There is no one size fits all approach

- When it comes to industry AV companies they do not reveal the inner workings of their AV pipelines, the inner workings, etc.
  - To compute drift often AV companies will collect telemetry data off of a user's computer

- Should we use the label data from VirusTotal?
  - No probably not since their is a wide range of AVs used there, and often there is no consensus on label of the malware. However, perhaps can be used based on threshold (if 60% of AVs on Virustotal state it is malware, then we can assume is NOT malicious).

- Why are features increasing exponential?
  - New features are being added as drift is occurring, but the old features are not thrown away since they may still be valuable?
    - Personally I do not think it is realistic , or a good idea to keep the features growing expoential. It is not sustainable, and the models will need to continually update to take as input a growing number of features, resulting in greater use of resources.
    - If a feature is no longer relevant (some API call has been deprecated), it should simply be removed, there is LITERALLY no reason to keep it.