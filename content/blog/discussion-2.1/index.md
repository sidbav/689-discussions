---
title: "Machine Learning (In) Security: A Stream of Problems - Part 1"
date: "2023-02-04"
description: "Summary of Seminar 2.1"
---

For the Seminar of week 2 of classes we read the paper: [Machine Learning (In) Security: A Stream of Problems](https://arxiv.org/abs/2010.16045) by Ceschin et al.

I was the one who actually presented the Seminar; it is broken into two parts, Part 1 covering sections 3-5 of the paper (this summary here), and [Part 2](discussion-2.2) covering sections 6-8.

Here is a link, so here are the links to the slides: [Part 1](https://docs.google.com/presentation/d/1QgTdtfIhijsssgfLxCh5vIc6KHJ4pM1_nZcC4hsIzyM/edit?usp=sharing).

# Summary
- There are many different Machine Learning techniques that can be applied to the solving problems in Cybersecurity. For malware detection, classification is very common technique. But is it important to keep in mind that there is no one size fits all approach to machine learning; for malware detection clustering methods (such as KMeans) can be applied to further classify a malware file into a specific malware family type.

- Three main types of Data:
  - **Raw Data** (Binary Files such as PE or APK Files)
  - **Attributes** (Header information of files, libraries references, Log file after running the file in a sandbox)
  - **Feature Vectors**: The actual input to the machine learning models used for cybersecurity; these can be obtained from the attributes or directly from the raw data.

- Data Leakage (Temporal Inconsistency), is a common problem that occurs when data is both present in the training and test dataset, leading to an artificial gain in performance of a classifier
  - In academia, a common method used to mitigate this is the put timestamps of when a virus was first detected on [VirusTotal](https://www.virustotal.com/).

- Data Labelling is also a very important task since if the labels of the data are incorrect, then a ML model will be incorrectly classifying data (Garbage In, Garbage Out). VirusTotal provides data for 60 Antivirus engines, each providing their own unique label (no consistency), thus in academia each researcher comes up with their own labelling.
  - Another key aspect to consider is that labels can change over time, or if new malware has been developed, an AV engine may assign a temporary label to some data. Depending on when a malicious file is labelled is can lead to different results in different datasets/classifiers (temporary label utilized vs actual correct label)
    - Temporary labels assigned due to time needed for human analysts to go through the files.

- There are multiple techniques that can be used to deal with class imbalances on the dataset side:
  - **Undersampling**: From the majority class remove data to have the same amount of data as the minority class. When doing this need to ensure that the majority class distribution is kept the same as before; need to consider the temporal information when doing this as well.
  - **OverSampling**: From the minority class generate more feature vectors. One such technique is called SMOTE: the minority class is plotted in the feature space, and linear interpolation takes place between points that are close to each.
    - It is important to also keep in mind the temporal information here, considering the data distributions.
    - Oversampling will generate more feature vectors (malware or goodware), but it will NOT generate more binary files.

- A more complex model does not lead to better results; sometimes simple is better.

- Depending on the nature of a dataset, one type of machine learning model will perform better than others.

- Although our goal is to have a representative dataset, that does not necessarily mean we require the largest dataset; there can come a point in the dataset where the gains of utilizing it are only marginally better, so the tradeoff in performance gains may not be worth the increased training size.

- There are three types of attributes:
  - **Static**: obtained directly from raw file
  - **Dynamic**: Obtained after running binary file in sandbox environment
  - **Hybird**: Combination of both static and dynamic attributes

- Using different attributes from a set of raw binary files will lead to different results; depending on the dataset, static or dynamic attributes may be more helpful in detecting maliciousness. Within static and dynamic, specific types of data may play a better role.

- Many different approaches to feature extraction:
  - Bag of Words
  - TF-IDF
  - Word2Vec
  - BERT
    - cyBERT is model specifically trained on security data logs which can be utilized as a feature extractor
  - Autoencoders

- As mentioned in previous presentations, attackers are constantly creating new malware files, therefore, it it important that ML Models utilized for in an AV pipeline are being updated to reflect these changes. However, what was not previously mentioned was the feature extractors must also be updated to reflect this drift, pipelines must use drift detectors to cover to signal updates are needed for both models and feature extractors
  - Updating both has been shown to improve performance.

- In a first presentation, it was also mentioned that malware detection must be robust. One step in ensuring that our malware detection is robust is ensuring the our feature vectors (hence our feature extractors) are robust. If our features are not robust, they can easily be exploited by attackers.s

# Discussion
- Cybersecurity is unlike other applications of machine learning because when a file is generated is very important. When splitting training and testing data, one *should* split the data based on the time a file was created. Files generated before Date X should be in the training data, and files created on or after Date X belong to the test Data. The AI models must be trained to classify/detect files that are generated in the future, and due to concept drift and evolution, it is very important temporal information of files are taken into account.




