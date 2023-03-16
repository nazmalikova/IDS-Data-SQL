# IDS-Data-SQL

International Debt Statistics Analysis
Just like citizens go to a bank if they need money to grow economically, countries also approach the World Bank for loans to support development in their countries. In this project, I will analyze countries' debts to the World Bank using SQL.

Dataset: The dataset belongs to the World Bank and contains information about how much money countries worldwide owing to the Bank. 
Data source: https://www.kaggle.com/datasets/theworldbank/international-debt-statistics?resource=download
It has 6 files:

![image](https://user-images.githubusercontent.com/126830389/225712988-445e424c-3af9-4367-b00c-110e574e5c24.png)

The main table is DATA, which includes the following columns:
Country_name: Full name of the country
Country_code: Three-letter code for the country.
Indicator_name: It specifies the motive behind the debt.
indicator_code debt,
Years from 1974 to 2024 with debt amount


SQL Project Idea: Using SQL commands on the dataset to answer the following questions:
1. What is the total amount of external debt that?
2. Which country has the highest debt, and how much is that?
3. What is the mean debt owed by countries for different debt indicators?
4. Which region has the highest debt, and how much is that?


First line of the code shows the top 10 rows of Data table:
![image](https://user-images.githubusercontent.com/126830389/225722489-0a7ae2b3-7df0-4bfd-8c76-3b850c0b21c2.png)

For further analysis we need to unpivot year columns and get this table with 6 columns:
![image](https://user-images.githubusercontent.com/126830389/225723021-4e66efce-3f18-4371-bdaf-83bcdcb9306e.png)

1. What is the total amount of money that countries owe to the World Bank?
To find total external debt need to choose indicator - External debt stocks, total (DOD, current US$), Indicator Code = 'DT.DOD.DECT.CD' . ALso, added new column growth_rates which is 'No growth' if yoy growth rate <= 0, 'Low' if 0 < yoy growth rate <= 5, 'Medium' 5 < yoy growth rate <= 10, and 'High' if yoy growth rate > 10.

![image](https://user-images.githubusercontent.com/126830389/225749180-2206917d-16d5-4d01-86bd-8f389923428d.png)


2. Which country has the highest debt, and how much is that, ratio of total?
China with a $1.4 trillion external debt in 2016
![image](https://user-images.githubusercontent.com/126830389/225741891-366a2c9f-4906-4dbc-9284-5feffebc25f4.png)

3. What is the mean debt owed by countries for different debt indicators?
In order to have only debt indicators need to choose Indicator series Topic - Economic Policy & Debt: External debt: Debt outstanding
![image](https://user-images.githubusercontent.com/126830389/225749822-97c1025e-eeec-4b95-81c0-66ba07cfbb21.png)


4. Which region has the highest debt, and how much is that?

![image](https://user-images.githubusercontent.com/126830389/225749907-e3ec916b-89c6-4e9a-8ba6-8e0a66cb72d9.png)

-- 5. What is the total debt by income group, average debt per country?
![image](https://user-images.githubusercontent.com/126830389/225751360-e683807f-6f3e-4612-a923-2f105b92f350.png)








