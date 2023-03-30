---
title: "Adversarial Machine Learning in Image Classification: A Survey Toward the Defender’s Perspective"
date: "2023-03-30"
description: "Discussion 8.2"
---

The following is the summary and discussion of the paper [Adversarial Machine Learning in Image Classification: A Survey Toward the Defender’s Perspective](https://dl.acm.org/doi/10.1145/3485133), by Machado et. al.

# Summary
- It is quite easy to fool machine learning models built for image classification by perturbing an image. Models will often suffer from the Clever Hans affect.

## Taxonomy of Adversarial Images (Perturbations)
- Scope:
  - Individual: Crafting a perturbation for each specific image
  - General/Universe Scope: Perturbations are generated without considering a specific input - this is more realistic and done more frequently

- Visibility:
  - Optimal: Not noticeable by the human eye, but classifier is confident about the incorrect prediction
  - Indistinguishable: Not noticeable by the human eye and unable to evade the model
  - Visible: Able to be spotted by humans and can fool the model
  - Physical: Added to real world object (for example stop signs, traffic lights in the case of self driving applications)
  - Fooling Images: Humans are unable to tell what the image represents, but a model will have high confidence regarding the classification of the image
  - Noise: non-malicious perturbations applied to the image, image is misclassified

- Measurement: Can apply the L0, L1, L2, L(infinity) norm to measure the difference between the original and perturbed image

## Taxonomy of Attacks
- A threat model explains how a defense (AV) is designed to protect against specific attacks

- Attackers Knowledge: White, Black, Grey Box Attacks

- Attacker Influence:
  - Poisoning Attacks: attacks attempts influence the training process of a model by corrupting the training data with mislabels to deviate the model behavior
  - Evasive Attacks: Attacker will create adversarial samples that can evade the ML model. Typically attackers will create a surrogate model (greybox attacks)

- Attack Specificity:
  - Targeted Attacks: Attackers will create adversarial samples specific to an AV/machine learning model such that the sample is classified into a specific class
  - Untargeted attacks: Attack wants to evade the model; they want the AV to mislabel their adverse sample

- Attack computation:
  - Iterative: Have a high computation cost (such as the Genetic algorithm approach we saw previously), but it probably more query efficient (less likely to be detected by the AVs)
  - Single Step: Apply gradient ascent approach, developing perturbations based on gradient. Typically need to apply a large change in the original malware sample. This approach is typically less effective, but has a much lower computational cost

- Security Violations
  - Availability violation: Any attack that affects the model's usability, leading to a denial of service.
  - Integrity: Occurs when an a sample is able to evade a model; the model is still able to detect other samples, but unable to specifically detect adverse samples
  - Privacy: Attackers attempt to gain knowledge about the model (the architecture, the training/validation data, etc.)

- Different approaches to Attacking:
  - Gradient Attacks: Typically done in a white box setting, using the gradient of the model to perform gradient ascent - not very realistic to do
  - Score Based Attacks: Develop a surrogate model to develop perturbations - black/greybox approach - this is more realistic
  - Decision Based: Develop small perturbations at a time using rejections sampling
  - Approximation Attacks: Attempt to mimic the model output by using differentiable functions and apply a gradient based attack using this approach

## Attacking Algorithms (there are many, here are a few covered in the presentation)
- Fast Gradient Sign Method (FGSM) - low computational cost, creates a large perturbation, BUT most of the time it does not evade the model
- Basic Iterative Method: Iterative approach of FGSM - perturbations are generated in much smaller steps - upper bound is also set on the perturbations
- Deep Fool - Find the closest decision boundary and perturb the image so that it can cross that boundary
- Carlini and Wagner Attack (CW Attack): Optimization algorithm to minimize the L2 difference between the original and perturbed image BUT also generates an image that can fool the classifier

## Taxonomy of Defense
- Proactive or Reactive:
  - Proactive: Developing robust classifiers against adversarial attacks
  - Reactive: Develop specific models to detect malicious images, etc.

- Gradient Masking:
  - Develop a defensive model that has a smooth gradient - will result in attackers having to perform a greater number of queries against the model
  - There are many approaches a defender can use:
    - Vanishing Gradient - Use a deep NN to have an extremely small gradient
    - Shattered Gradient - Introduce steps that are not differentiable
    - Adversarial Training
    - Defensive Distillation: Train a model to output softlabels, then train a second model to predict these soft labels - this model will have a smooth gradient

- Some other Defensive Approaches:
  - Develop a model to distinguish between adversarial and real samples
  - Compute the distributions of legitimate and adversarial images
  - Preprocess images
  - Ensemble of Models
  - Proximity Measurements: Check that the output label of a model matches similar labels (follows same "path" in a Neural Network)

## Why are Adversarial Samples able to bypass Models?
- Model lacks generalization
- Models are linear due to activation functions in Deep Neural Networks, thus they are able to be exploited by attackers easily.
- Boundary Tilting: Adversarial samples are generated by perturbing legitimate samples until they cross the boundary
- High dimensional data is very complex, thus models are vulnerable regardless of training techniques.
- Training Dataset is not representative
- Extracted Features are not robust, can be easily exploited by attackers

# Discussion
- Why are we looking at malware detection from the image domain perspective?
  - A lot of knowledge from other domains can be transferred to domains, that at initial glance do not seem to apply. Obviously there is not a "direct" mapping from one domain to the other, BUT there is loads of knowledge transfer

- The Brazil army is the one who released this paper? Why is this information in public view now?
  - The work that they are doing now is not classified - likely they have developed methods to deter from these attacks (defense), and likely have come up with attacks the evade systems.

- What is missing from this paper: Explainable AI - The presenter talks about some of their research regarding the usage of explainable AI in network security.
  - Able to check if the predicted outcome is aligned with model behavior/response
  - Can utilize the Shapley outcome which provides scores of which features are positively/negatively contributing to an outcome. If the Shapley score is low AKA low credibility from the main model, then we can rely on a secondary model for the result. This is a reactive approach.

- Is having a smooth gradient good or bad?
  - A smooth gradient allows you to hide information about the gradient. Smoother gradients mean that an attacker will need to perform a greater number of queries against a model to learn about it.
  - Moving target defense is also good, since it forces an attacker

- Bagging model can also be applied as defensive technique

- Unlike in malware domain, we can perform physical attacks in image domain. For example for self driving cars, we can cover up stop sizes, modify traffic lights, etc.
- Can apply SQL injection attack (license plate)
- Can perform a physical attack in the facial recognition domain by wearing a mask, makeup, etc - which is related to security domain as well.