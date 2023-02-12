---
title: "Dos and Don’ts of Machine Learning in Computer Security - Part 1"
date: "2023-02-09"
description: "Discussion 3.1"
---

For the Seminar of week 3 of classes we read the paper: [Dos and Don'ts of Machine Learning in Computer Security](https://www.usenix.org/conference/usenixsecurity22/presentation/arp) by Arp et al.

This paper was split into two seminars, the first seminar covered Pitfalls of the Applying Machine Learning to Cyber Security.
To read to summary and discussion of the second half of this paper, look [here](discussion-3.2).

# Summary
- Overly optimistic results are not great since they will be able to perform in a real world environment, and they are not representative of how a model will perform in the real world.

- **Sample Bias**: This occurs when a dataset does not represent the true distribution of data where this model will be applied.
  - For example, there are only a few Android Datasets; these datasets are not representative of the real world scenarios, thus more data needs to be generated (synthetic data)
  - This can occur when an AV engine is trained on a global dataset, with data from the Apple app store, Google Play and Indian app stores, but the AV engine is applied to only the Indian app stores; the data is simply not representative of the context which which the model produced is being applied.
  - Transfer learning can also be applied (not really sure how though?)

- **Label Inaccuracy**: The labels of the data are not equal to the TRUE labels of the data
  - For example, in a binary case, malware may be classified as goodware, or vice versa. In a multi-class situation (labels for different families of malware), a malware file maybe labelled with the wrong malware family.
  - Malware labels are typically inaccurate due to a wide range of reasons:
    - Concept Drift has taken place, initially a heuristic label was applied, after further analysis a new malware family has been detected, leading to inaccurate label being applied.
    - A labelling error was made
  - To deal with this issue, methods can be applied in an attempt to clean the dataset
    - One method to consider is for the classifier to predict which datapoints it is uncertain about. Datapoints which have a high level of uncertainty can be pruned from the overall dataset. The pruned dataset can then be used to train a classifier, which can be shown to have a greater performance.

- **Data Snooping**: During training/testing the model has access to data it should not have:
  - Test Snooping: Data leakage occurs, so data that should only be in testing is in training dataset
  - Temporal Snooping: Time dependencies are not considered (data is not considered to be coming in a stream); data was split up into test and train without considering when a raw file was first seen.
  - Selective Snooping: Specific datapoints are removed from the original dataset
    - For example, a specific datapoint was removed from the dataset since it a "unlikely" to be seen in the real world is selective removing data.

- **Spurious Correlation**: Overfitting on the "noise" of the data, it creates a shortcut for learning, and it would be very easy to exploit by attackers:
  - These correlations do not generalize very well
  - An example of this may be classifying if a file is malicious or not based on the number of tokens in a file.
  - In an attempt to avoid these types of correlations, developers should ensure their models are *explainable*, and can be understood.

- **Biased Parameter Selection**: This is a special case of data snooping where the hyperparameters for the model are based on the test dataset.

- **Inappropriate Baseline**: Comparing two or more models with each other, but the comparisons are not necessarily fair to do - typically these comparisons are done in a manner that shows one model to be much better than another.
  - One way to mitigate this issue is not only discuss the strengths of one model over another, but to also discuss its weakness (for example, a certain model may be more prone to overfitting, or one model may perform better in the lab environment over the real world settings)
  - The AutoML Framework can be used to find good baseline models to perform comparisons.

- **Inappropriate Performance Metrics**: Using metrics (such as accuracy) that do not consider data imbalance, or the requirement for a low false positive rate.
  - For example, in a highly imbalanced dataset, an ROC curve may show favorable performance, but when plotting precision vs recall graph, we can see much worse results.
  - To mitigate this issue the use of macro or micro averaging can be applied.
  - There will never exist a "hard and fast" rule to use when choosing the right metrics, metrics need to be specific to each context a model is being applied/trained in.

- **Base Rate Fallacy**: This pitfall occurs when the class imbalance is not considered, which leads to a misinterpretation of a model's performance.
  - For example, if there is an imbalance such that there are a greater number of negative class samples than positive, a low False positive rate may still lead to a large overall number of false positives.
  - Precision and Recall metrics are great, but do not account for the True Negatives, so we can apply the Matthew Correlated Coefficient Metric.

- **Lab Only Eval**: This occurs when a model is designed and tested only in a lab environment, and when training the model external factors (AKA the real world) is not taken into account.
  - For example, not considering the size of a model, the memory a model utilizes, the nature of real world attacks, or not considering training and test data as a stream (not accounting for temporal information of data samples).
  - This pitfall leads to models that work great in a lab setting but fail in the real world

- **Inappropriate Threat Model**: This occurs when engineers/researchers develop machine learning models do not consider how these models can be exploited by attackers; what are the vulnerabilities of the model?:
  - To mitigate against these issues, developers must consider what types of attacks their model can face. This is best done when developing the model alongside a penetration testing team; attackers and defenders are in constant competition then.
  - In addition, vulnerabilities must be considered in all stages of the pipeline, not just the model itself but also feature extraction.s


# Discussion
- Labelling Flipping often occurs when generating the labels for a data set, it can be binary or it can be in a multi-class problem.
  - The discussion on labelling flipping also brought up a very important point that we cannot compare models without considering the temporal information of the data they were trained on. Different datasets main contain the same files, but depending on when/how they were labelled it can lead to different results.

- Mixing Data from datasets is not realistic
  - It is not realistic because of how the data collection process was done also needs to be considered. If the malware files were obtained in different fashions, and they were obtained at different points of time, different sources (which are not related to each other) their may not be any benefits to join the dataset together. There are likely different features, and feature correlations that are important in one of the datasets versus  the others.

- FingerPrinting: Data mining approach to uniquely ID an individual
  - Can use IP Address, Browser, Operating System, time zone, tracking across different sites in order to uniquely identify a user. 1 Class classifiers can be used to this scenario to identify a specific user.

- Precision/recall fail because since they do not account for True negative rate.
  - Another student during class explained this, but honestly I did not really understand the argument, but after reading [Problems with Precision and Recall.](https://medium.com/analytics-vidhya/problems-with-precision-and-recall-3e10bae11c6d), the issues makes much more sense. Recall and Precision only focus on the positive classes. Thus, although they do provide much more information than accuracy in imbalanced datasets, they are really only showing the picture for the positive class, not the negative. Flipping the negative and positive class labels can potentially show that precision and recall metrics are very low. Hence, the MCC metric can be used to consider both negative and positive classes.

- Context is very important to consider when discussing AVs. Avs based out of one country will perform very poorly in another.
  - This is something that I did not consider before. If you think about pishing emails, each country likely has their own variety of pishing messages/emails they receive, due to culture and language. Therefore, when comparing the performance of AVs, one needs to consider the context that an AV will be used for (mobile, country, language, etc.)
  - This point is related to the Inappropriate Baseline pitfall. Comparisons should only be done if the comparison is fair and context of the AVs are the similar.

- Migration of attacks popular in one region will move to another years later
  - When considering that AVs are built on a local level this makes a lot of sense, certain attacks may first be developed in a specific region, such as the USA. Then a few years later, attackers in other regions will pick it up, for example in Asia
  - Attackers typically perform local attacks, do not develop malware on a global scale. Teams of attackers can sell malware to others.

- Stuxnet was a malware developed to prevent Iran from developing nuclear weapons:
  - This malware was placed on a USB stick and caused the centrifuges to function incorrectly.
    - I am surprised how someone (likely unknowingly) this closed off network via a USB attack. Typically such facilities have very strict policies against using external devices.
  - This is likely one of many malicious programs that the FBI, NSA, CIA, etc. have created to affect other nation states.