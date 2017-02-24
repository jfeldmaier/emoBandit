# Name of the Project: 

emoBandit

Evaluation of a pseudo machine learning algorithm in terms of the artificially generated feelings of security and arousal. 

# Institution:

Chair of data processing @ Technical University of Munich

# Contributors:

Johannes Feldmaier <johannes.feldmaier@tum.de>, 

# Description:

In this demonstration, an approach to evaluate decisions made during a multi-armed bandit learning experiment is presented. Usually, the results of machine learning algorithms applied on multi-armed bandit scenarios are rated in terms of earned reward and optimal decisions taken. These criteria are valuable for objective comparison in finite experiments. But learning algorithms used in real scenarios, for example in robotics, need to have instantaneous criteria to evaluate their actual decisions taken.

To overcome this problem, in our approach each decision updates the "Zurich model" which emulates the human sense of feeling secure and aroused. Combining these two feelings results in an emotional evaluation of decision policies and could be used to model the emotional state of an intelligent agent.

The results were presented at the IEEE RO-MAN '13 - The 22nd IEEE International Symposium on Robot and Human Interactive Communication (http://www.kros.org/ro-man2013/). The title of the paper was "Emotional Evaluation of Bandit Problems".

Written in Matlab 2013.
 
# Getting Started:

1. After cloning the repository run `experiment_02_01_13.m` in parent directory. 

2. The results should be generated and saved in folder of your working directory. 
