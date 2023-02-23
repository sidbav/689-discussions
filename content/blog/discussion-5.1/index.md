---
title: "Transcend: Detecting Concept Drift in Malware Classification Models"
date: "2023-02-23"
description: "Discussion 5.1"
---

This week, we discussed the paper: [Transcend: Detecting Concept Drift in Malware Classification Models](https://www.usenix.org/conference/usenixsecurity17/technical-sessions/presentation/jordaney) by Jordaney et. al.

# Summary
- Concept Drift: Unforeseen ways in which data is changing. As a result data points will begin to be wrongly classified by a model.
  - Occurs due to malware evolution or new families of malware are being established

- To account for concept drift we need to retrain our models, but the question is how often?
  - If we do not train often enough (too slow), thus we have an untrustworthy model
  - If we train too often (too fast), concept drift may have not occurred yet thus we are wasting computational resources, so in essence money.

- **Conformal Evaluator (CE)**: This implements the *Transcend Framework*. This will evaluate the classification result of a classifier on a scale where the two extremes are reliable and unreliable.
  - CE provides this metric using a p-value approach, which can be thought of as computing the similarity of the current data point and the training data points in the feature space. Ratio between number of total training points (per class) that are more dissimilar compared to the element under test is computed for each class.
  - For each model a Non Conformity Measure (NCM) is computed based on the model and a threshold level is computed for each class - this threshold level draws the line between reliable and unreliable.
  - The larger of a test data point, the greater probability the data point was correctly classified.
    - Intuitively this make sense; p values are only large for data points which are highly similar to the ones in the training dataset. Since the test data point is similar to data seen before, it is more likely for the classifier to correctly classify it.

- It is important to note that unlike other drift detectors, the CE does not send out a signals like Warning or Drift. The CE is ran alongside an already existing AV pipeline, evaluating the classification results. An analyst developer will then need to take a look at the CE results, and then decide when it will be appropriate to retrain the classifier to account for drift that has taken place.

- What a business can do is take note of datapoints which the CE believes are unreliably classified by the model, and then when they believe they should retrain the model, include the unreliable data points in the training dataset.
  - *Personal Note*: By this point of time, *ideally* the unreliable test data was analyzed by a human, thus the correct label was correctly applied to the data rather than having to use a pseudo-label)

- The authors of the paper show results of an experiment. The model is trained using one dataset and tested on different dataset (duplicates are removed). The experimented show that the model does not perform well on the test dataset BUT when removing the datapoints where the CE classified as unreliable, the model actually does perform quite well with high precision and recall scores.
  - When the model is retrained using the original training dataset and the unreliable test data set, the new model performs quite well as well.

# Discussion
- Although not explicitly stated during the presentation and/or discussion, from what I gathered here are the main benefits of using CE versus a traditional drift detector:
  - Labels are NOT required to be known beforehand to determine drift
  - Can easily be added to an existing AV pipelines (likely needs to be offline not online (user facing))

- What is the difference between statistics and probability (in this context, no according to mathematicians)?:
  - Statistics are computed for data that you do have, whereas probability is about data you do not have. Probability gives you information about how likely data is fitting to what you already have.
  - The use of statistics allows us to even earlier detect drift and tackle it when we deem to be appropriate

- Why are two metrics (reliability and probability of being malware useful)?
  - It gives us four categories:
    1. Reliable classification
    2. Reliable misclassification
    3. Unreliable classification
    4. Unreliable misclassification
  - We are able to LEARN even more about our data, we can understand how confident we are in our prediction (when not using a threshold). This is similar to the bulleye analogy for accuracy and precision.

- Was it a good idea for the researchers to combine the two different datasets?
  - NO probably not. Professor has mentioned that this will be covered in the upcoming discussion, so we will learn further details on why this was not a good idea from their perspective)
  - However, from the in class discussion, there were a couple reasons why we thought it was not a good idea:
    - The training data set was imbalanced, whereas the test dataset was balanced.
    - The datasets are collected by two different teams, which introduces bias:
    - Two different datasets will have their drift occur at different time periods, thus it is possible that data snooping is still present in the dataset. The evolution of the dataset changes based on how the data is collected.