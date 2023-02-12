---
title: "Dos and Don’ts of Machine Learning in Computer Security - Part 2"
date: "2023-02-12"
description: "Discussion 3.2"
---

For the Seminar of week 3 of classes we read the paper: [Dos and Don'ts of Machine Learning in Computer Security](https://www.usenix.org/conference/usenixsecurity22/presentation/arp) by Arp et al.

This paper was split into two seminars, the first seminar covered Pitfalls of the Applying Machine Learning to Cyber Security, the post on the first half of the seminar can be found [here](/discussion-3.1). This post will cover some examples of the pitfalls discussed int he previous post.


# Summary
- The pitfalls discussed in the first half of the paper are prevalent across academia in Computer Security. A study of the top 30 papers from a security conference in the last 4 years found that these pitfalls many of these pitfalls were present in them.
  - The most common pitfalls were sampling bias, data snooping, and lab only evaluation.

- What is interesting is many of the authors do not agree that base rate fallacy can be avoided in practice.
  - Recall base rate fallacy is when the class imbalance is not taken into account when considering a model's performance.

- The following points, will be examples of the pitfalls described before.

- **Mobile Malware Detection**:
  - We can see that when randomly sampling the Google Play Store, the Chinese App store, there is a greater number of positive malware detections on the Chinese app store than the Google Play store. It is more probable to randomly download malware when picking a random app in China app store than using the Google Play Store
  - As a result we can see that when comparing the performance of the models devloped using the a combined dataset (Chinese App store and Google Play store), versus only using the Chinese Play Store, the singular dataset model peforms better
    - This further emphasizes that mixing dataset does not lead to better results, it is important to consider the context a dataset is utilized in
  - It was also found that the model was heavily weighing whether or the string *play.google.com* was present when considering if an application was benign or not.
    - This facet of the model shows both spurious correlation (it shouldn't really matter that an app is from the play store vs China app store) and  sampling bias is present in this situation. This model is not specific to one context (Google) or another (China), thus it simply does not perform as well. AV models typically perform better when they are trained on data that is specific to a context, rather than being generalized to multiple scenarios.

- **Source Code Author Attribution**: In this specific instance, we can see that models can pickup on code syntax styles of developers, and heavily rely on style during classification:
  - An example is shown here where unutilized code is removed from a dataset, which results in a significant drop in performance accuracy.
  - This example is displaying the pitfall of supurious correlation - the model should not really be considering the code style, unused code when considering if a file is malicious or not.

- **Network Intrusion Detection**: In this example, very complex outlier detection methods were used, and a boxplot as used for outlier detection. From this experiment, it was found that the complex models were beat by the simpler models:
  - This comes back to previous seminars where is was also shown that complex does not mean a model will perform better.
  - In addition, example also showed that when models are tested only in a lab setting they are not exposed to the real world.

# Discussion
- Why do pitfalls occur even though we have the best researchers who are aware of many of these pitfalls in the first place?
  - There are quite a few reasons, one of them being they are difficult to avoid
  - Sampling Bias is one that is very difficult to avoid due to need to understand the data, and where it came from
    - In addition, often times a dataset does not contain the raw binary files, but rather it has the attributes and features extracted from it
  - Companies typically do not share their malware samples with each other
    - Either since they are AV companies
    - If they were affected by a malware attack they do not want to harm their reputation and share it with others

- Another important thing to consider is all software can be malicious, but one needs to consider the intent of the software program:
  - For example, when I am using my own personal computer and I run a command in sudo mode, my intent is not perform a malicious action on the computer. However, if another software program on my computer would like to run run commands in sudo mode, then it could have malicious intent.
  - It is very hard to classify a program's intent because in benign software and malicious software the actions can be the same, but an AV needs to classify them based on their intent.

- Coding Style is something that AVs will take a look since it help classify an attacker:
  - Coding Style can be treated as fingerprint for an attacker (attacking group)
  - A specific attack may have a unique coding style
  - Can be used to predict what types of attacks are incoming
  - A one class classifier can be used to perform this prediction

- Oversampling can be used to generate more samples of data in an attempt to remove bias:
  - This allows minority classes to have a greater presence in a dataset, but I am not entirely sure how oversampling could resolve the issue of spurious correlation as shown in the *play.google.com* feature.

- Correlation of Features does not mean causation:
  - Although there may be features that correlate together to indicate a high likelihood of malicious intent, it does not mean there is maliciousness