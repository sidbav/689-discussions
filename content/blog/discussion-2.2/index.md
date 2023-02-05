---
title: "Machine Learning (In) Security: A Stream of Problems - Part 2"
date: "2023-02-05"
description: "Summary of Seminar 2"
---

For the Seminar of week 2 of classes we read the paper: [Machine Learning (In) Security: A Stream of Problems](https://arxiv.org/abs/2010.16045) by Ceschin et al.

I was the one who actually presented the Seminar; it is broken into two parts, [Part 1](discussion-2.1) covering sections 3-5, and Part 2 covering sections 6-8. This post is Part 2 of the seminar.

[Here](https://docs.google.com/presentation/d/14sGnShlsb1x9ner0g3vzUwTFN_T6Z6YCxQbcOmi6RJM/edit?usp=sharing) is the link to the slides I used during presentation.

# Summary
- **Concept Drift**: When there is a change in relationship between the input of a machine learning model and its target output.
  - This will occur as attackers are constantly creating new malware files in an attempt evade detection from antivirus software

- **Concept Evolution**: Defining and refining *concepts*, resulting in new labels being created.
  - For example, when cryptojacking malware was first developed in the late 2000s, and early 2010s. A new class of malware was created, resulting in AV companies needed to create new labels (new family of malware) in their ML models.

- To deal with concept drift and evolution, drift detectors should be used in the machine learning pipeline for cybersecurity. There are two types of drift detectors: Supervised and Unsupervised:
  - Supervised drift detectors require the ground truth labels.
    - Early Drift Detector Method (EDDM) and Drift Detector Method (DDM) are examples of supervised drift detectors. They make use of the Sequential error (prequential) monitoring. Each data point is processed one at a time. These detectors will send out two different triggers: (1) Warning, indicting drift may be occurring and (2) Drift, indicating that drift has taken place
    - ADaptive WINdowing (ADWIN) is another example of a supervised drift detector which computes drift based on statistical metrics compute on different window sizes of the data. If the change is greater than the threshold, drift is detected.
  - Unsupervised drift detectors do not require the ground truth labels, which is more practical since it takes time for an analyst to correctly label a malware file. It is also a statical approach which can be based on the classifier output, data itself, etc. In addition can also make use of active learning techniques, where some portion of the data is labelled, and the other is not.

- **White Box Attacks**: Attacker has full access to the model, therefore attackers analyze the model and will find exploits. For example for an SVM they will look at where the decision boundary, see where what are the support vectors, etc.
  - Gradient Based attacks: Specific attacks applied to neural networks. Attackers will use the weights of the neural network to obtain specific perturbation vectors which combined with the a malware instance will still have the same functionality as before (still will be malware), but will be classified as benign by the model.

- **Black Box Attacks**: Attackers only have access to the output label of the model. They know nothing about the inner workings of the model. What they do is they attempt to replicate the machine learning models themselves, then once they have gotten to the point where they believe their local model is representative of the actual model, they will obtain perturbations in an attempt to exploit the model.

- Approaches Defenders take to develop better models:
  - Generative Adversarial Networks (GANs): a 2 part Neural network, the first part is used to generate malicious feature vectors, and the second part of the network will be trained to classify the malicious vectors. Both parts of the network attempt to maximum their performance, leading to improved classification performance.
  - Generate more data using data augmentation, oversampling techniques
  - Competitions such as the Machine Learning Security Evasion Competition (MLSEC) encourage the development of new and improved defense techniques.

- Approaches to deal with Class Imbalances when Training:
  - Cost Sensitive learning: Apply a penalty to misclassifying minority class data points
  - Ensemble learning: Make use of multiple classifiers, using all of them to output one final output label/confidence
    - Bagging: Each classifier is trained using a unique dataset which is generated through random sampling of all the data with replacement. This introduces diversity in the models.
    - AdaBoost: Train the classifiers iteratively, where with each iteration, extra importance is given to data points that were misclassified in the previous iteration. Each classifier attempts to learn from the mistakes of the other previous classifier.
  - Anomaly Detection: Make use of classifiers specifically designed for outlier detection, such as isolation forest, and a one class SVM.

- Transfer Learning is common technique used in Cybersecurity. It is the process where a model is developing using a previously trained model. For example, cyBERT which was previously mentioned.
  - Saves time and computational resources when training
  - If the original model has a robust feature set, so will the transferred model.
  - If the original model is widely available, both the original model and the transfer model are prone to white box attacks.
  - One model developed specifically for malware detection mapped binary files to a gray-scale image, then used the inception-v1 baseline model for classification of the malware files.

- Metrics:
  - As mentioned in other papers, accuracy is not a good metric to use for cybersecurity, since it does not reveal all information
  - Precision, Recall,f1score are much better metrics to use.
  - New metrics such as Conformal Evaluator (CE) and Tesseract have been proposed in some academic papers, which can be used to evaluate models.

- AV companies typically use a two layered approach when it comes to malware detection, using a online model on the user's computer and offline model in the cloud:
  - Online is light weight and runs in real time, offline can be much more complex, do not have to run in real time
  - Limited data size for online models, and (in theory) unlimited data size for offline models
  - Expect a greater number of false negatives in online models versus offline models.

- AV companies typically state in their marketing that their AV software is able to protect its users against day-0 malware. However, this claim is simply not true. There is a constant arms race between attacks creating malware and then defenders, updating their models to protect against the new malware. However, it is simply IMPOSSIBLE for the defenders to catch every single malware file simply due to the sheer volume of malware files being created. This claim is great for marketing not true in reality.

- It is important that models used in Antivirus software is not treated as a blackbox by the engineers who build. They must understand the inner workings of the model, such that if their is a situation where a malware file goes undetected, they understand why that takes places. Once they understand these vulnerabilities,the models can be updated to resolve these issues.

# Discussion
- The main advantage of using Transfer learnings is the ability to apply knowledge, techniques from one field to another. For example, the inception-v1 model previously mentioned applies knowledge from convolutional neural networks to malware detection.

- When attackers build a model locally in an attempt to recreate the antivirus companies' models, they will not run many files through the software. The reason being is the antivirus companies use the data send by its users to retrain its own models. Hence, attackers do not want to share all of their malware, since it will eventually become obsolete.

- Attackers will also use the approach similar to gradient descent when making changes to malware files in an attempt to discover weaknesses of an ML model. This is typically done as a black box attack.

- When applying cost sensitive learning, extra importance may be given to False Negatives or False Positives depending on the context an AV software will be used.

- Questions of legality of developing malware on your own machine were asked. I believe it should be legal since you are only causing harm to yourself, and companies also have penetration testers who try to find vulnerabilities in in their AV models. Penetration testers are important as it ensures the defenders are always trying to outperform each other.

- Random Forest typically perform very well in cybersecurity since they are able to handle concept drift. When concept drift occurs, only a few of the trees need to be updated. Adpative Random Forests can be used in this situation.