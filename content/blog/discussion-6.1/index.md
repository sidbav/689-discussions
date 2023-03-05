---
title: "Shallow Security: on the Creation of Adversarial Variants to Evade Machine Learning-Based Malware Detectors"
date: "2023-03-04"
description: "Discussion 6.1"
---

This week we have changed our perspective - rather than thinking about AV companies (defenders), we have began to take a look at how to generate adversarial malware samples - malware samples that are able to bypass a given malware detection model. Here is the link [paper](https://dl.acm.org/doi/10.1145/3375894.3375898) by Ceschin et. al.

# Summary
- The motivation for this paper is to explore different adversarial techniques for malware samples, for the EndGame Competition. There were 50 malware samples provided (from various malware families), with 3 models to be evaded:
  - MalConv which takes as input Raw Data
  - Non Negative MalConv which takes as input Raw Data
  - LightGBM Model which extracts the PE Header attributes

## Evading via Appending Random Data
- The goal of this technique is to increase the file size. The goal with this attack is the "push" the neurons of the Malconv (and non negative Malconv) to signal goodware; these models take chunks of bytes of the file as input. Increasing the file size will likely "Sway" these models to classify a malware file as goodware.

- Increasing the size of the random data that as appended to the file eventually resulted in a large number of malware files to be classified as goodware by MalConv model, but very few files were able to bypass the other two models using this technique.

## Evading via Appending Goodware Strings
- The goal with this technique is similar to the previous, but rather than using random data, appending goodware strings; if the models are analysing the frequency of the goodware strings in a file, it is very likely this technique can be used to evade the model.

- The researchers saw that this technique worked well against both the MalConv and non negative MalConv. The model did not have too much luck evading the LightGBM model.
  - Initially it really did not make sense to me why the non negative malconv was able to be evaded with this technique, since it is supposed to be designed such that it can only have an "increasing level of suspicion". It was later revealed by Prof. Botacin (who is also an author of this paper), that there was an implementation error with the Non Negative Malconv model, which lead to the evasion.

## Changing the Binary Headers
- The attackers changed common PE Headers to resemble goodware header files, but this technique only lead to the evaison of 6 malware files against the LightGBM Model.

## Packers
- A packer compresses the contents of a file, and will attach the decompression functionality to the compressed file. Using a packer leaders to a significant change in the File structure.

- There are many packers out there, one of them being [UPX](https://upx.github.io/), an open source and very commonly used packer.

- When using the UPX packer, detection rate *increases* which implies models are biased towards the usage of UPX - more likely to classify a file as malware when UPX is detected by the model.
  - This implies that using UPX is not a good idea so perhaps packing is still a good idea?

- The researchers tried using a less popular packer called Pelock AND appended data to the malware files. This technique was able to bypass all of the models, BUT it broke the functionality of some of the malware files - thus they are not good adversarial samples.

## Dropper
- Droppers will write the malicious executable to disk and then run itself. Typically contents of the malware file are hidden in the resources section of the PE file.
- [Dr0p1t](https://thewhiteh4t.github.io/2019/03/15/Dr0p1t-Framework-Malware-Dropper.html) is an example of a Dropper but it increases the size of the malware files past a certain point which is against the competition rules.
- The attackers developed this own customer dropper AND appended goodware strings to these newly generated files. These files were able to bypass all 3 models.
- We can see the size of the adverserial files are much greater than the original malware files.
- When uploading the file malware files to virustotal we can see that the detection rate against the AVs in VirusTotal drops very much.
  - It is important to note that VirusTotal only runs Static analysis on the files - Dynamic analysis is not performed.

# Discussion
- How features are extracted (or in other words feature representation) is VERY important. Depending on the feature representation, attackers will need to put a greater amount of effort in generating adversarial malware data files.
- PE Files have very "lose" rules due to backward compatibility. Even if some fields of the PE header file are incorrect, Windows will still allow the PE file to run without any issues.
  - This is an issue in the nature of the environment, and if Windows were to put a lock down on this, it could potentially reduce the number of malware files ran on Windows. Obviously, malware files will still be generated and attacked, but putting these restrictions will force attackers to be more sophisticated.
    - For example, if rules were more strict, could reduce the number of "appending random bytes" attack

- Downloaders: Similar to droppers, but will download the malware file from another resource online. The resource is not built in the original PE file.
  - AV companies can block these type of attacks by whitelisting/blacklisting certain domains, but attackers can get around it by only forming the IP Address/URL dynamically - This will prevent AVs from applying whitelist/blacklist rules in static analysis.

- Random Data: When it comes to appending Data, the goal is to append the minimum amount of data as possible. Only increase the file size as much as needed. This attack works best when there is no feature extractor involved. The reason this works well is a single byte does not determine if a software is malicious or not - it a pattern among a group of bytes. Essentially this approach tries to reduce the number of malware bytes so the classifier does not catch on to the pattern in them.
  - Non negative models should NOT be affected by this type of attack since a neuron should be not able to "change" its vote.
  - One "smart" approach can be to look into PE header file details and only load up data up the specified size in the PE file (when processing the file by the AV)

- Modifying PE Header files: Some fields are "useless" in the sense that MSFT does not enforce them to be correct - this can be exploited by an attacker.

- How do we ensure we do not break functionality of malware files?
  - Setup file to overtake another process' memory
  - Encrypt or compress the malware file
  - Put the malware inside another binary file (make it look goodware, for example calculator app mentioned in the next paper). This will lead to headers that are ACTUALLY correct (if rules are somehow enforced)

- When embedding malware inside the resources tab, it is important to remember that limited size of data can be inputted in there - malware will need to be broken up.
  - May also need to have multiple keys of encrypted.

- Concept Drift can occur due to change in the packers/droppers that attackers are using

- Attackers will try to make sure their malicious files DO NOT run on Virtual Machines and Sandboxes - want to evade detection as much as possible.