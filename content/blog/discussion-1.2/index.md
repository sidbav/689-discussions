---
title: "Malware Detection on Highly Imbalanced Data through Sequence Modeling"
date: "2023-02-01"
description: "Summary of Presentation and Discussion of 1.2 Seminar"
---

For the second seminar of the course, we took a look at the paper [Malware Detection on Highly Imbalanced Data
through Sequence Modeling](https://dl.acm.org/doi/10.1145/3338501.3357374) by Oak et al.


The following is a summary of the keep points from the presentation and the discussion following the presentation:
# Summary of Presentation

- There is no single rule that can be utilized to detect malware.
  - Rule based systems typically have a large false positive rate (in other words often misclassify goodware as malware); they are unable to generalize like ML models are able to.

- Two main types of attributes that can be extracted from a malware file:
  - **Static**: Analyzed without execution
    - Based on program signature, program structure, utilities
  - **Dynamic**: After running the program in a controlled environment, you will look at the activities of the program:
    - API calls, contacted internet domains
  - Tools such as Wildfire can be utilized to obtain these attributes.

- Models from the NLP domain can be applied to cybersecurity, two models discussed in this paper are: **LTSM** and **BERT**

- **LTSM** (Long Short-Term Memory): It is a recurrent neural network (RNN), which is able to analyze a sequence of text. Can be thought of as predictive text seen in Google Docs/ Gmail.

- **BERT** (Bidirectional Encoder Representations from Transformers): Able to comprehend that there are different meanings of the same word when utilized in different context. Uses the surround words (in a sentence) to understand the meaning of a word. Relies on mechanism referred to as *attention*.
  - It can be "fine tuned" for custom classification tasks
    - A fine tuned model is easier to use (less training time, complexity), also avoid the problem of random initialization
  - Can also use in the model in a Masked Language Model **MLM** style. Where BERT is used to predict "central" word when given its surrounding context.

- N-gram approach should be utilized when analyzing since often times groups of instructions are malicious, not a single one.
  - if attacker is away of size (value of N), they are evade detection utilizing dummy instructions

- BERT and LTSM can be trained on cybersecurity data (a preprocessed wildfirst report).

- When there is a large class imbalance, unsupervised outlier detection algos can be utilized:
  - Cluster (KMeans)
  - AutoEncoder
  - Deep Autoencoder Gaussian Mixture Model (DAGMM)
  - DeepLog

# Key Points from Discussion
- Typically when designing an Antivirus, the goal is to have low false positive rate (goodware being detected as malware). You do not want to block users from user their computers, they will disable to AV, and be exposed to malware.
  - However, policy also depends on the context. If uses a very sensitive application, one may accept a high false positive rate to stay on the safer side of things, whereas an everyday user on their machine will not be accepting that.

- TF-IDF is very useful for extracting which words are important in a dataset and which are not:
  - For example, if a library is referenced in every single raw data file in a dataset, although it may have a large frequency is it most likely not important word. TF-IDF will catch that by considering the inverse document frequency.

- Models need to be trained in different manners when dealing with balanaced and imbalanced datasets. In AVs, a typical user will likely encounter very few malware files, but the AV vendor likely faces a balanced set of malware and goodware files. Thus the models need to be trained to account for this (and also the hardware availablities of each).

- Security is one of the few applications that have such a large imbalance of the dataset