# About

**Hilo-wear** is an **Apple Watch App** that demonstrates three prototyped interfaces for communicating **indoor air quality forecasts**. We elicited three main elements of prediction of the harmful level of CO2 — Risk, Temporal Proximity, and Certainty, and explored three alternative ways of displaying indoor CO2 forecast through these elements. To evaluate our prototypes, we conducted a preliminary user study, in which three interfaces on Apple Watch were tested by 12 participants (within-subjects, a total of 36 sessions), and published the result in **CHI 2019 as a Late-Breaking Work**: ["Hilo-wear: Exploring Wearable Interaction with Indoor Air Quality Forecast"](https://dl.acm.org/doi/10.1145/3334480.3382813).

This repository presents the code for generating the synthetic data during the user experiment. Apple Developer is needed for the CloudKit access. (The CloudKit was used for logging users' "wrist up" events and for the researcher to change the "CO2 indicator" based on observed the participant’s action, i.e., opening the window.)

## Cite this work
If you are interested in using this work, please kindly cite it as follows:

@inproceedings{10.1145/3334480.3382813,
author = {Zhong, Sailin and Alavi, Hamed S. and Lalanne, Denis},
title = {Hilo-Wear: Exploring Wearable Interaction with Indoor Air Quality Forecast},
year = {2020},
isbn = {9781450368193},
publisher = {Association for Computing Machinery},
address = {New York, NY, USA},
url = {https://doi.org/10.1145/3334480.3382813},
doi = {10.1145/3334480.3382813},
abstract = {The quality of air in office spaces can have far-reaching impacts on the well-being and productivity of office workers. We present a system, called Hilo, that can monitor the level of carbon dioxide (CO2) in an office and provide a fairly accurate forecast of its evolution in the next few minutes. The main objective is to inform and to support the users in taking preventive actions when a harmful level of CO2 is predicted. We elicited three main elements of such prediction — Risk, Temporal Proximity, and Certainty, and explored alternative ways of displaying indoor CO2 forecast through these elements. To evaluate our prototypes, we conducted a preliminary&nbsp;user study, in which three interfaces on Apple Watch were tested by 12 participants (within-subjects, a total of 36 sessions).&nbsp;In this paper, we describe the results of this study and discuss implications for future work on how to create an engaging interaction with the users about the quality of air in offices and particularly its forecast.},
booktitle = {Extended Abstracts of the 2020 CHI Conference on Human Factors in Computing Systems},
pages = {1–8},
numpages = {8},
keywords = {well-being, smart environments, wearables, human-building interaction},
location = {Honolulu, HI, USA},
series = {CHI EA '20}
}

## Contact
Sailin Zhong (sailin.zhong@unifr.ch), Hamed S. Alavi, Denis Lalanne.
