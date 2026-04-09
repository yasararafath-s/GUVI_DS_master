# Dominos – Predictive Purchase Order System

## Project Overview
This project implements a predictive purchase order system for Domino's Pizza, forecasting future ingredient demand based on historical sales data to minimize waste and avoid stock-outs.

## Objectives
- Analyze historical pizza sales data to identify demand patterns
- Build time-series forecasting models to predict future sales
- Generate automated purchase orders based on predicted demand and ingredient requirements
- Optimize inventory management

## Tools & Technologies
- **Python** – Pandas, NumPy, Statsmodels, Prophet / ARIMA
- **Scikit-learn** – Machine learning models
- **Matplotlib / Seaborn** – Visualization
- **Streamlit** – Dashboard (optional)

## Project Structure
```
04_Dominos_Predictive_Purchase/
├── README.md
├── notebooks/          # EDA, forecasting, and order generation notebooks
├── app.py              # Optional Streamlit dashboard
├── data/               # Sales and ingredient datasets
└── models/             # Saved forecasting models
```

## Approach
1. **Data Preprocessing** – Clean sales data, handle missing values, engineer time features
2. **Forecasting** – Train ARIMA / Prophet models on pizza sales time series
3. **Purchase Order Generation** – Map forecasted sales to ingredient quantities
4. **Evaluation** – Measure forecast accuracy using MAE, RMSE

## Status
> 📁 Project files to be added. Clone or copy your project files into this folder.
