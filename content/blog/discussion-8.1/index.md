---
title: "EvadeDroid: A Practical Evasion Attack on Machine Learning for Black-box Android Malware Detection"
date: "2023-03-27"
description: "Discussion 8.1"
---
The following is a summary and discussion of the paper: [EvadeDroid: A Practical Evasion Attack on Machine Learning for Black-box Android Malware Detection](https://arxiv.org/abs/2110.03301) by Hamid Bostani and Veelasha Moonsamy.

# Summary
- This paper provides one of the first approaches to develop a zero knowledge attack in the problem space (rather than feature space) for APK files
  - As we will see later it is not really zero knowledge

- Some background knowledge:
  - The Android Application Package (APX) is made up of AndroidManifest.xml (required to install and run the app) and the Class.dex file which is an executable that represents the application behavior
  - There are quite a few problem space perturbations: Feature Addition (new content added), Feature Subtraction (content is removed), and Feature Modification (content both added and removed)
  - Ngrams - use to represent semantics of executables for malware detection
  - Random Search - Efficient algorithm, requires no assumption about the details of the objective function

- This type of attack is performed in the following manner:
  - the APK is disassembled, such that smali files are extracted. From the smali files n gram opcodes are extracted.
  - Opcodes are compared between both malware and goodware files, and a similarity metric is computed. Goodware files that have highly similar opcodes to the malware files are selected to be donors.
  - From the donor goodware files, specific API calls are extracted -> then the gadget is extracted from the file as well. Gadgets are all of the necessary libraries, functions, etc. required for a specific function call to function as expected. Gadgets are able to function independently, anything that is "inside" a gadget is all that is required for it function as expected
  - These gadgets are then injected into the malware files (typically in try catch blocks for example). Gadgets are continued to be injected into the malware file until the objective function is met. Gadgets are typically placed such that they never execute, and this can only be discovered in runtime.

- The researchers performed the above attack against 4 different classifiers: ADE-MA, DREBIN,MAMADROID, Sec-SVM.
- Using this method, the researchers were able to achieve a ~74% evasion rate in the worst case, and ~81% evasion rate in the best case. The attacks were fairly query efficient (except for Sec-SVM), typically only need 2 queries to the model.
- As the query budget increases, so does the evasion rate.
- This method was able to work on both Soft and hard label systems, with hard label systems requiring more queries and an increase in file size (on average)

- The researchers also uploaded the evasion malware files to virus total and listed out the results for 5 AVs where 60% of the adversarial malware were able to evade the 5 AVs
  - We should take these results with a grain of salt since the AVs are not actually listed (simply referred to as AV1, AV2, etc.)
- The researchers also attempted to use the adversarial samples developed for each specific classifier, and attempted to see how well these adversarial files would be able to generalize to other classifiers:
  - Adversarial samples generated from Sec-SVM are the best to generalize to other malware files, and MaMaDroid being the worst

# Discussion
- What is a Gadget:
  - It contains all of the required information for a specific function call to work as expected. It is the bare minimum information (classes, functions, standard libraries, etc.).
  - Gadgets are useful to inject into files since they can be fairly large, and are able to display benign behavior, so for some classifiers they can sort of "drown out" the malicious behavior
  - Gadgets may also refer to specific exploits found in a piece of software (such as a buffer overflow). Attackers will leverage gadgets to perform meaningful operations to them, able to reuse code as well

- Why is Android disassembly possible?
  - APK files are essentially a compressed version of all of the Android smali files. Smali files can be thought of as an Intermediate Representation of the Android code. The APK tool is able to extract it

- What is a major difference between Android files are PE Files?
  - For PE files, you can really only access the header of the files using the PE tool in python. For Android you are able to manipulate an ENTIRE folder of code
  - Android you are able to access to the entire complication, add new smali files (if desired)
  - Due to the way both Android and PE files are implemented, the approach to develop Adversarial samples are different for both.
  - Android files as very easy to compile again since you just need to "zip" the folder of Javacode which leads to the code being "compiled" again.

- Although the authors claim this a Zero knowledge approach, is it actually?
  - NO this is not! The authors know that static analysis is being performed, hence they can inject dead code into the files! In addition, they know these these specific classifiers are vulnerable to this type of attack.

- Were the Virus Total Results:
  - Yeah, probably, because the authors did not provide the names of the AVs, hence they may have only provided the best results!

- MaMaDroid - It is based on Markov Models -> this was one of the first approaches used to develop LLMs

- Why were more queries required for Sec-SVM?
  - Trained on Adversarial samples leading to much more robust decision boundary. It is more likely to detect perturbations of adversarial samples. Therefore, attacks on this model are much more robust compared to other models, hence leading to a better generalization

- Android files provide A LOT more information compared top PE files:
  - Manifest file provides files permissions, Ability to add/remove permission quite easily. Windows does not have this due to backward compatibility
  - PE file structure is much more well defined, compared to Android
  - Can use GAN to add/remove features

- ByteCode vs Assembly: Not compiled code but an immediate representation. Human Readable (atleast more than assembly). It is an intermediate representation.
  - Technically speaking compiled languaages also have an IR, such as C/C++. For example, when using the LLVM compiler (clang or clang++), the code is compiled into LLVM IR (here is an [example](https://github.com/Virtual-Machine/ir-examples/blob/master/ll/basic.ll)). However, I think the issue with a compiled language is this more for internal usage in the compiler, since code optimizations (loop fusion, peeling, etc.) are applied to this IR representation, and it is not really accessible to the user. It is also very difficult to go backwards from the IR, espically after code optimizations have been applied.