# DS_Microsoft – Classifying Cybersecurity Incidents

## Project Overview
This project develops a machine learning classifier to predict the triage grade of cybersecurity incidents (True Positive, Benign Positive, or False Positive) using Microsoft's GUIDE dataset, supporting Security Operations Centers (SOCs) in prioritizing threats.

## Objectives
- Preprocess and explore the GUIDE cybersecurity incidents dataset
- Engineer relevant features from raw incident, alert, and evidence data
- Train multi-class classification models to predict incident triage grades
- Evaluate models using macro-F1 score, precision, and recall

## Tools & Technologies
- **Python** – Pandas, NumPy, Scikit-learn, XGBoost, LightGBM
- **Imbalanced-learn** – Handle class imbalance (SMOTE / class weights)
- **Matplotlib / Seaborn** – Visualization
- **Jupyter Notebook** – Development environment

## Project Structure
```
05_Microsoft_Cybersecurity/
├── README.md
├── notebooks/          # EDA, feature engineering, and model training
├── data/               # GUIDE dataset (train/test splits)
└── models/             # Saved classifier models
```

## Target Classes
| Label | Meaning |
|-------|---------|
| **TP** | True Positive – Genuine threat |
| **BP** | Benign Positive – Legitimate activity flagged |
| **FP** | False Positive – No actual threat |

## Evaluation Metric
- **Macro-F1 Score** (primary)
- Precision and Recall per class

## Status
> 📁 Project files to be added. Clone or copy your project files into this folder.
