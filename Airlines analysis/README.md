# ✈️ Airlines Data Analysis — Revenue & Occupancy Optimization

![Python](https://img.shields.io/badge/Python-Data%20Analysis-blue.svg)
![SQL](https://img.shields.io/badge/SQL-Database_Analysis-orange.svg)
![Status](https://img.shields.io/badge/Status-Completed-success.svg)
![Domain](https://img.shields.io/badge/Domain-Aviation_Analytics-red.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

---

## 📘 About the Project

This project focuses on analyzing **airline operational and ticket booking data** to uncover insights related to:

* Revenue generation 💰
* Ticket booking trends 📈
* Aircraft occupancy rates ✈️
* Pricing strategies 🎯

The primary objective was to help the airline improve **profitability** by identifying opportunities to increase seat occupancy and optimize pricing strategies.

The analysis was conducted using **Python, SQL, and database querying techniques**.

---

## 🌍 Business Problem

The airline company operates a diverse fleet ranging from:

* Small business aircraft
* Medium-sized passenger aircraft

However, the company is facing several business challenges:

* 🌱 Stricter environmental regulations
* ⛽ Rising fuel prices
* 💸 Higher flight taxes
* 👨‍✈️ Increased labor costs
* 📉 Pressure on overall profitability

To address these challenges, the company wants to:

* Improve occupancy rates
* Increase revenue per seat
* Optimize ticket pricing strategies
* Identify low-performing flights and aircraft

---

## 🎯 Project Objective

The main goals of this analysis are:

✅ Increase aircraft occupancy rates

✅ Improve revenue generation per flight

✅ Analyze booking and pricing trends

✅ Identify high and low-performing aircraft

✅ Support better pricing and operational decisions

---

## 🛠️ Steps Included

### 📌 Business Understanding

* Understanding airline operational challenges
* Defining profitability-focused KPIs

### 📚 Data Collection & Database Connection

* Imported libraries
* Connected to database using SQL

### 🔍 Data Exploration

* Explored tables and schemas
* Identified key business variables

### 📊 Data Analysis

* Analyzed booking trends and revenue
* Compared occupancy rates across aircraft

### 📈 Reporting & Insights

* Created business reports and visualizations
* Generated actionable recommendations

---

## 🧰 Tools & Technologies

| Tool                           | Purpose                       |
| ------------------------------ | ----------------------------- |
| **Python**                     | Data analysis & preprocessing |
| **SQL**                        | Database querying             |
| **Pandas**                     | Data manipulation             |
| **Matplotlib / Visualization** | Charts & trend analysis       |
| **Jupyter Notebook**           | Analysis environment          |

---

## 📊 Key Analysis Performed

### ✈️ Aircraft Capacity Analysis

Identified aircraft with:

* More than 100 seats
* Highest seating capacity
* Occupancy performance
  
> The basic analysis of data provides insights into the number of planes with more than 100 seats, how the number of tickets booked, and the total amount earned changed over time, as well as the average fare for each aircraft with different conditions. These findings will be helpful in developing strategies to optimize occupancy rates and pricing for each aircraft.
> Table 1 shows the aircraft with more than 100 seats and the actual count of seats.


| Aircraft Code | Number of Seats |
| ------------- | --------------- |
| 319           | 116             |
| 320           | 140             |
| 321           | 170             |
| 733           | 130             |
| 763           | 222             |
| 773           | 402             |

---

### 📈 Ticket Booking & Revenue Trends

Analyzed:

* Daily ticket booking patterns
* Revenue growth trends
* Peak booking periods

In order to gain a deeper understanding of the trend in ticket bookings and revenue earned through those bookings, we utilized a line chart visualization. Upon analysis of the chart, we observe that the number of tickets booked exhibits a gradual increase from June 22nd to July 7th, followed by a relatively stable pattern from July 8th until August, with a noticeable peak in ticket bookings where the highest number of tickets was booked on a single day. It is important to note that the revenue earned by the company from these bookings is closely tied to the number of tickets booked. Therefore, we can see a similar trend in the total revenue earned by the company throughout the analyzed time period. These findings suggest that further exploration of the factors contributing to the peak in ticket bookings may be beneficial for increasing overall revenue and optimizing operational strategies.

> Total tickets booked:
<img width="810" height="279" alt="image" src="https://github.com/user-attachments/assets/8dc5f5b9-0970-4db9-8585-49b0489f2020" />


> Revenue trend
<img width="811" height="296" alt="image" src="https://github.com/user-attachments/assets/1f2e9b97-55d3-462f-ab0c-07363e516c9e" />


#### Key Observation:

* Ticket bookings gradually increased between **June and August**
* Revenue trends closely followed booking volume trends

---

### 💰 Fare Condition Analysis

Compared average ticket prices across:

* Business class
* Economy class
* Comfort class

> We were able to generate a bar graph to graphically compare the data after completing computations for the average cost associated with different fare conditions for each aircraft. Figure 3 displays data for three types of fares: business, economy, and comfort. It's worth mentioning that the comfort class is available on only one aircraft, the 773. Conversely, the CN1 and CR2 planes provide only the economy class. When comparing different pricing circumstances within each aircraft, the charges for the business class are consistently greater than those for the economy class. This trend may be observed across all planes, irrespective of fare conditions.

<img width="445" height="323" alt="image" src="https://github.com/user-attachments/assets/582c7e8c-f994-4948-91ce-cc0697c42b25" />


#### Key Findings:

* Business class fares are consistently higher
* Aircraft `773` offers comfort class
* Some aircraft only provide economy seating

---

## 🚀 Occupancy Rate Analysis

Occupancy rate was calculated using:

```text
Occupancy Rate = Booked Seats / Total Seats
```

Higher occupancy indicates:

* Better seat utilization
* Increased revenue opportunities
* Lower losses from empty seats

---

## 📌 Aircraft Performance Insights

### 🏆 Highest Revenue Aircraft

* **SU9** generated the highest total revenue
* Lower ticket prices may have increased demand

### 📉 Lowest Revenue Aircraft

* **CN1** generated the least revenue
* Limited facilities and economy-only seating may impact performance

---

## 📊 Occupancy Rate Insights

| Aircraft | Occupancy Rate |
| -------- | -------------- |
| 773      | 65.9%          |
| 733      | 61.7%          |
| SU9      | 58.5%          |
| 321      | 52.2%          |
| 763      | 51.3%          |

### Key Observation:

Aircraft `773` achieved the highest occupancy rate, indicating strong customer demand and efficient seat utilization.

---

## 💡 Revenue Optimization Scenario

A simulation was performed to estimate the impact of:

### ➕ Increasing occupancy rates by 10%

### Key Result:

Even a moderate increase in occupancy rates could significantly improve:

* Annual revenue
* Profitability
* Operational efficiency

This indicates that airlines should focus heavily on:

* Pricing optimization
* Customer acquisition
* Route planning

---

## 🔍 Key Insights

✅ Revenue strongly depends on booking volume
✅ Lower ticket prices can increase occupancy and revenue
✅ Aircraft with better facilities perform better financially
✅ Increasing occupancy rates directly boosts profitability
✅ Pricing strategy plays a major role in customer demand

---

## 🚀 Business Recommendations

### 🎯 Improve Pricing Strategy

* Optimize pricing based on aircraft type and customer demand
* Avoid extremely high or low ticket prices

### ✈️ Increase Occupancy Rates

* Focus on low-performing flights
* Introduce promotional campaigns and discounts

### 😊 Enhance Customer Experience

* Improve comfort and onboard services
* Increase customer retention and satisfaction

### 📊 Use Data-Driven Decision Making

* Monitor booking trends continuously
* Optimize routes and scheduling based on demand

---

## 🎤 Interview Explanation (How to Explain This Project)

### 🔹 Problem Understanding

The airline company wanted to improve profitability by increasing occupancy rates and optimizing ticket pricing strategies.

My role was to analyze airline booking and revenue data to identify:

* Low-performing aircraft
* Revenue opportunities
* Occupancy trends

---

### 🔹 Approach Taken

1. Connected and explored the airline database using SQL
2. Cleaned and analyzed booking and revenue data using Python
3. Calculated occupancy rates for each aircraft
4. Compared revenue and ticket pricing trends
5. Simulated revenue improvements with higher occupancy rates

---

### 🔹 Key Learnings

* Understanding airline business KPIs
* Revenue optimization techniques
* Occupancy rate analysis
* Pricing strategy analysis
* Combining SQL with Python for business analytics

---

### 🔹 Business Impact

This analysis can help airlines:

* Improve revenue generation
* Optimize ticket pricing
* Increase seat utilization
* Make data-driven operational decisions

---

## 👨‍💻 Author

**Ankit Verma**
*Data Analyst | Python • SQL • Business Analytics*

🔗 [LinkedIn](https://www.linkedin.com/in/ankit-verma)
🔗 [GitHub](https://github.com/ankitverma)

---

⭐ **If you found this project useful, consider starring the repository!** ⭐
