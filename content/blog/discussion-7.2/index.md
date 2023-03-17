---
title: "Mal-LSGAN: An Effective Adversarial Malware Example Generation Model"
date: "2023-03-16"
description: "Discussion 7.2"
---

The title of this paper is [Mal-LSGAN: An Effective Adversarial Malware Example Generation Model](https://ieeexplore.ieee.org/document/9685442), written by Wang et. al.

# Summary
- There are three different types of adversarial attacks:
  - Gradient Based - Get the gradient of the input, and attempt to perform something that is the opposite of gradient descent
  - Optimization Based - Typically very slow to do
  - Generative Adversarial Networks - Perturb the input a bit to classify the input to the network as the wrong label - attempts to reach the Nash equilibrium

- In GANs - The generator will produce realistic malware samples (or more likely a feature vector corresponding to malware files), and the discriminator will be the malware detector

- MalGAN was a previous attempt at developing a GAN for malware samples:
  - attempts to replicate the results of the actual detector
  - create adversarial malware samples
  - Very unstable training
  - The malware feature vectors that are produced to not work for other discriminators - will need need to develop specific malicious feature vectors for each type of discriminator

- Mal-LSGAN - takes an input BOTH malware data and some noise data to produce adversarial samples. In this example, we directly use the discriminator (not attempting to recreate it - a graybox approach).

- The goal of the generator is to reduce the probability that the discriminator (malware detector) will detect adversarial malware samples produced by the generator
- The goal of the discriminator is to distinguish between the malware and goodware - the metric utilized in this case the mean square error

- The authors of the paper are able to produce Okay results - they considered many different discriminators such as Random Forest, Decision Trees, Neural Networks, etc. Here they built each discriminator and provided as input a fixed feature set.

- How do we go from Feature vector -> malware file:
  - Based on the feature vector produced by the generator part of the network, specific features may be added to a preexisting malware file to make it "adversarial". Features marked off as zeros (removed from a file), will not be removed in order to preserve functionality.
  - Another approach is to utilize Reinforcement Learning. The agent can take actions to change a PE file without breaking it. The agent will learn what actions are rewarding and which are punishing.

# Discussion
- A very well known example of GAN networks are creating images:
  - A common example is to create images of people who do not exist - [this-person-does-not-exist.com](https://this-person-does-not-exist.com/en)
  - Another use case can be generate images that can fool a classifier

- How can we directly generate malware files from a GAN?
  - We can create a PE file template that the network needs to follow and eventually the Network will learn what makes a PE file valid/invalid.
  - Personally, I did not really understood what was meant by this point, but I would imagine perhaps it would involve a language model specifically for PE files? The model I guess would take as input the desired plus features and removed features, malware family, and the language model would produce an adversarial malware file to be complied? I am stretching here, but this is what I would imagine. I tried searching how a Neural Network would make use of a template but could not find much.

- A limitation of the current approach is it produces a feature vector that can be considered malicious - a key assumption here is the model (which is typically considered to be a blackbox) is you know what the input feature vectors are. This paper does not present what an attacker would do, but rather what AV companies may do instead - produce malicious feature vectors - which in turn can be used to produce adversarial malware files. These new malware files can be added to an AV's dataset for training/testing/validation of the their models.

- Why would anyone use this approach? An attacker would have access to the source code of the malware, assuming they produced it themselves, and the practical implementation of this does not really make sense for an attacker.

- The GAN technique is not stable, since the malware features vectors (as a result the adversarial malware files) produced do not translate from one discriminator to another.
  - How can be ensure it translates? Create an ensemble of defenders (discriminators) - this will produce adversarial malware feature vectors which should bypass more than one of the detectors. An approach like this generalizes.

- Something to keep in mind with this paper is their results are not great - the take away from this paper should be more about the idea rather than the results. The idea is good, can be reimplemented yourself.

- Query Efficient - As a defender you want to force the attacker to make many queries to your model. We can increase the number of queries they must perform by introducing hard labels, a pool of accuracy equivalent models - a moving target defense, etc.