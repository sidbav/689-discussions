---
title: "Transcending TRANSCEND: Revisiting Malware Classification in the Presence of Concept Drift"
date: "2023-02-26"
description: "Discussion 5.2"
---

For this presentation, we explored the paper: [Transcending TRANSCEND: Revisiting Malware Classification in the Presence of Concept Drift](https://ieeexplore.ieee.org/document/9833659) by Barbero et. al. This paper is follow up to the previous paper we explored in [Discussion 5.1](/discussion-5.1)

# Summary
- Classifiers will suffer DataSet shift over time:
  - Concept Drift: Change in data distribution due to change in the ground truth labels
  - Covariate Shift: Change in distribution due frequency of features changing over time
  - Prior Probability Shift: Change in distribution due to a change in base rate over time

- Often time all three of these dataset shifts are lumped in Concept Drift for convenience.

- We make use of the NonConformity Measure (NCM) to compute the dissimilarity of a new data point compared to data points in the training dataset of a malware detector, the p value of each new data point is computed.
  - NCM can be thought of as a distance measure, the more dissimilar, the greater the distance from existing data points.

- TRANSCEND is a framework that applies NCM using the Conformal Evaluator; it is able to provide a score of how reliable (hence also providing an unreliability score at the same time) a prediction by the classifier was.

- The conformal evaluator is built in three phases:
  - Calibration: Setting thresholds depending on desired performance based on different p values.
  - Test Phase: Calculate the p value of a new data points and either accept and reject the prediction based on the desired threshold
  - Rejection Phase: When rejecting a data point the classifier will face further costs:
    - Cost of removing the data point (Quarantine Cost)
    - Labelling Cost (cost of having an analyst labelling the file through malware analysis)
    - this cost can be adjusted based on the threshold set in the calibration phase.

- There are many different types of CEs:
  - Transductive Conformal Evaluation (TCE)
  - Approximate Transductive Conformal Evaluation (Approx-TCE)
  - Inductive Conformal Evaluation (ICE)
  - Cross Conformal Evaluation (CCE)

- For this paper, the authors decided not to use two different datasets, to reduce the amount of sampling bias (and other issues mentioned in [Discussion 5.1](/discussion-5.1). They utilize an SVM classifier on data obtained form the Drebin dataset.
  - From their experiments they see the model preforms quite well, much better than malware detectors doing malware detection.
  - In addition to running malware detection in Android datasets, the authors also work with the Ember. dataset for malware detection in Windows PE files. The TRANSCEND framework also works well on Ember.

# Discussion
- What was the point of this paper, why did the authors decide to write this paper?
  - The authors previous paper pretty much had the same ideas, but it failed for formal define the various concepts, thus it would be difficult to reproduce the results. Writing another paper allows them to correct any flaws in the previous paper (bias in dataset combining), and formalize concepts.
  - Formalize the concepts will help convince others to actually try using the framework
  - This paper also shows use how science progresses, first research papers are typically written, then slowly these concepts will be experimented with in practice.

- This paper is one of the few papers that actually considers the AV pipeline as a whole, rather than simply isolating the malware detector. It is important to do this since malware detectors make up a small portion of the entire pipeline that an AV company would run.

- Cost of False Positive Rate: The goal is ideally NEVER block a user from using goodware software. You always want to have a low false positive rate.
  - For example when it comes to SPAM email detection, it is better that some SPAM emails "slip through the cracks" than blocking non malicious emails that are important to the user.
  - Google anti spam is a very unique position since they have a HUGEEE and extremely diverse dataset. This leads to very good SPAM detection. Their pipeline would also include running signature checks based on the domain, sender of the email, number of users who have received the same email, etc. So they are able to apply a triage based approach first before applying a machine learning based malware detection.

- When selecting a threshold for the CE we can use grid or random search. Random search is actually just as affective as applying grid search, so may as well use random search since it will be less computationally expensive:

- When should we go about changing the reliability threshold?
  - In this paper the threshold was set based on the desired rejection rate of 15%, so it may be time to change threshold if the rejection rate is not met (probably a good idea to retrain classifier if rejection rate is exceeding the desired one).
    - Another note on this rejection rate was based on the number of malware samples that can be analyzed by an AV company via analysts. This was about 20 samples per day. Personally I am not sure if that is realistic or not?

- Another thing to note is attackers will often time embed code in their malware to ensure that the malware sample do not run in sandbox environments or virtual machines. Analysts will need to remove that code before attempting the further analyzing the file:
  - So that means that VirusTotal is actually not running the malware in a sandbox environment -> it is simply performing static analysis. I always assumed it was performing both static and dynamic analysis.

- Polymorphic malware: The malware file will have the same name (or stored in the same location) but contents of the file (AKA malware) will change over time.
  - They will change based on attackers paying the host to upload their malware for a certain period of time. The file structure will be different every time.

- PDF and Word Malware. Most users do not realize that word and pdf files are simply not just plain text, but their is a lot going on behind the scenes:
  - Word files can run MACROS (VBA code), and PDF files can run instructions, javascript code, or download other resources. Attackers will simply embed the malware inside of the PDF/Word file. To a user they will often not see any different but in the background malware has now infected their machine.
  - AV companies will often have models specifically for word and PDF files.
  - Drift will still occur in word and PDF files, but may occur more slowly since these standards are much stricter than PE files:
    - PDF files have an ISO (International Standard Organization) standard; Word files are set by Microsoft.

- The user typically needs to take an action (open a file, open a link, etc), to infect malware on their machine. Very few 0-click vulnerabilities exist:
  - NSO created a 0-click malware infector based on an error with SMS parsing
  - I also remember reading an [article](https://www.theguardian.com/technology/2020/jan/21/amazon-boss-jeff-bezoss-phone-hacked-by-saudi-crown-prince) that Jeff Bezos had his phone infected with a 0 click message received on Whatsapp. So 0-clicks are out there for sure, but much more difficult to find, a minimum of 1-click is needed.

- The most common type of malware is Remote Access Trojan (RAT):
  - A connection is created between the attackers and the infected user's device. The goal with a RAT is never let the user know they have been infected (otherwise connection will be lost!). Attacker can run commands are receive data. Attacker will need to clean up their tracks in order to ensure the user is kept in the dark.

