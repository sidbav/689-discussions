---
title: "No Need to Teach New Tricks to Old Malware: Winning an Evasion Challenge with XOR-based Adversarial Samples"
date: "2023-03-06"
description: "Discussion 6.2"
---

For this discussion we covered the paper: [No Need to Teach New Tricks to Old Malware: Winning an Evasion Challenge with XOR-based Adversarial Samples](https://dl.acm.org/doi/10.1145/3433667.3433669) by Ceschin et. al.

# Summary
- This paper is a follow up to the Machine Learning Security Evasion Competition; in addition to developing adversarial samples, teams were also asked to develop defensive models for the variant adversarial samples.

- The rules of the competition included:
  - Each team will receive 50 malware samples
  - Each team will develop a defensive model
  - Each team must develop adversarial samples which can bypass 3 models:
    - A model built on Ember (provided by organizer)
    - Team's defensive model
    - A third model called domumpdq

- The malware samples for this year's competition are much more diverse (30 malware families compared to 21 in the previous year)

## Defensive Solution (Need For Speed)
- Developed a model using Categorical, Textual and Static features using the Random Forest Classifier.
  - Achieved 98.1% f1 score on the training dataset which was composed of malware samples collected in Brazil
  - Model performed poorly against the competition's malware samples, likely due to training dataset being localized to Brazil and the test dataset was collected from a global pool of malware samples
  - RFC had an 80% threshold - would only classify a sample as goodware if at least 80% of the decision trees classify as
- Model was able to detect just under 90% of samples from the previous year

## Attacks
- Appending Goodware strings/data, the team is able to evade the Ember Model for 36 out of the 50 samples, 8 for Need for Speed, None for domumpqb

- Utilizing a Dropper the team is able to evade the Ember Model for all 50 samples

### Need for Speed
- Right now Need for Speed and domumpqb are able to detect the presence of Dropper; they are able to detect the usage of specific library and function calls (such as `FindResource`). Issue with using a packer is these models are also biased towards them, increasing the detection rate even further.

- To deal with the above issue, the researchers developed a Custom Dropper that resembles the Calculator application on Windows. The calc.exe is classified as 100% goodware by the Need for Speed Model.
- So the team compiled the adversarial malware file with Dead Calculator Code + Dropper into a never called function with all code optimizations turned off. All of the adversarial malware files developed in this manner are able to bypass the Need For Speed Model.

### Domumpdb
- Some of the previously developed adversarial samples were able to bypass this model, but not all.

- The authors of this paper assumed that the model is able to detect some of the embedded payload -> so they need to hide the payload.

- To hide the payload they applied two different techniques:
  - Encoding the malware as a base64 string
  - XORing the binaries with a key -> no longer would be human readable, thus model probably will not be able to pick up key strings.

- Applying both of the above techniques, the authors were able to bypass the model is less than 5 Queries
  - From my understanding this is considered to be a very low number of queries, which is good since the lower number of queries the lower likelihood it will be detected by an intrusion detection system (AVs detecting an attack on their system)

## Analysis of Results
- When uploading the adversarial samples to VirusTotal we can see there is a HUGE drop in the detection rate by the AVs. Some dropping from close to 90% detection (with the original file), all the way down to less then 10%.

- In addition, of the AVs that do detect the adversarial sample as malware, the malware family is being misclassified, with most of the adversarial samples being classified as `razy` or `remcos`

- The authors also try to train a model using the adversarial samples they developed, and they see the False Positive Rate (goodware being classified as malware) shot up all the way up to 78%. Given that these adversarial samples were designed in such a way to mimic goodware almost completely, when trainig the model with them, the model is unable to pick up patterns in goodware/malware. Hence leading to such a large FPR.

# Discussion
- Why do we use XOR?
  - The reason we use XOR to obscure the content of the file and it can be easily undone if the original key is known
  - An issue using XOR is the file contents may become all zeros after the operation, which can be interpreted as deadcode, which is why the authors also used base64 to obscure the content of the file

- How can we get around the custom built dropper designed to look like a calculator?
  - We can analyze the control flow graph, prehaps analyzing this will lead to better results
    - Personally I am not sure this approach would even work with the base64 approach or the XOR approach given the actual code is obfuscated, so how would you even develop the control flow? Maybe CFG can only be developed for the decoding of the data but both malware and goodware files may do the exact same?
  - Can make use of other features as well -> more features more data!

- Need for Speed is able to detect libraries and specific function calls when classifying a file as malware or goodware? How can be get around that?
  - Dynamically load in the libraries and function calls, so it cannot pick up specific libraries/functions associated with malware?
  - Personally I do not really understand how you would go about dynamically loading them in? Wouldn't you need to point to some sort of external resource (downloading data)? So wouldn't a pipeline looking at IP addresses pick that up (unless that is also obfuscated)

- From the analysis from VirusTotal we can see that some AVs perform MUCH better than others on specific malware families.

- What are some pratical, everyday uses of droppers:
  - ShortCuts, Downloaders, Installers
  - Getting data from external resources

- The similarity graph from paper:
  - ssdeep is a metric similar to the locality sensing hashing
  - After the dropper is used the files become very similar to each other -> Each adversarial malware sample was developed in a very similar manner, mimicking the calculator app on Windows.
  - Another approach can be to cluster samples in their feature space to tell similarity? Not really sure what is meant by this, but could be a similar to the NCM metric discussed previously
